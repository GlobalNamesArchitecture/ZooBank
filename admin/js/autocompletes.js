/*

	NAME: autocompletes.js

	PURPOSE:  Functionality associated with jQuery autocompletes.

	LAST MODIFIED: 4/24/2012 - made code more DRY and lean
		
	CREATED:  
	
	ORIGINAL AUTHOR: Robert Whitton
	
	MODIFICATIONS BY: David P. Shorthouse

	NOTES: 

*/

/*global $, window */

$(function() {
  "use strict";

  var ZOOBANK   = ZOOBANK || { 'config' : { 'env' : 1 } },
      keys      = [],
      key_value = {
        'author'  : { url : 'Authors.json', fxn : 'author' },
        'pub'     : { url : 'References.json', fxn : 'journal' },
        'article' : { url : 'References.json', fxn : 'article' },
        'language': { url : 'services.cfc?method=find_language', fxn : 'language' },
        'rank'    : { url : 'services.cfc?method=find_taxon_level', fxn : 'rank' },
        'parent'  : { url : 'NomenclaturalActs.json', fxn : 'protonym' }
      },
      no_match  = "no match";

  $.each(key_value, function(k,v) {
    v= null;
    keys.push(k);
  });

  $.each(keys, function() {
    var self = this, data = {};

    $('#'+self+'_search_string').autocomplete({
      minLength : (self === 'pub') ? 4 : 3,
      delay     : 400,
      search    : function() { $(this).addClass("wait"); },
      open      : function() { $(this).removeClass("wait"); },
      source    : function(request, response) {
        data = {
          term                : request.term,
          isPeriodical        : (self === 'pub') ? 1 : 0,
          add_selected_option : 1,
          top                 : 25,
          searchType          : 'Word Start'
        };
        if(self === 'parent') {
          $.extend(data, { RankGroup : "Genus", searchType : "begins with", DistinctNames : 1, add_new_parent_option : 1 });
        }
        $.ajax({
          url: '/'+key_value[self].url,
          dataType: "json",
          contentType: "application/json; charset=utf-8",
          data: data,
          success: function(data) {
            response(data);
          }
        });
      },
      select    : function(event, ui) {
        event = null;
        if(ZOOBANK.config.env === 0) {
          switch(self) {
            case 'author':
              $('#author_id').val(no_match);
              if (ui.item.id !== 0) { $('#author_id').val(ui.item.agentnameid); }
            break;

            case 'pub':
              $('#ParentReferenceUUID').val(no_match);
              if (ui.item.referenceid !== 0) { $('#ParentReferenceUUID').val(ui.item.referenceid); }
            break;

            case 'language':
              $('#LanguageID').val(no_match);
              if(ui.item.id !== 0) { $('#LanguageID').val(ui.item.id); }
            break;

            case 'rank':
              $('#parent_id').val(no_match);
              if(ui.item.id !== 0) { $('#parent_id').val(ui.item.id); }
            break;
          }
        } else {
          var fn = window[key_value[self].fxn+'_lookup_autocomplete_action'];
          if(typeof fn === 'function') {
            fn(ui, ui.item.value);
          }
          if($.trim(self) === 'author' || $.trim(self) === 'parent') {
            $(this).val('');
            return false;
          }
        }
      }
    });
  });
});
