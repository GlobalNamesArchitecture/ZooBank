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
</cfcomponent>