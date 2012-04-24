/*

	NAME: autocompletes.js

	PURPOSE:  Functionality associated with jQuery autocompletes.

	LAST MODIFIED: 4/20/2012 - added top parameter to reference searches
		
	CREATED:  
	
	ORIGINAL AUTHOR: Robert Whitton
	
	MODIFICATIONS BY: David P. Shorthouse

	NOTES: 

*/

/*global $, window */

$(function() {
  "use strict";

  var ZOOBANK   = ZOOBANK || { 'settings' : { 'env' : 1 } },
      keys      = [],
      key_value = {
        'author'  : { url : 'Authors.json', fxn : 'author_lookup_autocomplete_action' },
        'pub'     : { url : 'References.json', fxn : 'journal_lookup_autocomplete_action' },
        'article' : { url : 'References.json', fxn : 'article_lookup_autocomplete_action' },
        'language': { url : '/services.cfc?method=find_language', fxn : 'language_lookup_autocomplete_action' },
        'rank'    : { url : '/services.cfc?method=find_language', fxn : 'rank_lookup_autocomplete_action' },
        'parent'  : { url : '/services.cfc?method=find_taxon_level', fxn : 'protonym_lookup_autocomplete_action' }
     };

  $.each(key_value, function(k,v) {
    keys.push(k);
  });

  $.each(keys, function() {
    var self = this, data = {};

    $('#'+self+'_search_string').autocomplete({
      minLength : (self === 'pub') ? 4 : 3,
      delay     : 400,
      search    : function(event, ui) { $(this).addClass("wait"); },
      open      : function(event, ui) { $(this).removeClass("wait"); },
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
          url: key_value[self].url,
          dataType: "json",
          contentType: "application/json; charset=utf-8",
          data: data,
          success: function(data) {
            response(data);
          }
        });
      },
      select    : function(event, ui) {
        if(ZOOBANK.settings.env === 0) {
          switch(self) {
            case 'author':
              $('#author_id').val("no match");
              if (ui.item.id !== 0) { $('#author_id').val(ui.item.agentnameid); }
            break;

            case 'pub':
              $('#ParentReferenceUUID').val("no match");
              if (ui.item.referenceid !== 0) { $('#ParentReferenceUUID').val(ui.item.referenceid); }
            break;

            case 'language':
              $('#LanguageID').val("no match");
              if(ui.item.id !== 0) { $('#LanguageID').val(ui.item.id); }
            break;

            case 'rank':
              $('#parent_id').val("no match");
              if(ui.item.id !== 0) { $('#parent_id').val(ui.item.id); }
            break;
          }
        } else {
          var fn = window[key_value[self].fxn];
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
