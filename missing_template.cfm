<cfoutput>
	<cfparam name="request_type" default="get">
	<cfparam name="search_term" default="">
	<cfparam name="format" default="html">
	<cfparam name="callback_value" default="">
	
	<cfset current_request_uri = request.javax.servlet.error.request_uri>
	
	
	<cfif find(".json",current_request_uri)>
		<cfset format = "json">
		<cfset current_request_uri = Replace(current_request_uri,".json","","ALL")>
	<cfelse>
		<cfif find(".",current_request_uri)>
			<cfset format = ListLast(ListFirst(current_request_uri,"/"),".")>
		</cfif>
	</cfif>
	<cfset method = ListFirst(ListFirst(current_request_uri,"/"),".")>
	<cftry>
	<cfif Find("search_term",request.javax.servlet.forward.query_string)>
		<cfset request_type = "search">
		<cfset search_term = url.search_term>
	</cfif>
	<cfcatch>
		<!---There is no query sting, so the final list item may be the search term--->
		<cfset search_term = ListLast(current_request_uri,"/")>
		<cfset search_term = Replace(search_term,"_"," ","ALL")>
	</cfcatch>
	</cftry>
	<cfif IsNumeric(ListFirst(ListLast(current_request_uri,"/"),"."))>
		<cfset search_term = ListFirst(ListLast(current_request_uri,"/"),".")>
	</cfif>
	
	
	
	<cfif format is "json">
		<cftry>
			<cfif Find("callback",request.javax.servlet.forward.query_string)>
				<cfset format = "jsonp">
				<cfset callback_value = url.callback>
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
	
	
	<cfif method is "References">
		<cfinclude template="/references.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "TaxonActs">
		<cfinclude template="/taxonacts.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "Names">
		<cfinclude template="/names.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "api">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/api_details.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "about">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/about.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "contact">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/contact.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "register">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/editor/register3.cfm">
		<cfabort>
	</cfif>
	<cfif method is "do_login">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/do_login.cfm">
		<cfabort>
	</cfif>
	<cfif method is "editor">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/editor/index.cfm">
		<cfabort>
	</cfif>
	<cfif method is "log_out">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfset session.username = "">
		<cfset display_message = "You have successfully logged out of ZooBank">
		<cfinclude template="/index.cfm">
		<cfabort>
	</cfif>
	
	
	
	Request Type: #request_type# [#search_term#] Method: #method# Format: #format#
	<cfabort>
</cfoutput>