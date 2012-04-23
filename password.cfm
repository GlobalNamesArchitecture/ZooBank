<cfinclude template="/header.cfm">

<div class="container">
<span id="WelcomeText" class="WelcomeText"> 
	<cfif IsDefined("bad_password")>
		<h2>Password Incorrect, please try again</h2>
	</cfif>
	<h3>Forgot Password</h3>
	<table>
		<tr>
			<td>Email Address</td>
			<td><input type="text" size="52" id="email_address_pwd_reset" name="email_address_pwd_reset" /></td>
		</tr>
		<tr>
			<th colspan="2">
			<cf_recaptcha
				privateKey="6LcXUdASAAAAAJsEnyUQkkjYAoaWYB7GokMcLHss"
				publicKey="6LcXUdASAAAAAEJj-9vV5U6z95Z-Ye-4N4NxF0wt">
			<button class="primaryAction" type="button">Send temporary password to registered email address</button><br />[NOTE THIS FEATURE IS NOT YET ENABLED]</th>
		</tr>
	</table>
	
</span>
</div>

<cfinclude template="/footer.cfm">