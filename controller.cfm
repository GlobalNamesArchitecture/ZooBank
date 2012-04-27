<cfsilent>
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
		<cfelseif Find("term",request.javax.servlet.forward.query_string)>
			<cfset request_type = "search">
			<cfset search_term = url.term>
		<cfelse>
			<cfset search_term = ListLast(current_request_uri,"/")>
			<cfset search_term = Replace(search_term,"_"," ","ALL")>
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
	
		<!--- see if the request URI is an LSID or a UUID--->
	
	<!--- urn:lsid:zoobank.org:act:79F2C0A7-8EB5-4055-87A7-15074405FF4E --->
	<cfif find("urn:lsid:zoobank",current_request_uri)>
		<cfset method = ListLast(current_request_uri,":")>	
		<cfset format = "html">	
		<cfif find(".json",current_request_uri)>
			<cfset format = "json">	
		</cfif>
	</cfif>
		
	<cfif Len(method) is 36 or Len(method) is 33><!--- it is a UUID --->
		<cfinvoke component="gnub_services" method="get_zoobank_lsid" returnvariable="ZB_LSID_data">
			<cfinvokeargument name="UUID" value="#method#">
		</cfinvoke>
		<cfif ZB_LSID_data.recordcount is 0>
			<cflocation url="/Search?search_term=#method#">
			<cfabort>
		<cfelse>
			<cfset search_term = method>
			<cfif ZB_LSID_data.ZooBankDomain is "Nomenclatural Act">			
				<cfset method = "NomenclaturalActs">
			<cfelseif ZB_LSID_data.ZooBankDomain is "Reference">			
				<cfset method = "References">
			<cfelseif ZB_LSID_data.ZooBankDomain is "Author">			
				<cfset method = "Authors">
			</cfif>		
		</cfif>
	</cfif>
	
	<cfif method is "References">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfif isdefined("url.PublishedOnly") and format is "html">
		<html>
		<body onload="document.getElementById('form_send').submit();">
			<form id="form_send" action="/References" method="post">
				<input type="hidden" name="register" value="1" />
				<input type="hidden" name="PublishedOnly" value="0" />
				<input type="hidden" name="search_term" value="#search_term#" />
				<input type="hidden" name="format" value="html" />
			</form>
		</body>
		</html>
		<cfelse>
			<cfinclude template="/references.cfm">
		</cfif>
		<cfabort>
	</cfif>
	
	<cfif method is "NomenclaturalActs">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/nomenclaturalacts.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "Names">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/names.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "Identifiers">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/get_identifiers.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "Repositories">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/get_repositories.cfm">
		<cfabort>
	</cfif>
	
	<cfif method is "Authors">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/authors.cfm">
		<cfabort>
	</cfif>

	<cfif method is "Agents">		
		<cfheader
		statuscode="200"
		statustext="ok"
		/><cfinclude template="/agents.cfm">
		<cfabort>
	</cfif>
	<cfif method is "VideoGuideSWF">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/help.cfm">
		<cfabort>
	</cfif>
	<cfif method is "VideoGuide">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/youtube.cfm">
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
	
	<cfif method is "Register">
		
		<cfif not IsDefined("session.username")>
			<cfinclude template="index.cfm">
			<cfabort>
		</cfif>
		<cfif session.username is "">
			<cfinclude template="index.cfm">
			<cfabort>
		</cfif>
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
	<cfif method is "BadLogin">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/bad_login.cfm">
		<cfabort>
	</cfif>
	<cfif method is "editor">
		<cfif session.username is "">
			<cfinclude template="index.cfm">
			<cfabort>
		</cfif>
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/editor/index.cfm">
		<cfabort>
	</cfif>
	<cfif method is "PasswordHelp">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/password.cfm">
		<cfabort>
	</cfif>
	<cfif method is "RequestAccount">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/request_account.cfm">
		<cfabort>
	</cfif>
	<cfif method is "Search">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/search.cfm">
		<cfabort>
	</cfif>
	
	
	<cfif method is "BadPassword">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfset bad_password = 1>
		<cfinclude template="/password.cfm">
		<cfabort>
	</cfif>
	<cfif method is "log_out">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfset session.username = "">
		<cfcookie name="username" expires="now">
		<cfset display_message = "You have successfully logged out of ZooBank">
		<cfinclude template="/index.cfm">
		<cfabort>
	</cfif>
	<cfif method is "PublicationHistogram">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfinclude template="/author_pub_graph.cfm">
		<cfabort>
	</cfif>
	<cfif method is "TimedOut">
		<cfheader
		statuscode="200"
		statustext="ok"
		/>
		<cfset session.username = "">
		<cfset display_message = "You have timed out of ZooBank.  Please log in again.">
		<cfinclude template="/index.cfm">
		<cfabort>
	</cfif>
	
	
	
	Request Type: #request_type# [#search_term#] Method: #method# Format: #format#
	<cfabort>
</cfoutput>
</cfsilent>