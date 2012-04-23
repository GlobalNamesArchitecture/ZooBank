<cfinclude template="/header.cfm">
<script language="javascript" type="text/javascript">
	//set the test environment flag on
	var test_environment = 1
</script>
<script language="javascript" src="/admin/js/autocompletes.js" type="text/javascript"></script>
<fieldset style="text-align:left;">
	<legend>Test Functions for Autocomplete</legend>

<label class="entry_label">Author Search</label><input type="text" size="45" name="author_search_string" id="author_search_string" />&nbsp;ID:<input type="text" name="author_id" id="author_id" /><br />
<br />
<label class="entry_label">Journal Search</label><input type="text" size="45" name="pub_search_string" id="pub_search_string" />&nbsp;ID:<input type="text" name="ParentReferenceID" id="ParentReferenceID" /><br />
<br />
<label class="entry_label">Language Search</label><input type="text" size="45" name="language_search_string" id="language_search_string" />&nbsp;ID:<input type="text" name="LanguageID" id="LanguageID" /><br />
<br />
<label class="entry_label">Rank Search</label><input type="text" size="45" name="rank_search_string" id="rank_search_string" />&nbsp;ID:<input type="text" name="rank_id" id="rank_id" /><br />
<br />
<label class="entry_label">Protonym Search</label><input type="text" size="45" name="parent_search_string" id="parent_search_string" />&nbsp;ID:<input type="text" name="parent_id" id="parent_id" /><br />
<br />

<cfinclude template="/footer.cfm">