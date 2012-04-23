
<cfobject component="gnub_services" name="service">
<cfinvoke component="#service#" method="get_author" returnvariable="author_results">
	<cfinvokeargument name="search_term" value="#search_term#">
</cfinvoke>
<cfinvoke component="#service#" method="get_nomenclatural_acts" returnvariable="taxon_name_results">
	<cfinvokeargument name="search_term" value="#search_term#">
	<cfinvokeargument name="distinctNames" value="1">
</cfinvoke>
<cfinvoke component="#service#" method="get_reference" returnvariable="reference_results">
	<cfinvokeargument name="search_term" value="#search_term#">
</cfinvoke>

<cfif format is "html">
	<cfinclude template="/header.cfm">
	<div class="container">
		<div class="facetedNavigation">
			<cfoutput>
			<div class="facetedInfo">
				<p>You searched: <em>#search_term#</em></p>
				<ul>
					<li><a href="##authors">Authors</a> (#author_results.recordcount#)</li>
					<li><a href="##publications">Publications</a> (#reference_results.recordcount#)</li>
					<li><a href="##names">Nomenclatural Acts</a> (#taxon_name_results.recordcount#)</li>
				</ul>
				
			</div>
			</cfoutput>
			<!-- TODO: Put this into an included .js file -->
			<!-- TODO: this requires waypoints.js http://imakewebthings.com/jquery-waypoints/ -->
			<script type="text/javascript" charset="utf-8">
				$(document).ready(function() {
					$.waypoints.settings.scrollThrottle = 30;	
					$('.facetedNavigation').waypoint(function(event, direction) {
						$(this).toggleClass('sticky', direction === "down");
					});
				});
			</script>
		</div>
		<cfset row_cutoff_number = 26>
		<div class="facetedResults">
			<cfoutput>
			<h3 id="authors">Authors (#author_results.recordcount#)</h3>
			</cfoutput>
			<cfif author_results.recordcount gt 0>
				<ol class="searchResults">
				<cfoutput query="author_results">
					<cfif currentrow is row_cutoff_number>
						<a id="more_authors" class="secondaryAction">#recordcount-25# more...</a>
						<div id="more_authors_layer" style="display:none;">
						<script language="javascript">
							$("##more_authors").click(function () { 
								$('##more_authors_layer').toggle();
							});
						</script>
					</cfif>
					<li><a href="/Authors/#AgentUUID#"><cfif IsPerson is 1>#FamilyName#, #GivenName# #Prefix#<cfelse>#OrganizationName#</cfif></a>
					<cfif PreferredID is not PKID>
						&nbsp;[alias of: <a href="/Authors/#PreferredUUID#"><cfif IsPerson is 1>#PreferredFamilyName#, #PreferredGivenName# #PreferredPrefix#<cfelse>#PreferredOrganizationName#</cfif></a>]
					</cfif>
					</li>
					<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
						</div>
					</cfif>
				</cfoutput>
				</ol>
			</cfif>
			
			
			<hr>
			<cfoutput>
			<h3 id="publications">Publications (#reference_results.recordcount#)</h3>
			</cfoutput>
			<cfif reference_results.recordcount gt 0>
				<ol class="searchResults">
				<cfoutput query="reference_results">
					<cfif currentrow is row_cutoff_number>
						<a id="more_pubs" class="secondaryAction">#recordcount-25# more...</a>
						<div id="more_references_layer" style="display:none;">
						<script language="javascript">
							$("##more_pubs").click(function () { 
								$('##more_references_layer').toggle();
							});
						</script>
					</cfif>
					<li><a class="biblio-entry" href="/References/#UUID#"><span class="biblio-authors">#Authors# #year#</span> #FullTitle# #CitationDetails#</a></li>
					<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
						</div>
					</cfif>
				</cfoutput>
				</ol>
			</cfif>
			<hr>
			<cfoutput>
			<h3 id="names">Nomenclatural Acts (#taxon_name_results.recordcount#)</h3>
			</cfoutput>
			<cfif taxon_name_results.recordcount gt 0>
				<ol class="searchResults">
				<cfset current_rank_group = "">
				<cfoutput query="taxon_name_results">
					<cfif currentrow is row_cutoff_number>
						<a id="more_names" class="secondaryAction">#recordcount-25# more...</a>
						<div id="more_names_layer" style="display:none;">
						<script language="javascript">
							$("##more_names").click(function () { 
								$('##more_names_layer').toggle();
							});
						</script>						
					</cfif>
					<cfif taxon_name_results.RankGroup is not current_rank_group>
						<cfset current_rank_group = taxon_name_results.RankGroup>
						<li>#current_rank_group# Group</li>						
					</cfif>
					<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="/NomenclaturalActs/#ProtonymUUID#">#FormattedDisplay#</a> <cfif IsDefined("UsageAuthors")><cfif UsageAuthors is not ""><em>sensu</em> #UsageAuthors#</cfif></cfif></li>
					<cfif currentrow is recordcount and currentrow gt row_cutoff_number>
						</div>
					</cfif>
				</cfoutput>
				</ol>
			</cfif>		
			<!---<cfdump var="#protonym_results#">--->
			
			<!---<cfdump var="#reference_results#">--->
		</div><!---#last_pub.RegisteringAgentUUID#--->
	</div><!---container--->
	<cfinclude template="/footer.cfm">
<cfelseif format is "json">



<cfelseif format is "xml">



</cfif>








