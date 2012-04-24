<!--- ----------------------------------------- --->
<!--- 
	NAME: services.cfc

	PURPOSE:  Provide a library of general functions to handle processing, to centralize the code.

	LAST MODIFIED: 6/6/2011 - created
	
	CREATED:  6/6/2011 - created
	
	AUTHOR: Robert Whitton

	NOTES:  
		METHODS
			find_author
			find_pub
			find_journal
			show_author_pubs
			get_pub_authors
			insert_author
			get_pub_types
			find_taxon_act
			get_pub_authors
			find_language
			find_taxon_level	
			insert_reference
			get_nomenclatural_acts			
			
 --->
<!--- ----------------------------------------- --->
<cfcomponent>
	<cfset datasource = "taxonomer_sandbox"><!---taxonomer_sandbox--->
	<cffunction name="find_author" returntype="string" access="remote" returnformat="plain">
		<cfargument name="term" type="string" required="no" default="">
		<cfargument name="FamilyName" type="string" required="no" default="">
		<cfargument name="GivenName" type="string" required="no" default="">
		<cfargument name="Include_Organizations" type="string" required="no" default="false">
		<cfargument name="parentID" type="numeric" required="no">
		<cfargument name="first_name_fuzzy_match" required="no" default="no">
		<cfargument name="first_initial_fuzzy_match" required="no" default="no">
		
		<cfset searched_for_string = "">
		<cfparam name="Family_Name" default="#Arguments.FamilyName#">
		<cfparam name="Given_Name" default="#Arguments.GivenName#">
		<cfif Arguments.term is not "">
			<!---<cfif find(",",term)>
				<cfset Family_Name = Trim(ListFirst(term,","))>
				<cfset Given_Name = Trim(ListLast(term,","))>
				<cfset searched_for_string = "Family Name contains #Family_Name# and Given Name contains #Given_Name#.">
			<cfelseif find(" ",term)>
				<cfset Family_Name = Trim(ListLast(term," "))>
				<cfset Given_Name = Trim(ListFirst(term," "))>		
				<cfset searched_for_string = "Family Name contains #Family_Name# and Given Name contains #Given_Name#.">				
			<cfelse>
				<cfset searched_for_string = "Family name OR Given Name contains #term#.">
			</cfif>		--->	
			<cfset searched_for_string = term>
		<cfelse>
			<cfset Family_Name = Arguments.FamilyName>
			<cfset Given_Name = Arguments.GivenName>
			<cfset searched_for_string = "Family Name contains #Family_Name# and Given Name contains #Given_Name#.">
		</cfif>
		<!---
		IncludePers 	:  Include Persons in the result set (default value)
		--->
		<cfquery datasource="#datasource#" name="get_authors">
			EXEC dbo.sp_SearchAgent @IncludePers=1
			<cfif isDefined("term")>
				<cfif term is not "">
				,@SearchTerm='#term#'
				</cfif>
			</cfif>
			<cfif isDefined("Family_name")>
				,@FamilyNm = '#Family_Name#'
			</cfif>
			<cfif isDefined("Given_Name")>
				,@GivenNm = '#Given_Name#'
			</cfif>
			,@AuthorID='#Arguments.parentID#'
		</cfquery>
		<cfset return_string = '['>
		<cfoutput query="get_authors">
			<cfset return_string = '#return_string#{"id": "#PKID#", "label": "#Replace(FormattedName,"=","alias of ","ALL")#", "value": "#Replace(FormattedName,"=","alias of ","ALL")#", "ZBLSID": "#ZBLSID#", "familyname": "#get_authors.FamilyName#", "givenname": "#get_authors.GivenName#","validagentid": "#get_authors.ValidAgentID#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfif not isDefined("Arguments.term")>
			<cfset term = "#Given_Name# #Family_Name#">
		</cfif>
		<!---<cfset return_string = '#return_string#,{"id":0,"label":"Not in list.  Click New Author to create entry.","value":"Not in list.  Click New Author to create entry.","term":"#term#"}]'>--->
		<cfset return_string = '#return_string#]'>
		<cfif get_authors.recordcount is 0>		
			<cfif Find(",",searched_for_string)>
				<cfset new_given_name = ListLast(searched_for_string)>
				<cfset new_family_name = ListFirst(searched_for_string)>
			<cfelse>
				<cfset new_family_name = ListLast(searched_for_string," ")>
				<cfset new_given_name = ListFirst(searched_for_string," ")>				
			</cfif>
			<cfset new_family_name = "#UCase(Left(Trim(new_family_name),1))##LCase(RemoveChars(Trim(new_family_name),1,1))#">
			<cfset new_given_name = "#UCase(Left(Trim(new_given_name),1))##LCase(RemoveChars(Trim(new_given_name),1,1))#">
			<cfset return_string = '[{"id":0,"label":"No Match Found. You searched for #searched_for_string#.  Click New Author to create a new entry for this author.","value":"No Match Found. You searched for #searched_for_string#.  Click New Author to create entry.","term":"#term#"},{"id":-1,"label":" Add #new_given_name# #new_family_name# as a new author","value":"No Match.","term":"#term#","familyname":"#new_family_name#","givenname":"#new_given_name#"}]'>
		</cfif>
		
		<cfreturn return_string />	
	</cffunction>

	<cffunction name="find_pub" returntype="string" access="remote" returnformat="plain">
		<cfargument name="term" type="string" required="no">
		<cfargument name="journals_only" type="string" required="no" default="0">
		<cfargument name="ReferenceID" type="string" required="no">
		<!---  Stored Procedures
		input Parameters:  @ReferenceID, @UUID, @AuthorIDList (comma delimited list of authors), @SearchTerm (parsed), @FuzzyMatch (boolean, defaults to true (ignores diacritics), @IsRegistered (has LSID) (1 registered only, 0 only unregistered, else both), @IsPeriodical, @PublishedOnly (hides the in press entries)
		
		RETURNS: UUID, ReferenceID (PKID), ParentReferenceID, LSID, SearchString, CleanSearchString (no diacriticals - plain text), IsPublished, ReferenceTypeID, CheatFullAuthors,Year,Title,Publisher,PlacePublished, Volume,Number,Pages,Edition,DatePublished,Figures,StartDate (earliest poss. published date), EndDate (latest poss. date published), CheatCitation (Author and Year), CheatCitationDetails (everything after title), CheatAuthors (last names only), CleanTitle (no HTML tags)
		--->
		<cfquery datasource="#datasource#" name="get_pubs">
			EXEC sp_SearchReference 
			@IsPeriodical = #Arguments.journals_only#
			<cfif Arguments.term is not "">,@SearchTerm = '#Arguments.term#'</cfif>			
			<cfif Arguments.ReferenceID gt 0>,@ReferenceID = #Arguments.ReferenceID#</cfif>			
		</cfquery>
		<cfset return_string = '['>
		<cfoutput query="get_pubs">
			<cfset return_string = '#return_string#{"id": "#ReferenceID#", "label": "#CleanTitle# #CheatCitation#", "value": "#Title# #CheatCitation#", "CheatFullAuthors" : "#CheatFullAuthors#", "Year" : "#Year#", "Title" : "#Title#", "CheatCitationDetails" : "#CheatCitationDetails#","cheatauthors":"#CheatAuthors#","lsid":"#lsid#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_pubs.recordcount is 0>
			<cfset return_string = '[{"id":0,"label":"","value":"No Match Found for: #term#."}]'>
		</cfif>
		
		<cfreturn return_string />	
	</cffunction>
	
	<cffunction name="filtered_refererence_search" access="remote" returnformat="plain">
		<cfargument name="author_id_list" type="string" required="no">
		<cfargument name="publication_year" type="string" required="no">
		<cfargument name="journal_id" type="string" required="no" default="0">
		<cfargument name="reference_title" type="string" required="no">
		<cfquery name="search_reference" datasource="#datasource#">
			SELECT     TOP (200) r.ReferenceID, r.ParentReferenceID, r.ReferenceTypeID, r.LanguageID, r.Year, r.Title, r.SecondaryTitle, r.Publisher, r.PlacePublished, r.Volume, 
                      r.NumberVolumes, r.Number, r.Pages, r.InPages, r.Section, r.Edition, r.DatePublished, r.TypeWork, r.ShortTitle, r.Figures, r.StartDate, r.EndDate, r.URL, r.CheatCitation, 
                      r.CheatAuthors, r.CheatFullAuthors, r.CheatCitationDetails, r.CheatSearchReference, p.Title AS parent_title, a.CheatFullAgentName
			FROM         Reference AS r INNER JOIN
								  Reference AS p ON r.ParentReferenceID = p.ReferenceID INNER JOIN
								  ReferenceAuthor AS ra ON ra.ReferenceID = r.ReferenceID INNER JOIN
								  Agent AS a ON a.AgentID = ra.AgentID
			WHERE     r.ReferenceID <> 0
			<cfif Arguments.reference_title is not "">
				AND (r.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.reference_title#%">) 
			</cfif>
			<cfif Arguments.publication_year is not "">
				AND (r.Year LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.publication_year#">) 
			</cfif>
			<cfif Arguments.author_id_list is not "">
				<cfloop list="#Arguments.author_id_list#" index="temp_author_id">
					AND (#temp_author_id# IN
                        (SELECT     AgentID
                        FROM          ReferenceAuthor
                        WHERE      (ReferenceID = r.ReferenceID))) 
				</cfloop>
			</cfif>
			<!---AND (r.CheatFullAuthors LIKE '%Myers, Robert F.%') --->
			<cfif Arguments.journal_id is not 0 and Arguments.journal_id is not "">
				AND (r.ParentReferenceID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.journal_id#">)
			</cfif>
			ORDER BY r.ReferenceID
		</cfquery>
		
		<cfset return_string = '['>
		<cfoutput query="search_reference" group="ReferenceID">
			<cfset return_string = '#return_string#{"id": "#ReferenceID#", "label": "#CheatFullAuthors# #Title# #CheatCitation#", "value": "#Title# #CheatCitation#", "CheatFullAuthors" : "#CheatFullAuthors#", "Year" : "#Year#", "Title" : "#Title#", "CheatCitationDetails" : "#CheatCitationDetails#","cheatauthors":"#CheatAuthors#","CheatCitation":"#CheatCitation#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif search_reference.recordcount is 0>
			<cfset return_string = '[{"id":0,"label":"","value":"No Results."}]'>
		</cfif>
		
		<cfreturn return_string />	
	
	</cffunction>
	<cffunction name="find_journal" returntype="string" access="remote" returnformat="plain">
		<cfargument name="term" type="string" required="yes">
		<cfargument name="journals_only" type="string" required="no" default="0">
		<cfquery datasource="#datasource#" name="get_journals">
			<!---SELECT     dbo.PK.PKID, dbo.PK.CorrectID, CAST(dbo.Reference.Title AS nvarchar(255)) AS ImportedTitle, dbo.Reference.Edition AS Series, dbo.Reference.ShortTitle, 
                      dbo.view_ZooBankPubs.Identifier AS ZooBank, CAST(CASE WHEN Edition IS NULL THEN Title ELSE Title + ', ' + Edition END AS nvarchar(255)) AS FullTitle, 
                      CASE WHEN PK.PKID = CorrectID THEN 1 ELSE 0 END AS IsCorrect, dbo.view_ZooBankPubs.RegistrationTimeStamp
			FROM         dbo.PK INNER JOIN
								  dbo.Reference ON dbo.PK.PKID = dbo.Reference.ReferenceID LEFT OUTER JOIN
								  dbo.view_ZooBankPubs ON dbo.PK.PKID = dbo.view_ZooBankPubs.PKID
			WHERE     (dbo.Reference.ReferenceTypeID = 39) AND (dbo.PK.CorrectID <> 0) AND (dbo.PK.PKID = dbo.PK.CorrectID) AND (dbo.Reference.ShortTitle LIKE '%#Arguments.term#%')--->
			
			SELECT    LSID, IsPublished, ReferenceTypeID, CheatFullAuthors, Year, Title, Publisher, PlacePublished, Volume, Number, Pages, Edition, DatePublished, Figures, 
                      StartDate, EndDate, CheatCitation, CheatCitationDetails, ReferenceID, ParentReferenceID, SearchString
			FROM         view_SearchReference
			where 
			<cfif find(" ",Arguments.term)>
				<cfset count = 1>
				(<cfloop list="#arguments.term#" delimiters=" " index="temp_term">
					SearchString like '%#temp_term#%'
					<cfif count lt ListLen(Arguments.Term," ")>
						and
					</cfif>
					<cfset count = count + 1>
				</cfloop>)
			<cfelse>
				SearchString like '%#Arguments.term#%'
			</cfif>
			<cfif Arguments.journals_only is 1>
				AND ReferenceTypeID=39
			<cfelse>
				and ReferenceTypeID in (2,26,39)
			</cfif>
			
			order by Title,CheatCitation
			
		</cfquery>
		<cfset return_string = '['>
		<cfoutput query="get_journals">
			<cfset return_string = '#return_string#{"id": "#ReferenceID#", "label": "#Title#", "value": "#Title#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_journals.recordcount is 0>
			<cfset return_string = '[{"id":"0","label":"No Match Found for ''#term#''.  Please Enter a New Parent Publication","value":""}]'>
		</cfif>		
		<cfreturn return_string />	
	</cffunction>
	
	<cffunction name="show_author_pubs" returntype="query" access="remote" hint="Returns a list of publications for a given author" returnformat="json">
		<cfargument name="LSID" type="string" required="no" default="">
		<cfargument name="return_type" required="no" default="All">
		<cfargument name="AuthorID" type="string" required="yes">
				
		<cfquery name="get_pubs" datasource="#datasource#">
			EXEC sp_SearchReference @AuthorIDList = '#Arguments.AuthorID#'
			<!--- pass a 1 to get only registered, a 0 to get only unregistered, pass nothing to get both --->
		</cfquery>
		<cfreturn get_pubs />		
	</cffunction>
	
	<cffunction name="insert_author" hint="inserts a new author" access="remote" returntype="struct" returnformat="json">
		<cfargument name="GivenName" type="string" required="yes">
		<cfargument name="FamilyName" type="string" required="yes">
		<cfargument name="author_suffix" type="string" required="no">
		<cfargument name="LogUserName" type="string" required="yes">	
		<cfargument name="LinkID" type="string" required="no">
		<cfargument name="no_verify" type="numeric" required="no" default="0">
		<cfset result = StructNew()>
		
		<cfif Arguments.no_verify is 0>
			<!--- check to see if there is already an exact match for this name --->
			<cfinvoke method="find_author" returnvariable="author_results">
				<cfinvokeargument name="GivenName" value="#Arguments.GivenName#">
				<cfinvokeargument name="FamilyName" value="#Arguments.FamilyName#">
			</cfinvoke>
			<cfset new_author_results = DeserializeJSON(author_results)>
			<cfif new_author_results[1].id gt 0>
				<cfset result.message = "ALERT: Matching author(s) in the database">
				<cfset result.display_string = "">
				<cfset result.number_matches = new_author_results.size()>
				<cfloop from="1" to="#result.number_matches#" step="1" index="temp_entry">
					<cfset "result.author#temp_entry#.FamilyName" = new_author_results[temp_entry].value>
					<cfset "result.author#temp_entry#.GivenName" = new_author_results[temp_entry].value>
					<cfset "result.author#temp_entry#.PKID" = new_author_results[temp_entry].id>
					<cfset "result.author#temp_entry#.ZBLSID" = new_author_results[temp_entry].ZBLSID>
				</cfloop>
			<cfelse><!---there are no matches, so do the insert--->
				<cfinvoke method="insert_author" returnvariable="insert_result">
					<cfinvokeargument name="GivenName" value="#Arguments.GivenName#">
					<cfinvokeargument name="FamilyName" value="#Arguments.FamilyName#">
					<cfif Arguments.author_suffix is not "">
						<cfinvokeargument name="author_suffix" value="#Arguments.author_suffix#">
					</cfif>
					<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
					<cfif Arguments.LinkID is not "">
						<cfinvokeargument name="LinkID" value="#Arguments.LinkID#">
					</cfif>
					<cfinvokeargument name="no_verify" value="1">
				</cfinvoke>
				<cfreturn insert_result />
			</cfif>
		<cfelse><!--- do the insert --->
			<cfquery name="insert_person" datasource="#datasource#">
				DECLARE @result varchar(36)
				
				EXEC	sp_insertPerson @GivenName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.GivenName#">,  
				@FamilyName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FamilyName#">,
				@LogUserName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">,
				@suffix=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.author_suffix#">
				<cfif Arguments.LinkID gt 0>
					,@ValidAgentUUID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LinkID#">
				</cfif>
				
				,@UUID=@result output
				
				select @result as UUID
				
			</cfquery>
			<cfset result.message = "success">
			<cfset result.UUID = insert_person.UUID>
			<cfset result.FamilyName = Arguments.FamilyName>
			<cfset result.GivenName = Arguments.GivenName>
			<!--- If the new name is linked to another name, do not create an LSID, else create one --->
			<cfif Arguments.LinkID is not "">
				<cfset result.lsid = "Alias name, no LSID">
			<cfelse>
				<!--- register this person to get them an LSID --->
				<cfinvoke method="create_LSID" returnvariable="register">
					<cfinvokeargument name="PKID" value="#insert_person.PKID#">
					<!---<cfinvokeargument name="RegisteringAgentID" value="">--->
					<cfinvokeargument name="DoRegister" value="1">
					<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
				</cfinvoke>
				<cfset result.lsid = register>
			</cfif>
		</cfif>
		
		<cfreturn result />		
	</cffunction>
	
	<cffunction name="get_pub_types" access="remote" hint="Returns a list of published works - a publication in which a nomenclatural act can appear" returntype="string" returnformat="plain">
		<!---table name is reference_type
		Need a hint to display the difference between a book and an edited volume (has authored chapters)
		--->		
		<cfscript>
			pub_type_query = QueryNew("id, value");
			QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "0");
			querySetCell(pub_type_query, "value", "&nbsp;");
			QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "1");
			querySetCell(pub_type_query, "value", "Article in a Journal, Magazine, or other Periodical");
			QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "2");
			querySetCell(pub_type_query, "value", "Book or Monograph");
			QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "3");
			querySetCell(pub_type_query, "value", "Book Section");
			QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "5");
			querySetCell(pub_type_query, "value", "Edited Volume with separately-authored Chapters or Sections");
			// Convert the query to JSON.
			theJSON = SerializeJSON(pub_type_query,false,true);
		</cfscript>
			<!---QueryAddRow(pub_type_query, 1);
			querySetCell(pub_type_query, "id", "13");
			querySetCell(pub_type_query, "value", "Electronic Publication");--->
		<cfreturn theJSON />
	</cffunction>
	
	<cffunction name="get_pub_authors" access="remote" hint="Returns a list of authors for a given reference" returntype="query" returnformat="json">
		<cfargument name="ReferenceID" type="numeric" required="yes">
		<!---
		Stored Procedure - sp_GetReferenceAuthorList
		Returns columns:
		AgentID = PKID for author
		UUID 
		LSID
		IsPerson - 1 is Person, 0 is organization
		CheatFullAgent - preformatted name
		GivenName
		FamilyName
		Suffix
		OrganizationName
		Abbreviation
		ParentOrganizationID
		AuthorType = "Author", "Editor", "Director" - Text field
		Sequence - integer to tell what order in the authorship
		
		--->
		<cfquery name="get_authors" datasource="#datasource#">
			EXEC sp_GetReferenceAuthorList 
			<cfif Arguments.ReferenceID gt 0>@ReferenceID = #Arguments.ReferenceID#</cfif>
		</cfquery>
		<cfreturn get_authors />	
	</cffunction>
	
	<cffunction name="find_taxon_act" access="remote" hint="Returns a list of taxon names that match a search term" returntype="string" returnformat="plain">
		<cfargument name="term" type="string" required="no">
		<cfargument name="TaxonNameUsageID" type="string" required="no">
		<cfquery name="get_acts" datasource="#datasource#">
			<!---SELECT     parent_ref.Title as parent_title, r.CheatCitation, r.CheatAuthors, r.CheatCitationDetails, r.CheatSearchReference, v.LSID, v.isOriginal, v.TaxonRankID, v.Rank, v.RankGroup, 
                      v.NameString, v.namePrefix, v.nameSuffix, v.IsItalics, v.nameComplete, v.oAuthorship, v.oYear, v.oPages, v.authorship, v.Year, v.Pages, v.TaxonNameUsageID, 
                      v.ProtonymID, v.ValidUsageID, v.ParentUsageID, v.SearchString, v.FormattedParent, v.ReferenceTypeID, v.ReferenceID, v.CheatFullAuthors, r.ReferenceID AS Expr1, 
                      r.ParentReferenceID, r.ReferenceTypeID AS Expr2, r.LanguageID, r.Year AS Expr3, r.Title, r.SecondaryTitle, r.Publisher, r.PlacePublished, r.Volume, 
                      r.NumberVolumes, r.Number, r.Pages AS reference_page, r.InPages, r.Section, r.Edition, r.DatePublished, r.TypeWork, r.ShortTitle, r.Figures, r.StartDate, r.EndDate, 
                      r.URL
				FROM         view_ZooBankSearchActs AS v INNER JOIN
                      Reference AS r ON v.ReferenceID = r.ReferenceID LEFT OUTER JOIN
                      Reference AS parent_ref ON parent_ref.ReferenceID = r.ParentReferenceID--->
			<!---SELECT     p.ProtonymID, p.TypeProtonymID, p.WordTypeID, p.NomenCodeID, p.GenderID, p.IsFossil, p.Grade, p.CheatAvailable, p.CheatHomonym, p.CheatFullProtonym, 
                      p.CheatAcceptedUsageID, p.CheatHierarchy, p.OriginalParent, p.Types, p.TypeLocality, p.Authors, p.IsGenderMatched, tn.TaxonNameUsageID, 
                      tn.ProtonymID AS Expr1, tn.ReferenceID, tn.TaxonRankID, tn.ValidUsageID, tn.ParentUsageID, tn.ReliabilityID, tn.NameString, tn.Prefix, tn.Suffix, tn.Pages, 
                      tn.Illustration, tn.IsNothoTaxon, tn.IsQuestioned, tn.IsNewCombination, tn.IsFirstRevision, tn.tsn, tn.CheatNameComplete, tn.CheatIsAutonym, tn.CheatStatus, 
                      r.ReferenceID AS Expr2, r.ParentReferenceID, r.ReferenceTypeID, r.LanguageID, r.Year, r.Title, r.SecondaryTitle, r.Publisher, r.PlacePublished, r.Volume, 
                      r.NumberVolumes, r.Number, r.Pages AS oPages, r.InPages, r.Section, r.Edition, r.DatePublished, r.TypeWork, r.ShortTitle, r.Figures, r.StartDate, r.EndDate, r.URL, 
                      r.CheatCitation, r.CheatAuthors, r.CheatFullAuthors, r.CheatCitationDetails, r.CheatSearchReference, parent_ref.Title AS parent_title, 'asdfasdfasdfasdfdssdfa' as lsid,
					  parent_ref.CheatFullProtonym as formattedparent,tr.rank
			FROM         Protonym AS p INNER JOIN
                      TaxonNameUsage AS tn ON tn.ProtonymID = p.ProtonymID LEFT OUTER JOIN
                      Reference AS r ON tn.ReferenceID = r.ReferenceID LEFT OUTER JOIN
                      Reference AS parent_ref ON parent_ref.ReferenceID = r.ParentReferenceID LEFT OUTER JOIN 
					  TaxonRank as tr on tr.TaxonRankID = tn.TaxonRankID--->
					  SELECT p.ProtonymID, p.TypeProtonymID, p.WordTypeID, p.NomenCodeID, p.GenderID, p.IsFossil, p.Grade, p.CheatAvailable, p.CheatHomonym, p.CheatFullProtonym, 
						p.CheatAcceptedUsageID, p.CheatHierarchy, p.OriginalParent, p.Types, p.TypeLocality, p.Authors, p.IsGenderMatched, tn.TaxonNameUsageID, 
						tn.ProtonymID AS Expr1, tn.ReferenceID, tn.TaxonRankID, tn.ValidUsageID, tn.ParentUsageID, tn.ReliabilityID, tn.NameString, tn.Prefix, tn.Suffix, tn.Pages, 
						tn.Illustration, tn.IsNothoTaxon, tn.IsQuestioned, tn.IsNewCombination, tn.IsFirstRevision, tn.tsn, tn.CheatNameComplete, tn.CheatIsAutonym, tn.CheatStatus, 
						r.ReferenceID AS Expr2, r.ParentReferenceID, r.ReferenceTypeID, r.LanguageID, r.Year, r.Title, r.SecondaryTitle, r.Publisher, r.PlacePublished, r.Volume, 
						r.NumberVolumes, r.Number, r.Pages AS oPages, r.InPages, r.Section, r.Edition, r.DatePublished, r.TypeWork, r.ShortTitle, r.Figures, r.StartDate, r.EndDate, r.URL, 
						r.CheatCitation, r.CheatAuthors, r.CheatFullAuthors, r.CheatCitationDetails, r.CheatSearchReference, parent_ref.Title AS parent_title, ZBLSID.lsid, dbo.FormatNameComplete(tn.ParentUsageID, 1, tn.TaxonRankID, tn.ParentUsageID) As FormattedParent, tr.[rank] as [Rank],tn.CheatNameComplete as NameComplete
						FROM Protonym AS p INNER JOIN
						TaxonNameUsage AS tn ON tn.ProtonymID = p.ProtonymID LEFT OUTER JOIN
						Reference AS r ON tn.ReferenceID = r.ReferenceID LEFT OUTER JOIN
						Reference AS parent_ref ON parent_ref.ReferenceID = r.ParentReferenceID left outer join 
						view_ZooBankLSID As ZBLSID ON tn.TaxonNameUsageID = ZBLSID.PKID INNER JOIN
						TaxonRank AS tr ON tn.TaxonRankID=tr.TaxonRankID
			WHERE    p.ProtonymID <> 0
				<cfif Arguments.term is not "">
					<cfloop list="#Trim(Arguments.term)#" delimiters=" " index="temp_term">
						AND (CheatNameComplete LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Trim(temp_term)#%">)  
					</cfloop>
				</cfif>
				<cfif Arguments.TaxonNameUsageID is not "">
					AND TaxonNameUsageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TaxonNameUsageID#">
				</cfif>
		</cfquery>	
		
		
		<cfset return_string = '['>
		<cfoutput query="get_acts">
			<cfset BHL_Response = "No BHL Results">
			<cfset bhl_PageID = 0>
			<cfset bhl_itemid = 0>
			<cfset bhl_titleid = 0>
			<cfset bhl_pageNumbers_list = ''>
			<!---try to get BHL data on the Act--->
			<cfif Arguments.TaxonNameUsageID is not "" AND ListFirst(oPages,"-") gt 0>
				<cfinvoke component="services" method="get_bhl" returnvariable="service_results">
					<cfinvokeargument name="year" value="#year#">
					<cfinvokeargument name="title" value="#parent_title#">
					<cfinvokeargument name="volume" value="#volume#">
				</cfinvoke>
				
				<cfif IsDefined("service_results.Result[1].Items[1].ItemID")>
					<cfif service_results.Result[1].Items[1].ItemID gt 0>
					
					<!--- 485-488, pl. 15 
						<cfif Find("pl.",reference_page)>
							<cfset reference_page = Replace(reference_page,"pl.","","ALL")>
						</cfif>--->
						<cfset temp_reference_page = Trim(oPages)>
						<cfset page_number_list = "">
						
						
						<cfif find("-",temp_reference_page)>
							<cfset temp_reference_page = ListFirst(temp_reference_page,",")>
							<cfset start_num = ListFirst(temp_reference_page,"-")>
							<cfset end_num = ListLast(temp_reference_page,"-")>
							<cfloop from="#start_num#" to="#end_num#" index="temp_page">
								<cfset page_number_list = ListAppend(page_number_list,temp_page)>
							</cfloop>
						<cfelse>
							<cfset page_number_list = temp_reference_page>
						</cfif>
					
						<cfquery name="get_bhl" datasource="bhl_h2">
							SELECT p.PageID, p.ItemID, p.SequenceOrder, p.Year, p.Volume, p.Issue, p.PagePrefix, p.PageNumber, p.PageTypeName, p.CreationDate,i.titleid
							FROM page AS p INNER JOIN
							item AS i ON p.ItemID = i.ItemID
							WHERE i.ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_results.Result[1].Items[1].ItemID#"> 
							and p.PageNumber in (#page_number_list#) <!--- #ListFirst(reference_page,"-")#	--->
						</cfquery>	
						<cfif get_bhl.recordcount gt 0>
							<cfset BHL_Response = "BHL Success">
							<cfset bhl_PageID = ValueList(get_bhl.PageID)>
							<cfset bhl_pageNumbers_list = ValueList(get_bhl.PageNumber)>
							<cfset bhl_itemid = get_bhl.ItemID>
							<cfset bhl_titleid = get_bhl.titleid>
						<cfelse>
							<cfset BHL_Response = "0 results">
						</cfif>
					</cfif>		
				</cfif>
			</cfif>
			<cfset return_string = '#return_string#{"id": "#TaxonNameUsageID#", "label": "#CheatNameComplete#", "value": "#CheatNameComplete#","ReferenceID":"#ReferenceID#","lsid":"#LSID#","FormattedParent":"#FormattedParent#","NameString":"#NameString#","Rank":"#Rank#","nameComplete":"#nameComplete#","CheatCitation":"#CheatCitation#","CheatFullAuthors":"#CheatFullAuthors#","CheatCitationDetails":"#CheatCitationDetails#","Year":"#Year#","Title":"#Title#","bhl_response":"#BHL_Response#","bhl_pageid":"#bhl_PageID#","volume":"#volume#","parent_title" : "#parent_title#","bhl_pageNumbers_list":"#bhl_pageNumbers_list#","verbatimPages":"#oPages#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_acts.recordcount is 0>
			<cfset return_string = '[{"id":0,"label":"No Match Found for:.","value":"No Match Found for: ."}]'>
		</cfif>
		
		<cfreturn return_string />
	</cffunction>
	
	<cffunction name="find_language" access="remote" hint="returns a list of languages filtered by term" returntype="string" returnformat="plain">
		<cfargument name="term" type="string" required="no">
		<cfquery name="get_lang" datasource="#datasource#">
			SELECT     LanguageID, Language
			FROM         Language
			where Language like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.term#%">
		</cfquery>
		
		<cfset return_string = '['>
		<cfoutput query="get_lang">
			<cfset return_string = '#return_string#{"id": "#LanguageID#", "label": "#Language#", "value": "#Language#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_lang.recordcount is 0>
			<cfset return_string = '[{"id":"0","label":"No Match Found for: #term#.","value":"No Match Found for: #term#."}]'>
		</cfif>
		
		<cfreturn return_string />
	</cffunction>
	
	<cffunction name="find_taxon_level" access="remote" hint="returns a list of taxon levels optionally filtered" returntype="string" returnformat="plain">
		<cfargument name="term" type="string" required="no">
		<cfargument name="rank_id" type="numeric" required="no" default="100">
		<cfargument name="rank_group" type="string" required="no" default="Family">
		<cfquery name="get_rank" datasource="#datasource#">
			<!---SELECT     TOP (200) TaxonRankID, Abbreviation, Rank, ZoologyRank, BotanyRank, BacteriaRank, ViralRank, TaxonRankTerm, Prefix, Suffix, rank_ID, IsItalics
			FROM         TaxonRank
			WHERE    Rank like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.term#%">
			and rank_ID >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.rank_id#">
			ORDER BY rank_ID
			
			Returns two columns
			TaxonRankID - Value
			Rank - Display Value
			--->
			EXEC sp_ListTaxonRank
			@filter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.rank_group#">
			
			
		</cfquery>
		
		
		<cfset return_string = '['>
		<cfoutput query="get_rank">
			<cfset return_string = '#return_string#{"id": "#TaxonRankID#", "label": "#Rank#", "value": "#Rank#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_rank.recordcount is 0>
			<cfset return_string = '[{"id":0,"label":"","value":"No Match Found for: #term#."}]'>
		</cfif>
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<!--- Stream the content back to the client. --->
		<cfcontent
		type="application/json; charset=utf-8"
		variable="#return_string#"
		/>
		<!---<cfreturn return_string />--->
	</cffunction>
	
	<cffunction name="create_LSID" hint="Creates a new registration for an item, and returns the LSID" access="public">
		<cfargument name="PKID" type="numeric" required="no" default="0">
		<cfargument name="UUID" type="string" required="no" default="">
		<!---<cfargument name="RegisteringAgentID" type="numeric" required="yes">--->
		<cfargument name="DoRegister" type="numeric" required="no" default="1">
		<cfargument name="LogUserName" type="string" required="yes">
		
		<cfquery name="register_name" datasource="#datasource#">
			DECLARE @result varchar(150)
			EXEC	sp_AssignZooBankLSID 
			<cfif PKID gt 0>
				@PKID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PKID#">,
			<cfelseif UUID is not "">
				@UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UUID#">,
			</cfif>
			<!---@RegisteringAgentID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RegisteringAgentID#">,--->
			@DoRegister	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DoRegister#">,
			@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">,
			@LSID=@result output
				
			select @result as LSID
				
		</cfquery>	
		
		<cfreturn register_name.LSID />
	</cffunction>
	<cffunction name="insert_reference" hint="Inserts a new reference item" access="remote" returntype="string" returnformat="plain">
		<cfargument name="ParentReferenceUUID" type="string" required="no">
		<cfargument name="ReferenceTypeID" type="numeric" required="yes">
		<cfargument name="LanguageID" type="string" required="no">
		<cfargument name="issn_online" type="string" required="no">
		<cfargument name="issn_print" type="string" required="no">
		<cfargument name="ISBN" type="string" required="no">
		<cfargument name="DOI" type="string" required="no">
		<cfargument name="RepositoryName" type="string" required="no">
		<cfargument name="Year" type="string" required="yes">
		<cfargument name="Title" type="string" required="yes">
		<cfargument name="Volume" type="string" required="yes">
		<cfargument name="Number" type="string" required="yes">
		<cfargument name="Pages" type="string" required="yes">
		<cfargument name="Figures" type="string" required="yes">
		<cfargument name="DatePublished" type="string" required="yes">
		<cfargument name="Authors" type="string" required="no" hint="A comma delimited list of Agent UUIDs">
		<cfargument name="LogUserName" type="string" required="yes" hint="The user name of the user entering the reference">
		<cfargument name="author_name_list" type="string" required="no" hint="a bar delimited list of the author names, formatted ['ALIAS~']familyname(s),givenname(s)">
		<!---@ParentReferenceUUID	int				=0,
		@ReferenceTypeID	tinyint			=0,
		@LanguageID			int				=0,
		@Year				nvarchar(25)	=NULL,
		@Title				nvarchar(1000)	=NULL,
		@ShortTitle			nvarchar(255)	=NULL,
		@Publisher			nvarchar(255)	=NULL,
		@PlacePublished		nvarchar(255)	=NULL,
		@Volume				nvarchar(255)	=NULL,
		@NumberVolumes		nvarchar(255)	=NULL,
		@Number				nvarchar(255)	=NULL,
		@Pages				nvarchar(255)	=NULL,
		@InPages			nvarchar(255)	=NULL,
		@Figures			nvarchar(255)	=NULL,
		@Edition			nvarchar(255)	=NULL,
		@DatePublished		nvarchar(255)	=NULL,
		@StartDate			datetime		=NULL,
		@EndDate			datetime		=NULL,
		@TypeWork			nvarchar(255)	=NULL,
		@URL				nvarchar(2000)	=NULL,
		@Authors			nvarchar(MAX)	=NULL,
		@LogUserName		nvarchar(128)	='',
		@PKID				int				=0		OUTPUT--->
		
		<!---<cftransaction>--->
			<cfset update_author_uuid_list = "">
			<!---check to see that each author exists, if not create the agend and get the UUID --->
			<cfif Arguments.Authors is not "">
				<cfset author_count = 1>				
				<cfif Left(author_name_list,1) is "|">
					<cfset author_name_list = RemoveChars(author_name_list,1,1)>
				</cfif>
				<cfloop list="#author_name_list#" delimiters="|" index="temp_author_name">
					<cfset current_author_uuid = ListGetAt(Arguments.Authors,author_count,",")>					
					<!--- deal with Aliases--->
					<cfif Find("ALIAS~",temp_author_name)>
						<cfinvoke method="insert_author" returnvariable="new_author_uuid">
							<cfinvokeargument name="FamilyName" value="#Trim(ListLast(ListFirst(temp_author_name),"~"))#">
							<cfinvokeargument name="GivenName" value="#Trim(Listlast(temp_author_name))#">
							<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
							<cfinvokeargument name="LinkID" value="#ListGetAt(Arguments.Authors,author_count,",")#">
							<cfinvokeargument name="no_verify" value="1">						
						</cfinvoke>
						<cfset current_author_uuid = new_author_uuid.UUID>
					<cfelse><!---not an alias of a registered person, check to see if they are already registered--->					
						<cfinvoke component="gnub_services" method="get_author" returnvariable="author_details">
							<cfinvokeargument name="UUID" value="#ListGetAt(Arguments.Authors,author_count,",")#">
						</cfinvoke>
						<!---<cfdump var="#author_details#">--->
						<cfif author_details.recordcount is 0><!---insert the author --->
							<cfset new_author_family_name = Trim(ListFirst(temp_author_name))>
							<cfset new_author_given_name = Trim(Listlast(temp_author_name))>
							<cfinvoke method="insert_author" returnvariable="new_author_uuid">
								<cfinvokeargument name="FamilyName" value="#new_author_family_name#">
								<cfinvokeargument name="GivenName" value="#new_author_given_name#">
								<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
								<cfinvokeargument name="no_verify" value="1">						
							</cfinvoke>
							<cfset current_author_uuid = new_author_uuid.UUID>
						</cfif>
					</cfif><!--- Alias or not--->
					<cfset update_author_uuid_list = ListAppend(update_author_uuid_list,current_author_uuid,"|")>
					<cfset author_count = author_count + 1>
				</cfloop>
			</cfif>
								
			<!--- Check to see if this reference exists --->
			<cfinvoke method="get_reference" component="gnub_services" returnvariable="check_duplicate_pub">
				<cfinvokeargument name="search_term" value="#Arguments.Title#29348579234">
				<cfinvokeargument name="ParentReferenceUUID" value="#Arguments.ParentReferenceUUID#">
				<cfinvokeargument name="AuthorUUIDList" value="#update_author_uuid_list#">
				<cfinvokeargument name="StartYear" value="#Arguments.Year#">
				<cfinvokeargument name="Volume" value="#Arguments.Volume#">				
			</cfinvoke>
			<cfset function_result = StructNew()>
			<cfif check_duplicate_pub.recordcount is 0>
				<cfset stripped_title = Replace(Arguments.Title,Chr(10)," ","ALL")>
				<cfset stripped_title = Replace(stripped_title,Chr(13)," ","ALL")>
				<cfquery name="insert_reference" datasource="#datasource#">
					EXEC	sp_InsertReference 
					@ParentReferenceUUID = <cfif Arguments.ParentReferenceUUID gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ParentReferenceUUID#"><cfelse>0</cfif>,
					@ReferenceTypeID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReferenceTypeID#">,			
					@LanguageID	= <cfif Arguments.LanguageID gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LanguageID#"><cfelse>0</cfif>,
					@Year	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Year)#">,
					@Title	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#stripped_title#">,
					@Volume	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Volume#">,
					@Number	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Number#">,
					@Pages	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pages#">,
					@Figures	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Figures#">,
					@DatePublished	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.DatePublished)#">,
					@Authors	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(update_author_uuid_list,",","|","ALL")#|">,
					@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">					
				</cfquery>
				
				<!---<cfdump var="#insert_reference#"><cfabort>--->
				<!--- Check to see if any identifiers have been passed.  If so, create the identifiers --->				
				<cfif Arguments.issn_online is not "">
					<cfif Arguments.ParentReferenceUUID is not 0>
						<cfset identifier_uuid = Arguments.ParentReferenceUUID>
					<cfelse>
						<cfset identifier_uuid = insert_reference.UUID>
					</cfif>
					<cfinvoke component="gnub_services" method="create_identifier">
						<cfinvokeargument name="Domain" value="ISSN">
						<cfinvokeargument name="UUID" value="#identifier_uuid#">
						<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
						<cfinvokeargument name="Identifier" value="#Arguments.issn_online#">
						<cfinvokeargument name="ResolutionNote" value="Online Edition">
					</cfinvoke>
				</cfif>
				<cfif Arguments.issn_print is not "">
					<cfif Arguments.ParentReferenceUUID is not 0>
						<cfset identifier_uuid = Arguments.ParentReferenceUUID>
					<cfelse>
						<cfset identifier_uuid = insert_reference.UUID>
					</cfif>
					<cfinvoke component="gnub_services" method="create_identifier">
						<cfinvokeargument name="Domain" value="ISSN">
						<cfinvokeargument name="UUID" value="#identifier_uuid#">
						<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
						<cfinvokeargument name="Identifier" value="#Arguments.issn_print#">
						<cfinvokeargument name="ResolutionNote" value="Print Edition">
					</cfinvoke>
				</cfif>
				<cfif Arguments.ISBN is not "">
					<cfif Arguments.ParentReferenceUUID is not 0>
						<cfset identifier_uuid = Arguments.ParentReferenceUUID>
					<cfelse>
						<cfset identifier_uuid = insert_reference.UUID>
					</cfif>
					<cfinvoke component="gnub_services" method="create_identifier">
						<cfinvokeargument name="Domain" value="ISBN">
						<cfinvokeargument name="UUID" value="#identifier_uuid#">
						<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
						<cfinvokeargument name="Identifier" value="#Arguments.ISBN#">
					</cfinvoke>
				<cfelseif Arguments.DOI is not "">
					<cfinvoke component="gnub_services" method="create_identifier">
						<cfinvokeargument name="Domain" value="DOI">
						<cfinvokeargument name="UUID" value="#insert_reference.UUID#">
						<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
						<cfinvokeargument name="Identifier" value="#Arguments.DOI#">
					</cfinvoke>
				</cfif>
				
				<!--- deal with online archive--->
				<cfif Arguments.RepositoryName is not "">
					<cfinvoke component="gnub_services" method="link_repository">
						<cfinvokeargument name="ReferenceUUID" value="#insert_reference.UUID#">
						<cfinvokeargument name="RepositoryName" value="#Arguments.RepositoryName#">
						<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">
					</cfinvoke>			
				</cfif>
				
				<!---get the cheat citation for the new entry for display purposes--->			
				<cfinvoke method="get_reference" component="gnub_services" returnvariable="new_citation_value">
					<cfinvokeargument name="ReferenceUUID" value="#insert_reference.UUID#">
				</cfinvoke>			
				<!---set the LSID--->
				<cfinvoke method="create_LSID" returnvariable="new_reference_LSID">
					<cfinvokeargument name="UUID" value="#insert_reference.UUID#">
					<cfinvokeargument name="DoRegister" value="1">
					<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">			
				</cfinvoke>
				<!---<cfset function_result = '[{"pk":"#insert_reference.PK#","new_citation":"#Arguments.Title#"}]'>--->
				
				<cfset function_result.UUID = insert_reference.UUID>
				<cfif Arguments.ReferenceTypeID is 39>
					<cfset function_result.new_citation = "<em>#new_citation_value.FullTitle#</em>">
				<cfelse>
					<cfset function_result.new_citation = "#new_citation_value.Authors# #new_citation_value.Year# #new_citation_value.FullTItle# #new_citation_value.CitationDetails#">
				</cfif>
				<cfset function_result.message = "Success">
				<cfset function_result.lsid = new_reference_LSID>
				<cfset function_result.cheatauthors = new_citation_value.Authors>
			<cfelse><!---duplicate pub recordcount gt 0--->
				<cfset function_result.uuid = check_duplicate_pub.uuid>
				<cfset function_result.new_citation = arguments.title>
				<cfset function_result.message = "Publication already exists.">
			</cfif>
		<!---</cftransaction>--->
		<cfcontent
		type="application/json; charset=utf-8">
		<cfheader statuscode="200" statustext="ok" /><cfoutput>[{"message":"#function_result.message#","uuid":"#function_result.UUID#","fulltitle":"#function_result.new_citation#","referencetypeid":"#Arguments.ReferenceTypeID#"}]</cfoutput>
	</cffunction>
	
	<cffunction name="get_nomenclatural_acts" access="remote" returntype="query" returnformat="json" hint="Returns all nomenclatural acts (names), optionally filtered by author and/or publication">
		<cfargument name="ReferenceID" type="numeric" required="no">
		<cfargument name="RankGroup" type="string" required="no" default="">
		<cfargument name="term" type="string" required="no">
		<!---
			sp_ListReferenceTNU
	
			INPUT:
			@ReferenceID (PKID for reference to list containing TNUs)
			@RankGroup ('Higher'|'Family'|'Genus'|'Species'|'Other') -- used to filter
			to a particular rank group
			
			OUTPUT
			TaxonNameUsageID
			lsid
			UUID
			ProtonymID
			IsOriginal (1=originally described in this work, otherwise 0)
			ReferenceID
			TaxonRankID
			Rank
			RankGroup
			SortRank
			Display  --->
		<cfquery name="get_names" datasource="#datasource#">
			EXEC sp_ListReferenceTNU
			@ReferenceID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReferenceID#">,
			@RankGroup =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RankGroup#">
			<!---SELECT     TOP (200) ReferenceID, RankGroup, IsOriginal, IsItalics, NameString, NameString, TaxonRankID, FormattedParent, Rank, oAuthorship, oYear, oPages, Pages, TaxonNameUsageID, ProtonymID
			FROM         view_ZooBankListActs
			WHERE     ReferenceID > 0
			<cfif Arguments.ReferenceID gt 0>
				and (ReferenceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReferenceID#">)
			</cfif>
			<cfif Arguments.lowest_taxon_rank gt 0>
				and TaxonRankID >= 60
			</cfif>
			<cfif arguments.term is not "">
				and NameString like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.term#%">
			<cfelse>
				<cfset term = "Reference ID: #Arguments.ReferenceID#">
			</cfif>
			order by TaxonRankID asc--->
		</cfquery>
	
		<!---<cfset return_string = '['>
		<cfoutput query="get_names">
			<cfset return_string = '#return_string#{"id": "#TaxonNameUsageID#", "label": "#Rank# #NameString# (#oAuthorship#, #oYear#)", "value": "#NameString# (#oAuthorship#, #oYear#)","rank": "#Rank#","referenceid": "#ReferenceID#", "taxonrankid":"#TaxonRankID#"},'>
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>
		<cfset return_string = '#return_string#]'>
		<cfif get_names.recordcount is 0>
			<cfset return_string = '[{"id":0,"label":"","value":"No Match Found for: #term#."}]'>
		</cfif>
		
		<cfreturn return_string />--->
		<cfreturn get_names />
	
	</cffunction>
	
	
	<cffunction name="insert_taxon_name" hint="Inserts a new name" access="remote" returnformat="JSON" returntype="struct">
		<cfargument name="ReferenceUUID" type="string" required="yes">
		<cfargument name="ProtonymUUID" type="string" required="no">
		<cfargument name="TaxonRankID" type="numeric" required="no">
		<cfargument name="ParentUsageUUID" type="string" required="no">
		<cfargument name="NameString" type="string" required="no">
		<cfargument name="Pages" type="string" required="no">
		<cfargument name="Authors" type="string" required="no">
		<cfargument name="Types" type="string" required="no">
		<cfargument name="IsFossil" type="string" required="no">
		<cfargument name="Illustration" type="string" required="no">
		<cfargument name="LogUserName" type="string" required="no">
		<cfargument name="establish_protonym" type="numeric" required="yes">
		<cfargument name="assign_zb_lsid" type="numeric" required="yes">
	
		<!--- 	
		--		@ReferenceID	: publication that the name is in 
		--		@TaxonRankID
		--		@ValidUsageID
		--		@ParentUsageID
		--		@ReliabilityID
		--		@NameString
		--		@Prefix
		--		@Suffix
		--		@Pages
		--		@Illustration
		--		@IsNothoTaxon
		--		@IsQuestioned
		--		@IsNewCombination
		--		@IsFirstRevision
		--		@tsn
		--		@ParentRankID
		--		@LogUserName
		
		Returns PKID, UUID in a recordset		
		--->		
		<cftransaction>
			<cfquery name="insert_name" datasource="#datasource#">		
				EXEC	sp_InsertTaxonNameUsage
				@ReferenceUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReferenceUUID#">,
				@TaxonRankID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TaxonRankID#">,
				<cfif Arguments.ParentUsageUUID is not "">
					@ParentUsageUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ParentUsageUUID#">,
				</cfif>
				@NameString = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NameString#">,
				@Pages = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pages#">,
				@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">
				<cfif arguments.ProtonymUUID is not "">, @ProtonymUUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProtonymUUID#"></cfif>
						
			</cfquery>
			
			<!---<cfscript>
				sleep(15000);
			</cfscript>--->			
			<cfif Arguments.ReferenceUUID is not "">
				<!--- get the reference details to populate the response with authors and year--->
				<cfinvoke method="get_reference" component="gnub_services" returnvariable="get_reference_data">
					<cfinvokeargument name="ReferenceUUID" value="#Arguments.ReferenceUUID#">
					<cfinvokeargument name="PublishedOnly" value="0">
				</cfinvoke>
				<cfset result.year = get_reference_data.year>
				<cfset result.authors = get_reference_data.Authors>
			<cfelse>
				<cfset result.year = "">
				<cfset result.authors = "">
			</cfif>
			
			
			<cfset result.message = "Created Taxon Name Usage (UUID:#insert_name.UUID#)">
			<!---<cfset result.new_taxon_name_usage_id = insert_name.PKID>--->
			<cfif Arguments.establish_protonym is 1>
				<!---call to establish a protonym--->
				<cfinvoke method="insert_protonym">
					<cfinvokeargument name="ProtonymID" value="#insert_name.PKID#">
					<cfinvokeargument name="NomenCodeID" value="2">
					<cfif Arguments.IsFossil gt 0>
						<cfinvokeargument name="IsFossil" value="#Arguments.IsFossil#">
					<cfelse>
						<cfinvokeargument name="IsFossil" value="0">
					</cfif>
					<cfinvokeargument name="Types" value="#Arguments.Types#">
					<cfinvokeargument name="Authors" value="#Arguments.Authors#">
					<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">		
				</cfinvoke>
				<cfset result.message = "#result.message# and established protonym">
			</cfif>
			
			<!--- get the nomenclatural act details to populate the response with the clean display--->
			<cfinvoke method="get_nomenclatural_acts" component="gnub_services" returnvariable="get_nomenclatural_act_data">
				<cfinvokeargument name="UUID" value="#insert_name.UUID#">
			</cfinvoke>							
			<cfset result.name_clean_display = get_nomenclatural_act_data.CleanDisplay>			
			<cfset result.uuid = insert_name.UUID>			
			
			<cfif Arguments.assign_zb_lsid is 1>
				<!--- Register the new LSID --->
				<cfinvoke method="create_LSID" returnvariable="new_reference_LSID">
					<cfinvokeargument name="PKID" value="#insert_name.PKID#">
					<cfinvokeargument name="DoRegister" value="1">
					<cfinvokeargument name="LogUserName" value="#Arguments.LogUserName#">			
				</cfinvoke>	
				<cfset result.message = "#result.message# and created LSID (#new_reference_LSID#)">
				<cfset result.new_lsid = new_reference_LSID>
			</cfif>
		</cftransaction>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="insert_protonym" hint="insert a new protonym">
		<cfargument name="ProtonymID" type="numeric" required="yes">
		<cfargument name="NomenCodeID" type="numeric" required="no" default="2">
		<cfargument name="IsFossil" type="numeric" required="no" default="0">
		<cfargument name="Types" type="string" required="no" default="2">
		<cfargument name="Authors" type="string" required="no" default="2">
		<cfargument name="LogUserName" type="string" required="no" default="2">
		<!---@ProtonymID=NewPKID
		@NomenCodeID=2
		@IsFossil
		@Types
		@Authors
		@LogUserName--->
		<cfquery name="insert_new_name" datasource="#datasource#">
			EXEC sp_EstablishProtonym
			@ProtonymID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProtonymID#">,
			@NomenCodeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NomenCodeID#">,
			@IsFossil = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IsFossil#">,
			@Types = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Types#">,
			@Authors = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Authors#">,
			@LogUserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LogUserName#">		
		</cfquery>	
	</cffunction>
	
	<cffunction name="get_protonym" hint="Returns a list of names that match search string" access="remote" returnformat="plain">
		<cfargument name="RankGroup" type="string" required="no">
		<cfargument name="term" type="string" required="no">
		<cfargument name="ProtonymID" type="numeric" required="no">
		<cfargument name="display_type" type="string" required="no" default="autocomplete">
		<!--- INPUT:
		@RankGroup ('Family'|'Genus'|'Species')
		@SearchTerm - any part of taxon name you'r looking for
		
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
			<!---EXEC 	sp_SearchProtonym
			@RankGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RankGroup#">,
			@SearchTerm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.term#">	--->

			SELECT     p.ProtonymID, p.TypeProtonymID, p.WordTypeID, p.NomenCodeID, p.GenderID, p.IsFossil, p.Grade, p.CheatAvailable, p.CheatHomonym, p.CheatFullProtonym, 
                      p.CheatAcceptedUsageID, p.CheatHierarchy, p.OriginalParent, p.Types, p.TypeLocality, p.Authors, p.IsGenderMatched, tn.TaxonNameUsageID, 
                      tn.ProtonymID AS Expr1, tn.ReferenceID, tn.TaxonRankID, tn.ValidUsageID, tn.ParentUsageID, tn.ReliabilityID, tn.NameString, tn.Prefix, tn.Suffix, tn.Pages, 
                      tn.Illustration, tn.IsNothoTaxon, tn.IsQuestioned, tn.IsNewCombination, tn.IsFirstRevision, tn.tsn, tn.CheatNameComplete, tn.CheatIsAutonym, tn.CheatStatus
			FROM         Protonym AS p INNER JOIN
								  TaxonNameUsage AS tn ON tn.ProtonymID = p.ProtonymID
			WHERE     p.ProtonymID <> 0
			<cfif Arguments.term is not "">
				AND (tn.CheatNameComplete like '#Arguments.term#')
			</cfif>

			
		</cfquery>
		<cfif Arguments.display_type is not "autocomplete">
			<cfreturn get_names />
		<cfelse>
			<cfset return_string = '['>
			<cfoutput query="get_names">
				<cfset return_string = '#return_string#{"id": "#ProtonymID#", "label": "#CleanDisplay#", "value": "#FormattedDisplay#","namestring":"#NameString#"},'>
			</cfoutput>
			<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
				<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
			</cfif>
			<cfset return_string = '#return_string#]'>
			<cfif get_names.recordcount is 0>
				<cfset return_string = '[{"id":0,"label":"No Match Found for: #term#.","value":"No Match Found for: #term#."}]'>
			</cfif>
			<cfreturn return_string />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="get_bhl">
		<cfargument name="title" type="string">
		<cfargument name="year" type="string">
		<cfargument name="volume" type="string">
		
		<cfhttp URL="http://www.biodiversitylibrary.org/api2/httpquery.ashx">
			<cfhttpparam name="op" value="BookSearch" type="url">
			<cfhttpparam name="title" value="#Arguments.title#" type="url">
			<cfhttpparam name="volume" value="#Arguments.volume#" type="url">
			<cfhttpparam name="year" value="#Arguments.year#" type="url">
			<cfhttpparam name="apikey" value="f0116e4a-33d5-46f4-acea-1e9238a6563b" type="url">
			<cfhttpparam name="format" value="json" type="url">
		</cfhttp>
		
		
		<cfset results = DeserializeJSON(cfhttp.filecontent)>
		
		<!---<cfset new_xml = Replace(cfhttp.filecontent,'<Response xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">','<Response>','ALL')>
		
		<textarea>#cfhttp.filecontent#</textarea></cfoutput>
		<cfset inXML = xmlParse(new_xml)>
		<cffile action="write" file="e:\temp.xml" output="#cfhttp.filecontent#">
		<cffile action="read" file="e:\temp.xml" variable="myXML">
		<cfset inXML = xmlParse(myXML)>
		
		<!---<cfset inXML = bhl_results.filecontent>--->

		
		
		<!---
		<cfinvoke webservice="http://www.biodiversitylibrary.org/api2/soap.asmx?wsdl" method="BookSearch" returnvariable="json_results">
			<cfinvokeargument name="title" value="#Arguments.title#">
			<cfinvokeargument name="year" value="#Arguments.year#">
			<cfinvokeargument name="volume" value="#Arguments.volume#">
			<cfinvokeargument name="apikey" value="f0116e4a-33d5-46f4-acea-1e9238a6563b">			
		</cfinvoke>--->
		
		<cfreturn inXML />--->
		<cfreturn results />
	
	</cffunction>
	
	<cffunction name="get_bhl_pages">
		<cfargument name="ItemID" type="string" required="yes">
		
		<cfhttp URL="http://www.biodiversitylibrary.org/api2/httpquery.ashx">
			<cfhttpparam name="op" value="GetItemPages" type="url">
			<cfhttpparam name="itemid" value="#Arguments.ItemID#" type="url">
			<cfhttpparam name="apikey" value="f0116e4a-33d5-46f4-acea-1e9238a6563b" type="url">
			<cfhttpparam name="format" value="json" type="url">
		</cfhttp>
		
		
		<cfset results = DeserializeJSON(cfhttp.filecontent)>

		<cfreturn results />
	</cffunction>
	<!---http://www.biodiversitylibrary.org/openurl?pid=title:744&volume=3&issue=&spage=494&date=1993--->
	<cffunction name="get_bhl_single_page">
		<!---<cfargument name="TitleID" type="string" required="yes">--->
		<cfargument name="title" type="string" required="yes">
		<cfargument name="volume" type="string" required="yes">
		<cfargument name="spage" type="string" required="yes">
		<cfargument name="epage" type="string" required="yes">
		<cfargument name="year" type="string" required="yes">
		
		<cfhttp URL="http://www.biodiversitylibrary.org/openurl">
			<!---<cfhttpparam name="pid" value="title:#Arguments.TitleID#" type="url">--->
			<cfhttpparam name="title" value="#Arguments.title#" type="url">
			<cfhttpparam name="volume" value="#Arguments.volume#" type="url">
			<cfhttpparam name="spage" value="#Arguments.spage#" type="url">
			<cfhttpparam name="epage" value="#Arguments.epage#" type="url">
			<cfhttpparam name="date" value="#Arguments.year#" type="url">
			<cfhttpparam name="format" value="json" type="url">
		</cfhttp>
			

		<cfreturn cfhttp.filecontent />
	</cffunction>
	
	<cffunction name="get_gni">
		<cfargument name="search_term" required="yes">
		<cfhttp URL="http://gni.globalnames.org/name_strings.json">
			<cfhttpparam name="search_term" value="#Arguments.search_term#" type="url">
			<cfhttpparam name="commit" value="Search" type="url">
		</cfhttp>
		<cfset results = DeserializeJSON(cfhttp.filecontent)>	
		<cfreturn results />
	
	</cffunction>

</cfcomponent>