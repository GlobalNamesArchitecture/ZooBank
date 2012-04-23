	
	var selected_authors_array = [];	
	var selected_authors_name_array = [];
	var selected_pub_pkid = '';
	
	$().ready(function() {
	
	
});

function add_author_to_list(PKID,author_name,zblsid){
	//clear the add_author_result layer in case it was populated
	document.getElementById("add_author_result").innerHTML='';
	if($.inArray(PKID, selected_authors_array)<0){
		selected_authors_array.push(PKID);
		selected_authors_list = selected_authors_array.toString();
		selected_authors_name_array.push(author_name);
		//add the author to the UL
		var new_author_html = "<li class='ui-state-default' style='background:#CFE8E5;height:15px;' id='"+PKID+"~"+author_name+"'><span class='ui-icon ui-icon-arrowthick-2-n-s' onmouseover='Tip(&quot;Click and Drag this Author to another sequence&quot;,BGCOLOR,&quot;#9CD9F7&quot;,TITLE,&quot;&quot;,BGCOLOR,&quot;#9CD9F7&quot;)' onmouseout='UnTip();'>A&nbsp;<\/span>&nbsp;&nbsp;&nbsp;<span id='img_remove_author_"+PKID+"'>&nbsp;&nbsp;<img src='/images/close_icon.gif' onmouseover='Tip(&quot;Delete this Author from the list.	&quot;,BGCOLOR,&quot;#9CD9F7&quot;,TITLE,&quot;&quot;,BGCOLOR,&quot;#9CD9F7&quot;)' onmouseout='UnTip();' alt='Remove this Author' \/><\/span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id='author_name_layer_"+PKID+"' style='width:450px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+author_name+" ";
		if(zblsid==''||zblsid==undefined) new_author_html = new_author_html + ' [not registered]';
		else new_author_html = new_author_html + ' <img src="\/images\/lsidlogo.jpg" \/>';
		new_author_html = new_author_html + ' <\/span><\/li>';
		$("#selected_author_list").append(new_author_html);
		//<a class='cellxsm' onclick='show_pubs(&quot;"+selected_authors_list+"&quot;,&quot;" + author_name + "&quot;,&quot;pub_layer&quot;);$( &quot;#pub_layer&quot; ).dialog( &quot;open&quot; ,0);'>Show Pubs<\/a>
		//add an onclick to the author_name layer to launch edit and show pubs
		$("#author_name_layer_"+PKID).click(function () { 
			get_aliases(PKID,'alias_layer');
			$( '#select_author' ).dialog( 'open' );
			show_pubs(PKID,document.getElementById("display_name").value,"author_pub_layer",1);
			});
		//add an onclick to the delete icon image
		$("#img_remove_author_"+PKID).click(function () { 
			$(this).parent().fadeOut().remove();
			remove_author("+PKID+");
			UnTip();
			});
		
		document.getElementById("author_search_string").value='';
			
		//selected_authors_array = $('#a_sortable').sortable('toArray');
		
		}//end if
	else alert(author_name + " Already Selected");
	
	var joint_pub_header_html = 'Matching Published Works&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id="btn_pub_not_in_list" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"><span class="ui-button-text">Pub Not in List<\/span><\/button>';
	//alert(selected_authors_array.toString());
	if(selected_authors_array.toString()!=""){
		if(selected_authors_array.length>=2&&document.getElementById("reference_citation_preview").innerHTML=="") show_pubs(selected_authors_array.toString(), joint_pub_header_html,'joint_pubs',0);
		}//end if
	window.setTimeout(function() {
    $("#btn_pub_not_in_list").click(function () { 
     	$('#pub_search_form_layer').hide();
		//$( '#accordion' ).accordion( "activate" , 1 );	
		});
		}, 250);//alert('should be displayed');
	
	build_author_citation_preview();
	
	//add the Finished button
	document.getElementById("action_button_layer").innerHTML = '<span style="text-align:center;"><button id="btn_finished_selecting_authors" type="button"><span class="ui-button-text">Finished Selecting Authors<\/span><\/button><\/span>';
	$( "#btn_finished_selecting_authors" ).button();
	//add the onclick instructions
	 $("#btn_finished_selecting_authors").click(function () { 
     	//if(confirm("Have you finished adding all the authors of the Published Work?")){
			$( '#accordion' ).accordion( "deactivate" , 0 );
			$( '#accordion' ).accordion( "activate" , 1 );
			$("#authors_layer").hide();
			$("#authors_layer").removeClass("active_section");
			document.getElementById("author_citation_preview").innerHTML = document.getElementById("author_citation_preview").innerHTML;// + ' <button type="button" id="btn_edit_authors">edit<\/button>';
			$( "button" ).button();
			$("#pub_type_question_layer").addClass("active_section");
			$("#pub_type_question_layer").show();
			$("#pub_search_form_layer").hide();
			//clear any selected publication			
			document.getElementById("reference_citation_preview").innerHTML = "";
			document.getElementById("pub_id").value='';
			//clear any nomenclatural acts
			$("#name_acts_button_layer").hide();
			document.getElementById("current_acts_layer").innerHTML = "";
			//clear the review layer?
			//document.getElementById("review_layer").innerHTML = "";
			
			//$("#publication_type_layer").addClass("active_section");
			$("#publication_layer").show();
			$("#new_pub").show();
			
			$("#btn_edit_authors").click(function () { 
				build_author_citation_preview();
				$("#authors_layer").show();
			});
			
			//}//end if
		});
		
	
	//add the Instruction text
	document.getElementById("selected_author_instruction_layer").innerHTML = '<span class="form_instructions_text">Select all authors of the Published Work and place them in the correct sequence.<\/span><br \/>&nbsp;';
	
	//onclick="$( &quot;#accordion&quot; ).accordion( &quot;activate&quot; , 1 );$(&quot;#pub_search_form_layer&quot;).hide();"
}//end function add_author_to_list

function build_author_citation_preview(author_name){
	var author_citation_content = '';
		
	//turn the sortable list into an array
	var author_sorted_array = $('#selected_author_list').sortable('toArray');
	//loop over the array and build the display
	for(i=0;i<author_sorted_array.length;i++){
			//the id array is in the format author_id~author_name
			id_name_array = author_sorted_array[i].split("~");
			author_citation_content = author_citation_content + id_name_array[1] +';';
			}//end for
	document.getElementById("author_citation_preview").innerHTML = author_citation_content;
	
	var author_search_label_html = '';
	if(author_sorted_array.length>0) {
		author_search_label_html = 'Next Author';
		registration_instruction_text = "";
		$("#registration_instruction_layer").removeClass("form_instructions_text");
		}
	else {
		author_search_label_html = 'First Author';
		registration_instruction_text="To start the registration process, begin by entering the authors of the published work in which the nomenclatural acts appear (you will be prompted later for the authors of new taxon names, if different from the authors of the published work). If the acts appear in a chapter or section of an edited volume, begin by entering the editors of the edited volume (you will be prompted later for the authors of the chapter or section).";
		}
	document.getElementById("author_search_span").innerHTML = author_search_label_html;
	document.getElementById("registration_instruction_layer").innerHTML=registration_instruction_text;
	}//end function build_author_citation_preview



function remove_author(author_id){
	//find the author to be removed in the current array
	var location_of_author = $.inArray(author_id, selected_authors_array);
	//remove the author
	selected_authors_array.splice(location_of_author,1);
	//clear the publications layer
	document.getElementById("pub_layer").innerHTML = '';
	
	//rebuild the joint pubs layer with the new mixtures
	if(selected_authors_array.length>=2&&document.getElementById("reference_citation_preview").innerHTML=="")	show_pubs(selected_authors_array.toString(), 'Joint Pubs','joint_pubs',0);
	//show the preview of how the author citation will look with this combination of authors
	build_author_citation_preview();
	//check to see if this was the last author, if so, clear the elements
	if(selected_authors_array.length==0){
		document.getElementById("action_button_layer").innerHTML = '';
		document.getElementById("selected_author_instruction_layer").innerHTML = '';
		document.getElementById("joint_pubs").innerHTML = '';
		$("#registration_instruction_layer").addClass("form_instructions_text");
		document.getElementById("author_citation_preview").innerHTML = '';
	}
}

//this function may no longe be needed based on how editing will be handled or if we allow a user to edit what they have already entered
function show_search_form(layer_name,field_name,id_field_name,method,current_value){
	//build the search form HTML to be displayed
	var form_content = '<input type="text" onmouseout="reset_search_form(&quot;'+layer_name+'&quot;,&quot;'+field_name+'&quot;,&quot;'+id_field_name+'&quot;,&quot;'+method+'&quot;,&quot;'+current_value+'&quot;);" size="50" name="'+field_name+'" id="'+field_name+'" value="'+current_value+'" />';
	document.getElementById(layer_name).innerHTML = form_content;
	//create the autocomplete for the new search fields
	$( "#"+field_name ).autocomplete({
		source: "/editor/services.cfc?method="+method,
		minLength: 2,
		select: function(event, ui) {document.getElementById(id_field_name).value=ui.item.id;
		//call the function to rebuild the search form
		reset_search_form(layer_name,field_name,id_field_name,method,ui.item.value)
		if(method=='find_author') selected_authors_array.push(ui.item.id);
		}			
	});
	document.getElementById(field_name).focus();
	document.getElementById(field_name).select();
}

//function to display the contents of an autocomplete box if the user cancels editing that value
function reset_search_form(layer_name,field_name,id_field_name,method,current_value){
	var result_content = '<span onclick="show_search_form(&quot;'+layer_name+'&quot;,&quot;'+field_name+'&quot;,&quot;'+id_field_name+'&quot;,&quot;'+method+'&quot;,&quot;'+current_value+'&quot;)";>'+current_value+'<\/span>';
	//alert(method);
	if(method=='find_author') document.getElementById(layer_name).innerHTML = document.getElementById(layer_name).innerHTML + ' ' + current_value;
	else document.getElementById(layer_name).innerHTML = result_content;
}

//function to insert a new author into zoobank
function add_author(no_verify,LinkID){
	//the LinkID is the PKID if there is no alias
	if(document.getElementById("pkid").value!="") LinkID = document.getElementById("pkid").value;
	var result_html = '';
	//call the add author function
	var add_new_author = $.ajax({
	url: "/editor/services.cfc?method=insert_author",
	data: ({GivenName:document.getElementById('GivenName').value,
	FamilyName:document.getElementById('FamilyName').value,
	author_suffix:document.getElementById('author_suffix').value,
	LogUserName:LogUserName,
	LinkID:LinkID,
	no_verify:no_verify}),
	type: "get",
	success: function(msg){
		var results = JSON.parse(msg);//some browsers cannot natively parse the JSON result
		if(results.status=="undefined") document.getElementById('pub_layer').innerHTML = "no results";
		else {
			if(results.message=="success") {
				document.getElementById('add_author_result').innerHTML = "Successfully Added";
				//build on the summary layer
				
				result_html = result_html + 'Added: ' + results.pkid;
				var author_name = results.familyname + ', ' + results.givenname;
				add_author_to_list(results.pkid,author_name,results.lsid);
				//update the summary layer
				review_html = '<\/br><\/br><span class="completed_question_label">Created and Registered Author: <\/span><span class="completed_question_result_text">'+ author_name + '<\/span>';
				show_text("review_layer",review_html,1,0);
								
				$("#new_author").dialog('close');
				document.getElementById('GivenName').value = '';
				document.getElementById('FamilyName').value = '';
				document.getElementById('add_author_result').innerHTML='';
				document.getElementById('btn_author_form').disabled=false;
			//add this author to the selected author layer
				}
			else 
				var author_list = '<table>';
				for(i=1;i<=results.number_matches;i++){
					row_class = 'alt_row';
					if(i%2==0) row_class = 'regular_row';
					author_list = author_list + '<tr class="'+row_class+'"><td>' + eval('results.author'+i+'.familyname') + '<div id="author_pub_layer_'+eval("results.author"+i+".pkid")+'"><\/div><\/td><td><button  class="new_item_button" type="button" onclick="show_pubs('+eval("results.author"+i+".pkid")+',&quot;'+eval("results.author"+i+".familyname")+'&quot;,&quot;author_pub_layer_'+eval("results.author"+i+".pkid")+'&quot;,1);">show pubs<\/button><button class="new_item_button" type="button" onclick="add_author_to_list('+eval("results.author"+i+".pkid")+',&quot;'+eval("results.author"+i+".familyname")+'&quot;,&quot;'+eval("results.author"+i+".lsid")+'&quot;);$( &quot;#new_author&quot; ).dialog( &quot;close&quot; );clear_author_form();">This is the Author<\/button><\/td><\/tr>';
				}
				document.getElementById('add_author_result').innerHTML = "<span class='warning_text'>"+results.message + '.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please confirm that the author you are trying to add is not listed below<\/span><br /><button id="btn_final_add_author">Confirm New Author<\/button><\/br>' + author_list + '<\/table>';
				$("#btn_final_add_author").click(function () { 
					insert_author();
				});				
				$( "button" ).button();
		}//end else
		}
	}
).responseText;			
}
function insert_author(){
	add_author(1);
}

//function to clear all values from the new author form
function clear_author_form(){
	document.getElementById("FamilyName").value = '';
	document.getElementById("GivenName").value = '';
	document.getElementById("display_name").value = '';
	document.getElementById("pkid").value = '';
	document.getElementById("author_pub_layer").innerHTML = '';
	document.getElementById("add_author_result").innerHTML = '';
}

function create_alias_form(pkid){
	$( "#select_author" ).dialog("close");
	//update the title of the modal dialog box
	$("#new_author").dialog('option','title','Enter Alias for '+document.getElementById("GivenName").value + ' ' + document.getElementById("FamilyName").value);
	//update the label with the new action button text
	document.getElementById("btn_author_form_label").innerHTML = 'Create new alias for author';
	document.getElementById("pkid").value = pkid;
	//open the updated
	$( "#new_author" ).dialog("open");
}

function select_publication(pubid,pub_citation,cheatauthors){
	//clear the current author array, if any
	selected_authors_array = [];
	selected_pub_pkid = pubid;
	//clear the current author preview
	document.getElementById("author_citation_preview").innerHTML = '';
	
	//set the new name authors field in the new acts form
	document.getElementById("new_name_authors").value = cheatauthors;
	
	//NOTE: This is only needed when we enable editing...
	
	//add to the summary
	review_html = '<\/br><\/br><span class="completed_question_label">Selected Publication: <\/span><span class="completed_question_result_text">'+ pub_citation + '<\/span>';
	show_text("review_layer",review_html,1,0);
				
	//add all of the selected publication authors to the selected authors list in the authorship section
	get_author_by_pub(pubid);
	
	//add the publication to the publication display layer
	document.getElementById("selected_article").innerHTML = "<span class='completed_question_label'>Published Work: <\/span>" + pub_citation;
	document.getElementById("reference_citation_preview").innerHTML = pub_citation;
	current_pub_citation = pub_citation;
	//set the pub_id value in the pub_form
	document.getElementById("pub_id").value = pubid;
	$( '#accordion' ).accordion( "deactivate" , 1 );
	$( '#accordion' ).accordion( "activate" , 2 );
	//hide the joint pubs layer
	$("#joint_pubs").hide();	
	$("#new_pub").hide();
	$("#pub_type_question_layer").hide();
	$("#pub_search_form_layer").hide();
	
	//reset the new author form
	document.getElementById('btn_author_form').disabled=false;
	document.getElementById('add_author_result').innerHTML='';
	
	//hide the author citation preview and the author layer
	//$("#author_citation_preview").hide();
	$("#authors_layer").hide();
	
	build_author_citation_preview();
	//get and show the current names for this pub
	get_pub_acts(pubid,0,'current_acts_layer');
	//display the taxonomic acts section
	$("#nomenclatural_acts_layer").height(400);
	$("#nomenclatural_acts_layer").show();
	$("#name_acts_button_layer").show();
	//set the nomenclatural_acts_layer to be active
	$("#name_acts_button_layer").addClass("active_section");	
	//$( '#accordion' ).accordion( "activate" , 2 );
	
}//end select_publication function
