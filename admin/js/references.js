$().ready(function() {
	//add an onclick to the authorship radio button to disable/enable the author(s) form field	
	$("#new_name_is_authorship_identical_0").click(function () {
		$("#new_name_authors").attr("disabled", false); 
	});
	$("#new_name_is_authorship_identical_1").click(function () {
		$("#new_name_authors").attr("disabled", true); 
	
	});
	
	
	//add an onclick to the new registration button to launch new name form
	$("#btn_start_new_name_registration").click(function () { 
		$('input[id=btn_show_new_name_form_species]').click();
		$( '#nomenclatural_acts_layer' ).slideDown();
		//$( '#taxonName' ).show();
		$( '#btn_start_new_name_registration' ).hide();
		$( '.registerAnother').hide();
	});
	
	//add an onclick to the new registration button to launch new name form
	$("#cancel_registration").click(function () { 
		$( '#nomenclatural_acts_layer' ).slideUp();
		//$( '#taxonName' ).hide();
		$( '#btn_start_new_name_registration' ).show();
		$( '.registerAnother').show();
		$( '#form_part_new_name').hide();
	});
	
	//add an onchange event to the rank_id select button to decide whether to show the parent form field
	$("#rank_id").change(function () { 
		//clear the selected_parent layer in case it was already populated
		document.getElementById("selected_parent").innerHTML = "";
		document.getElementById("new_name_parent_confirmation_layer").innerHTML = "";
		if($("#rank_id").val()!=50&&$("#rank_id").val()!=60) {
			$( '#new_name_parent_layer' ).show();//display parent for Family or Genus
			var rankgroup = 'Genus';
			if($("#rank_id").val()>70) rankgroup='Species';
			if ($("#rank_id").val()<60) rankgroup='Family';
			get_pub_acts(document.getElementById("pub_id").value,1,'new_act_current_names_in_pub',rankgroup);
			$( '#form_part_new_name').slideUp();
			}
		else {
			//$( '#new_name_parent_layer' ).hide();
			$( '#form_part_new_name').slideDown();
			} //end else
	});
	
	
	
	//add an onchange event to the btn_register_name button to submit the new name
	$("#btn_register_name").click(function () { 
	
		//disable the button
		$("#btn_register_name").attr("disabled", true); 
		//change the button text to working
		document.getElementById("btn_register_name").innerHTML = "working...";
		//create a visual cue to show that something is happening
		$('#btn_register_name').after('<img src="/images/autocomplete-loading.gif" alt="working..." />');
			
		var insert_acts = submit_new_name({
				data: {
				ReferenceUUID : $("#pub_id").val(),
				new_rank_id : $("#rank_id").val(),
				new_name_spelling : $("#new_name_spelling").val(),
				new_name_pages : $("#new_name_pages").val(),
				new_name_type_genus : '',
				new_name_authors : $("#new_name_authors").val(),
				is_fossil : '',
				LogUserName : LogUserName,
				establish_protonym : 1,
				assign_zb_lsid : 1,
				ProtonymUUID : $("#ProtonymUUID").val(),
				new_name_figures : $("#new_name_figures").val(),
				ParentUsageUUID: $("#ParentUsageUUID").val(),
				registration_type: "new_protonym"
			}
		});
	});
	
	$("#btn_show_new_name_form_family").click(function () { 
     	//get_pub_acts(document.getElementById("pub_id").value,1,'new_act_current_names_in_pub','Family');		
		$("#new_name").dialog('option','title','New Family-Group Name');
		document.getElementById("new_name_instruction_layer").innerHTML = 'Enter the details for a new Family-Group name established in this published work.';
		//clear the parent name radio layer in case it is present from a species lookup
		document.getElementById("new_act_current_names_in_pub").innerHTML='';
		document.getElementById("selected_parent").innerHTML='';
		document.getElementById("new_name_parent_confirmation_layer").innerHTML='';
		//show the main form (hidden for species
		$("#new_nomenclatural_act_main_form_layer").show();
		//set the tool tip help verbiage to be family specific
		set_tip("image_help_taxon_type","","Enter the Type Genus for this Family-Group name.");
		set_tip("image_help_taxon_authors","","Enter the Authorship for this Family-Group name, if different from the Authorship of the Published Work.");
		set_tip("image_help_taxon_spelling","","Enter the Family-Group name <em>exactly<\/em> as it appears in this<br \/>Published Work, including any diacritics (if any).");
		//get the values for the select list
		build_taxon_select_list("rank_id","Family");			
		$("#new_name_parent_layer").hide();
		//hide the illustration'/figures layer
		$("#new_name_figures_layer").hide();
		document.getElementById("new_name_type_label").innerHTML = 'Type Genus';
		//$( '#new_name' ).dialog( 'open' );
		$( '#form_part_new_name').slideDown();
		
    });
	$("#btn_show_new_name_form_genus").click(function () { 
     	//get_pub_acts(document.getElementById("pub_id").value,1,'new_act_current_names_in_pub','Genus');
		$("#new_name").dialog('option','title','New Genus-Group Name');
		//clear the parent name radio layer in case it is present from a species lookup
		document.getElementById("new_act_current_names_in_pub").innerHTML='';
		document.getElementById("selected_parent").innerHTML='';
		document.getElementById("new_name_parent_confirmation_layer").innerHTML='';
		//show the main form (hidden for species
		$("#new_nomenclatural_act_main_form_layer").show();
		document.getElementById("new_name_instruction_layer").innerHTML = 'Enter the details for a new Genus-Group name established in this published work.';		
		//get the values for the select list
		build_taxon_select_list("rank_id","Genus");
		$("#new_name_parent_layer").hide();		
		//set the tool tip help verbiage to be genus specific
		set_tip("image_help_taxon_type","","Enter the Type Species for this Genus-Group name.");
		set_tip("image_help_taxon_authors","","Enter the Authorship for this Genus-Group name, if different from the Authorship of the Published Work.");
		set_tip("image_help_taxon_spelling","","Enter the Genus-Group name <em>exactly<\/em> as it appears in this<br \/>Published Work, including any diacritics (if any).");
		//hide the illustration'/figures layer
		$("#new_name_figures_layer").hide();
		document.getElementById("new_name_type_label").innerHTML = 'Type Species';
		//$( '#new_name' ).dialog( 'open' );
		$( '#form_part_new_name').slideDown();
		
    });
	$("#btn_show_new_name_form_species").click(function () { 
		$("#new_name").dialog('option','title','New Species-Group Name');
		document.getElementById("new_name_instruction_layer").innerHTML = 'Enter the details for a new Species-Group name established in this published work. Begin by indicating the genus with which this new species epithet was combined in this Published Work.';		
     	get_pub_acts(document.getElementById("pub_id").value,1,'new_act_current_names_in_pub','Genus');
		//get the values for the select list
		build_taxon_select_list("rank_id","Species");
		//set the tool tip help verbiage to be species specific
		set_tip("image_help_taxon_type","","Enter the Type Species for this Genus-Group name.");
		set_tip("image_help_taxon_authors","","Enter the Authorship for this Genus-Group name, if different from the Authorship of the Published Work.");
		set_tip("image_help_taxon_spelling","","Enter the Species Epithet <em>exactly<\/em> as it appears in this Published Work, including any diacritics (if any).");
		//show the illustration'/figures layer
		$("#new_name_figures_layer").show();
		//show the parent search if it was hidden
		$("#new_act_current_names_in_pub").show();
		$("#new_name_parent_layer").show();
		$("#new_name_parent_label").show();
		$("#new_name_parent_search_layer").show();
		//clear the selected parent if showing
		document.getElementById("selected_parent").innerHTML='';
		//hide the parent confirmation if it is showing
		document.getElementById("new_name_parent_confirmation_layer").innerHTML='';
		//hide the main part of the new name form if it is showing
		//$("#new_nomenclatural_act_main_form_layer").hide();
		document.getElementById("new_name_type_label").innerHTML = 'Type Specimen(s)';
		//open the new name modal dialog
		//$( '#new_name' ).dialog( 'open' );
		$( '#form_part_new_name').slideUp();
    });
		
	$( "#new_parent_name_layer" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		width:900,
		modal: true});
	
});

function protonym_lookup_autocomplete_action(ui) {
	if(ui.item.id==0){
		document.getElementById("btn_register_parent").innerHTML = "Create Parent Name";
		$("parent_search_string").val('');
		document.getElementById("ProtonymUUID").value=ui.item.protonymuuid;
		document.getElementById("new_name_spelling").value=ui.item.namestring;
		if(ui.item.rankgroup=="Genus"){
			var searched_value = document.getElementById("parent_search_string").value;	
			//make sure the first character is UpperCase
			var new_value = "";
			for(i=0;i<searched_value.length;i++){
				if(i==0) new_value = searched_value[i].toUpperCase();
				else new_value = new_value + searched_value[i].toLowerCase();
				}//end for
			document.getElementById("new_parent_original_spelling").value = new_value;	
			document.getElementById("new_parent_current_spelling").value = new_value;	
			document.getElementById("new_parent_name_display_layer").innerHTML = new_value;
			$( '#new_parent_name_layer' ).dialog( 'open' );
			//$("#btn_show_new_name_form_genus").checked();
				//alert("here");
				//$('input[id=btn_show_new_name_form_genus]').click();
			}//end if genus
			
			//add a click function to the action button on the new parent name form
			
			
			
			$("#btn_register_parent").click(function () { 
				
				//change the text
				document.getElementById("btn_register_parent").innerHTML = "working...";
				
				//add a visual cue
				$("#btn_register_parent").after('<img src="/images/autocomplete-loading.gif" alt="working..." />');
				
				
				//make sure the required fields are filled in
				
				//send the data to a service to register the protonym in the selected publication
				var new_parent_registration = submit_new_name({
				data: {
					ReferenceUUID : "",//$("#original_reference_uuid").val(),
					new_rank_id : 60,
					new_name_spelling : $("#new_parent_original_spelling").val(),
					new_name_pages : $("#parent_article_page").val(),
					new_name_type_genus : $("#parent_type_species").val(),//
					new_name_authors : $("#parent_authors").val(),//""
					is_fossil : '',
					LogUserName : LogUserName,
					establish_protonym : 1,
					assign_zb_lsid : 1,
					ProtonymUUID : "",
					new_name_figures : "",
					ParentUsageUUID: "",
					registration_type: "new_parent"
					}
				});
								
			});
			
			
		}//end if id = 0
	else {
		document.getElementById("ParentUsageUUID").value=ui.item.tnuuuid;
		document.getElementById("ProtonymUUID").value=ui.item.protonymuuid;
		document.getElementById("parent_taxonrankid").value=ui.item.taxonnamerankid;
		var result_content = ui.item.value;
		document.getElementById("selected_parent").innerHTML = result_content;
		document.getElementById("parent_name").value=ui.item.namestring;
		confirm_species_parent(1,ui.item.rankgroup);
		//clear the autocomplete and then hide it
		document.getElementById("parent_search_string").value='';
		$("#new_name_parent_search_layer").hide();
	}
}

function confirm_species_parent(register,rankgroup,taxonnamerankid){
	//make sure the layer is dsiplayed
	$("#new_name_parent_confirmation_layer").show();
	var current_target_rank_level = $('#rank_id option:selected').text();
	var display_html = 'Please confirm that the '+current_target_rank_level+' name you are about to register<br \/> was combined with the '+rankgroup+' name ' + document.getElementById("selected_parent").innerHTML + ' in this Published Work.';
	display_html = display_html + '<br \/><button type="button" id="btn_new_name_confirm_parent" class="primaryAction">Confirm Parent '+rankgroup+'<\/button><span id="btn_cancel_parent">cancel</span>';
	document.getElementById("new_name_parent_confirmation_layer").innerHTML = display_html;
	//add an onclick to the cancel btn
	
	$("#btn_cancel_parent").click(function () { 
		document.getElementById("new_act_current_names_in_pub").innerHTML="";
		document.getElementById("new_name_parent_confirmation_layer").innerHTML="";	
		document.getElementById("selected_parent").innerHTML="";			
		$("#new_name_parent_search_layer").show();
		//click the current button that was clicked to reload the taxon acts
		$('input[id=btn_show_new_name_form_species]').click();
	});
		
	$("#btn_new_name_confirm_parent").button();
	//add the onclick action to this new confirmation button
	$("#btn_new_name_confirm_parent").click(function () { 
		//register the parent taxon name usage, ONLY IF coming from Autocomplete, NOT the RADIO butyton.
		if(register==1){//		DO NOT execute sp_EstablishProtonym or sp_AssignZooBankLSID at this time.
			var IsFossil;
			if(document.getElementById("is_fossil").checked) IsFossil = 1;
			else IsFossil = 0;
			//display the rest of the form
			$("#new_nomenclatural_act_main_form_layer").show();
			//submit the form 			
			var insert_acts = submit_new_name({
				data: {
				ReferenceUUID : $("#pub_id").val(),
				new_rank_id : 60,
				new_name_spelling : $("#parent_name").val(),
				new_name_pages : '',
				new_name_type_genus : '',
				new_name_authors : '',
				is_fossil : '',
				LogUserName : LogUserName,
				establish_protonym : 0,
				assign_zb_lsid : 0,
				TaxonRankID :  $("#parent_taxonrankid").val(),
				ProtonymUUID : $("#ProtonymUUID").val(),
				new_name_figures : '',
				ParentUsageUUID: $("#ParentUsageUUID").val(),
				registration_type:"new_tnu"
				}
			});
			//submit_new_name(document.getElementById("pub_id").value,60,document.getElementById("parent_name").value,document.getElementById("new_name_pages").value,document.getElementById("new_name_type_genus").value,document.getElementById("new_name_authors").value,IsFossil,LogUserName,0,0,document.getElementById("ParentUsageUUID").value,document.getElementById("new_name_figures").value,'');
			document.getElementById("new_name_parent_confirmation_layer").innerHTML = 'Registration of ' + document.getElementById("selected_parent").innerHTML + ' Completed';
			}// end if
		else {//hide the confirmation sections and show the rest of the new name form
			//clear the confirm layer content
			document.getElementById("new_name_confirm_layer").innerHTML = '';
			$("#new_name_parent_confirmation_layer").hide();
			$("#new_act_current_names_in_pub").hide();
			//show the Save Record button
			$("#btn_new_name_form").show();
			$("#new_nomenclatural_act_main_form_layer").show();
			}//end else
		$( '#form_part_new_name').slideDown();
		//clear the ProtonymUUID field
		document.getElementById("ProtonymUUID").value="";
		
	});
	
}

function get_pub_acts_response_action(results,include_radio_btns,layer_name,RankGroup){
	var acts_html;
	var num_lsid = 1;//number of records that have LSIDs
	if(include_radio_btns>0) {
		acts_html = 'Select a '+RankGroup+'<br \/><ol>';
			//$("#new_name_parent_label").hide();
		} //end if
	else {
		acts_html = '<table class="name_usage_table" border="0"><tr><th class="current_acts_header">Nomenclatural Acts<\/th><th class="current_acts_header">Other Taxon-Name Usages<\/th><\/tr>';
		var nomenclatural_html = '';
		var other_taxon_usage_html = '';
		var current_nomenclatural_act_header = '';
		var current_other_taxon_usage_header = '';
	}
	if(results.length==1&&results[0].id==0) acts_html = "No registered "+RankGroup+" names for this publication";
	else {
		for(i=0;i<results.length;i++){
			name_string = results[i].namestring;
			if(include_radio_btns>0){
				//alert(layer_name);
				acts_html =  acts_html + '<li><label for="current_genus_'+i+'" class="ParentUsageUUID_btn"><input type="radio" name="current_genus" onclick="document.getElementById(&quot;ParentUsageUUID&quot;).value=&quot;'+results[i].tnuuuid+'&quot;;$(&quot;#new_name_parent_search_layer&quot;).hide();document.getElementById(&quot;selected_parent&quot;).innerHTML=&quot;'+name_string+'&quot;;confirm_species_parent(0,&quot;'+RankGroup+'&quot;);" id="current_genus_'+i+'" value="'+results[i].tnuuuid+'" /> '
				acts_html =  acts_html + name_string + "<\/label><\/li>";
				}
			else {	//acts_html =  acts_html + results[i][7] + ": " + name_string + "<br\/>";
				//if this isOriginal populate that column
				if(results[i][4]==1) {
					//check to see if there should be a new header
					if(current_nomenclatural_act_header!=results[i][8]) {
						current_nomenclatural_act_header = results[i][8];
						nomenclatural_html = nomenclatural_html + '<span class="section_header">'+ current_nomenclatural_act_header + '<\/span><\/br>';
						}
					if(results[i][1]!="") {
						row_class='';//row_class = 'regular_row';
						//if(num_lsid%2==0) row_class = 'alt_row';
						
						num_lsid = num_lsid+1;
						}
					
					nomenclatural_html = nomenclatural_html + '<span class="'+row_class+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + results[i][10];
					if(results[i][7]!=current_nomenclatural_act_header) nomenclatural_html = nomenclatural_html + ' [' + results[i][7] + ']';	
					if(results[i][1]!="") {
						hide_layer_html = ' [<a href="javascript:clear_layer(&quot;lsid_layer_'+i+'&quot;);">hide<\/a>]';
						nomenclatural_html = nomenclatural_html + '<img src="/images/lsid-token.gif" style="float:right;" width="30" onclick="show_text(&quot;lsid_display_layer&quot;,&quot;' + results[i][10] + '<br\/>' + results[i][1] + '&quot;);" alt="LSID:' + results[i][1] + '" /><span id="lsid_layer_'+i+'"><\/span>';
						
						}
					nomenclatural_html = nomenclatural_html + '<\/span><\/br>';
					}//end if  //<a href=javascript:clear_layer(&quot;lsid_layer_'+i+'&quot;);>hide<\/a>
					
				else {//other Taxon Name Usage
					if(current_other_taxon_usage_header!=results[i][8]) {
						current_other_taxon_usage_header = results[i][8];
						other_taxon_usage_html = other_taxon_usage_html + '<span class="section_header">'+ current_other_taxon_usage_header + '<\/span><\/br>';
						}
					other_taxon_usage_html = other_taxon_usage_html +  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + results[i][10];
					if(results[i][7]!=current_other_taxon_usage_header) other_taxon_usage_html = other_taxon_usage_html + ' [' + results[i][7] + ']';	
					other_taxon_usage_html = other_taxon_usage_html + '<br \/>';
					}//end else
			}//end else (not radio button or form based
			//
		}//end for
		}//end else
	if(include_radio_btns>0) acts_html =  acts_html + '<\/ol>';
	else acts_html =  acts_html + '<tr><td valign="top" width="50%" style="background-color:#EBEBFF;color:#800000;">'+nomenclatural_html+'<br\/><div class="lsid_display_layer_style" id="lsid_display_layer" style="display:none;"><\/div><\/td><td valign="top" style="background-color:#C5DBEC;color:#000000;">'+other_taxon_usage_html+'<\/tr><\/table>';
		
	
	document.getElementById(layer_name).innerHTML = acts_html;
	
	//add an onclick event to the new radio buttons to hide the parent_search text box when a radio button is selected
	 $('input.ParentUsageUUID_btn').click( function( event )
	  {
		$("#new_name_parent_search_layer").hide();
	  })
	
	
	//$( '#accordion' ).accordion( "activate" , 2 );
	//display the current nomenclatural acts layers
	$("#"+layer_name).show();
	$("#nomenclatural_acts_layer").show();	

}//end function get_pub_acts_response_action

function submit_new_name_response_action(results,new_name_spelling,establish_protonym,assign_zb_lsid,registration_type) {
	var new_name_results = JSON.parse(results);
	//alert(new_name_results.uuid);
	document.getElementById("ParentUsageUUID").value = new_name_results.uuid;
	//call the get nomenclatural acts for the reference - refid, use radio buttons, target layer
	
	document.getElementById("new_act_current_names_in_pub").innerHTML = '';
	//get_pub_acts(document.getElementById("pub_id").value,0,'current_acts_layer');
	var review_html = '<\/br><\/br><span class="completed_question_label">';
	//update the review layer
	//alert(registration_type);
	if(establish_protonym==1) {
		review_html = review_html + 'Created Protonym';
		//refresh the page
		//window.location.reload();
		document.getElementById("ParentUsageUUID").value = new_name_results.uuid;
		if(registration_type=="new_parent"){
			//record the tnu
			var new_parent_registration = submit_new_name({
				data: {
					ReferenceUUID : $("#pub_id").val(),
					new_rank_id : 60,
					new_name_spelling : $("#new_parent_current_spelling").val(),
					new_name_pages : "",
					new_name_type_genus : "",
					new_name_authors : "",
					is_fossil : "",
					LogUserName : LogUserName,
					establish_protonym : 0,
					assign_zb_lsid : 0,
					ProtonymUUID : document.getElementById("ParentUsageUUID").value,
					new_name_figures : "",
					ParentUsageUUID: "",
					registration_type: "new_tnu"
					}
				});
			//close the modal dialog
			$( '#new_parent_name_layer' ).dialog( 'close' );
			//refresh the taxon acts
			get_pub_acts(document.getElementById("pub_id").value,1,'new_act_current_names_in_pub','Genus');
				
		
		}//end if
		else if (registration_type == "new_tnu") {
			//alert(registration_type);
			//append an new TNU to the actsResults layer
			$("#tnuResults ol li:last").after('<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="\/NomenclaturalActs\/'+new_name_results.uuid+'"><em>'+new_name_spelling+'<\/em> '+new_name_results.authors+' '+new_name_results.year+'<\/a><\/li>');
			//update the count for tnus (taxon_name_count)
			document.getElementById("taxon_name_count").innerHTML = parseInt(document.getElementById("taxon_name_count").innerHTML) + 1;
			} //end else if
		
		else if (registration_type == "new_protonym") {
			//append an new TNU to the actsResults layer
			$("#actsResults ol li:last").after('<li><span class="lsidButton"><\/span>&nbsp;<a href="\/NomenclaturalActs\/'+new_name_results.uuid+'">'+new_name_results.name_clean_display+'<\/a><\/li>');
			//update the count for nomenclatural acts (nomenclatural_acts_count)
			document.getElementById("nomenclatural_acts_count").innerHTML = parseInt(document.getElementById("nomenclatural_acts_count").innerHTML) + 1;
			//return the form to a new state
			$('span[id=cancel_registration]').click();
			$("#registerAnother").show();
			} //end else if
		
		
		
		
		}
	else {
		if (registration_type == "new_tnu") {
			//alert(registration_type);
			//append an new TNU to the actsResults layer
			$("#tnuResults ol li:last").after('<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="\/NomenclaturalActs\/'+new_name_results.uuid+'">'+new_name_results.name_clean_display+'<\/a><\/li>');
			//update the count for tnus (taxon_name_count)
			document.getElementById("taxon_name_count").innerHTML = parseInt(document.getElementById("taxon_name_count").innerHTML) + 1;
			//return the form to a new state
			//$('span[id=cancel_registration]').click();
			$("#nomenclatural_acts_layer").show();
			} //end else if
		
		review_html = review_html + 'Recorded Taxon Name Usage';
		//set the parent id to be the new taxon name usage of the parent
		document.getElementById("ParentUsageUUID").value = new_name_results.uuid;
		}
	if(assign_zb_lsid==1) review_html = review_html + ' and Registered';
	
	
	review_html = review_html + ': <\/span><span class="completed_question_result_text">'+ new_name_spelling + '<\/span>';
	//show_text("review_layer",review_html,1,0);
}

function article_lookup_autocomplete_action(ui){
	document.getElementById("original_reference_uuid").value=ui.item.referenceuuid;


}


