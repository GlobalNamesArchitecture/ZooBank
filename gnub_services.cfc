<!--- ----------------------------------------- --->
<!--- 
	NAME: gnub_services.cfc

	PURPOSE:  Provide a library of general functions to handle processing, to centralize the code.

	LAST MODIFIED: 4/20/2012 - added top parameter to reference searches
	3/22/2011 - created
	
	CREATED:  3/22/2011 - created
	
	AUTHOR: Robert Whitton

	NOTES:  
		METHODS
			get_author
			get_nomenclatural_acts
			get_reference
			get_external_identifiers
			create_identifier
			link_repository
			get_repositories
			
 --->
<!--- ----------------------------------------- --->
<cfcomponent>
	<cfset datasource = "taxonomer_sandbox"><!---taxonomer_sandbox [SQLDEV] or gnub_taxonomer_sandbox--->
	
	<!---  AUTHORS --->
	<!---  AUTHORS --->
	<cffunction name="get_author" output="true">
		<cfargument name="search_term" type="string" required="no" default="">
		<cfargument name="Family_Name" type="string" required="no">
		<cfargument name="Given_Name" type="string" required="no">
		<cfargument name="AgentId" type="string" required="no" default="">
		<cfargument name="AgentUUID" type="string" required="no" default="">
		<cfargument name="ReferenceID" type="string" required="no" default="">
		<cfargument name="ReferenceUUID" type="string" required="no" default="">
		<cfargument name="search_type" type="string" required="no" default="">
		<cfargument name="UUID" type="string" required="no" default="">
		<cfargument name="ResponseType" type="string" required="no" default="">
		<cfargument name="FuzzyMatch" type="string" required="no" default="0">
		<cfargument name="top" type="numeric" required="no" default="0">
		<!--- INPUTS:
		UUID - the UUID of the specific name, not necessarily the person
		AgentId
		AgentUUID
		FamilyNm
		GivenNm
		SearchTerm
		IncludePers
		IncludeOrg
		SearchType - default to begins with
		--->

		<cfquery datasource="#datasource#" name="get_authors">
			EXEC dbo.sp_SearchAgentName @IncludePers=1
			<cfif Arguments.search_term is not "">
				,@SearchTerm='#search_term#'
			</cfif>
			<cfif Arguments.search_type is not "">
				,@SearchType='#Arguments.search_type#'
			</cfif>
			<cfif isDefined("Family_name")>
				,@FamilyNm = '#Family_Name#'
			</cfif>
			<cfif isDefined("Given_Name")>
				,@GivenNm = '#Given_Name#'
			</cfif>
			<cfif Arguments.AgentId gt 0>
				,@AgentId='#Arguments.parentID#'
			</cfif>
			<cfif Arguments.AgentUUID gt 0>
				,@AgentUUID='#Arguments.AgentUUID#'
			</cfif>
			<cfif Arguments.ReferenceID gt 0>
				,@ReferenceID='#Arguments.ReferenceID#'
			</cfif>
			<cfif Arguments.ReferenceUUID gt 0>
				,@ReferenceUUID='#Arguments.ReferenceUUID#'
			</cfif>
			<cfif Arguments.UUID gt 0>
				,@UUID='#Arguments.UUID#'
			</cfif>
			<cfif Arguments.ResponseType gt 0>
				,@ResponseType='#Arguments.ResponseType#'
			</cfif>
			<cfif Arguments.FuzzyMatch gt 0>
				,@FuzzyMatch = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.FuzzyMatch#">
			</cfif>
			<cfif Arguments.top gt 0>
				,@top = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.top#">
			</cfif>
		</cfquery>	
		<cfif not IsDefined("get_authors")>
			<cfset get_authors = QueryNew('agentnameid')>
		</cfif>
		<cfreturn get_authors />
	</cffunction>
	
	<!---  NOMENCLATURAL ACTS --->
	<!---  NOMENCLATURAL ACTS --->
	<cffunction name="get_nomenclatural_acts" hint="Returns a list of names that match search string">
		<cfargument name="RankGroup" type="string" required="no">
		<cfargument name="search_term" type="string" required="no">
		<cfargument name="ProtonymID" type="numeric" required="no">
		<cfargument name="PKID" type="numeric" required="no">
		<cfargument name="UUID" type="string" required="no">
		<cfargument name="ReferenceID" type="numeric" required="no">
		<cfargument name="ReferenceUUID" type="string" required="no">
		<cfargument name="display_type" type="string" required="no" default="autocomplete">
		<cfargument name="distinctNames" type="string" required="no" default="0">
		<cfargument name="ProtonymUUID" type="string" required="no">
		<cfargument name="IsNomenclaturalAct" type="numeric" required="no"> <!---0 - ignore, 1 is only nomenclatural acts, 2 is only non-nomenclatural acts--->
		<cfargument name="SearchType" type="string" required="no">
		<!--- INPUT:
		@RankGroup ('Family'|'Genus'|'Species')
		@SearchTerm - any part of NOMENCLATURAL name you'r looking for
		@PKID - of the TNU
		@ProtonymID
		@ProtonymUUID
		@ReferenceID
		@ReferenceUUID
		@SearchType - defaults to contains
		@DistinctNames
				
		OUTPUT:
		LSID
		ProtonymID
		TaxonRankID
		NameString - the name only (no author)
		CheatNameComplete - formatted?
		CleanDisplay - No HTML markup added
		FormattedDisplay - HTML markup added
		Sort --->
		<cfquery name="get_names" datasource="#datasource#">
			EXEC 	sp_SearchTaxonNameUsage
			@DistinctNames = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.distinctNames#">
			<!---@RankGroup = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.search_term#">	,--->
			<cfif Arguments.search_term is not "">
				, @SearchTerm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.search_term#">	
			</cfif>
			<cfif Arguments.ProtonymUUID is not "">
				, @ProtonymUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProtonymUUID#">	
			</cfif>
			<cfif Arguments.UUID is not "">
				, @UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UUID#">	
			</cfif>
			<cfif Arguments.PKID is not "">
				, @PKID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PKID#">	
			</cfif>
			<cfif Arguments.RankGroup is not "">
				, @RankGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RankGroup#">	
			</cfif>
			<cfif Arguments.ReferenceID is not "">
				, @ReferenceID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReferenceID#">	
			</cfif>
			<cfif Arguments.ReferenceUUID is not "">
				, @ReferenceUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReferenceUUID#">	
			</cfif>
			<cfif Arguments.IsNomenclaturalAct is not "">
				, @IsNomenclaturalAct = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IsNomenclaturalAct#">	
			</cfif>
			<cfif Arguments.SearchType is not "">
				, @SearchType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SearchType#">	
			</cfif>
			
		</cfquery>
		<cfif not IsDefined("get_names")>
			<cfset get_names = QueryNew('TaxonName')>
		</cfif>
		<cfreturn get_names />
		
	</cffunction>
	<!--- REFERENCES --->
	<!--- REFERENCES --->
	<cffunction name="get_reference">
		<cfargument name="search_term" type="string" required="no">
		<cfargument name="IsPeriodical" type="string" required="no" default="0">
		<cfargument name="ReferenceID" type="string" required="no">
		<cfargument name="AuthorIDList" type="string" required="no">
		<cfargument name="AuthorUUIDList" type="string" required="no">
		<cfargument name="UUID" type="string" required="no">
		<cfargument name="StartYear" type="string" required="no">
		<cfargument name="EndYear" type="string" required="no">
		<cfargument name="PKID" type="string" required="no">
		<cfargument name="ParentReferenceUUID" type="string" required="no">
		<cfargument name="PublishedOnly" type="string" required="no">		
		<cfargument name="top" type="numeric" required="no" default="0">
		<!---  Stored Procedures
		input Parameters:  @ReferenceID, @UUID, @AuthorIDList (comma delimited list of authors), @SearchTerm (parsed), @FuzzyMatch (boolean, defaults to true (ignores diacritics), @IsRegistered (has LSID) (1 registered only, 0 only unregistered, else both), @IsPeriodical, @PublishedOnly (hides the in press entries), @ParentReferenceUUID
		
		RETURNS: UUID, ReferenceID (PKID), ParentReferenceID, LSID, SearchString, CleanSearchString (no diacriticals - plain text), IsPublished, ReferenceTypeID, CheatFullAuthors,Year,Title,Publisher,PlacePublished, Volume,Number,Pages,Edition,DatePublished,Figures,StartDate (earliest poss. published date), EndDate (latest poss. date published), CheatCitation (Author and Year), CheatCitationDetails (everything after title), CheatAuthors (last names only), CleanTitle (no HTML tags), ParentReferenceID (PKID), ParentReferenceUUID, ParentReference
		--->
		<cfquery datasource="#datasource#" name="get_pubs">
			EXEC sp_SearchReference 
			@IsPeriodical = #Arguments.IsPeriodical#
			<cfif Arguments.search_term is not "">,@SearchTerm = '#Arguments.search_term#'</cfif>			
			<cfif Arguments.ReferenceID gt 0>,@ReferenceID = #Arguments.ReferenceID#</cfif>	
			<cfif Arguments.AuthorIDList gt 0>,@AuthorIDList = #Arguments.AuthorIDList#</cfif>	
			<cfif Arguments.AuthorUUIDList gt 0>,@AuthorUUIDList = '#Arguments.AuthorUUIDList#'</cfif>	
			<cfif Arguments.UUID gt 0>,@UUID = '#Arguments.UUID#'</cfif>	
			<cfif Arguments.StartYear gt 0>,@StartYear = '#Arguments.StartYear#'</cfif>	
			<cfif Arguments.EndYear gt 0>,@EndYear = '#Arguments.EndYear#'</cfif>	
			<cfif Arguments.PKID gt 0>,@PKID = '#Arguments.PKID#'</cfif>
			<cfif Arguments.ParentReferenceUUID gt 0>,@ParentReferenceUUID = '#Arguments.ParentReferenceUUID#'</cfif>
			<cfif Arguments.PublishedOnly is not "">,@PublishedOnly = '#Arguments.PublishedOnly#'</cfif>	
			<cfif Arguments.top gt 0>
				,@top = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.top#">
			</cfif>			
		</cfquery>

		
		<cfif not IsDefined("get_pubs")>
			<cfset get_pubs = QueryNew('No_Records_Found')>
		</cfif>
		<cfreturn get_pubs />	
	</cffunction>
	
	<cffunction name="get_external_identifiers">
		<cfargument name="uuid" type="string" required="no">
		<cfargument name="pkid" type="string" required="no" default="">
		<cfargument name="ResponseType" type="string" required="no">
		<cfargument name="Domain" type="string" required="no">
		
		<!---INPUT
		@UUID
		@PKID
		@ResponseType RecordCount or LastRecord 
		@Domain
		--->
		
		<cfquery datasource="#datasource#" name="get_ids">
			EXEC sp_GetExternalIdentifiers
			<cfif Arguments.uuid is not "">
				@UUID = '#Arguments.uuid#'
			<cfelseif Arguments.PKID is not "">
				@PKID = '#Arguments.PKID#'
			</cfif>
			<cfif Arguments.ResponseType is not "">
				@ResponseType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ResponseType#">	
			</cfif>
			<cfif Arguments.Domain is not "">
				,@Domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Domain#">	
			</cfif>
		</cfquery>
	
		<cfreturn get_ids />
	</cffunction>
	
	<cffunction name="create_identifier">
		<cfargument name="Domain" type="string" required="yes">
		<cfargument name="UUID" type="string" required="yes">
		<cfargument name="LogUserName" type="string" required="yes">
		<cfargument name="Identifier" type="string" required="yes">
		<cfargument name="ResolutionNote" type="string" required="no">
		<!--- Check to see if any identifiers have been passed.  If so, create the identifiers 
		@UUID
		@LogUserName
		@IdentifierDomainUUID
		@IdentifierDomainPKID
		@Domain - ISSN, ISBN, DOI
		@Identifier
		@ResolutionNote
		--->
		
		<cfquery name="create_identifier" datasource="#datasource#">
				EXEC sp_InsertIdentifier
				@UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UUID#">,
				@Domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Domain#">,
				@Identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Identifier#">,
				@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">
				<cfif Arguments.ResolutionNote is not "">,@ResolutionNote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ResolutionNote#"></cfif>
		</cfquery>
	
	</cffunction>
	
	<cffunction name="link_repository">
		<cfargument name="ReferenceUUID" type="string" required="yes">
		<cfargument name="RepositoryName" type="string" required="yes">
		<cfargument name="LogUserName" type="string" required="yes">
		<!--- Links a reference to an online or persistent repository
		@ReferenceUUID
		@RepositoryName
		@LogUserName
		@IdentifierDomainPKID
		@Domain - ISSN, ISBN, DOI
		@Identifier
		@ResolutionNote
		--->
		
		<cfquery name="link_reference_to_repository" datasource="#datasource#">
				EXEC sp_InsertReferenceArchive
				@ReferenceUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReferenceUUID#">,
				@RepositoryName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RepositoryName#">,
				@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">
		</cfquery>
	
	</cffunction>
	
	<cffunction name="get_repositories">
		<cfargument name="ReferenceUUID" type="string" required="no">
		<cfargument name="RepositoryName" type="string" required="no">
		<cfargument name="Top" type="numeric" required="no" default="100">
		<!--- 
			All fields that come back with Search Reference
			RepositoryName, RepositoryURL RepositoryID, RepositoryUUID, PKID {for join table}, UUID {for join table}
		--->
		
		<cfquery name="getRepositories" datasource="#datasource#">
			EXEC sp_GetReferenceArchive
			@Top = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Top#">
			<cfif Arguments.ReferenceUUID is not "">,@ReferenceUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReferenceUUID#"></cfif>
			<cfif Arguments.RepositoryName is not "">,@RepositoryName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RepositoryName#"></cfif>
		</cfquery>
	
		<cfreturn getRepositories />
	</cffunction>
	
	<cffunction name="get_zoobank_lsid">
		<cfargument name="UUID" type="string" required="no">
		<cfargument name="LSID" type="string" required="no">
		<cfquery name="getLSID" datasource="#datasource#">
			EXEC sp_GetZooBankLSID
			<cfif Arguments.UUID is not "">@UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UUID#"></cfif>
			<cfif Arguments.LSID is not "">@LSID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LSID#"></cfif>
		</cfquery>
		<cfif not IsDefined("getLSID")>
			<cfset getLSID = QueryNew('No_Records_Found')>
		</cfif>
		<cfreturn getLSID />
	</cffunction>
	
	
	
</cfcomponent>