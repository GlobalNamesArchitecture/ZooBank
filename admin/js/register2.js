$().ready(function() {
	document.getElementById("citation_parse_lookup_btn").disabled = 0;
	$("#citation_check_form").validate({ 
        submitHandler: function(form) {
   			//disable the Button
			document.getElementById("citation_parse_lookup_btn").disabled = 1;
			//show the processing indicator
			document.getElementById("citation_lookup_status_layer").innerHTML = '<img src="/images/loading_blue.gif" />';
			//call the add author function
			call_freecite(document.getElementById("raw_citation_string").value);
 		},
 		rules: { 
            raw_citation_string: { 
               	required: true
            }}, 
        messages: { 
            raw_citation_string: {
			required: "Please enter a citation to search against."}
			}
	}); 

	$( "button" ).button();
	
	
	
});//end ready function

function call_freecite(citation_string){

	var citation_parse = $.ajax({
	url: "http://freecite.library.brown.edu/citations/create",
	type: "post",dataType: "json",
	data: ({citation :citation_string}),
	success: function(msg){
		
		var results = JSON.parse(msg);//some browsers cannot natively parse the JSON result
		if(results.status=="undefined") document.getElementById('citation_lookup_status_layer').innerHTML = "no results";
		else if(results.data.length>0){
			alert(results.status);
		}
	}
	}
).responseText;			

}//end function

function call_crossref(citation_string){

	var citation_parse = $.ajax({
	dataType: ($.browser.msie) ? "text" : "xml",
    accepts: {
        xml: "text/xml",
        text: "text/xml"
    },

	url: "http://www.crossref.org/openurl",
	type: "post",
	data: ({pid: "whittonr@gmail.com",
	redirect:false,
	title :citation_string}),
	success: function(msg){
		
		var results = JSON.parse(msg);//some browsers cannot natively parse the JSON result
		if(results.status=="undefined") document.getElementById('citation_lookup_status_layer').innerHTML = "no results";
		else if(results.data.length>0){
			alert(results.status);
		}
	}
	}
).responseText;			

}//end function