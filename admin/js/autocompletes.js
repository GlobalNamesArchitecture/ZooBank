/*

	NAME: autocompletes.js

	PURPOSE:  Functionality associated with jQuery autocompletes.

	LAST MODIFIED: 4/20/2012 - added top parameter to reference searches
		
	CREATED:  
	
	ORIGINAL AUTHOR: Robert Whitton

	NOTES: 

*/
$().ready(function() {
$( "#author_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: function(request, response) {
            $.ajax({
                url: "/Authors.json",
                dataType: "json",
				contentType: "application/json; charset=utf-8",
                data: {
                    term: request.term,
                    add_selected_option: 1,
					top: 25,
					searchtype: 'Word Start'
                },
                success: function(data) {
                    response(data);
                }
            });
        },		
		minLength: 3,
		delay: 400,
		
		select: function(event, ui) {
			if(test_environment==1){
				if(ui.item.id==0) document.getElementById("author_id").value="No Match";
				else document.getElementById("author_id").value=ui.item.agentnameid;
			}
			else author_lookup_autocomplete_action(ui,ui.item.value);
			//clear the search string
			return false;
			document.getElementById("author_search_string").value='';
		},

		change: function(){
		   try{
			   // Dig through the bowels of the autocomplete widget's data store to find the "add [x] as a new author" list item, then  get its ui.item
			   var item = $.data(this).autocomplete.menu.element.find("li:last-child").data("item.autocomplete");
			// Holy shitballs!
			   //author_lookup_autocomplete_action({ item: item });
			   document.getElementById("author_search_string").value='';
		   } catch (err) {
		   }
		   return false;
	   }
}); //end author autocomplete
		
	
	$( "#pub_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: function(request, response) {
            $.ajax({
                url: "/References.json",
                dataType: "json",
                data: {
                    term: request.term,
                    IsPeriodical: 1,
					add_selected_option: 1,
					top: 50
                },
                success: function(data) {
                    response(data);
                }
            });
        },		
		autoFocus: true,
		minLength: 4,
		delay: 400,
		select: function(event, ui) {
			if(test_environment==1){
				if(ui.item.referenceid==0) document.getElementById("ParentReferenceUUID").value="no match";
				else document.getElementById("ParentReferenceUUID").value=ui.item.referenceid;
				}
			else journal_lookup_autocomplete_action(ui);
		}
	});//end journal search autocomplete
	
	
	//$("#author_search_string").focus();
	$( "#article_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: function(request, response) {
            $.ajax({
                url: "/References.json",
                dataType: "json",
                data: {
                    term: request.term,
                    IsPeriodical: 0,
					add_selected_article_option: 1
                },
                success: function(data) {
                    response(data);
                }
            });
        },
		minLength: 3,
		delay:400,
		select: function(event, ui) {
			article_lookup_autocomplete_action(ui);
			//document.getElementById("article_id").value=ui.item.id;
		//var result_content = '<span onclick="show_search_form(&quot;selected_pub&quot;,&quot;pub_search_string&quot;,&quot;pub_id&quot;,&quot;find_journal&quot;,&quot;'+ui.item.value+'&quot;)";>'+ui.item.value+'<\/span>';
		//document.getElementById("selected_article").innerHTML = "<span class='completed_question_label'>Published Work: <\/span>" + result_content;
		//document.getElementById("article_search_string").value = '';
		//select_publication(ui.item.id,ui.item.value,ui.item.cheatauthors);
		//document.getElementById("reference_citation_preview").innerHTML = ui.item.value;
		//call the function to get all names in this pub, regardless of rankgroup (ReferenceID,include_radio_btns,layer_name,RankGroup)
		//get_pub_acts(ui.item.id,0,'current_acts_layer');
		//display the taxonomic acts section
		//$("#nomenclatural_acts_layer").show();
		//selected_pub_pkid = ui.item.id;
		}			
	});
	
	
	/*$( "#taxon_act_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: "/services.cfc?method=find_taxon_act",
		minLength: 2,
		select: function(event, ui) {document.getElementById("taxon_act_id").value=ui.item.id;
		var result_content = '<span onclick="show_search_form(&quot;selected_pub&quot;,&quot;pub_search_string&quot;,&quot;pub_id&quot;,&quot;find_journal&quot;,&quot;'+ui.item.value+'&quot;)";>'+ui.item.value+'<\/span>';
		document.getElementById("selected_taxon_act").innerHTML = result_content;
		}			
	})*/
	$( "#language_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: "/services.cfc?method=find_language",
		minLength: 3,
		delay: 400,
		select: function(event, ui) {
			if(test_environment==1){
				if(ui.item.id==0) document.getElementById("LanguageID").value="no match";
				else document.getElementById("LanguageID").value=ui.item.id;
				}
			else language_lookup_autocomplete_action(ui);
			return false;
			
		}			
	});//end language autocomplete
	$( "#rank_search_string" ).autocomplete({
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: "/services.cfc?method=find_taxon_level",
		minLength: 3,
		delay: 400,
		select: function(event, ui) {
			if(test_environment==1){
				if(ui.item.id==0) document.getElementById("rank_id").value="no match";
				else document.getElementById("rank_id").value=ui.item.id;
				}
			else rank_lookup_autocomplete_action(ui);
		}			
	});//end rank autocomplete
	
	$( "#parent_search_string" ).autocomplete({		
		search: function(event, ui) {
			$(this).addClass("wait");
			},
        	open: function(event, ui) {
            $(this).removeClass("wait");
        },
		source: function(request, response) {
            $.ajax({
                url: "/NomenclaturalActs.json",
                dataType: "json",
                data: {
                    term: request.term,
                    RankGroup: "Genus",
					searchType: "begins with",
					DistinctNames: 1,
					add_new_parent_option: 1
                },
                success: function(data) {
                    response(data);
                }
            });
        },
		minLength: 3,
		delay: 400,
		select: function(event, ui) {
			if(test_environment==1){
				if(ui.item.id==0) document.getElementById("parent_id").value="no match";
				else document.getElementById("parent_id").value=ui.item.id;
				}
			else protonym_lookup_autocomplete_action(ui);
			document.getElementById("parent_search_string").value='';
			return false;
		}			
	});//end parent taxon name autocomplete
});//end ready function
