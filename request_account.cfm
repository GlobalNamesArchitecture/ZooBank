<cfinclude template="/header.cfm">

<div class="container">
<span id="request_account" class="WelcomeText"> 
	<h3>Create a ZooBank Account</h3>
	<form action="/NewAccount" method="post" name="new_acct_form" id="new_acct_form">
	<table>
		<tr>
			<td>First Name</td>
			<td><input type="text" id="new_acct_givenname" name="new_acct_givenname" size="52" /></td>
		</tr>
		<tr>
			<td>Last Name</td>
			<td><input type="text" id="new_acct_familyname" name="new_acct_familyname" size="52"  /></td>
		</tr>
		<tr>
			<td>Email Address</td>
			<td><input type="text" id="new_acct_email_addr" name="new_acct_email_addr" size="52" /></td>
		</tr>
		<tr>
			<td colspan=2><cf_recaptcha
				privateKey="6LcXUdASAAAAAJsEnyUQkkjYAoaWYB7GokMcLHss"
				publicKey="6LcXUdASAAAAAEJj-9vV5U6z95Z-Ye-4N4NxF0wt"></td>
		</tr>
		<tr>
			<th colspan="2"><button class="primaryAction" id="btn_request_account" type="button">Request Account</button> [NOTE THIS FEATURE IS NOT YET ENABLED]</th>
		</tr>
	</table>
	</form>
</span>
</div>
<cfinclude template="/footer.cfm">