

<cfobject component="gnub_services" name="service">
<cfinvoke component="#service#" method="get_author" returnvariable="author_results">
	<cfif Len(search_term) is 36 or Len(search_term) is 33>
		<cfinvokeargument name="AgentUUID" value="#search_term#">
	<cfelse>
		<cfinvokeargument name="search_term" value="#search_term#">
	</cfif>
</cfinvoke>

<cfif format is "html">
	<cfinclude template="/header.cfm">
	<div class="container">
		
		<h2><cfif author_results.IsPerson>Person<cfelse>Organization</cfif> Details</h2>
		<hr>
		<h3>Name</h3>
		<cfoutput query="author_results">
			<li><a href="/Authors/#UUID#"><cfif IsPerson>#FamilyName#, #GivenName# #Prefix#<cfelse>#Organization#</cfif></a></li>
		</cfoutput>
		<cfdump var="#author_results#">
		<hr>
		<h3>Publications</h3>
		<!---<cfdump var="#reference_results#">--->
	<cfinclude template="/footer.cfm">
<cfelseif format is "json">



<cfelseif format is "xml">



</cfif>








