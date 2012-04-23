/*

	NAME: index.js

	PURPOSE:  ZooBank wide javascript functions.

	LAST MODIFIED: 
		
	CREATED:  
	
	ORIGINAL AUTHOR: Robert Whitton

	NOTES: Many of these functions are deprecated

*/

$().ready(function() {
	//add onclick event to the login link
	$('#login_link').click(function(){
		   if( $(this).hasClass('menu_open') ) {
				   $(this).removeClass('menu_open');
				   $('#login_form_layer').hide();
		   } else {
				   $(this).addClass('menu_open');
				   $('#login_form_layer').show();
		   }

		   return false;
   });
   
   //add onclick event to the cancel login link
	$('#btn_cancel_login').click(function(){
		   $('#login_form_layer').hide();
		   $('#login_link').removeClass('menu_open');
	});	
	
	//add onclick event to the cancel login link
	$('#btn_home_page_search').click(function(){
		  if($("#search_term").val()!="") {
				document.getElementById("search_error").innerHTML = '<img src="/images/loading_16.gif" alt="working..." \/>';
				document.getElementById("btn_home_page_search").innerHTML = 'working...';
				document.getElementById("form_home_page_search").submit();
			}
		  else document.getElementById("search_error").innerHTML = "Please enter a search term";
	});	
	
	
	//
	$('#btn_header_search').click(function(){
		  if($("#search_term").val()!="") {
				document.getElementById("search_error").innerHTML = '<img src="/images/loading_16.gif" alt="working..." \/>';
				document.getElementById("btn_header_search").innerHTML = 'working...';
				document.getElementById("form_general_search").submit();
			}
		  else document.getElementById("search_error").innerHTML = "Please enter a search term";
	});	
	
	
});


function general_search(taxonid) {
	if(document.getElementById("taxon_act_search_string").value.length<=2){
		$("#search_error").addClass("error");
		document.getElementById("search_error").innerHTML = 'Please enter a search term';
	}	
	else{
	$("#search_error").removeClass("error");
	
	//document.getElementById("search_error").innerHTML = '';
	//clear any TNU displays
	//document.getElementById("ref_names_layer").innerHTML = '';
	//clear any current search results
	//document.getElementById("results_display_layer").innerHTML = '';
	var search_term = document.getElementById("general_search_string").value;
	if(typeof taxonid === "undefined") {
		$("#general_search_string").addClass("loading");
		window.location='/Search?search_term='+search_term;
		//document.getElementById("results_display_layer").innerHTML = '<img src="/images/loading_blue.gif" />';
		//document.getElementById("ref_details_layer").innerHTML = '';
		//document.getElementById("ref_names_layer").innerHTML = '';
		//document.getElementById("ref_authors_layer").innerHTML = '';
		}
	else search_term = '';
	var get_acts = $.ajax({
		//url: "/services.cfc?method=find_taxon_act",
		url: "/Search",
		asynch:false,
		data: ({
		search_term:search_term,
		TaxonNameUsageID:taxonid
		}),
		type: "get",
		success: function(msg){
			//var results = JSON.parse(msg);//some browsers cannot natively parse the JSON result
			if(typeof taxonid === "undefined") find_taxon_act_response_action(msg,search_term);				
			else get_taxon_details_response_action(msg,search_term);
			$("#general_search_string").removeClass("loading");
			}//end success
		}//end ajax section arguments
		).responseText;		
	}//end else
}

function show_details(taxonid,pubid){
	
	document.getElementById("ref_details_layer").innerHTML = '<img src="/images/loading_blue.gif" />';
	general_search(taxonid);
	//get_pub_details(pubid);
	//get_author_by_pub(pubid);
	//get_pub_acts(pubid);
	//setSectionClass('deemphasized_section','results_display_layer',0);
	//setSectionClass('empahsized_section','ref_details_layer',0);
}

function get_taxon_details_response_action(results){
	var acts_html = '<div class="actSummary"><h2 class="actName">'+results[0].nameComplete+'</h2><div class="lsidWrapper"><span class="lsidLogo">LSID</span><input type="text" value="'+results[0].lsid+'" class="selectAll lsid" \/><object width="110" height="14" id="clippy" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"><param value="/public/flash/clippy.swf" name="movie"><param value="always" name="allowScriptAccess"><param value="high" name="quality"><param value="noscale" name="scale"><param value="text=urn:lsid:zoobank.org:act:8BDC0735-FEA4-4298-83FA-D04F67C3FBEC" name="FlashVars"><param value="#f5f5ff" name="bgcolor"><embed width="110" height="14" bgcolor="#f5f5ff" flashvars="text='+results[0].lsid+'" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" allowscriptaccess="always" quality="high" name="clippy" src="/public/flash/clippy.swf"></object><script charset="utf-8" type="text/javascript">$(".selectAll").click(function(){ this.select(); });</script></div><table><tbody><tr>	<th scope="row">Rank</th><td>'+results[0].Rank+'</td></tr><tr><th scope="row">Parent</th><td>'+results[0].FormattedParent+'</td></tr><tr><th scope="row">Publication</th><td colspan="2"><span class="biblio-entry"><span class="biblio-authors">'+results[0].CheatFullAuthors + '<\/span> (' + results[0].Year + ') <span class="biblio-title">' + results[0].Title + '<\/span> ' + results[0].CheatCitationDetails + '&nbsp;<a href="/References/'+results[0].ReferenceID+'">[show all names in ref.]<\/a><\/span></td></tr></tbody></table></div>';
	
	
	acts_html = acts_html + '<div id="bhl_results" class="bhl_results"><\/div><div id="gni_results_layer"><\/div><div id="gni_detailed_results_layer"><\/div><div id="el_results_layer"><\/div>';
	
	
		
	document.getElementById("ref_details_layer").innerHTML = acts_html;
	var bhl_html = 'no bhl match';
	if(results[0].bhl_response=="BHL Success") {//if(results[0].bhl_pageid>0) {	
		bhl_html = '<span style="width:300px;"><img src="/images/BHLlogo.png" style="width:110;" /> Images courtesy of the Biodiverity Heritage Library<\/span><br \/>';
		var pageid_array = results[0].bhl_pageid.split(',');//jQuery.makeArray(results[0].bhl_pageid);
		var pageNumArray = results[0].bhl_pageNumbers_list.split(',');
		//loop over the pages and display the thumbnail of the page and a link to BHL's full size image
		for(i=0;i<pageid_array.length;i++){
			bhl_html = bhl_html + '<a href="http://www.biodiversitylibrary.org/pagethumb/'+pageid_array[i]+',600,800" target="_blank"><img src="http://www.biodiversitylibrary.org/pagethumb/'+pageid_array[i]+',40,60" \/><\/a><br \/>Page: '+pageNumArray[i]+' <br \/><a href="http://biodiversitylibrary.org/page/'+pageid_array[i]+'" target="_blank">BHL Page in Ref.<\/a> ';
			} //end for
		}//end if 
	document.getElementById("bhl_results").innerHTML = bhl_html;
	//call global names index
	get_gni_data( results[0].nameComplete, { add_register_link: 0 })
	//call explorers log to see what 
	get_exp_log_data(results[0].nameComplete);
	
}

function get_pub_details_response_action(pubid,results){
	var pub_details_html = '<span class="biblio-entry"><span class="biblio-authors">'+results[0].CheatFullAuthors + '<\/span> (' + results[0].Year + ') <span class="biblio-title">' + results[0].Title + ' ' + results[0].CheatCitationDetails + '&nbsp;[show all names in ref.]<\/span><\/span>';
	
	document.getElementById("publication_details").innerHTML = pub_details_html + '<\/div>';
}


function get_author_by_pub_response_action(pubid,results){
	var author_html = 'Authors<br \/>';
	for(x=0;x<results.data.length;x++){
			author_html = author_html + results.data[x][4] + '<br \/>';
		}//end for
	document.getElementById("ref_authors_layer").innerHTML = author_html;
}

/*
function get_pub_acts_response_action(results){
	var acts_html = '<div class="actSummary"><h2 class="actName">Taxon Name Usages<\/h2><ol>';
	for(x=0;x<results.data.length;x++){
			acts_html = acts_html + '<li><span class="clickable_layer" onclick="general_search('+results.data[x][3] +');">' +results.data[x][10] + '<\/span> ' + results.data[x][7] + ' ' + results.data[x][1] + '<\/li>';
		}//end for
	document.getElementById("ref_names_layer").innerHTML = acts_html + '<\/ol>';


}*/

function find_taxon_act_response_action(results,search_term){
	//alert("Here");
	var results_html = '<div class="searchResults"><h2 class="actName">Search Results for <em>'+search_term+'<\/em><\/h2>';
	if(results[0].id==0) {
		results_html = results_html + results[0].label + '<br \/><div id="gni_results_layer"><\/div><div id="gni_detailed_results_layer" style="display:none;"><\/div>';
		//call gni to see if what it knows
		document.getElementById("results_display_layer").innerHTML = results_html + '<\/div>';
		get_gni_data( search_term, { add_register_link: 1 })
				
		}//end if
	else {
		results_html = results_html + '<ol>';
		for(i=0;i<results.length;i++){
				results_html = results_html + '<li onclick="window.location=&quot;/TaxonActs/'+results[i].id+'&quot;;"><span class="actName">' +results[i].nameComplete + '<\/span> <span class="authorship">' +results[i].CheatCitation+'</span><\/li>';//onclick="show_details('+results[i].id+','+results[i].ReferenceID+');"
			}//end for
		document.getElementById("results_display_layer").innerHTML = results_html + '<\/ol><\/div>';
	}//end else
	
}

function launch_get_bhl_data(title,volume,year,lname){
	
	get_bhl_data('book_search',title,volume,year,'');//method,title,volume,year,lname
	
}
function get_bhl_data_response_action(results,method,title,volume,year){
	alert("results came back");
	var results_html = results.Result[0].FullTitle;
	document.getElementById("bhl_results_layer").innerHTML = results_html;

}

function get_gni_data_response_action(results,term,add_register_link){
	var gni_html = "<span id='gni_results_layer' class='clickable_layer'><img src='/images/gni.png' />" + results.name_strings.length + ' matches<\/span>';
	document.getElementById("gni_results_layer").innerHTML = gni_html;
	
	//add an onclick event to the results layer to toggle the detailed results
	 $("#gni_results_layer").click(function () { 
     	$("#gni_detailed_results_layer").toggle();
    }); //end add click	

	
	var gni_details_html = "<ol>";
	if(typeof results.name_strings === "undefined") gni_details_html = "No GNI matches";
	else {
		if(results.name_strings.length>0){
			for(i=0;i<results.name_strings.length;i++){
				gni_details_html = gni_details_html + '<li>'+results.name_strings[i].name
				if(add_register_link==1) gni_details_html = gni_details_html + ' <span class="clickable_layer">register<\/span>';
				gni_details_html = gni_details_html + '<\/li>';	
				
				}//end for
			}//end if results gt 0
		}//end else
	document.getElementById("gni_detailed_results_layer").innerHTML = gni_details_html +'<\/ol>';
	
}//end function

function get_exp_log_data_response_action(msg,term){
	//alert("EL");
	alert("cas_spc: " + msg.data[0][18]);
	//get_el_evidence_data(msg.data[0][0]);
}

function get_el_evidence_data_response_action(msg,term){
	
	var evidence_html = '<img src="\/images\/el_logo.gif" \/><br \/>' +msg.data.length + ' records in Explorers Log<br \/>';
	var number_clips = 0;
	var number_stills = 0;
	var visual_observations = 0;
	var exemplar_still_rating = 10;
	var exemplar_still_uuid = 0;
	for(i=0;i<msg.data.length;i++){
		if(msg.data[i][81]=="MovingImage")number_clips = number_clips + 1;//81 is media_type, 82 is media_subtype, 18 is duration
		else if(msg.data[i][81]=="StillImage"){
			number_stills = number_stills + 1;
			if(msg.data[i][74]<=exemplar_still_rating&&msg.data[i][74]>0) {
				exemplar_still_rating = msg.data[i][74];
				exemplar_still_uuid = msg.data[i][99];
				}//end if
			}//end else if
		if(msg.data[i][79]=="Visual Observation")visual_observations = visual_observations + 1;
		}//end for
	
	evidence_html = evidence_html + number_clips + " Video Clips<br \/>" + number_stills + " Still Images<br \/>" + visual_observations + ' Visual Observations';
	if(exemplar_still_uuid!="") evidence_html = evidence_html +'<br \/><img src="http://www.explorers-log.com/'+exemplar_still_uuid+'" \/>';
	document.getElementById("el_results_layer").innerHTML = evidence_html;
	
	
}

