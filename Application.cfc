<cfcomponent> 
  <cfscript>
    this.name = "zoobank";
	this.sessionmanagement = true;
	this.ApplicationTimeout = CreateTimeSpan( 0, 1, 20, 0 );
	this.SessionTimeout = CreateTimeSpan( 0, 1, 20, 0 );
    this.clientmanagement = true;
	curdate = now();
	site_root_folder = "";//cfset site_root_folder = ListLast(get_rules.system_path,"\")>
	install_path = cgi.PATH_TRANSLATED;
	install_path = Replace(install_path,ListLast(install_path,'\'),'');
  </cfscript>
	<!--- Define the page request properties. --->
<cfsetting
requesttimeout="20"
showdebugoutput="true"
enablecfoutputonly="false"
/>
  <cffunction name="onApplicationStart">
   <!--- // your code to initialise the variables that will go in "application" scope ---> 
    <cfset application.datasource = "taxonomer_sandbox">
  </cffunction>
  <cffunction name="onRequestStart">
		<cfargument name="requesturi" required="true"/> 
		<cfif ListLast(requesturi,"/") is not "index.cfm" and ListLast(requesturi,"/") is not "do_login.cfm">
			<cfif parameterExists(session.IsAuthenticated) is "true">
				<cfif session.username gt 0>
					<!---<cfquery name="login" datasource="#application.datasource#">
						select * from users
						where PK_UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.UserID#">
					</cfquery>--->
				<cfelse>
					<!---You have timed out
					<cfabort>--->
					<!---<cflocation url="/zoobank/index.cfm?session_userid=0">--->
					<!---<cfabort>--->
				</cfif>
			<cfelse>
				<cfif parameterExists(cookie.username) is "Yes">
					<!--- Using the tag to set a cookie --->
					<cfset session.username = cookie.username>
					RESET SESSION ID - Cookie was good.
					<!---<cflocation url="/zoobank/index.cfm?no_session_present=1">--->
				<cfelse>					
					<!---You have timed out <a href="/index.cfm">Begin Again</a>
					<cfabort>--->
					<!--- SessionID and CookieID Lost<br />
					<cflocation url="/index.cfm?no_session_or_cookie_present=1">
					<cfabort> --->
				</cfif>
			</cfif>
		</cfif>
		<cfset access_display_string="">
	</cffunction>
  <cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires after pre page processing is complete.">
		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true" />
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
		
		<!--- Return out. --->
		<cfreturn />
</cffunction>
</cfcomponent>