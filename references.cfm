<!--- References controller --->
<!--- ----------------------------------------- --->
<!--- 
	NAME: references.cfm

	PURPOSE:  Returns results for references in HTML and JSON format.

	LAST MODIFIED: 4/20/2012 - added top parameter to reference searches
		
	CREATED:  
	
	ORIGINAL AUTHOR: Robert Whitton

	NOTES:  
					
 --->
<!--- ----------------------------------------- --->
<cfobject component="gnub_services" name="service">
<cfset debug = 0>
<cfif debug is 1>
	<cfoutput>
	Request Type: #request_type# [#search_term#] Method: #method# Format: #format#
	#Len(search_term)#
	<cfdump var="#url#"></cfoutput>
	<cfabort>
</cfif>
<!---<cfoutput><cfdump var="#form#">#Len(form.search_term)#</cfoutput>
			<cfabort>--->
			
<cfif isdefined("form.search_term")>
	<cfset search_term = form.search_term>
</cfif>
<cfinvoke component="#service#" method="get_reference" returnvariable="reference_results">
	
	
<cfif isdefined("search_type")>
		<cfif search_type is "filter">
			<cfinvokeargument name="AuthorUUIDList" value="#AuthorUUIDList#">
			<cfinvokeargument name="StartYear" value="#StartYear#">
			<cfinvokeargument name="EndYear" value="#EndYear#">
			<cfif IsDefined("ParentReferenceUUID")>
				<cfif Trim(ParentReferenceUUID) is not "">
					<cfif ParentReferenceUUID is not "undefined">
						<cfinvokeargument name="ParentReferenceUUID" value="#ParentReferenceUUID#">
					</cfif>
				</cfif>
			</cfif>
			<cfif Trim(reference_title) is not "">
				<cfinvokeargument name="search_term" value="#reference_title#">		
			</cfif>
		</cfif>
	<cfelse>
		<cfif isdefined("IsPeriodical")>
			<cfinvokeargument name="IsPeriodical" value="#IsPeriodical#">
			<cfinvokeargument name="search_term" value="#search_term#">	
		<cfelseif Len(search_term) is 36 or Len(search_term) is 33>
			<cfinvokeargument name="UUID" value="#search_term#">
		<cfelse>
			<cfinvokeargument name="search_term" value="#search_term#">
		</cfif>
		<cfif IsDefined("PublishedOnly")>
			<cfinvokeargument name="PublishedOnly" value="#PublishedOnly#">
		</cfif>
		
	</cfif>
	<cfif IsDefined("top")>
		<cfinvokeargument name="top" value="#top#">
	</cfif>
</cfinvoke>
<!---
<cfdump var="#reference_results#">
<cfabort>--->


<!---
<cfoutput>#IsDefined("PublishedOnly")# #isdefined("IsPeriodical")# #isdefined("search_type")# #Len(search_term)#</cfoutput>
--->

<cfif format is "html">
	<cfif reference_results.recordcount is 0>
		<cfheader
		statuscode="404"
		statustext="Not Found"
		/>
		<cfabort>
	</cfif>
	<cfinclude template="/header.cfm">
	<!---<cfdump var="#reference_results#"><cfabort>--->
	<cfoutput query="reference_results"> 
	<div class="container">
		<div class="actSummary">
			<h2 class="actName">
				<cfif referenceType is not "Periodical">#Authors# #Year# 
				</cfif>#FullTitle#
			</h2>
			<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
				<cfinvokeargument name="UUID" value="#reference_results.UUID#">
			</cfinvoke>
			<!---<cfdump var="#get_ids#">--->
			<cfif get_ids.recordcount gt 0>
				<cfoutput query="get_ids">
					<cfif get_ids.IdentifierClass is "LSID">
						<div class="lsidWrapper">
							<span class="lsidLogo">LSID</span><span class="lsid" style="background-color:white;line-height:18px;vertical-align:top;">#get_ids.identifier#</span>
							<!---<input type="text" value="#get_ids.identifier#" class="selectAll lsid" disabled="true" />--->
							<object width="110" height="14" id="clippy" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" type="application/x-shockwave-flash">
								<param value="/public/flash/clippy.swf" name="movie">
								<param value="always" name="allowScriptAccess">
								<param value="high" name="quality">
								<param value="noscale" name="scale">
								<param value="text=#get_ids.identifier#" name="FlashVars">
								<param value="##f5f5ff" name="bgcolor">
								<embed width="110" height="14" bgcolor="##F5F5FF" flashvars="text=#get_ids.identifier#" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" allowscriptaccess="always" quality="high" id="clippy1" src="/public/flash/clippy.swf">
							</object>
							<script type="text/javascript">
								$(".selectAll").click(function(){ this.select(); });
							</script>
						</div>
					</cfif>
				</cfoutput>
				<cfoutput query="get_ids">
					<cfif get_ids.IdentifierClass is not "LSID">
					<cfif IdentifierURL is not "">
					<a href="#IdentifierURL#" target="_blank"></cfif>
						<cfif DomainLogoURL is not "">
							<img src="#DomainLogoURL#" title="#get_ids.IdentifierDomain# #get_ids.identifier#" alt="#get_ids.IdentifierDomain#" style="height:24px" />
						<cfelse>
							#get_ids.IdentifierDomain#<cfif get_ids.ResolutionNote is not ""> #get_ids.ResolutionNote#</cfif>
						</cfif>
					<cfif IdentifierURL is not ""></a><cfelse>: #get_ids.identifier#</cfif>&nbsp;						
					</cfif>
				</cfoutput>
			</cfif>
			<cfif referenceType is not "Periodical">
				<table>
				<tbody>
					<tr>
						<th scope="row">Publication</th>
						<td>
							<span class="biblio-entry"><span class="biblio-authors">#Authors#</span> #Year# <span class="biblio-title">#FullTitle#</span> #CitationDetails#</span>
						</td>
					</tr>
					<cfinvoke component="#service#" method="get_author" returnvariable="author_results">
						<cfinvokeargument name="ReferenceUUID" value="#reference_results.UUID#">
						<!--- --->
					</cfinvoke>					
					<tr>
						<th scope="row">Authors</th>
						<cfset js_author_array = "[">
						
						<td><cfoutput query="author_results">
							<cfif currentrow is 1>
								<cfset author_lastname_list = FamilyName>
							<cfelseif currentrow is recordcount and currentrow is not 1>
								<cfset author_lastname_list = "#author_lastname_list# & #FamilyName#">
							<cfelse>
								<cfset author_lastname_list = "#author_lastname_list#, #FamilyName#">
							</cfif>
							<a href="/Authors/#AgentUUID#">#FamilyName#, #GivenName# #Prefix#</a>
							<cfif BirthDate is not "">(#DateFormat(BirthDate,"yyyy")#-<cfif DeathDate is not "">#DateFormat(DeathDate,"yyyy")#</cfif>)</cfif> ;
							<cfset js_author_array = "#js_author_array#'#AgentUUID#'">
							<cfif currentrow is not recordcount>
								<cfset js_author_array = "#js_author_array#,">
							</cfif>
							</cfoutput>
							<cfset js_author_array = "#js_author_array#]">
						</td>
					</tr>			
				
					<cfinvoke component="#service#" method="get_reference" returnvariable="parent_reference_results">
						<cfinvokeargument name="PKID" value="#ParentReferenceID#">
					</cfinvoke>
					<tr>
						<th scope="row">Parent Reference</th>
						<td>
							<span class="biblio-entry"><span class="biblio-title">
							<a href="/References/#parent_reference_results.UUID#">#parent_reference_results.FullTitle#</a></span></span>
						</td>
					</tr>		
					<tr>
						<th scope="row">Publisher</th>
						<td>
							<span class="biblio-entry"><span class="biblio-title">
							#parent_reference_results.Publisher#</a></span></span>
						</td>
					</tr>	
					<tr>
						<th scope="row">Place Published</th>
						<td>
							<span class="biblio-entry"><span class="biblio-title">
							#parent_reference_results.PlacePublished#</a></span></span>
						</td>
					</tr>	
					<tr>
						<th scope="row">Date Published</th>
						<td>
							<span class="biblio-entry"><span class="biblio-title">
							#parent_reference_results.DatePublished#</a></span></span>
						</td>
					</tr>	
				</tbody>
				</table>
			</cfif>
		</div>
	</div>
	
	</cfoutput>
	<!---
	<div class="container">
		<h3>Authors</h3>
		<ol>
		<cfoutput query="author_results">
			<li><A href="/Authors/#AgentUUID#">#FamilyName#, #GivenName# #Prefix#</a> <cfif BirthDate is not "">(#DateFormat(BirthDate,"yyyy")#-<cfif DeathDate is not "">#DateFormat(DeathDate,"yyyy")#</cfif>)</cfif></li>
		</cfoutput>
		</ol>
			
	</div>
	--->
	<cfif IsDefined("session.username")>
		<cfif session.username is not "" and reference_results.ReferenceType is not "Periodical">
			<cfjavascript src="/admin/js/references.js" />
			<cfoutput>
				<script type="text/javascript">
					LogUserName = '#session.username#';
					selected_authors_array = #js_author_array#;
					<cfif IsDefined("register")>
						$().ready(function() { $('input[id=btn_show_new_name_form_species]').click(); });
					</cfif>					
				</script>
			</cfoutput>
			<div class="nextAction">
				<div class="container">
					
					<div id="registerAnother" class="registerAnother"<cfif IsDefined("register")> style="display:none;"</cfif>>
						<p><span class="primaryAction" id="btn_start_new_name_registration">Register</span> a new Nomenclatural Act in this publication </p>
					</div>
					<cfoutput>
					<input type="hidden" name="pub_id" id="pub_id" value="#reference_results.UUID#" />
					</cfoutput>
					
					<div id="nomenclatural_acts_layer"<cfif not IsDefined("register")> style="display:none;"</cfif>>
						<div class="infoMsg">
							<p>Please register new genus-group names established in this published work before registering any species-group names.</p>
						</div>
						<span id="name_act_search_layer" style="display:none;">Nomenclatural Acts
							<span class="celllg">Search</span>
							<input type="text" size="30" name="taxon_act_search_string" id="taxon_act_search_string" /><br />
							<span id="selected_taxon_act" class="cellmed1"></span>
							<input type="hidden" name="taxon_act_id" id="taxon_act_id" />		
						</span>		
						<div id="new_name">
							<form name="form_new_name" id="form_new_name" method="get" action="go_nowhere">
							<table border="1">
								<tr>
									<td class="entry_label" style="width:150px;">Rank Group</td>
									<td colspan="1">
									<div id="name_acts_button_layer" class="nomenclatural_acts_layer_style" style="text-align:left;">	
										<input type="radio" name="rank_group_selection" id="btn_show_new_name_form_family" />Family
										<input type="radio" name="rank_group_selection" id="btn_show_new_name_form_genus" />Genus
										<input type="radio" name="rank_group_selection" id="btn_show_new_name_form_species" />Species
									<!---
										<button id="btn_show_new_name_form_family" type="button">New Family-Group Name</button>
										<button id="btn_show_new_name_form_genus" type="button">New Genus-Group Name</button>
										<button id="btn_show_new_name_form_species" type="button">New Species-Group Name</button>--->
									</div>				
									<div id="new_name_instruction_layer" class="form_instructions_text" style="display:none;"></div>
									
									</td>
								</tr>
								
								<tr id="new_nomenclatural_act_main_form_layer" ><!---style="display:none;"--->
									<td class="entry_label">Rank *</td>
									<td><select id="rank_id" name="rank_id"></select>
										<!---<input id="rank_search_string" type="text" />--->
										<img src="/images/help.gif" id="image_help_taxon_rank" alt="help icon" />
										
									<!---<span id="selected_rank"></span><input type="hidden" id="rank_id" name="rank_id" />---></td>
	
								</tr>
								<tr id="new_name_parent_layer">
									<td class="entry_label" id="new_name_parent_label"><label for="parent_search_string">Parent <em>*</em></label></td>
									<td colspan="1">
									<div id="new_act_current_names_in_pub"></div>
									<span id="new_name_parent_search_layer"><input id="parent_search_string" size="57" type="text" placeholder="new parent name" /><!---[Required for all ranks except Family and Genus]---></span>
									<span id="selected_parent" class="completed_question_result_text completed_section"></span><br />
									<input type="hidden" name="ParentUsageUUID" id="ParentUsageUUID" />
									<input type="hidden" name="ProtonymUUID" id="ProtonymUUID" />
									<input type="hidden" name="parent_taxonrankid" id="parent_taxonrankid" />
									<input type="hidden" name="parent_name" id="parent_name" />
									
									<div id="new_name_parent_confirmation_layer"></div>
									</td>
								</tr>
								<tbody id="form_part_new_name" style="display:none;">
								<tr>
									<td class="entry_label">Spelling *</td>
									<td><input type="text" size="57" id="new_name_spelling" name="new_name_spelling" />
										<img src="/images/help.gif" id="image_help_taxon_spelling" alt="help icon" /><br /><br /></td>
								</tr>
								<tr>
									<td class="entry_label">Page</td>
									<td><input type="text" size="57" name="new_name_pages" id="new_name_pages" />
										<img src="/images/help.gif" id="image_help_taxon_pages" alt="help icon" /><br /><br /></td>
								</tr>
								<tr id="new_name_figures_layer">
									<td class="entry_label">Fig(s)</td>
									<td><input type="text" size="57" name="new_name_figures" id="new_name_figures" />
										<img src="/images/help.gif" id="image_help_taxon_figures" alt="help icon" /><br /><br /></td>
								</tr>
								<tr>
									<td class="entry_label" id="new_name_type_label">Type Genus</td>
									<td><input type="text" size="57" name="new_name_type_genus" id="new_name_type_genus" />
										<img src="/images/help.gif" id="image_help_taxon_type" alt="help icon" /><br /><br /></td>
								</tr>
								<tr>
									<td colspan="2" style="font-weight:bolder;">Is the authorship of the name identical to the authorship of the Published Work?</td> 
								</tr>
								<tr>
									<td class="entry_label">&nbsp;</td>
									<td>Yes <input type="radio" value="1" name="is_authorship_identical" id="new_name_is_authorship_identical_1" checked />
										| No <input type="radio" value="0" name="is_authorship_identical" id="new_name_is_authorship_identical_0" />
										<img src="/images/help.gif" id="image_help_taxon_authorship" alt="help icon" /><br /><br /></td>
								</tr>
								<!---<label class="entry_label">Type Locality</label> <input type="text" /><br /><br />--->
								<cfoutput>
								<tr id="new_name_authorship_input_layer" class="disabled">
									<td class="entry_label">Author(s)</td>
									<td><input type="text" name="new_name_authors" id="new_name_authors" value="#author_lastname_list#" size="57" disabled class="disabled" />
										<img src="/images/help.gif" id="image_help_taxon_authors" alt="help icon" /><br /><br /></td>
								</tr>
								</cfoutput>
								<tr>
									<td class="entry_label"></td>
									<td><input type="checkbox" name="is_fossil" id="is_fossil" value="1" /><label for="is_fossil">This new taxon name is based on fossil material</label></td>
								</tr>
									<!---
									<div class="form_button_layer">
										<button id="btn_new_name_form" type="button">Save Record</button>
									</div>--->
								<tr>
									<td>&nbsp;</td>
									<td><div id="new_name_confirm_layer"></div></td>
								</tr>
								<tr>
									<td colspan="1">&nbsp;</td>
									<td colspan="1">
										<button class="primaryAction" type="button" id="btn_register_name">Register Nomenclatural Act</button>
										<span id="cancel_registration" class="secondaryAction">cancel</span>											
									</td>
								</tr>
								</tbody>
							</table>
							</form>
							</div><!--- new_nomenclatural_act_main_form_layer --->							
						</div><!---new_name--->
					</div><!---nomenclatural_acts_layer--->
					<cfoutput>
					<div id="new_parent_name_layer" title="New Parent Name">
						<div class="container">
						<span class="infoMsg">The Genus "<em><span id="new_parent_name_display_layer"></span></em>" is not already Registered in ZooBank.  Please provide as much information as you can for this genus:</span>
						<table>
							<tr>
								<td>Original Spelling</td>
								<td><input id="new_parent_original_spelling" type="text" /></td>
							</tr>
							<tr>
								<td>Spelling used by #reference_results.Authors# #reference_results.Year#</td>
								<td><input id="new_parent_current_spelling" type="text" /></td>
							</tr>
							<tr style="display:none;">
								<td>Original Publication</td>
								<td><input id="article_search_string" type="text" size="80" /><input type="hidden" id="original_reference_uuid" /></td>
							</tr>
							<tr style="display:none;">
								<td>Page</td>
								<td><input id="parent_article_page" type="text" /></td>
							</tr>
							<tr>
								<td>Author(s)</td>
								<td><input id="parent_authors" type="text" /></td>
							</tr>
							<tr>
								<td>Type Species</td>
								<td><input id="parent_type_species" type="text" /></td>
							</tr>
							<tr>
								<td colspan="2"><button type="button" id="btn_register_parent" class="primaryAction">Create Parent Name</button></td>
							</tr>
						</table>
					</div>
					</cfoutput>
				</div><!--- container --->
			</div><!--- nextAction--->
		</cfif><!--- session.username is not "" --->
	</cfif><!--- session.username is defined --->	
	
	<cfif reference_results.ReferenceType is not "Periodical">
		<cfset row_cutoff_number = 26>
		<br />
		<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="getNomenclaturalActs">
			<cfinvokeargument name="ReferenceUUID" value="#reference_results.UUID#">
			<cfinvokeargument name="IsNomenclaturalAct" value="1">
		</cfinvoke>
		
			<div class="container">
			<h3><cfoutput>Nomenclatural Acts (<span id="nomenclatural_acts_count">#getNomenclaturalActs.recordcount#</span>)</cfoutput></h3>
			<div id="actsResults">
				<ol><li></li><!---seed the list with an empty li, to allow the new names to be appended to the ol after the last li--->
				<cfif getNomenclaturalActs.recordcount gt 0>
					<cfset current_rank_group = "">
					<cfoutput query="getNomenclaturalActs">
						<cfif currentrow is row_cutoff_number>
							<a id="more_names" class="secondaryAction">#recordcount-25# more...</a>
							<div id="more_names_layer" style="display:none;">
							<script language="javascript">
								$("##more_names").click(function () { 
									$('##more_names_layer').toggle();
								});
							</script>						
						</cfif>
						<cfif getNomenclaturalActs.RankGroup is not current_rank_group>
							<cfset current_rank_group = getNomenclaturalActs.RankGroup>
							<li>#current_rank_group# Group</li>						
						</cfif>
						<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
							<cfinvokeargument name="UUID" value="#reference_results.UUID#">
						</cfinvoke>
						<li><a href="/NomenclaturalActs/#getNomenclaturalActs.UUID#">
						<cfif get_ids.recordcount gt 0>
							<cfoutput query="get_ids">
							<cfif get_ids.IdentifierClass is "LSID">
								<span class="lsidButton"></span>
							</cfif>
							</cfoutput>
						</cfif>		
						#FormattedDisplay#</a> <!---<span><cfif lsid is not "">#lsid#</cfif></span>---></li>
						<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
							</div>
						</cfif>
					</cfoutput>
				</cfif>
				</ol>
				</div>
			</div>
			<br />

		
		<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_reference_tnus">
			<cfinvokeargument name="ReferenceUUID" value="#reference_results.UUID#">
			<cfinvokeargument name="IsNomenclaturalAct" value="2">
		</cfinvoke>
		
			<div class="container">
			<h3><cfoutput>Other Taxon Names (<span id="taxon_name_count">#get_reference_tnus.recordcount#</span>)</cfoutput></h3>
			<div id="tnuResults">
				<ol><li></li><!---seed the list with an empty li, to allow the new names to be appended to the ol after the last li--->
				<cfif get_reference_tnus.recordcount gt 0>
					<cfset current_rank_group = "">			
					<cfoutput query="get_reference_tnus">
						<cfif currentrow is row_cutoff_number>
							<a id="more_tnus" class="secondaryAction">#recordcount-25# more...</a>
							<div id="more_tnus_layer" style="display:none;">
							<script language="javascript">
								$("##more_tnus").click(function () { 
									$('##more_tnus_layer').toggle();
								});
							</script>						
						</cfif>
						<cfif get_reference_tnus.RankGroup is not current_rank_group>
							<cfset current_rank_group = get_reference_tnus.RankGroup>
							<li>#current_rank_group# Group</li>						
						</cfif>
						<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="/NomenclaturalActs/#get_reference_tnus.UUID#">#FormattedDisplay#</a> <!---<span><cfif lsid is not "">#lsid#</cfif></span>---></li>
						<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
							</div>
						</cfif>
					</cfoutput>
				</cfif>
				</ol>
				</div>
			</div>
		</cfif>
	<!--- <cfdump var="#get_reference_tnus#">--->
	<cfinclude template="/footer.cfm">
	<cfabort>
	
<cfelseif format is "json">

	<cfif not IsDefined("search_term")>
		<cfset search_term = term>
	</cfif>	

	<cfif IsNumeric(search_term) or (Len(search_term) is 36 or Len(search_term) is 33)>
		
		<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="get_reference_acts">
			<cfinvokeargument name="ReferenceID" value="#reference_results.PKID#">
		</cfinvoke>
		<cfset reference_json = SerializeJSON(reference_results,false,"lower","long")>
		<cfset response = '#Replace(reference_json,"]",",","ONE")# #SerializeJSON(get_reference_acts,false,"lower","long")# ]'>
	<cfelse>
		
		<!---<cfset return_string = SerializeJSON(reference_results,false,"lower","long")>--->
		
		<cfset return_string = '['>
		<cfoutput query="reference_results">
			<cfset ZBLSID = "">
			<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
				<cfinvokeargument name="UUID" value="#reference_results.UUID#">
			</cfinvoke>
			<cfif get_ids.recordcount gt 0>
				<cfoutput query="get_ids">
				<cfif get_ids.IdentifierClass is "LSID">
					<cfset ZBLSID = get_ids.identifier>
				</cfif>
				</cfoutput>
			</cfif>	
		
			<cfset safe_title = Replace(FullTitle,"/","\/","ALL")>
			<cfset safe_title = Replace(safe_title,chr(10)," ","ALL")>
			<cfset safe_title = Replace(safe_title,chr(13)," ","ALL")>
			<cfset safe_title = Replace(safe_title,"  "," ","ALL")>
			<cfset safe_title = Replace(safe_title,'"','\"',"ALL")>
			<cfset safe_citation = Replace(CitationDetails,"/","\/","ALL")>
			<cfset safe_clean_display = Replace(cleandisplay,chr(10)," ","ALL")>
			<cfset safe_clean_display = Replace(safe_clean_display,chr(13)," ","ALL")>
			<cfset safe_clean_display = Replace(safe_clean_display,'"','\"',"ALL")>
			
			
			
			<cfset return_string = '#return_string#{ "referenceuuid":"#UUID#","label": "#safe_clean_display#", "value": "#safe_clean_display#", "authors" : "#Authors#", "year" : "#Year#", "title" : "#safe_title#", "citationdetails" : "#safe_citation#","volume":"#volume#","number":"#number#","edition":"#edition#","publisher":"#publisher#","placepublished":"#placepublished#","pagination":"#pagination#","startpage":"#startpage#","endpage":"#endpage#","language":"#language#","referencetype":"#referencetype#","lsid":"#ZBLSID#","parentreferenceid":"#parentreferenceuuid#","parentreference":"#parentreference#"},'>
			<!---
			<cfset return_string = '#return_string#{ "referenceuuid":"#UUID#","label": "#cleandisplay#", "value": "#cleandisplay#", "authors" : "#Authors#", "year" : "#Year#", "title" : "#FullTitle#", "citationdetails" : "#CitationDetails#","volume":"#volume#","number":"#number#","edition":"#edition#","publisher":"#publisher#","placepublished":"#placepublished#","pagination":"#pagination#","startpage":"#startpage#","endpage":"#endpage#","language":"#language#","referencetype":"#referencetype#","lsid":"#ZBLSID#","parentreferenceid":"#parentreferenceuuid#","parentreference":"#parentreference#"},'>--->
			
		</cfoutput>
		<cfif Right(Trim(return_string),1) is ","><!--- get rid of a trailing comma, if present --->
			<cfset return_string = RemoveChars(return_string,Len(return_string),1)>
		</cfif>

		
		<!--- NEED TO ONLY RETURN THIS FOR INTERNAL AUTOCOMPLETES --->
		<cfif isdefined("add_selected_option") or isdefined("add_selected_article_option")>
			<cfif return_string is not "[">
				<cfset return_string = '#return_string#,'>
			</cfif>
			<cfif isdefined("add_selected_option")>
				<cfset return_string = '#return_string#{"id":"0","label":"Add #search_term# as new periodical.","value":"#search_term#"}'>
			<cfelseif isdefined("add_selected_article_option")>
				<cfset return_string = '#return_string#{"id":"0","label":"Create New Reference","value":"Create New Reference"}'>
			</cfif>
		</cfif>
		
		
		
		
		
		<cfset return_string = '#return_string#]'>
		
		
		<cfset response = return_string>		
	</cfif>
	
	
	<cfif format is "jsonp">
		<cfset response = "#callback_value# (#response#)">
	</cfif>
	<cfset responseBinary = toBinary(toBase64(response)) />
	 <!---

	Tell the client how much data to expect so that it knows when
	to close the connection with the server.
	--->
	<cfsilent>
	<cfcontent
	type="application/json; charset=utf-8"></cfsilent>
	
	<cfheader
	statuscode="200"
	statustext="ok"
	/>
	<!--- Stream the content back to the client. 
	<cfcontent type="application/json; charset=utf-8">--->
	
	<cfoutput>#response#</cfoutput>
	
</cfif>


