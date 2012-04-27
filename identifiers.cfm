<!--- Identifiers controller --->
<cfobject component="gnub_services" name="service">
<cfinvoke component="#service#" method="get_external_identifiers" returnvariable="get_ids">
	<cfif Len(search_term) is 36 or Len(search_term) is 33>
		<cfinvokeargument name="UUID" value="#search_term#">
	<cfelseif IsNumeric(search_term)>
		<cfinvokeargument name="PKID" value="#search_term#">
	</cfif>
	<cfif IsDefined("Domain")>
		<cfinvokeargument name="Domain" value="#Domain#">
	</cfif>
	<cfif IsDefined("uuid")>
		<cfinvokeargument name="uuid" value="#uuid#">
	</cfif>
</cfinvoke>


<cfif format is "html">
	 <cfheader
	statuscode="200"
	statustext="ok"
	/>
	<cfinclude template="/header.cfm">
		<div class="container">
		<ol>
		<cfoutput query="get_ids">
			<li>#IdentifierDomain# #Identifier# #IdentifierURL# #DomainLogoURL#</li>
		</cfoutput>
		</ol>
		</div>
	<cfinclude template="/footer.cfm">
	<cfabort>
<cfelseif format is "json">
	
	<!--- IdentifierID	IdentifierUUID	PKID	UUID	IdentifierClass	IdentifierDomainID	IdentifierDomain	Abbreviation	DomainLogoURL	IssuerID	IssuerUUID	Identifier	isDepreciated	RegistrationTimeStamp	RegisteringAgentID	RegisteringAgentUUID	RegisteringAgentGivenName	RegisteringAgentFamilyName	RegisteringAgentOrganizationName	IdentifierURL	CorrectPKID 	ResolutionNote
1 --->
	<cfset return_string = '['>
	<cfoutput query="get_ids">
		<cfset return_string = '#return_string#{"Identifier": "#Identifier#", "IdentifierDomain": "#IdentifierDomain#", "Abbreviation": "#Abbreviation#","IdentifierURL":"#IdentifierURL#","RegisteringAgentGivenName":"#RegisteringAgentGivenName#","RegisteringAgentFamilyName":"#RegisteringAgentFamilyName#","RegisteringAgentOrganizationName":"#RegisteringAgentOrganizationName#","IdentifierUUID":"#IdentifierUUID#", "DomainLogoURL":"#DomainLogoURL#","ResolutionNote":"#ResolutionNote#"},'>
	</cfoutput>
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


