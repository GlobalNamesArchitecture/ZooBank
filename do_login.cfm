<!--- Check that the username is valid--->
<cfinvoke component="admin.user_services" method="validate_user" returnvariable="isValid">
	<cfinvokeargument name="username" value="#form.username#">
</cfinvoke>
<cfif IsValid is 1>
	<cfif password is "ZooBank123">
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