<cfinclude template="../header.cfm">

<cfparam name="LogUserName" default = "#session.username#">
<cfjavascript src="/admin/js/register2.js" minimize="true" munge="true" output="body">
<cfjavascript src="/admin/js/jquery.refparser.js" minimize="true" munge="true" output="body">

<fieldset>
<legend class="cellmed">Register a new nomenclatural act</legend>
<form id="citation_check_form" method="post" action="">
Already have the citation?  Paste it here<textarea id="raw_citation_string" rows="3" cols="100">Udvarhelyi, I.S., Gatsonis, C.A., Epstein, A.M., Pashos, C.L., Newhouse, J.P. and McNeil, B.J. Acute Myocardial Infarction in the Medicare population: process of care and clinical outcomes. Journal of the American Medical Association, 1992; 18:2530-2536.</textarea><div id="citation_lookup_status_layer"></div>
<button id="citation_parse_lookup_btn" type="submit">Parse</button>
</form><br />
<form id="doi_lookup_form" action="" method="post">
Lookup from Digital Object Identifier (DOI) number <input type="text" id="doi_lookup" size="40" /><button>Search on DOI</button>
</form>
</fieldset>


<script type="text/javascript"> 
$(function(){ 
// Configure some options 
var options = { // JSONP-based web service parser 
parserUrl : "http://biblio.globalnames.org/parser.json", 
// select 3rd party sources to query, pass empty array if no querying desired 
sources : ["crossref", "bhl", "biostor"], 
// input auto-formatter. Options are "ama", "apa", or "asa" 
style : "apa", 
// set the target for the final click event (e.g. '_blank') 
target : "", 
// set a timeout in milliseconds, max 10000 (should be at least 5000 because BHL can be slow) 
timeout : 5000, 
// URL or path to the icons directory & icons themselves 
iconPath : "http://biblio.globalnames.org/assets/", 
// class for the icons for more control over styling 
iconClass : 'refparser-icon', 
// title/alt text and icons 
icons : { search : { title : "Search", icon : 'magnifier.png' }, loader : { title : "Loooking for reference...", icon : "ajax-loader.gif" }, doi : { title : "To publisher...", icon : "world_go.png" }, bhl : { title : "Biodiversity Heritage Library...", icon : "page_white_go.png" }, biostor : { title : "BioStor...", icon : "page_white_go.png" }, scholar : { title : "Search Google Scholar...", icon : "g_scholar.png" }, timeout : { title : "Timeout", icon : "clock_red.png" }, error : { title : "Failed parse or DOI look-up", icon : "error.png" } }, 
/* Callbacks */ 
onSuccessfulParse : function(obj, data) { /* 'obj' = jQuery object, 'data' = CITEPROC JS object for parsed reference */ 
	document.getElementById("ref_parser_results_layer").innerHTML = data.records[0].title;
	
	//alert("Checking ZB for author: "+data.records[0].author[0].family);
	for(i=0;i<data.records[0].author.length;i++){
		var check_author = $.ajax({
			url: "/editor/services.cfc?method=find_author",
			asynch: true,
			data: ({
			FamilyName:data.records[0].author[i].family,
			GivenName:data.records[0].author[i].given
			}),
			type: "get",
			success: function(msg){
				var results = JSON.parse(msg);
				//find_author_response_action(results,term,familyName,givenName);
				document.getElementById("ref_parser_author_results_layer").innerHTML = document.getElementById("ref_parser_author_results_layer").innerHTML + results[0].familyname + ', ' +results[0].givenname + ': '+results[0].label + '<br \/>';
				}//end success
			}//end ajax section arguments
			).responseText;	
	}//end for
	//var results = JSON.parse(author_check_results);
	//alert(data.records[0].title);
	
},//end successfulParse 
onFailedParse : function(obj) { /* 'obj' is the jQuery object */ }, 
onError : function(obj) { /* 'obj' is the jQuery object */ } }; 
/* Pre-compiled list of citations */ 
$(".biblio-entry").refparser(options); 
/* User input box */ 
$(".biblio-input").refparser(options); }); 
</script> 
<!-- Pre-compiled list of citations --> 
<p class="biblio-entry">10.3897/zookeys.166.1802</p> 
<!-- User input box --> 
<input class="biblio-input" size="150"></input>

<div id="ref_parser_results_layer"></div>
<div id="ref_parser_author_results_layer"></div>



<cfinclude template="../footer.cfm">

		