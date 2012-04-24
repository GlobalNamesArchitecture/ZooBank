<!--- 

NAME: nomenclaturalacts.cfm
PURPOSE: Nomenclatural Acts Controller 
LAST MODIFIED: 4/23/2012 - added 404 error if no match is found for a UUID search.
CREATED: March 2012
ORIGINAL AUTHOR:  Robert Whitton
NOTES:  Calls service to get data on nomenclatural acts.  Renders a response in either HTML or json formatted data.

--->
	
<cfobject component="gnub_services" name="service">
<cfif IsDefined("term")>
	<cfset search_term = term>
</cfif>
<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_act_details">
	<cfif Len(search_term) is 36 or Len(search_term) is 33>
		<cfinvokeargument name="UUID" value="#search_term#">
	<cfelseif IsNumeric(search_term)>
		<cfinvokeargument name="PKID" value="#search_term#">
	<cfelseif IsDefined("ReferenceUUID")>
		<cfinvokeargument name="ReferenceUUID" value="#ReferenceUUID#">
	<cfelse>
		<cfinvokeargument name="search_term" value="#search_term#">
	</cfif>
	<cfif IsDefined("RankGroup")>
		<cfinvokeargument name="RankGroup" value="#RankGroup#">
	</cfif>
	<cfif IsDefined("searchType")>
		<cfinvokeargument name="searchType" value="#searchType#">
	</cfif>
	<cfif IsDefined("distinctNames")>
		<cfinvokeargument name="distinctNames" value="#distinctNames#">
	</cfif>
</cfinvoke>
<!---<cfdump var="#get_act_details#"><cfabort>--->

<cfif format is "html">
	<cfif get_act_details.recordcount is 0 and (Len(search_term) is 36 or Len(search_term) is 33)>
		 <cfheader
		statuscode="404"
		statustext="Not Found"
		/>
		<cfabort>
	</cfif>
	 <cfheader
	statuscode="200"
	statustext="ok"
	/>
	<cfinclude template="/header.cfm">
	<!---<cfdump var="#get_act_details#"><cfabort>--->
	<cfif get_act_details.recordcount gt 1>
		<div class="container">
			<cfoutput><p>Search Results [#get_act_details.recordcount#] for <em>#search_term#</em></p></cfoutput>
			<ol class="searchResults">
			<cfoutput query="get_act_details">
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="/NomenclaturalActs/#ProtonymUUID#">#FormattedDisplay#</a> <cfif IsDefined("UsageAuthors")><em>sensu</em> #UsageAuthors#</cfif></li>
			</cfoutput>
			</ol>
		
		</div>
		<cfinclude template="/footer.cfm">
		<cfabort>
	</cfif>
	<cfif get_act_details.recordcount gt 0>
	<cfoutput query="get_act_details">
	
		<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_act_details">
			<cfinvokeargument name="UUID" value="#get_act_details.ProtonymUUID#">
		</cfinvoke>
		<div class="container">
			<div class="actSummary">
				<h2 class="actName">
					#FormattedDisplay#
				</h2>
				<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
					<cfinvokeargument name="UUID" value="#get_act_details.ProtonymUUID#">
				</cfinvoke>
				<!---<cfdump var="#get_ids#">--->
				<cfif get_ids.recordcount gt 0>
					<cfoutput query="get_ids">
					<cfif get_ids.IdentifierClass is "LSID">
						<div class="lsidWrapper">
							<span class="lsidLogo">LSID</span><input type="text" value="#get_ids.identifier#" class="selectAll lsid"><object width="110" height="14" id="clippy" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000">
								<param value="/public/flash/clippy.swf" name="movie">
								<param value="always" name="allowScriptAccess">
								<param value="high" name="quality">
								<param value="noscale" name="scale">
								<param value="text=get_ids.identifier" name="FlashVars">
								<param value="##f5f5ff" name="bgcolor">
								<embed width="110" height="14" bgcolor="##F5F5FF" flashvars="text=#get_ids.identifier#" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" allowscriptaccess="always" quality="high" name="clippy" src="/public/flash/clippy.swf">
							</object>
							<script type="text/javascript">
								$(".selectAll").click(function(){ this.select(); });
							</script>
						</div>
					<cfelse>
						
					</cfif>
					</cfoutput>
					
					<cfoutput query="get_ids">
						<cfif get_ids.IdentifierClass is not "LSID">
						<a href="#IdentifierURL#" target="_blank">
							<cfif DomainLogoURL is not "">
								<img src="#DomainLogoURL#" title="#get_ids.IdentifierDomain# #get_ids.identifier#" alt="#get_ids.IdentifierDomain# icon" />
							<cfelse>
								#get_ids.IdentifierDomain#<cfif get_ids.ResolutionNote is not ""> #get_ids.ResolutionNote#</cfif>
							</cfif>
						</a>&nbsp;						
						</cfif>
					</cfoutput>
				</cfif>
				<!---<cfdump var="#get_act_details#">--->
				<table>
					<tbody>
						<tr>
							<th scope="row">
								Rank
							</th>
							<td>
								#RankGroup#
							</td>
						</tr>
						<cfif RankGroup is "Species">
						<tr>
							<th scope="row">
								Parent
							</th>
							<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_orig_parent_details">
								<cfinvokeargument name="UUID" value="#get_act_details.OriginalParentUsageUUID#">
							</cfinvoke>
							
							<cfinvoke component="#service#" method="get_reference" returnvariable="get_orig_parent_ref_details">
								<cfinvokeargument name="ReferenceUUID" value="#get_orig_parent_details.ReferenceUUID#">
							</cfinvoke>
							<!---<cfdump var="#get_orig_parent_details.ReferenceUUID#"><cfabort>--->
							<td>
								<em>#get_act_details.ParentName#</em> [<a href="/NomenclaturalActs/#get_orig_parent_details.UUID#">#get_orig_parent_details.ScientificName#</a> 
								<!---<cfdump var="#get_orig_parent_ref_details#"><cfabort>--->
								<a href="/References/<cfif get_orig_parent_ref_details.ReferenceType is "Sub-Reference">#get_orig_parent_ref_details.ParentReferenceUUID#<cfelse>#get_orig_parent_ref_details.UUID#</cfif>">
								#get_orig_parent_details.UsageAuthors# #get_orig_parent_ref_details.year#</a>]
							
							</td>
						</tr>
						</cfif>
						<tr>
							<th scope="row">
								Publication
							</th>
							<!--- Get the reference information --->
							<cfinvoke component="#service#" method="get_reference" returnvariable="reference_results">
								<cfinvokeargument name="ReferenceUUID" value="#get_act_details.ReferenceUUID#">
							</cfinvoke>
							<td><!---#get_act_details.ReferenceUUID# <cfdump var="#reference_results#"> <cfabort>--->
								<span class="biblio-entry"><span class="biblio-authors"><a href="/References/#reference_results.UUID#">#reference_results.Authors# #reference_results.Year#</a> </span><span class="biblio-title">#reference_results.FullTitle#</span> #reference_results.CitationDetails#&nbsp;<a href="/References/#reference_results.UUID#">[show all names in ref.]</a></span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<!--- PLACEHOLDER UNTIL LATER
		<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_child_taxa">
			<cfinvokeargument name="ParentUsageUUID" value="">
		</cfinvoke>
		--->
		
		
		<cfset Start_Page = "">
		<cfset End_Page = "">
		<cfif get_act_details.StartPage is not "">
			<cfset Start_Page = get_act_details.StartPage>
		</cfif>
		<cfif reference_results.StartPage is not "">
			<cfset Start_Page = reference_results.StartPage>
		</cfif>
		<cfif reference_results.EndPage is not "">
			<cfset End_Page = reference_results.EndPage>
		</cfif>
		<cfif Start_Page is "" and End_Page is "">
			<cfif reference_results.Pagination is not "">
				<cfif Find("-",reference_results.Pagination)>
					<cfset Start_Page = ListFirst(reference_results.Pagination,"-")>
					<cfset End_Page = ListLast(reference_results.Pagination,"-")>
				<cfelseif Find(",",reference_results.Pagination)>
					<cfset Start_Page = ListFirst(reference_results.Pagination,",")>
					<cfset End_Page = ListLast(reference_results.Pagination,",")>
				</cfif>
			</cfif>
		</cfif>

		
		<cfinvoke component="services" method="get_bhl_single_page" returnvariable="bhl_page">
			<!---<cfinvokeargument name="TitleID" value="#bhl_data.Result[1].TitleID#">--->
			<cfinvokeargument name="title" value="#reference_results.ParentReference#">
			<cfinvokeargument name="volume" value="#reference_results.Volume#">
			<cfinvokeargument name="spage" value="#Start_Page#">
			<cfinvokeargument name="epage" value="#Start_Page#">
			<cfinvokeargument name="year" value="#reference_results.Year#">
		</cfinvoke>
		<cfset bhl_page_struct = DeserializeJSON(bhl_page)>
		<!---<cfdump var="#bhl_page_struct#">--->
		<cfset start_pageID = 0>
		<cfif IsDefined("bhl_page_struct.citations[1].Url")>
			<cfset start_pageID = ListLast(bhl_page_struct.citations[1].Url,"/")>
		</cfif>

		
		<div id="bhl_results" class="bhl_results alt_row">
			<div class="container">
				<div class="outlink">
					<h3>Literature</h3>
			
					<div class="attribution">
						<a class="attributionLogoWrapper" href="http://biodiversitylibrary.org" target="_blank" >
							<img src="/images/BHLlogo.png" alt="BHL Logo" />
						</a>
						<!-- You want to se the line-height below to the height of the logo image above + 6px to get the text to line up nicely-->
						<p style="line-height: 34px">Literature images courtesy of the <a href="http://biodiversitylibrary.org/name/#Replace(REReplace(get_act_details.ScientificName,"<[^>]*(?:>|$)","","ALL"), " ", "_", "ALL")#" target="_blank">Biodiversity Heritage Library</a>.</p>
					</div>
					<div class="bhlPageImages">
					<cfif start_pageID gt 0 and Len(bhl_page_struct.citations) is 1>
						<div class="bhlPage">
							<a class="thumbnail" href="http://www.biodiversitylibrary.org/pagethumb/#start_pageID#,600,800" target="_blank">
								<img src="http://www.biodiversitylibrary.org/pagethumb/#start_pageID#,80,200" alt="BHL Page Image" />
							</a>
							<a href="http://biodiversitylibrary.org/page/#start_pageID#" target="_blank">Page: #Start_Page#</a>
						</div>
					<cfelseif Len(bhl_page_struct.citations) is 0>
							No Results
					<cfelse>
						Multiple Responses - <a href="http://www.biodiversitylibrary.org/openurl?title=#reference_results.ParentReference#&volume=#reference_results.Volume#&spage=#Start_Page#&date=#reference_results.Year#" target="_blank">Go To BHL Results</a>
					</cfif>
					</div>
					
				</div>
			</div>
			
		</div><!--- end bhl_results --->
		
		<!---<cfdump var="#get_act_details#">--->
		<cfinvoke component="services" method="get_gni" returnvariable="gni_results">
			<cfinvokeargument name="search_term" value="#get_act_details.ParentName# #get_act_details.NameString#">
		</cfinvoke>
		<div id="gni_detailed_results_layer" class="gni_results">
			<div class="container">
				<div class="outlink">
					<h3>Related Names</h3>				
					<div class="attribution">
						<a class="attributionLogoWrapper" href="http://gni.globalnames.org" target="_blank" >
							<img src="/images/gni-logo.png" alt="GNI Logo" />
						</a>
						<!-- You want to se the line-height below to the height of the logo image above + 6px to get the text to line up nicely-->
						<p style="line-height: 42px">Additional names information provided courtesy of the <a href="http://gni.globalnames.org/name_strings?search_term=#Replace(REReplace(get_act_details.ScientificName,"<[^>]*(?:>|$)","","ALL"), " ", "+", "ALL")#&amp;commit=Search" target="_blank">Global Names Index</a>.</p>
					</div>
					<ol>
						<cfloop from="1" to="#Len(gni_results.name_strings)#" step="1" index="i">
						<li>#gni_results.name_strings[i].name#</li>
						</cfloop>
					</ol>
				</div>
			</div>
		</div>
			
		<cfhttp URL="http://explorers-log.com/names.json?">
			<cfhttpparam name="search_term" value="#get_act_details.ScientificName#" type="url">
			<cfhttpparam name="__BDRETURNFORMAT" value="jsonp" type="url">
		</cfhttp>
		<cfif IsJSON(cfhttp.filecontent)>
			<cfset result_set = DeserializeJSON(cfhttp.filecontent)>
			<!---
			<cfloop index="json" list="#cfhttp.filecontent#" delimiters="#chr(10)#">
				#json#<br />
			</cfloop>--->
			<cfset best_image_uuid = "">
			<cfset best_image_quality = 10>
			<cfset number_video_clips = 0>
			<cfset number_still_images = 0>
			<cfset number_visual_observations = 0>
			<cfoutput query="result_set">
				<cfif media_type is "MovingImage">
					<cfset number_video_clips = number_video_clips + 1>
				</cfif>
				<cfif media_type is "StillImage">
					<cfset number_still_images = number_still_images + 1>
				</cfif>
				<cfif samplingprotocol is "Visual Observation">
					<cfset number_visual_observations = number_visual_observations + 1>
				</cfif>
				<cfif content_quality lt best_image_quality>
					<cfset best_image_uuid = media_uuid>
				</cfif>
			</cfoutput>
			<!---<cfdump var="#result_set#">--->
			<!---<cfif Len(cfhttp.filecontent) gt 5>--->
			<cfoutput>
				<div id="el_results_layer" class="el_results alt_row">
					<div class="container">
						<div class="outlink">
							<h3>Observations from Explorer's Log</h3>
							<div class="attribution">
								<a class="attributionLogoWrapper" href="http://www.explorers-log.com" target="_blank" >
									<img src="/images/el-logo.png" alt="Explorers Log Logo" />
								</a>
								<!-- You want to se the line-height below to the height of the logo image above + 6px to get the text to line up nicely-->
								<p style="line-height: 34px">Observation data provided courtesy of <a href="http://www.explorers-log.com" target="_blank">Explorer's Log</a>.</p>
							</div>					
							#result_set.recordcount# records in Explorers Log<br>
							#number_video_clips# Video Clips<br>
							#number_still_images# Still Images<br>
							#number_visual_observations# Visual Observations<br>
							<cfif best_image_uuid is not ""><img src="http://www.explorers-log.com/#best_image_uuid#" alt="Image from Explorers Log" /></cfif>
						</div>
					</div>
				</div>
			<!---</cfif>--->
			</cfoutput>
		</cfif>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<div class="container">
			No Results for  <em>"#search_term#"</em><!---#method#--->
		</div>
		</cfoutput>
	</cfif>
	
	
		
	
	<cfinclude template="/footer.cfm">
	<cfabort>
<cfelseif format is "json">
	<cfif get_act_details.recordcount is 0>
		 <cfheader
		statuscode="404"
		statustext="Not Found"
		/>
		<cfabort>
	</cfif>
	<!--- ProtonymID	ProtonymUUID	RankGroup	OriginalReferenceID	OriginalReferenceUUID	NameString	ScientificName	CleanDisplay	FormattedDisplay	FormattedProtonym	SortProtonym	SortUsage	SortRankGroup	ProtonymSort --->
	<cfset return_string = '['>
	<cfoutput query="get_act_details">
		<cfset zblsid = "">
		<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
			<cfinvokeargument name="UUID" value="#get_act_details.ProtonymUUID#">
		</cfinvoke>
		<cfif get_ids.recordcount gt 0>
			<cfoutput query="get_ids">
			<cfif get_ids.IdentifierClass is "LSID">
				<cfset zblsid = get_ids.Identifier>
			</cfif>
			</cfoutput>
		</cfif>
		<cfset return_string = '#return_string#{"tnuuuid":"#UUID#","OriginalReferenceUUID":"#OriginalReferenceUUID#","protonymuuid": "#ProtonymUUID#", "label": "#CleanDisplay#", "value": "#ScientificName#","lsid":"#zblsid#","parentname":"#ParentName#","namestring":"#NameString#","rankgroup":"#RankGroup#","usageauthors":"#UsageAuthors#","taxonnamerankid":"#taxonnamerankid#"},'>
	</cfoutput>
	
	<!---<cfif get_act_details.recordcount is 0>--->
		<cfif IsDefined("add_new_parent_option")>
			<cfif RankGroup is not "Species">
				<cfset term = "#UCase(Left(term,1))##LCase(RemoveChars(term,1,1))#">
			</cfif>
			<!---<cfif return_string is not "[">
				<cfset return_string = '#return_string#,'>
			</cfif>--->
			<cfset return_string = '#return_string#{"id":0,"label":"Create New #RankGroup# #term#","value":"Create New #RankGroup# #term#","namestring":"#term#","rankgroup":"#rankgroup#"}'>
		</cfif>	
			
		<!---	
		<cfelse>
			<cfset return_string = '[{"id":0,"label":"No Match Found for:.","value":"No Match Found for: ."}]'>
		</cfif>--->
	<!---</cfif>--->
	<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
		<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
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
	<cfheader
	name="content-length"
	value="#arrayLen( responseBinary )#"
	/>
	 <cfheader
	statuscode="200"
	statustext="ok"
	/>
	<!--- Stream the content back to the client. --->
	<cfcontent
	type="application/json; charset=utf-8"
	variable="#responseBinary#"
	/>
	
</cfif>


