<!--- Check that the username is valid--->
<cfinvoke component="admin.user_services" method="validate_user" returnvariable="isValid">
	<cfinvokeargument name="username" value="#form.username#">
</cfinvoke>

<cfif IsValid is 1>
	
	<cfif password is "ZooBank123">
		<cfinvoke component="admin.user_services" method="get_user" returnvariable="user_details">
			<cfinvokeargument name="username" value="#form.username#">
		</cfinvoke>
		<cfset session.user_display_name = "#user_details.GivenName# #user_details.FamilyName#">
		<cfset session.username = username>
		<cfset session.IsAuthenticated = true>
		<cflocation url="/" addtoken="no">
		<cfabort>
	<cfelse>
		<cflocation url="/BadPassword" addtoken="no">
		<cfabort>
	</cfif>
<cfelse>
	<cflocation url="/BadLogin" addtoken="no">
	<cfabort>
</cfif>