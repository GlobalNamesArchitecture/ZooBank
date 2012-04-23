<cfinclude template="header.cfm">
<cfobject component="gnub_services" name="services">
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="total_acts">
	<cfinvokeargument name="ResponseType" value="RecordCount">
	<cfinvokeargument name="Domain" value="ZooBank Nomenclatural Act">	<!---ZooBank Nomenclatural Act--->
</cfinvoke>
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="last_act">
	<cfinvokeargument name="ResponseType" value="LastRecord">
	<cfinvokeargument name="Domain" value="ZooBank Nomenclatural Act">	
</cfinvoke>
<cfinvoke component="#services#" method="get_nomenclatural_acts" returnvariable="last_taxon_act_name">
	<cfinvokeargument name="UUID" value="#last_act.UUID#">
</cfinvoke>
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="total_pubs">
	<cfinvokeargument name="ResponseType" value="RecordCount">
	<cfinvokeargument name="Domain" value="ZooBank Publication">	
</cfinvoke>
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="last_pub">
	<cfinvokeargument name="ResponseType" value="LastRecord">
	<cfinvokeargument name="Domain" value="ZooBank Publication">	
</cfinvoke>
<cfinvoke component="#services#" method="get_reference" returnvariable="last_pub_name">
	<cfinvokeargument name="ReferenceUUID" value="#last_pub.UUID#">
</cfinvoke>
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="total_authors">
	<cfinvokeargument name="ResponseType" value="RecordCount">
	<cfinvokeargument name="Domain" value="ZooBank Author">	
</cfinvoke>
<cfinvoke component="#services#" method="get_external_identifiers" returnvariable="last_author">
	<cfinvokeargument name="ResponseType" value="LastRecord">
	<cfinvokeargument name="Domain" value="ZooBank Author">	
</cfinvoke>
<cfinvoke component="#services#" method="get_author" returnvariable="last_author_name">
	<cfinvokeargument name="AgentUUID" value="#last_author.UUID#">
</cfinvoke>
<div class="intro">
	<div class="container">
		<p class="introduction"><span class="tagline">The Official Registry of Zoological Nomenclature</span> 
ZooBank provides a means to register new nomenclatural acts, published works, and authors.<!---		and assigns unique Life Science Identifiers (<abbr title="Life Science Identifier">lsid</abbr>s) to those names. ---></p>
	</div>
</div>

<div class="searchBar">
	<div class="container">
		<form action="/Search" method="get" id="form_home_page_search"><input type="text" class="search_input_field" id="search_term" name="search_term" lang="en" size="65">
		<button type="button" id="btn_home_page_search" class="primaryAction small">Search</button><span id="search_error" class="search_error_msg"></span></form>
	</div>
</div>
<cfoutput>
<!---<cfdump var="#last_taxon_act_name#">--->
<div id="results_display_layer" class="results_display_layer container"></div>
<div class="container">
	<div id="statistics">
		<div class="homeStatistic">
			<div class="icon">
				<img src="/images/stats-icon-nomenclatural-acts.gif" alt="nomenclatural acts icon" />
			</div>
			<div class="info">
				<div class="value">#NumberFormat(total_acts.RecordCount,"999,999,999,999,999")#</div>
				<div class="metric">Nomenclatural Acts</div>
				<div class="mostRecent">
					<p>Most recent: <a href="/NomenclaturalActs/#last_taxon_act_name.UUID#" class="mostRecentEntry"><span class="actName">#last_taxon_act_name.ScientificName#</span></a> 
					<span class="authorship">#last_taxon_act_name.UsageAuthors#</span></p>
					<p class="registrationAttribution">Registered by <a href="/Authors/#last_act.RegisteringAgentUUID#" class="userName">#last_act.RegisteringAgentGivenName# #last_act.RegisteringAgentFamilyName#</a> on 
					<span class="timestamp">#DateTimeFormat(last_act.RegistrationTimeStamp,"dd MMM")#</span></p>
				</div>
			</div>
		</div>		
		<!---<cfdump var="#last_act#">--->
		<div class="homeStatistic">
			<div class="icon">
				<img src="/images/stats-icon-publications.gif" alt="publications icon" />
			</div>
			<div class="info">
				<div class="value">#NumberFormat(total_pubs.RecordCount,"999,999,999,999,999")#</div>
				<div class="metric">Publications</div>
				<div class="mostRecent">
					<p>Most recent: <a href="/References/#last_pub_name.UUID#" class="mostRecentEntry">#last_pub_name.authors# #last_pub_name.year#</a></p>
					<p class="registrationAttribution">Registered by <a href="/Authors/#last_pub.RegisteringAgentUUID#" class="userName">#last_pub.RegisteringAgentGivenName# #last_pub.RegisteringAgentFamilyName#</a> on 
					<span class="timestamp">#DateTimeFormat(last_pub.RegistrationTimeStamp,"dd MMM")#</span></p>
				</div>
			</div>
		</div>
		
		<div class="homeStatistic">
			<div class="icon">
				<img src="/images/stats-icon-authors.gif" alt="authors icon" />
			</div>
			<div class="info">
				<div class="value">#NumberFormat(total_authors.RecordCount,"999,999,999,999,999")#</div>
				<div class="metric">Authors</div>
				<div class="mostRecent">
					<p>Most recent: <a href="/Authors/#last_author_name.UUID#" class="mostRecentEntry">#last_author_name.familyname# #last_author_name.givenname# #last_author_name.prefix#</a></p>
					<p class="registrationAttribution">Registered by <a href="/Authors/#last_author.RegisteringAgentUUID#" class="userName">#last_author.RegisteringAgentGivenName# #last_author.RegisteringAgentFamilyName#</a> on 
					<span class="timestamp">#DateTimeFormat(last_author.RegistrationTimeStamp,"dd MMM")#</span></p>
				</div>
			</div>
		</div>
	</div>
	<div id="how_to_contribute">
		<h2 class="contribute_to_zoobank">Contribute to ZooBank</h2>
		<p style="text-align:center;">
			<cfif isdefined("session.username")>
				<cfif session.username is not "">
					<a href="/Register" class="primaryAction">Register Content</a>
				<cfelse>
					<a href="/RequestAccount" class="primaryAction">Create an Account</a>
				</cfif>
			<cfelse>
				<a href="/RequestAccount" class="primaryAction">Create an Account</a>
			</cfif>
		</p>
		<div id="icznLogo" ><img src="/images/iczn-birds.png" alt="iczn logo bird" /></div>
	</div>
</div>
</cfoutput>
<cfinclude template="footer.cfm">
<cfabort>
<cfquery name="check_BHL" datasource="bhl_h2">
	<!---CREATE INDEX IDXCREATORENAME ON creator(CreatorName)
	CREATE INDEX IDXFULLTITLE ON title(FullTitle)
	CREATE INDEX IDXCREATORTITLEID ON creator(TitleID)
	CREATE INDEX IDXTITLEID ON title(TitleID)
	CREATE INDEX IDXENTITYID ON doi(EntityID)
	CREATE INDEX IDXSUBJTITLEID ON subject(TitleID)
	CREATE INDEX IDXSUBJECT ON subject(subject)
	CREATE INDEX IDXTIDTITLEID ON titleidentifier(TitleID)
	CREATE INDEX IDXITEMID ON page(ItemID)
	CREATE INDEX IDXPAGEID ON page(PageID)
	CREATE INDEX IDXPAGENAMEPAGEID ON pagename(PageID)
	CREATE INDEX IDXNAMECONFIRMED ON pagename(NameConfirmed)
	CREATE INDEX IDXIITEMITEMID ON Item(ItemID)
	CREATE INDEX IDXIITEMTITLEID ON Item(TitleID)
	SELECT COUNT(PageID) from page as EXPR1
	DROP INDEX IF EXISTS IDXIITEM_TITLEID
	SELECT t.FullTitle,p.*,pn.NameConfirmed,t.TitleURL
	from title as t join item as i on t.TitleID = i.TitleID join page as p on i.itemid = p.itemid 	left outer join pagename as pn on pn.PageID = p.PageID 
	where pn.NameCOnfirmed = 'Chaetodon imperator'
	
	SELECT pn.NameConfirmed,p.PageID 
	from PageName as pn join page as p on pn.PageID = p.PageID join item as i on p.itemid = i.itemid
	where pn.NameCOnfirmed like 'Chaetodon imperat%'--->
	
	select pn.*
	from
	pagename as pn
	where <!---p.itemid = 33302--->
	pn.NameConfirmed like 'Chaetodon tink%'
	
	<!---
	SELECT pn.NameConfirmed,p.PageID 
	from PageName as pn join page as p on pn.PageID = p.PageID join item as i on p.itemid = i.itemid
	where pn.NameCOnfirmed like 'Chaetodon imperat%'
	
	SELECT t.FullTitle,p.*,pn.NameConfirmed,t.TitleURL
	from title as t join page as p on t.TitleID = p.itemid 	left outer join pagename as pn on pn.PageID = p.PageID 
	where t.TitleID = 29911
	
	SELECT t.FullTitle,p.PageNumber,pn.NameConfirmed
	from tital as t join page as p on t.TitleID = p.itemid 	join pagename as pn on pn.PageID = p.PageID
	where pn.NameConfirmed like 'imperator'
	
	SELECT t.* , p.PageNumber, p.Year as page_year
	from title as t join page as p on t.TitleID = p.ItemID
	where TitleID = 12540
	
	SELECT t.FullTitle, pn.NameConfirmed,p.PageNumber
	from title as t join page as p on t.TitleID = p.itemID join pagename as pn on pn.PageID = p.PageID
	where TitleID = 52237
	
	SELECT     TOP (200) pn.NameConfirmed,p.PageNumber,c.CreatorType, c.CreatorName, c.CreationDate, t.FullTitle, t.LanguageCode, t.TitleURL, t.ShortTitle,s.subject ,tid.IdentifierName,tid.identifierValue,d.DOI
	FROM         creator as c join title as t on c.TitleID = t.TitleID join subject as s on s.TitleID = t.TitleID left outer join titleidentifier as tid on tid.TitleID = t.TitleID
	LEFT OUTER JOIN doi as d on d.EntityID = t.TitleID left outer join page as p on t.titleid = p.ItemID left outer join pagename as pn on p.PageID = pn.PageID
	WHERE     (c.CreatorName LIKE 'Pyle, R%')
	
	SELECT     TOP (200) c.CreatorType, c.CreatorName, c.CreationDate, t.FullTitle, t.LanguageCode, t.TitleURL, t.ShortTitle,s.subject ,tid.IdentifierName,tid.identifierValue,d.DOI
	FROM         creator as c join title as t on c.TitleID = t.TitleID join subject as s on s.TitleID = t.TitleID left outer join titleidentifier as tid on tid.TitleID = t.TitleID
	LEFT OUTER JOIN doi as d on d.EntityID = t.TitleID
	WHERE     (c.CreatorName LIKE 'Pyle, R%') --->
</cfquery><!---
<cfoutput query="check_bhl">

	#FullTitle#  #TitleURL# <a href="http://www.biodiversitylibrary.org/pagethumb/#PageID#,400,600" target="_blank">BHL Page</a><br />
</cfoutput>--->




<cfdump var="#check_BHL#">		