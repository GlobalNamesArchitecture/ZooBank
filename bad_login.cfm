<cfinclude template="/header.cfm">
	<div class="container">
	<h2>Invalid Username</h2>
	<p>Forgotten Username?<br /><br />
	Enter your registered email address below and we will send your username to that address.<br /><br />
	Registered Email Address <input type="text" size="80" name="registered_email" id="registered_email" /><br /><br />
	<button type="button" id="btn_forgot_pwd" class="primaryAction">Send me my username</button>
	<span style="font-weight:bolder;">[NOTE THIS FEATURE IS NOT YET ENABLED]</span>
	</p>
	<cfset session.IsAuthenticated = false>
	<cfset session.username = "">
	</div>
<cfinclude template="/footer.cfm">