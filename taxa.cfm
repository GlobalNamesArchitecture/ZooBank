<!--- References controller --->
<cfparam name="RankGroup" default="species">
<cfif format is "html">
	 <cfheader
	statuscode="200"
	statustext="ok"
	/>
	<cfinclude template="/header.cfm">
	

	
	<cfinvoke component="services" method="get_protonym" returnvariable="get_name_details">
		<cfif IsNumeric(search_term)>
			<cfinvokeargument name="TaxonNameUsageID" value="#search_term#">
		<cfelse>
			<cfinvokeargument name="term" value="#search_term#">
		</cfif>
		<cfinvokeargument name="RankGroup" value="#RankGroup#">
		<cfinvokeargument name="display_type" value="normal">
	</cfinvoke>
	<!---cfset name_details = DeserializeJSON(get_name_details)>--->
	<cfdump var="#get_name_details#">
<!---	<cfoutput>
	<div id="actsResults">
	<ol>
		<li>#name_details[1].label# <span><cfif name_details[1].lsid is not "">#name_details[1].lsid#</cfif></span></li>
	</ol>
	</div>
	
	<span style="width:300px;"><img src="/images/BHLlogo.png" style="width:110;" /> Images courtesy of the Biodiverity Heritage Library</span><br \/>
		<cfloop list="#name_details[1].bhl_pageid#" index="temp_imageid">
			<a href="http://www.biodiversitylibrary.org/pagethumb/#temp_imageid#,600,800" target="_blank">
			<img src="http://www.biodiversitylibrary.org/pagethumb/#temp_imageid#,80,200" /></a><br \/>
			Page:  <br \/><a href="http://biodiversitylibrary.org/page/#temp_imageid#" target="_blank">BHL Page in Ref.</a> 
		</cfloop>
	
	
		
	</cfoutput>--->
	<cfinclude template="/footer.cfm">
	<cfabort>
<cfelseif format is "json">

	
	<cfinvoke component="services" method="get_protonym" returnvariable="get_name_details">
		<cfif IsNumeric(search_term)>
			<cfinvokeargument name="TaxonNameUsageID" value="#search_term#">
		<cfelse>
			<cfinvokeargument name="term" value="#search_term#">
		</cfif>
		<cfinvokeargument name="RankGroup" value="#RankGroup#">
		<cfinvokeargument name="display_type" value="normal">
	</cfinvoke>
	
	
	<!---<cfdump var="#get_name_details#">
	<cfdump var="#get_name_details#">
	<cfabort>--->
	<cfset response = SerializeJSON(get_name_details,false,"lower","long")>
	
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


