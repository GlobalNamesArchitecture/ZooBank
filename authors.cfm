

<cfobject component="gnub_services" name="service">
<cfinvoke component="#service#" method="get_author" returnvariable="author_results">
	<cfif isdefined("term")>
		<cfif Find(",",term)>
			<cfinvokeargument name="Family_Name" value="#Trim(ListFirst(term,","))#">
			<cfinvokeargument name="Given_Name" value="#Trim(ListLast(term,","))#">
		<cfelseif find(" ",term)>
			<cfinvokeargument name="Family_Name" value="#Trim(ListLast(term," "))#">
			<cfinvokeargument name="Given_Name" value="#Trim(ListFirst(term," "))#">
		<cfelse>
			<cfinvokeargument name="Family_Name" value="#Trim(term)#">
		</cfif>	
		
	</cfif>
	<cfif Len(search_term) is 36 or Len(search_term) is 33>
		<cfinvokeargument name="AgentUUID" value="#search_term#">
	</cfif>
	<cfif isdefined("FamilyName")>
		<cfinvokeargument name="Family_Name" value="#Trim(FamilyName)#">
	</cfif>
	<cfif isdefined("GivenName")>
		<cfinvokeargument name="Given_Name" value="#Trim(GivenName)#">
	</cfif>
		
	<cfif IsDefined("ReferenceUUID")>
		<cfinvokeargument name="ReferenceUUID" value="#ReferenceUUID#">	
	<cfelse>
		<!---<cfinvokeargument name="search_term" value="#search_term#">--->
		<!---<cfinvokeargument name="search_type" value="contains">--->
	</cfif>
	<cfif isdefined("top")>
		<cfinvokeargument name="top" value="#top#">
	</cfif>
	<cfif isdefined("ResponseType")>
		<cfinvokeargument name="ResponseType" value="#ResponseType#">
	</cfif>
	<cfif isdefined("SearchType")>
		<cfinvokeargument name="search_type" value="#SearchType#">
	</cfif>
	<cfif isdefined("uuid")>
		<cfinvokeargument name="uuid" value="#uuid#">
	</cfif>
</cfinvoke>
<!---<cfif not isdefined("top")>
	<cfdump var="#author_results#">
	<cfabort>
</cfif>--->



<cfheader statuscode="200" statustext="ok" />

<cfif format is "html">
	<cfinclude template="/header.cfm">
	<div class="container">
		<cfif IsDefined("search_term") and author_results.recordcount is not 1 and (Len(search_term) is not 36 and Len(search_term) is not 33)>
			<div class="facetedResults">
				<h3 id="authors">Authors</h3>
				<ol class="searchResults">
				<cfif author_results.recordcount is 0>
					<li>No Results</li>
				<cfelse>
				
					<cfoutput query="author_results">
						<li><a href="/Authors/#AgentUUID#"><cfif IsPerson is 1>#FamilyName#, #GivenName# #Prefix#<cfelse>#OrganizationName#</cfif></a>
						<cfif PreferredID is not PKID>
							&nbsp;[alias of: <a href="/Authors/#PreferredUUID#"><cfif IsPerson is 1>#PreferredFamilyName#, #PreferredGivenName# #PreferredPrefix#<cfelse>#PreferredOrganizationName#</cfif></a>]
						</cfif>
						</li>
					</cfoutput>
				</cfif>
				</ol>
			</div>
		<cfelse>
			<div class="actSummary">
				<cfoutput>
				<!---<cfif author_results.IsPerson>Person<cfelse>Organization</cfif> Details--->
				<h2 class="authorName"><cfif author_results.IsPerson>#author_results.FamilyName#, #author_results.GivenName# #author_results.Prefix#<cfelse>#author_results.Organization#</cfif></h2>
				</cfoutput>
				<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
					<cfinvokeargument name="UUID" value="#author_results.AgentUUID#">
				</cfinvoke>
				<cfset isRegistered = 0>
				<cfif get_ids.recordcount gt 0>
					<cfoutput query="get_ids">
					<cfif get_ids.IdentifierClass is "LSID">
						<cfset isRegistered = 1>
						<div class="lsidWrapper">
							<span class="lsidLogo">LSID</span>
							<input type="text" class="selectAll lsid" value="#get_ids.identifier#">
							<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
							width="110" height="14" id="clippy" type="application/x-shockwave-flash">
							<param name="movie" value="/public/flash/clippy.swf">
							<param name="allowScriptAccess" value="always">
							<param name="quality" value="high">
							<param name="scale" value="noscale">
							<param name="FlashVars"
							value="text=#get_ids.identifier#">
							<param name="bgcolor" value="##f5f5ff">
							<embed src="/public/flash/clippy.swf" width="110" height="14"
							id="clippy1" quality="high" allowscriptaccess="always"
							type="application/x-shockwave-flash"
							pluginspage="http://www.macromedia.com/go/getflashplayer"
							flashvars="text=#get_ids.identifier#"
							bgcolor="##f5f5ff">
							</object>

							<!-- TODO Refactor this to some sort of unobtrusive thing -->
							<script type="text/javascript">
							$('.selectAll').click(function(){ this.select(); });
							</script>
						</div>
					</cfif>
					</cfoutput>				
				</cfif>
			</div>
			<cfif isRegistered is 0>
				<span>This Author has not yet been Registered</span>
				<cfoutput>
					<!---<a class="secondaryAction" type="button" href="/register?authorid=#author_results.AgentUUID#">Register Now</a><br /><br />--->
				</cfoutput>
			</cfif>
			<cfif author_results.recordcount gt 1>
				Other names this person has used:<br />
				<cfoutput query="author_results" startrow="2">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif author_results.IsPerson>#author_results.FamilyName#, #author_results.GivenName# #author_results.Prefix#<cfelse>#author_results.Organization#</cfif><br />
				</cfoutput>
			</cfif>
			
			<cfset row_cutoff_number = 26>
			<cfinvoke component="#service#" method="get_reference" returnvariable="reference_results">
				<cfinvokeargument name="AuthorUUIDList" value="#author_results.AgentUUID#">
			</cfinvoke>
			<hr>
			<h3><cfoutput>Publications (#reference_results.recordcount#) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			
			<img style="vertical-align:text-bottom;" src="/PublicationHistogram/#author_results.AgentUUID#" alt="Publishing history histogram" /></cfoutput></h3>
			<ol>
			<cfoutput query="reference_results">
				<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
					<cfinvokeargument name="UUID" value="#reference_results.UUID#">
				</cfinvoke>
				<cfif currentrow is row_cutoff_number>
					<a id="more_pubs" class="secondaryAction">#recordcount-25# more...</a>
					<div id="more_pubs_layer" style="display:none;">
					<script language="javascript">
						$("##more_pubs").click(function () { 
							$('##more_pubs_layer').toggle();
						});
					</script>						
				</cfif>				
				<li>
				<a class="biblio-entry" href="/References/#UUID#">				
				<cfif get_ids.recordcount gt 0>
					<cfoutput query="get_ids">
					<cfif get_ids.IdentifierClass is "LSID">
						<span class="lsidButton"></span>				
					</cfif>
					</cfoutput>
				</cfif>
				<span class="biblio-authors">#Authors# #year#</span>
				#FullTitle# #CitationDetails#</a>
				</li>
				<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
					</div>
				</cfif>
			</cfoutput>
			</ol>
		</cfif>
		</div>
		<!---<cfdump var="#reference_results#">--->
	<cfinclude template="/footer.cfm">
<cfelseif format is "json">
	<!---<cfoutput>Request Type: #request_type# [#search_term#] Method: #method# Format: #format#
	<cfdump var="#request#">
	<cfdump var="#url#">
	</cfoutput>
	<cfabort>--->
	<cfsilent>
	<cfset new_family_name = "">
	<cfset new_given_name = "">
	<cfset return_string = '['>
	<cfoutput query="author_results">
		<cfset ZBLSID = "">
		<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
			<cfinvokeargument name="UUID" value="#author_results.AgentUUID#">
		</cfinvoke>
		<cfif get_ids.recordcount gt 0>
			<cfoutput query="get_ids">
			<cfif get_ids.IdentifierClass is "LSID">
				<cfset ZBLSID = get_ids.identifier>
			</cfif>
			</cfoutput>
		</cfif>	
		<cfset return_string = '#return_string#{"agentnameid": "#UUID#", "label": "#Replace(FormattedAgentName,"=","alias of ","ALL")#", "value": "#Replace(FormattedAgentName,"=","alias of ","ALL")#", "ZBLSID": "#ZBLSID#", "familyname": "#author_results.FamilyName#", "givenname": "#author_results.GivenName#","preferreduuid": "#author_results.preferreduuid#","agentid": "#author_results.AgentUUID#"},'>
	</cfoutput>
	<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
		<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
	</cfif>

	<!---<cfset return_string = '#return_string#,{"id":0,"label":"Not in list.  Click New Author to create entry.","value":"Not in list.  Click New Author to create entry.","term":"#term#"}]'>--->
	<cfif not IsDefined("search_term")>
		<cfset search_term = term>
	</cfif>
	<cfif Find(",",search_term)>
		<cfset new_given_name = ListLast(search_term)>
		<cfset new_family_name = ListFirst(search_term)>
	<cfelseif Find(" ",search_term)>
		<cfset new_family_name = ListLast(search_term," ")>
		<cfset new_given_name = ListFirst(search_term," ")>		
	<cfelse>
		<cfset new_family_name = search_term>
		<cfset new_given_name = "">	
	</cfif>
	<cftry>
		<cfset new_family_name = "#UCase(Left(Trim(new_family_name),1))##LCase(RemoveChars(Trim(new_family_name),1,1))#">
		<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfset new_given_name = "#UCase(Left(Trim(new_given_name),1))##LCase(RemoveChars(Trim(new_given_name),1,1))#">
		<cfcatch></cfcatch>
	</cftry>
	<cfset new_author_uuid = CreateUUID()>
	
	<!---NEED TO RETURN THIS SECTION ONLY FOR INTERNAL AUTOCOMPLETES!!!--->
	<cfif isdefined("add_selected_option")>
		<cfif return_string is not "[">
			<cfset return_string = '#return_string#,'>
		</cfif>
		<cfset return_string = '#return_string#{"agentnameid":"#new_author_uuid#","label":" Add #new_given_name# #new_family_name# as a new author","value":"No Match.","term":"#search_term#","familyname":"#new_family_name#","givenname":"#new_given_name#"}'>
	</cfif>
	<cfset return_string = '#return_string#]'>
	<cfset response = return_string>
	
	<cfif format is "jsonp">
		<cfset response = "#callback_value# (#response#)">
	</cfif>
	<cfset responseBinary = toBinary(toBase64(response)) />
	 <!---

	Tell the client how much data to expect so that it knows when
	to close the connection with the server.
	--->
	</cfsilent>
	<cfcontent type="application/json; charset=utf-8">
	<cfprocessingdirective pageEncoding="utf-8">
	<!---<cfoutput>#return_string#</cfoutput><cfabort>
	<cfcontent type="text/plain; utf-8">
	<cfheader charset="utf-8" name="content-disposition" value="ALOHA" />
	<cfheader charset="utf-8" name="content-length"	value="#arrayLen( responseBinary )#" />--->
	<cfheader charset="utf-8" statuscode="200" statustext="ok"	/>
	<!--- Stream the content back to the client. --->
	<!---<cfcontent type="application/json; charset=utf-8" variable="#responseBinary#" />
	<cfcontent type="application/json; charset=utf-8" variable="#response#" />--->
	<cfoutput>#response#</cfoutput>
	<!---<cfcontent type="application/json; charset=utf-8" variable="#response#" />--->
	<cfabort>
<cfelseif format is "xml">



</cfif>








