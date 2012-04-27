<cfsilent>
<cfparam name="method" default="">
<cfset cssFiles = ArrayNew(1)>
<cfset ArrayAppend( cssFiles, "/admin/css/redmond/jquery-ui-1.8.16.custom.css" )>
<cfset ArrayAppend( cssFiles, "/admin/css/zoobank.css" )>
<!---<cfset ArrayAppend( cssFiles, "/admin/css/dynamicCSS.css" )>--->
<cfset ArrayAppend( cssFiles, "/admin/css/screen.css" )>
<cfset jsFiles = ArrayNew(1)>
	<cfset ArrayAppend( jsFiles, "/admin/js/zoobank.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/jquery-1.6.2.min.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/jquery-ui-1.8.16.custom.min.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/jquery.validate.min.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/json2.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/jquery.corner.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/autocompletes.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/waypoints.min.js" )>
	<cfset ArrayAppend( jsFiles, "/admin/js/underscore-min.js" )>
	<!--- <script src="http://documentcloud.github.com/underscore/underscore-min.js"
type="text/javascript" charset="utf-8"></script>--->
	<cfset jsFilesBody = ArrayNew(1)>
	<cfset ArrayAppend( jsFilesBody, "/admin/js/wz_tooltip.js" )>
	<cfset ArrayAppend( jsFilesBody, "/admin/js/tip_balloon.js" )>
	<cfset ArrayAppend( jsFilesBody, "/admin/js/index.js" )>
	<cfparam name="display_message" default="">
	<cfif display_message is not "">
		<cfset message_vis = "">
	<cfelse>
		<cfset message_vis = " style='display:none;'">
	</cfif>
</cfsilent>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>ZooBank.org</title>
	<!---<link href='http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700' rel='stylesheet' type='text/css'>--->
	<cfstylesheet src="#cssfiles#" minimize="true">	
	<cfjavascript src="#jsFiles#" minimize="true" munge="true" output="head">	
	
</head>
<body>
	<cfjavascript src="#jsFilesBody#" minimize="true" munge="true" output="body">
	<header id="header">
	<cfif (Find("editor",cgi.PATH_TRANSLATED) is 1) or (method is not "log_out" and method is not "TimedOut" and Find("zoobank\index.cfm",cgi.PATH_TRANSLATED) is 0 and Find("openbd\index.cfm",cgi.PATH_TRANSLATED) is 0)>
	<span id="smll_iczn_logo" class="small_iczn_logo"><img src="/images/iczn-birds-small.png" alt="small ICZN logo" /></span></cfif>
	<div class="container">
		<h1 class="logo"><a href="/"><img src="/images/zoobank-logo.gif" alt="ZooBank Logo" /> </a></h1>
		<nav>
			<ul>
				<cfif isdefined("session.username")>
					<cfif session.username is not "">
						<cfoutput><li>Logged in as <a href="/Editor">#session.user_display_name#</a></li></cfoutput>
						<li><a href="/Register">register</a></li>
					</cfif>
				</cfif>
				<li><a href="/About">about</a></li>
				<li><a href="/Contact">contact</a></li>
				<li><a href="/Api">api</a></li>
				<li class="login_container">
					<cfset loggedIn = 0>
					<cfif isdefined("session.username")>
						<cfif session.username is not "">
							 <cfset loggedIn = 1>
						</cfif>
					</cfif>
					<cfif loggedIn>
						 <a id="logout_link" href="/log_out">log out</a>
					<cfelse>
					   <a id="login_link" href="#login_form_layer">login</a>
					   <div id="login_form_layer" style="display:none;" class="login_form">
						   <form action="/do_login.cfm" method="post" class="uniForm">
							   <fieldset>
								   <div class="ctrlHolder">
									 <label for="username">Username</label> <input name="username" id="username" type="text" >
								   </div>
								   <div class="ctrlHolder">
									 <label for="password">Password</label> <input name="password" id="password" type="password" >
								   </div>
							   </fieldset>
							   <div class="buttonHolder">
									   <button type="submit" id="btn_login" class="primaryAction small">Log In</button>
									   <!-- You'll need some jquery to hide the login menu when Cancel is clicked -->
									   <button type="button" id="btn_cancel_login" class="secondaryAction">Cancel</button>
							   </div>
							   <div class="helpful_links">
									   <p><a href="/PasswordHelp">Forgot your password?</a></p>
									   <p><a href="/RequestAccount">Create an account</a></p>
							   </div>
						   </form>
					   </div>
				   </cfif>
				</li>				
			</ul>			
		</nav>
	</div>
	</header>
	<cfif (Find("editor",cgi.PATH_TRANSLATED) is 1) or (method is not "register" and method is not "log_out" and method is not "TimedOut" and Find("zoobank\index.cfm",cgi.PATH_TRANSLATED) is 0 and Find("openbd\index.cfm",cgi.PATH_TRANSLATED) is 0)>
	<div class="searchBar">
		<div class="container">
			<form action="/Search" id="form_general_search" method="get"><input type="text" class="search_input_field" id="search_term" name="search_term" lang="en" size="65">
			<button type="button" id="btn_header_search" class="primaryAction small">Search</button><span id="search_error" class="search_error"></span></form>
		</div>
	</div></cfif><cfoutput>
	<div class="container">
		<div class="okMsg"#message_vis#>#display_message#
		</div>
	</div></cfoutput>