
$().ready(function() {
	$('.roundedCorner').corner("top");			   
	
	//accordion
	$( "#accordion" ).accordion({ autoHeight: false,clearStyle: true });
	
	//set tooltips
	set_tip("image_help_cancel_button","","Click here to start over");
	set_tip("image_help_author_search","","Enter any part of an author\'s name, with or without diacriticals,<br \/> and select it from the list. If it\'s not in the list, then click the &quot;New Author&quot; button.");
	
	set_tip("image_help_select_author_name","","Ensure this is the correct person, and choose (or create) the author\'s name <em>exactly</em> as it appears in<br \/>the Published Work itself. The selected (or created) name should have the same spelling,<br \/> diacriticals, given names, abbreviated names, and suffix as it appears in the &quot;by-line&quot; area of the Published Work.");
	
	//new author form
	set_tip("image_help_new_author_familyname","","Enter the person\'s family name, <em>exactly</em> as it appears in the Published Work <br \/>(with appropriate diacriticals, punctuation, hyphenation, etc.");
	set_tip("image_help_new_author_givenname","","Enter the person\'s given name(s), <em>exactly</em> as it appears in the Published <br \/>Work (with appropriate diacriticals, punctuation, abbreviations, hyphenation, etc.");
	set_tip("image_help_new_author_suffix","","Enter the person\'s suffix (e.g., \'Jr.\', \'II\', \'III\', etc.), exactly<br \/> as it appears in the Published Work.");
	
	
	set_tip("image_help_pub_search","","Required for article and book section.");
	
	set_tip("image_help_pub_date","","Please enter at least the year of publication.<br \/>If you have the full date, please follow the format mm/dd/yyyy.");
	
	//new periodical form
	set_tip("image_help_periodical_full_title","","Enter the complete title of the periodical, without Series number.");
	set_tip("image_help_periodical_abbr_title","","Enter a standard abbreviation for the title of this periodical, if any.");
	set_tip("image_help_periodical_series","","Enter the Series Name or Number, if any.");
	
	//new taxon form
	set_tip("image_help_taxon_rank","","Select the particular Rank at which the new name is used within the publication itself.");
	set_tip("image_help_taxon_pages","","Enter the Page(s) within this Published Work where the name appears.");
	set_tip("image_help_taxon_type","","Enter the Type Genus for this Family-Group name.");
	set_tip("image_help_taxon_authors","","Enter the Authorship for this Family-Group name, if different from the Authorship of the Published Work.");
	set_tip("image_help_taxon_spelling","","Enter the Family-Group name <em>exactly<\/em> as it appears in this<br \/>Published Work, including any diacritics (if any).");
	set_tip("image_help_taxon_figures","","Enter any Illustrations or Figures within this Published Work that depict this Species.");
	
	
	//new book series form	
	set_tip("image_help_periodical_bookseries_year","","Enter the Year(s) in which this series of books was published. If more than one year,<br \/>enter range of years (e.g., \'1847-1849\'). If stated year(s) of publication is not the actual year of publication,<br \/>then enter the stated year(s) first, followed by the actual year(s) in [brackets] (e.g., \'1847 [1848]\'<br \/>or \'1847-1849 [1847-1850]\'). If not yet published, then leave this empty.");
	set_tip("image_help_bookseries_publisher","","Enter the name of the Publisher of the book series as it<br \/>appears within the Work itself. If more than one Publisher, list each one,<br \/>separated by a semicolon.");	
	set_tip("image_help_bookseries_place_published","","Enter the place of publication, as it appears within the<br \/>Work itself. If more than one Publisher, list each one, separated by a semicolon.");	
	set_tip("image_help_bookseries_edition","","Enter the specific Edition of this Published Work,<br \/>as it appears in the Work itself.");
	set_tip("image_help_bookseries_volumes","","Enter the total number of volumes within this book series.");
	
	//new pub form
	set_tip("image_help_pub_archive","","Enter details of where this electronic Published Work has been archived.");
	set_tip("image_help_pub_title","","Enter the complete title for the Published Work.");
	set_tip("image_help_pub_year","","Enter the Year in which this Work was published. If stated year<br \/>of publication is not the actual year of publication, then enter the stated year first, followed<br \/>by the actual year in [brackets] (e.g., \'1847 [1848]\').");
	set_tip("image_help_pub_volume","","Enter the volume of this Published Work, as it appears in the Work itself.");
	set_tip("image_help_pub_number","","Enter the number of this Published Work, as it appears in the Work itself.");
	set_tip("image_help_pub_pages","","Enter the pagination for this article.");
	
	//set onclick events for form elements
	//add a click event to the add author button to open the dialog window
	 $("#btn_new_author").click(function () { 
     	clear_author_form();
		document.getElementById("btn_author_form_label").innerHTML = "Create New Author";
		$("#new_author").dialog('option','title','Enter new Author');
		$( '#new_author' ).dialog( 'open' );
		//reset the form validation
		$("#author_form").validate().resetForm();
    }); 
	 $("#btn_new_name_form").click(function () { 
     	if($("#form_new_name").validate().form()) {
			display_final_new_name_confirm();
			}
    }); 
	 
	$("#publication_pub_type_electronic").click(function () { 
		select_pub_medium();
	});
	$("#publication_pub_type_durable").click(function () { 
		select_pub_medium();
	});
	$("#pub_type_1").click(function () { //Article in a Journal, Magazine, or other Periodical
		select_pub_type();
	});
	$("#pub_type_2").click(function () { //Book or Monograph
		select_pub_type();
	});
	$("#pub_type_5").click(function () { //Edited Volume with separately-authored Chapters or Sections
		select_pub_type();
	});
	$("#btn_show_new_periodical_form").click(function () { 
     	$( '#create_periodical_layer' ).dialog( 'open' );
    });
	$("#btn_show_new_pub_form").click(function () { 
     	$( '#new_pub' ).dialog( 'open' );
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
		$( '#new_name' ).dialog( 'open' );
		
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
		$( '#new_name' ).dialog( 'open' );
		
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
		$("#new_nomenclatural_act_main_form_layer").hide();
		document.getElementById("new_name_type_label").innerHTML = 'Type Specimen(s)';
		//open the new name modal dialog
		$( '#new_name' ).dialog( 'open' );
    });
	
	$("#btn_cancel").click(function () { 
     	window.location='register.cfm';
		current_rank_group = 'Species';
    });
	
	$("#pub_part_book_series_1").click(function () { //Yes, this book is part of a series
		//show the parent reference search form		
		$( '#pub_parent_id_layer').show();
		//change the text of the action button		
		document.getElementById("btn_show_new_periodical_form_text").innerHTML = "Create New Book Series";
		
		//show the additional fields for a book series vs. a new periodical
		$( '#new_book_series_questions_layer').show();
		//reset the tool tip text to be book series specific
		set_tip("image_help_periodical_full_title","","Enter the complete title for the Book Series.");
		set_tip("image_help_periodical_abbr_title","","If this Book Series is known by a short title, enter it here.");
		
		//change the entry label to "Book Series"
		document.getElementById("parent_pub_question_section").innerHTML = '<span class="entry_label">Book Series</span>';		
		
		//hide the periodical specific fields
		$( '#new_periodical_form_fields').hide();
		//set the action button text to show add new book series
		document.getElementById("btn_create_new_periodical_text").innerHTML = "Create Book Series";
		//set the dialog title to reflect new book series
		$("#create_periodical_layer").dialog('option','title','Enter new Book Series');
		//open the dialog
		//$( '#create_periodical_layer' ).dialog( 'open' );	
		//hide the rest of the new pub form questions, unless the parent has already been set
		$("#create_pub_layer").hide();
	});
	$("#pub_part_book_series_0").click(function () { //No, this book is NOT part of a series
		$( '#pub_parent_id_layer').hide();
		$( '#create_periodical_layer' ).dialog( 'hide' );		
		//show the rest of the new pub form
		$("#create_pub_layer").show();
	});
	
	$("#pub_form_already_published_1").click(function () { //Yes this publication has already been published
		document.getElementById("pub_form_instructions_layer").innerHTML = "Complete all of the required values below, and as many of the optional values as possible.<br\/><br\/>";
		$("#pub_year_input_layer").show();
		document.getElementById("pub_year_explanation_text").innerHTML = "";
		$("#pub_form_instructions_layer").show();	
		$('#pub_already_published_question').removeClass("active_section");
		$('#create_pub_layer').addClass("active_section");
		$("#create_pub_layer").show();
		//show the completed question result and hide the question layer
		document.getElementById("pub_already_published_completed_value").innerHTML = '<span class="completed_question_label">Already Published?<\/span><span class="completed_question_result_text">Yes<\/span>';
		$("#pub_already_published_question").hide();
		//new_pub
	});
	
	$("#pub_form_already_published_0").click(function () { //No, this publication has not yet been published
		document.getElementById("pub_form_instructions_layer").innerHTML = "Enter as much of the following information as possible.<br\/><br\/>";	
		//hide the pub year input field
		$("#pub_year_input_layer").hide();
		//add "N/A" text where the year was
		document.getElementById("pub_year_explanation_text").innerHTML = "N/A";
		
		$("#pub_form_instructions_layer").show();
		$('#pub_already_published_question').removeClass("active_section");
		$('#create_pub_layer').addClass("active_section");
		$("#create_pub_layer").show();
		//show the completed question result and hide the question layer
		$("#pub_already_published_question").hide();
		document.getElementById("pub_already_published_completed_value").innerHTML = '<span class="completed_question_label">Already Published?<\/span><span class="completed_question_result_text">Not Yet Published<\/span>';
	});
	
	
	$("#new_name_is_authorship_identical_1").click(function () { //Yes the author ship of the name identical to the authorship of the Published Work
		document.getElementById("new_name_authors").disabled = 1;
		$("#new_name_authors").addClass("disabled");
		$("#new_name_authorship_input_layer").addClass("disabled");
	});
	
	$("#new_name_is_authorship_identical_0").click(function () { //No, the author ship of the name is difference from the authorship of the Published Work
		document.getElementById("new_name_authors").disabled = 0;
		$("#new_name_authors").removeClass("disabled");
		$("#new_name_authorship_input_layer").removeClass("disabled");
	});
	
	//set the sortable layer for authors
	$( "#selected_author_list" ).sortable({
	   stop: function(event, ui) {build_author_citation_preview()}
	});
	
	//create all dialog boxes
	$( "#new_author" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		width:900,
		modal: true});

	$( "#select_author" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		width:900,
		height:500,
		modal: true});

	$( "#pub_layer" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		height:500,
		width:900,
		modal: true});
	$( "#new_name" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		height:600,
		width:700,
		modal: true});
	$( "#create_periodical_layer" ).dialog({
		autoOpen: false,
		hide: "fadeOut",
		height:500,
		width:700,
		modal: true});
	
	
	
	//set client side validation rules
	$.validator.setDefaults({
		highlight: function(input) {
			$(input).addClass("ui-state-highlight");
		},
		unhighlight: function(input) {
			$(input).removeClass("ui-state-highlight");
		}
	});
	
	$("#form_create_periodical").validate({ 
        submitHandler: function(form) {
			//call submit_publication with the following arguments (ParentReferenceID,ReferenceTypeID,LanguageID,Year,Title,ShortTitle,Series,Volume,Number,Pages,Figures,DatePublished,Authors,LogUserName)
   			submit_publication(0,document.getElementById("new_periodical_ReferenceTypeID").value,'','',document.getElementById("new_periodical_full_title").value,document.getElementById("new_periodical_abbr_title").value,document.getElementById("new_periodical_series").value,'','','','','','',LogUserName);
			//populate the new publication form with the returned parentID
			//document.getElementById("pub_id").value=ui.item.id;
			//close the create periodical dialog window
			$( '#create_periodical_layer' ).dialog( 'close' );
			//show the rest of the form
			$('#new_pub').show();
			$('#create_pub_layer').show();
			
			//remove the active class from this question and apply to the next
			$('#pub_parent_id_layer').removeClass("active_section");
			$('#pub_already_published_question').addClass("active_section");
			
			//hide the question layer and new periodical button
			$('#parent_pub_question_section').hide();
			$('#btn_show_new_periodical_form').hide();
			
			//populate the selected pub layer
			document.getElementById("selected_pub").innerHTML = '<span class="completed_question_label">Published in<\/span><span class="completed_question_result_text completed_section" id="parent_pub_id"> ' + document.getElementById("new_periodical_full_title").value + '<\/span>';
 		},
 		rules: { 
            new_periodical_full_title: { 
               	required: true
            }}, 
        messages: { 
            new_periodical_full_title: {
			required: "Please enter the full title of the periodical."
			}}
	}); 
	
 	$("#author_form").validate({ 
        submitHandler: function(form) {
   			//disable the Button
			document.getElementById("btn_author_form").disabled = 1;
			//show the processing indicator
			document.getElementById("add_author_result").innerHTML = '<img src="/images/loading_blue.gif" />';
			//call the add author function
			add_author(0);
 		},
 		rules: { 
            FamilyName: { 
               	required: true
            },
			GivenName: { 
                required: true
            }}, 
        messages: { 
            FamilyName: {
			required: "Please enter the Author's Family name."},
			GivenName: {
			required: "Please enter the Author's Given Name(s), or at least initials."}
			}
	}); 
	$("#pub_form").validate({ 
		submitHandler: function(form) {
			//call submit_publication with the following arguments (ParentReferenceID,ReferenceTypeID,LanguageID,Year,Title,ShortTitle,Series,Volume,Number,Pages,Figures,DatePublished,Authors,LogUserName)
				
   			submit_publication(document.getElementById("ParentReferenceID").value,document.getElementById("pub_type").value,document.getElementById("LanguageID").value,document.getElementById("pub_year").value,document.getElementById("pub_title").value,document.getElementById("pub_abbr_title").value,document.getElementById("pub_series").value,document.getElementById("pub_volume").value,document.getElementById("pub_number").value,document.getElementById("pub_pages").value,document.getElementById("pub_figures").value,document.getElementById("pub_date").value,selected_authors_array.toString(),LogUserName);
			//the submit_publication function will set the pub_id field with the value of the newly inserted publication
			
			//the submit_publication functio will populate the reference citation
			
			
			//hide all the pub form elements
			$("#new_pub").hide();
			//alert("PubID prior to calling get pub acts: " + document.getElementById("pub_id").value);
			//get the publications acts
			//get_pub_acts(document.getElementById("pub_id").value);
			//alert("PubID after calling get_pub_acts: " + document.getElementById("pub_id").value);
			
			
 		},
		rules: { 
            pub_title: { 
               	required: true
            },
			pub_year: {
				required: true
			},
			pub_type: {
				required: true
			}}, 
        messages: { 
           pub_title: {
			required: "Please enter the publication title."},
			pub_year: {
			required: "Please enter the year of publication in YYYY format."},
			pub_type: {
			required: "Please select the type of publication."}
			}
	});//end validator rules  
	
	 $("#form_new_name").validate({ 
		submitHandler: function(form) {		
			//get the is_fossil value
			var IsFossil;
			if(document.getElementById("is_fossil").checked) IsFossil = 1;
			else IsFossil = 0;
			//display a processing visual aid
			document.getElementById("new_name_confirm_layer").innerHTML = '<br \/><br \/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/loading_blue.gif" />';
			//submit the form - submit_new_name(pub_ReferenceID,new_rank_id,new_name_spelling,new_name_pages,new_name_type_genus,new_name_authors,is_fossil,LogUserName,establish_protonym,assign_zb_lsid,ProtonymID,new_name_figures,ParentUsageID)
			submit_new_name(document.getElementById("pub_id").value,document.getElementById("rank_id").value,document.getElementById("new_name_spelling").value,document.getElementById("new_name_pages").value,document.getElementById("new_name_type_genus").value,document.getElementById("new_name_authors").value,IsFossil,LogUserName,1,1,'','',document.getElementById("parent_id").value);
			//show the Save Record button
			$("#btn_new_name_form").show();
			//clear the confirm layer content
			document.getElementById("new_name_confirm_layer").innerHTML = '';
			new_author_name = document.getElementById("new_name_authors").value;
			//clear the new name form
			$('#form_new_name')[0].reset();
			//reset the new_author_names field
			document.getElementById("new_name_authors").value = new_author_name;
			//clear the parent fields in the form
			document.getElementById("parent_id").value = '';
			document.getElementById("parent_name").value = '';
			//close the modal dialog
			$( "#new_name" ).dialog('close');
 		},
		rules: { 
            rank_id: { 
               	required: true
            },
			new_name_spelling: {
				required: true
			}}, 
        messages: { 
           rank_id: {
			required: "Please enter the epithet rank."},
			new_name_spelling: {
			required: "You Must Enter the Family-Group name <em>exactly</em> as it appeared in this Published Work."
			}}
	});//end validator rules  
	
	//enable button style to all buttons
	$( "button" ).button();
	
	//clear any form values that may be cached by the browser
	$('#pub_form')[0].reset();
	document.getElementById("pub_id").value='';//clear the field in case the browser cached it
	
});//end ready function

//function to display context sensitive fields based on the medium of publication for the publication
function select_pub_medium(){
	if(document.getElementById("publication_pub_type_electronic").checked) {
		display_text = 'Electronic Only Publication';
		$("#pub_form_archive_question_layer").show();
		set_tip("image_help_pub_pages","","Enter the pagination for this article.");
		}
	else {
		display_text = 'Printed on Durable Media';
		$("#pub_form_archive_question_layer").hide();
		set_tip("image_help_pub_pages","","Enter the pagination for this article.  If no page numbers<br \/>are printed within the work itself, enter the sequentially numbered <br \/>pages on which the article appears, in [brackets].");
		}
	document.getElementById("publication_type_display_layer").innerHTML = display_text + " <button id='btn_change_pub_method'>change<\/button>";
	$( "button" ).button();
	//show the display layer
	$("#new_pub").show();
	$("#publication_type_question_layer").hide();
	//hide the question layer
	$("#publication_type_display_layer").show();
	//add an onclick event to the change Button
	$("#btn_change_pub_method").click(function () { //reopen the publication medium question
		$("#publication_type_question_layer").show();
		$("#publication_type_display_layer").hide();	
	});
	$("#publication_layer").show();
}//end function select_pub_medium

//function to display context sensitive fields based on the type of publication
function select_pub_type(){
	var completed_display_text;
	if(document.getElementById("pub_type_1").checked) {//Article in a Journal, Magazine, or other Periodical
		document.getElementById("pub_type").value="1";	
		completed_display_text = 'Article in a Periodical';
		$("#parent_pub_question_section").show();
		$("#pub_parent_id_layer").show();
		$("#pub_book_series_layer").hide();
		$("#create_pub_layer").hide();
		//reset the text of the create new periodical Button
		document.getElementById("btn_show_new_periodical_form_text").innerHTML = "Create New Periodical";
		//reset the action button of the create new periodical form Button
		document.getElementById("btn_show_new_periodical_form_text").innerHTML = "Create New Periodical";
		//reset the text of the dialog box title
		$("#create_periodical_layer").dialog('option','title','Enter new Periodical');
		//reset the tool tips
		set_tip("image_help_periodical_full_title","","Enter the complete title of the periodical, without Series number.");
		set_tip("image_help_periodical_abbr_title","","Enter a standard abbreviation for the title of this periodical, if any.");
		//hide the book series specific questions		
		$("#new_book_series_questions_layer").hide();
		//reset the title and abbr_title text
		document.getElementById("new_periodical_full_title_label").innerHTML = "Full Title of Periodical*";
		document.getElementById("new_periodical_abbr_title_label").innerHTML = "Abbreviated title of periodical";
		//reset the referencetype
		document.getElementById("new_periodical_ReferenceTypeID").value="39";
		//hide the edited volume layer
		$("#edited_volume_instructions_layer").hide();
		}//end if 
	else if(document.getElementById("pub_type_2").checked) {//Book or Monograph
		document.getElementById("pub_type").value="2";	
		completed_display_text = 'Book or Monograph';
		$("#parent_pub_question_section").show();
		$("#pub_parent_id_layer").hide();
		$("#create_pub_layer").hide();
		$("#pub_book_series_layer").show();
		document.getElementById("new_periodical_full_title_label").innerHTML = "*Title";
		document.getElementById("new_periodical_abbr_title_label").innerHTML = "Short Title";
		document.getElementById("new_periodical_ReferenceTypeID").value="26";
		//hide the edited volume layer
		$("#edited_volume_instructions_layer").hide();
		}//end else if
	else if(document.getElementById("pub_type_5").checked) {//Edited Volume with separately-authored Chapters or Sections
			document.getElementById("pub_type").value="5";	
			completed_display_text = 'Edited Volume';
			$("#parent_pub_question_section").show();
			$("#pub_parent_id_layer").hide();
			$("#pub_book_series_layer").hide();
			$("#new_book_series_questions_layer").hide();
			$("#create_pub_layer").hide();
			//set the reference typeid
			document.getElementById("new_periodical_ReferenceTypeID").value="5";		
			//display the edited volume instructions
			display_text = '<div class="form_instructions_text"><span>Confirm that the Author(s) listed above represent the Editors of the entire Volume, not of a particular Chapter or Section within the Edited Volume.<\/span><\/div><br \/><button id="btn_edited_volume_editors_for_all">These are the Editors of the entire Volume<\/button>&nbsp;<button id="btn_edited_volume_editors_for_section_only">These are the Authors of a Chapter or Section within the Edited Volume<\/button>';
			document.getElementById("edited_volume_instructions_layer").innerHTML = display_text;
			//set the onclick values for these buttons
			$("#btn_edited_volume_editors_for_all").click(function () { 
				//make the new pub layer active
				$("#create_pub_layer").addClass("active_section");
				$("#create_pub_layer").show();
				$("#edited_volume_instructions_layer").hide();
				
			});
			$("#btn_edited_volume_editors_for_section_only").click(function () { 
				alert("Before entering the chapters or sections within an Edited Volume, you must first select or enter the Edited Volume itself");
			});
			//enable button style to all buttons
			$( "button" ).button();
			//show the edited volume layer
			$("#edited_volume_instructions_layer").show();
			
			
		}//end else if
	
	document.getElementById("pub_type_display_layer").innerHTML = '<span class="completed_question_label">Publication Type<\/span><span class="completed_question_result_text completed_section">' + completed_display_text + '<\/span><br \/>';
	$("#pub_type_question_layer").hide();
	//make this section no longer active
	$("#publication_layer").removeClass("active_section");
	//make the next section the active section
	$("#pub_parent_id_layer").addClass("active_section");	
	
	
}//end function select_pub_types

function author_lookup_autocomplete_action(ui){
	if(ui.item.id==0) {
		document.getElementById("FamilyName").value = ui.item.term;
		document.getElementById("GivenName").value = '';
		$( '#new_author' ).dialog( 'open' );
		document.getElementById("author_search_string").value='';
		}
	else{
	document.getElementById("author_id").value=ui.item.agentnameid;
	add_author_to_list(ui.item.agentnameid,ui.item.label);
	document.getElementById("FamilyName").value = ui.item.familyname;
	document.getElementById("GivenName").value = ui.item.givenname;
	document.getElementById("display_name").value = ui.item.familyname + ', '+ui.item.givenname;
	document.getElementById("pkid").value = ui.item.agentnameid;
	//get_aliases(ui.item.agentid,'alias_layer');
	//$( '#select_author' ).dialog( 'open' );
	show_pubs(ui.item.agentid,document.getElementById("display_name").value,"author_pub_layer",1);
	
	}

}//end author_lookup_autocomplete_action

function journal_lookup_autocomplete_action(ui){
	document.getElementById("ParentReferenceID").value=ui.item.id;
	if(ui.item.id==0){
		$( '#create_periodical_layer' ).dialog( 'open' );
		}
	else {
		//var result_content = '<span id="parent_pub_id">'+ui.item.value+'<\/span>';
		document.getElementById("selected_pub").innerHTML = '<span class="completed_question_label">Published in<\/span><span class="completed_question_result_text" id="parent_pub_id"> ' + ui.item.value + '<\/span>';
		//add the onclick element to the new layer to allow for editing
		$("#parent_pub_id").click(function () { 
			show_search_form("selected_pub","pub_search_string","pub_id","find_journal",ui.item.value);
		});
		
		$("#btn_show_new_periodical_form").hide();
		$("#pub_parent_id_layer").hide();
		//make the new_pub layer active
		$("#pub_already_published_question").addClass("active_section");
		$("#pub_parent_id_layer").removeClass("active_section");
		
		
		$("#pub_already_published_question").addClass("active_section");
		$("#pub_already_published_question").show();
		
	}//end else
}

function language_lookup_autocomplete_action(ui){

	document.getElementById("LanguageID").value=ui.item.id;
	var result_content = ui.item.value;
	document.getElementById("selected_language").innerHTML = result_content;
	//hide the search field
	$("#pub_language_input_field").hide();
	//add an onclick to the selected language display layer to make it editable again
	$("#selected_language").click(function () { 
		$("#pub_language_input_field").show();
	});
	//put focus on the field
	document.getElementById("language_search_string").focus();
	//add an on mouseout to revert back
}

function rank_lookup_autocomplete_action(ui) {
	document.getElementById("rank_id").value=ui.item.id;
	var result_content = ui.item.value;
	document.getElementById("selected_rank").innerHTML = result_content;
}

function protonym_lookup_autocomplete_action(ui) {
	document.getElementById("parent_id").value=ui.item.id;
	var result_content = ui.item.value;
	document.getElementById("selected_parent").innerHTML = result_content;
	document.getElementById("parent_name").value=ui.item.namestring;
	confirm_species_parent(1);
	//clear the autocomplete and then hide it
	document.getElementById("parent_search_string").value='';
	$("#new_name_parent_search_layer").hide();
}

function get_pub_acts_response_action(results,include_radio_btns,layer_name,RankGroup){
	var acts_html;
	var num_lsid = 1;//number of records that have LSIDs
	if(include_radio_btns>0) {
		acts_html = '<label class="entry_label">Parent Genus<\/label>';
		$("#new_name_parent_label").hide();
		} //end if
	else {
		acts_html = '<table class="name_usage_table" border="0"><tr><th class="current_acts_header">Nomenclatural Acts<\/th><th class="current_acts_header">Other Taxon-Name Usages<\/th><\/tr>';
		var nomenclatural_html = '';
		var other_taxon_usage_html = '';
		var current_nomenclatural_act_header = '';
		var current_other_taxon_usage_header = '';
	}
	
	if(results.data.length==1&&results.data[0][0]==0) acts_html = "No registered names for this publication";
	else {
		for(i=0;i<results.data.length;i++){
			if(results.data[i][6]>60) name_string = results.data[i][10];
			else name_string = results.data[i][10];
			if(include_radio_btns>0){
				acts_html =  acts_html + '<input type="radio" name="current_genus" onclick="document.getElementById(&quot;parent_id&quot;).value='+results.data[i][0]+';$(&quot;#new_name_parent_search_layer&quot;).hide();document.getElementById(&quot;selected_parent&quot;).innerHTML=&quot;'+results.data[i][10]+'&quot;;confirm_species_parent(0);" id="current_genus_'+i+'" value="'+results.data[i][0]+'" /> '
				acts_html =  acts_html + name_string + "<br\/>";
				}
			else {	//acts_html =  acts_html + results.data[i][7] + ": " + name_string + "<br\/>";
				//if this isOriginal populate that column
				if(results.data[i][4]==1) {
					//check to see if there should be a new header
					if(current_nomenclatural_act_header!=results.data[i][8]) {
						current_nomenclatural_act_header = results.data[i][8];
						nomenclatural_html = nomenclatural_html + '<span class="section_header">'+ current_nomenclatural_act_header + '<\/span><\/br>';
						}
					if(results.data[i][1]!="") {
						row_class='';//row_class = 'regular_row';
						//if(num_lsid%2==0) row_class = 'alt_row';
						
						num_lsid = num_lsid+1;
						}
					
					nomenclatural_html = nomenclatural_html + '<span class="'+row_class+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + results.data[i][10];
					if(results.data[i][7]!=current_nomenclatural_act_header) nomenclatural_html = nomenclatural_html + ' [' + results.data[i][7] + ']';	
					if(results.data[i][1]!="") {
						hide_layer_html = ' [<a href="javascript:clear_layer(&quot;lsid_layer_'+i+'&quot;);">hide<\/a>]';
						nomenclatural_html = nomenclatural_html + '<img src="/images/lsidlogo.jpg" style="float:right;" width="30" onclick="show_text(&quot;lsid_display_layer&quot;,&quot;' + results.data[i][10] + '<br\/>' + results.data[i][1] + '&quot;);" alt="LSID:' + results.data[i][1] + '" /><span id="lsid_layer_'+i+'"><\/span>';
						
						}
					nomenclatural_html = nomenclatural_html + '<\/span><\/br>';
					}//end if  //<a href=javascript:clear_layer(&quot;lsid_layer_'+i+'&quot;);>hide<\/a>
					
				else {//other Taxon Name Usage
					if(current_other_taxon_usage_header!=results.data[i][8]) {
						current_other_taxon_usage_header = results.data[i][8];
						other_taxon_usage_html = other_taxon_usage_html + '<span class="section_header">'+ current_other_taxon_usage_header + '<\/span><\/br>';
						}
					other_taxon_usage_html = other_taxon_usage_html +  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + results.data[i][10];
					if(results.data[i][7]!=current_other_taxon_usage_header) other_taxon_usage_html = other_taxon_usage_html + ' [' + results.data[i][7] + ']';	
					other_taxon_usage_html = other_taxon_usage_html + '<br \/>';
					}//end else
			}//end else (not radio button or form based
			//
		}//end for
		}//end else
	if(include_radio_btns>0) {}
	else acts_html =  acts_html + '<tr><td valign="top" width="60%" style="background-color:#F0E68C;color:#800000;">'+nomenclatural_html+'<br\/><div class="lsid_display_layer_style" id="lsid_display_layer" style="display:none;"><\/div><\/td><td valign="top" style="background-color:#C5DBEC;color:#000000;">'+other_taxon_usage_html+'<\/tr><\/table>';
		
	
	document.getElementById(layer_name).innerHTML = acts_html;
	//$( '#accordion' ).accordion( "activate" , 2 );
	//display the current nomenclatural acts layers
	$("#"+layer_name).show();
	$("#nomenclatural_acts_layer").show();	

}//end function get_pub_acts_response_action

function confirm_species_parent(register){
	//make sure the layer is dsiplayed
	$("#new_name_parent_confirmation_layer").show();
	var display_html = 'Please confirm that the species name you are about to register was combined with the genus name, ' + document.getElementById("selected_parent").innerHTML + ' in this Published Work.';
	display_html = display_html + '<br \/><button type="button" id="btn_new_name_confirm_parent">Confirm Parent Genus<\/button>';
	document.getElementById("new_name_parent_confirmation_layer").innerHTML = display_html;
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
			//submit the form - submit_new_name(pub_ReferenceID,new_rank_id,new_name_spelling,new_name_pages,new_name_type_genus,new_name_authors,is_fossil,LogUserName,establish_protonym,assign_zb_lsid,ProtonymID,new_name_figures,ParentUsageID)
			submit_new_name(document.getElementById("pub_id").value,60,document.getElementById("parent_name").value,document.getElementById("new_name_pages").value,document.getElementById("new_name_type_genus").value,document.getElementById("new_name_authors").value,IsFossil,LogUserName,0,0,document.getElementById("parent_id").value,document.getElementById("new_name_figures").value,'');
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
	});
	
}


function submit_publication_response_action(results,ParentReferenceID,ReferenceTypeID,LanguageID,Year,Title,ShortTitle,Series,Volume,Number,Pages,Figures,DatePublished,Authors,LogUserName){
	//set the parent Reference or the actual pub_id with the new pub_id value
	if(ParentReferenceID==0&&ReferenceTypeID==39) document.getElementById("ParentReferenceID").value = results.pk;
	else {
		$( '#accordion' ).accordion( "deactivate" , 1 );
		$( '#accordion' ).accordion( "activate" , 2 );
		//clear the pub form values
		$('#pub_form')[0].reset();
		//hide the pub form
		$( '#tbl_pub_form').hide();
		//alert(results[0][0]);
		//alert(results.length);
		document.getElementById("pub_id").value = results.pk;
		document.getElementById("reference_citation_preview").innerHTML = results.new_citation;
		get_pub_acts(results.pk,1,'new_act_current_names_in_pub');
		//show the nomenclatural acts layers
		$("#nomenclatural_acts_layer").show();
		$("#name_acts_button_layer").show();
		//populate the author field in the new names form with the CheatAuthors field in the results struct
		document.getElementById("new_name_authors").value = results.cheatauthors;
		}//end else
		//update the summary layer
		review_html = '<\/br><\/br><span class="completed_question_label">Created and Registered Publication: <\/span><span class="completed_question_result_text">'+ results.new_citation + '<\/span>';
		show_text("review_layer",review_html,1,0);
		$('#nomenclatural_acts_layer').parent().click();

}//end function submit_publication_response_action

function get_author_by_pub_response_action(pubid,results){
	var author_sorted_array = [];
	//var cheat_author_value = results.data[0][23];
	document.getElementById('selected_author_list').innerHTML = '';
	for(n=0;n<results.data.length;n++){
		add_author_to_list(results.data[n][0],results.data[n][4],results.data[n][2]);
		//add the CheatAuthor result to an array of authors for later display
		//author_sorted_array.push(results.data[n][23]);
		//cheat_author_value = cheat_author_value + results.data[n][23];
		}//end for
	//document.getElementById("new_name_authors").value = cheat_author_value;
	//document.getElementById("author_citation_preview").innerHTML = cheat_author_value;
}//end get_author_by_pub_response_action

function display_final_new_name_confirm() {
	$("#btn_new_name_form").hide();
	display_html = '<br \/><br \/><b>Please confirm that you wish to register '+ document.getElementById("new_name_spelling").value+', as first established';
	if(document.getElementById("new_name_pages").value!="") display_html = display_html + ' on p. '+document.getElementById("new_name_pages").value +' ';
	display_html = display_html + ' in this Published Work:<\/b><br \/>' + document.getElementById("reference_citation_preview").innerHTML;
	display_html = display_html + '<br \/><br \/><button id="btn_new_name_confirm" type="submit">Confirm New Registration<\/button><button id="btn_new_name_cancel" type="button">Cancel Registration<\/button>';
	document.getElementById("new_name_confirm_layer").innerHTML = display_html;
	new_author_name = document.getElementById("new_name_authors").value;
	//add the onclick actions for the new buttons
	$("#btn_new_name_cancel").click(function () { 
		//show the Save Record button
		$("#btn_new_name_form").show();
		//clear the confirm layer content
		document.getElementById("new_name_confirm_layer").innerHTML = '';
     	//clear the new name form
		$('#form_new_name')[0].reset();
		//close the modal dialog
		$( "#new_name" ).dialog('close');
		//reset the new_author_names field
		document.getElementById("new_name_authors").value = new_author_name;
    });
	//format the new buttons
	$("#btn_new_name_confirm").button();
	$("#btn_new_name_cancel").button();
}//end function display_final_new_name

function submit_new_name_response_action(results,new_name_spelling,establish_protonym,assign_zb_lsid) {
	//call the get nomenclatural acts for the reference - refid, use radio buttons, target layer
	get_pub_acts(document.getElementById("pub_id").value,0,'current_acts_layer');
	var review_html = '<\/br><\/br><span class="completed_question_label">';
	var new_name_results = JSON.parse(results);
	//update the review layer
	if(establish_protonym==1) review_html = review_html + 'Created Protonym';
	else {
		review_html = review_html + 'Recorded Taxon Name Usage';
		//set the parent id to be the new taxon name usage of the parent
		document.getElementById("parent_id").value = new_name_results.new_taxon_name_usage_id;
		}
	if(assign_zb_lsid==1) review_html = review_html + ' and Registered';
	
	
	review_html = review_html + ': <\/span><span class="completed_question_result_text">'+ new_name_spelling + '<\/span>';
	show_text("review_layer",review_html,1,0);
}