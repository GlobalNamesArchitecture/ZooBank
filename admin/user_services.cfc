<cfcomponent>
	<cfset datasource = "taxonomer_sandbox"><!---gnub_taxonomer_sandbox--->
	<cffunction access="public" name="validate_user" returntype="string">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="no">
	
		<cfquery name="check_user" datasource="aspnetdb"><!---aspnetdb_gnub--->
			SELECT LastActivityDate
			from aspnet_Users
			where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
		
		</cfquery>
		<cfif check_user.recordcount is 1>
			<cfset isValidUser = 1>
		<cfelse>
			<cfset isValidUser = 0>
		</cfif>
		<cfreturn isValidUser />
	</cffunction>
	
	<cffunction name="get_user">
		<cfargument name="username" type="string" required="yes">
	
		<cfquery name="get_users" datasource="#datasource#">
			EXEC sp_GetUserDetails
			@UserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.username#">
		</cfquery>
		
		<cfreturn get_users />
	</cffunction>
	
	
	
</cfcomponent>