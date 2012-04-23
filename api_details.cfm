<cfinclude template="header.cfm">
<cfjavascript src="/admin/js/api_details.js">
<cfoutput>


<div class="container">

<div class="textPage api_reference">
<h2>ZooBank API</h2>
<h3>Authors</h3>

<label>Search for an Author <a id="author_search_json_link">[json data]</a></label> <a href="/Authors.json?search_term=pyle" target="_blank">http://#cgi.server_name#/Authors.json?search_term=pyle</a><br />
<div id="author_search_json" style="display:none;padding-left:35px;"><h3>JSON Results for Author Search</h3>
	<table>
		<thead>
		<tr>
			<th>COLUMN</th>
			<th>DESCRIPTION</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td>agentnameid</td>
			<td>The GUID for the agent name</td>
		</tr>
		<tr>
			<td>label</td>
			<td>Formatted name - FamilyName, GivenName(s)</td>
		</tr>
		<tr>
			<td>value</td>
			<td>Formatted name - FamilyName, GivenName(s)</td>
		</tr>
		<tr>
			<td>ZBLSID</td>
			<td>ZooBank LSID if assigned</td>
		</tr>
		<tr>
			<td>familyname</td>
			<td>The Agent's FamilyName</td>
		</tr>
		<tr>
			<td>givenname</td>
			<td>The Agent's GivenName(s)</td>
		</tr>
		<tr>
			<td>agentid</td>
			<td>The GUID for the agent</td>
		</tr>
		</tbody>
	</table>
</div>
<label>Search for an Author [json data]</label> <a href="/Authors.json?term=pyle" target="_blank">http://#cgi.server_name#/Authors.json?term=pyle</a> - useful in jQuery Autocompletes<br />
<label>Search for an Author [HTML]</label> <a href="/Authors?search_term=pyle" target="_blank">http://#cgi.server_name#/Authors?search_term=pyle</a><br />
<label>Get an Author by identifier</label> <a href="/Authors/8C466CBE-3F7D-4DC9-8CBD-26DD3F57E212" target="_blank">http://#cgi.server_name#/Authors/8C466CBE-3F7D-4DC9-8CBD-26DD3F57E212</a><br />
<label>View a histogram displaying an Authors publication range</label> <a href="/PublicationHistogram/10F0B043-B68B-4C69-AD12-C2AEC5FA584F" target="_blank">http://#cgi.server_name#/PublicationHistogram/10F0B043-B68B-4C69-AD12-C2AEC5FA584F</a><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/PublicationHistogram/10F0B043-B68B-4C69-AD12-C2AEC5FA584F" alt="Publication history histogram" />


<!---
Find an Author's aliases: <a href="http://#cgi.server_name#/editor/services.cfc?method=find_author&parentID=19670408" target="_blank">http://#cgi.server_name#/editor/services.cfc?method=find_author&parentID=19670408</a><br />

Show an Author's Publications: <a href="http://#cgi.server_name#/editor/services.cfc?method=show_author_pubs&AuthorID=19670408" target="_blank">http://#cgi.server_name#/editor/services.cfc?method=show_author_pubs&AuthorID=19670408</a><br />
--->
<br />
<h3>Publications</h3>

<label>Search for a Publication [json data]</label> <a href="/References.json?search_term=pyle" target="_blank">http://#cgi.server_name#/References.json?search_term=pyle</a><br />
<label>Search for a Publication [json data]</label> <a href="/References.json?term=pyle" target="_blank">http://#cgi.server_name#/References.json?term=pyle</a>- useful in jQuery Autocompletes<br />
<label>Search for a Publication [HTML]</label> <a href="/References?term=pyle" target="_blank">http://#cgi.server_name#/References?term=pyle</a><br />
<label>Get a Publication by identifier [HTML]</label> <a href="/References/427D7953-E8FC-41E8-BEA7-8AE644E6DE77" target="_blank">http://#cgi.server_name#/References/427D7953-E8FC-41E8-BEA7-8AE644E6DE77</a><br />
<label>Get a Publication by identifier [json]</label> <a href="/References.json/427D7953-E8FC-41E8-BEA7-8AE644E6DE77" target="_blank">http://#cgi.server_name#/References.json/427D7953-E8FC-41E8-BEA7-8AE644E6DE77</a><br />

<!---
Search Publications: <a href="http://#cgi.server_name#/editor/services.cfc?method=find_pub&term=hoplolat" target="_blank">http://#cgi.server_name#/editor/services.cfc?method=find_pub&term=hoplolat</a> <br />


For a given reference, show the authors: <a href="http://#cgi.server_name#/editor/services.cfc?method=get_pub_authors&ReferenceID=19729101" target="_blank">http://#cgi.server_name#/editor/services.cfc?method=get_pub_authors&ReferenceID=19729101</a><br />

For a given reference, show the taxonom acts: <a href="http://#cgi.server_name#/editor/services.cfc?method=get_nomenclatural_acts&ReferenceID=19729101" target="_blank">http://#cgi.server_name#/editor/services.cfc?method=get_nomenclatural_acts&ReferenceID=19729101</a><br />
--->
<br />
<h3>Taxon Name Usages</h3>

<label>Get a Nomenclatural Act by identifier [HTML]</label> <a href="/NomenclaturalActs/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2" target="_blank">http://#cgi.server_name#/NomenclaturalActs/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2</a><br />
<label>Get a Nomenclatural Act by identifier [json]</label> <a href="/NomenclaturalActs.json/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2" target="_blank">http://#cgi.server_name#/NomenclaturalActs.json/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2</a><br />
<label>Get Nomenclatural Acts by name [HTML]</label> <a href="/NomenclaturalActs/Pseudanthias_carlsoni" target="_blank">http://#cgi.server_name#/NomenclaturalActs/Pseudanthias_carlsoni</a><br />
<label>Get Nomenclatural Acts by name [json]</label> <a href="/NomenclaturalActs.json/Pseudanthias_carlsoni" target="_blank">http://#cgi.server_name#/NomenclaturalActs.json/Pseudanthias_carlsoni</a><br />
<label>Search for a Nomenclatural Act [HTML]</label> <a href="/NomenclaturalActs?search_term=pyle" target="_blank">http://#cgi.server_name#/NomenclaturalActs?search_term=pyle</a><br />
<label>Search for a Nomenclatural Act [json]</label> <a href="/NomenclaturalActs.json?search_term=pyle" target="_blank">http://#cgi.server_name#/NomenclaturalActs.json?search_term=pyle</a><br />

<br />
<h3>Identifiers</h3>
<label>Get Identifiers by id [json]</label> <a href="/Identifiers.json/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2" target="_blank">http://#cgi.server_name#/Identifiers.json/6EA8BB2A-A57B-47C1-953E-042D8CD8E0E2</a><br />


<br />
<h3>Graphics</h3>
ZooBank Logo [gif] <div class="container" style="background-color:##31309c;width:220px;padding:5px">
<h1 class="logo"><img alt="ZooBank Logo" src="/images/zoobank-logo.gif" /></h1></div>
ZooBank Logo [jpg] <img src="/images/ZooBankBanner.jpg" alt="ZooBank Logo" /><br />


<h2>Definitions</h2>
<h3>Reference</h3>A static documentation source. Examples include: Publications, printed documents, static electronic documents, snapshop versions of databases. In the context of ZooBank, only References that are Published Works (in the sense of the Code) are registered.<br /><br />
<h3>Taxon Name Usage</h3>A usage instance or treatment of a name of an organism within a reference.<br /><br />
<h3>Nomenclatural Act</h3>The subset of taxon name usage instances that involve code-governed actions on scientific names. Examples: Establishment of names for new taxa, subsequent new combinations (ICNafp), lectotypifications, neotypifications, first-reviser actions (ICZN).<br /><br />
<h3>Original Name Usage</h3>A subset of nomenclatural acts that represent the establishment of a name for a new taxon, in compliance with the relevant code(s).<br /><br />
<h3>Protonym</h3>The first usage of a particular scientific name within a reference, regardless of whether or not it is established in compliance with the relevant code(s).<br /><br />
<h3>Scientific Names</h3>The full scientific name, with authorship and date information if known. Includes orthographic variants, misspellings, etc. See <a href="http://rs.tdwg.org/dwc/terms/index.htm" target="_blank">DarwinCore definition</a>.<br /><br />

</cfoutput>

<!---
Find a taxonomic name: <a href="http://zoobank.explorers-log.com/Names?search_term=chromi&RankGroup=Genus" target="_blank">
	http://zoobank.explorers-log.com/Names?search_term=chromi&RankGroup=Genus</a><br /><br />
	
	<a href="http://zoobank.explorers-log.com/Names.json?search_term=chromi" target="_blank">
	http://zoobank.explorers-log.com/Names.json?search_term=chromi</a><br /><br />
--->
<!---
<h2>Taxon Name Usage</h2>	
	
	Search for a taxon name usage: 
	http://zoobank.explorers-log.com/TaxonActs.json?search_term=&TaxonNameUsageID=20393331</a><br /><br />
	
	Get a specific usage:
	http://zoobank.explorers-log.com/TaxonActs/20393331<br /><br />

	
	
	
	
	
	
	
	
Add a new taxon name usage: http://#cgi.server_name#/editor/services.cfc?method=insert_taxon_name&Pages=&ReferenceID=19729101&TaxonRankID=60&NameString=Hoplolatilus&Authors=Basset%2C+Novotny%2C+Miller+%26+Pyle&Types=&IsFossil=0&LogUserName=whittonr&establish_protonym=0&assign_zb_lsid=0&ProtonymID=20316739&Illustration=&ParentUsageID=
<br /><br />
This example shows the registration of the usage of the genus (TaxonRankID=60) "Hoplolatilus" (TaxonID: 20316739) in Reference 19729101 ; not a fossil record (IsFossil=0) and do not establish_protonym since this is already a known genus<br />

Returns: new_taxon_name_usage_id - internal ZooBank ID - not an LSID--->
</div>


</div>

<cfinclude template="footer.cfm">