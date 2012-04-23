<cfinclude template="/header.cfm">
<cfoutput>
<span class="form_instructions_text">Search for an author</span>
<cfparam name="author_search_default" default="Robert Whitton">
<input type="text" id="author_search" value="#author_search_default#" /><button onclick="window.location='function_test.cfm?author_search_default='+document.getElementById(&quot;author_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="find_author" returnvariable="find_author_results">
	<cfinvokeargument name="term" value="#author_search_default#">
</cfinvoke>
<p class=cellxsm>
<span class=cellsm><cfdump var="#find_author_results#"></span>
</p>
<hr />

<span class="form_instructions_text">Search for a reference</span>
<cfparam name="reference_search_default" default="New Yorker">
<input type="text" id="reference_search" value="#reference_search_default#" /><button onclick="window.location='function_test.cfm?reference_search_default='+document.getElementById(&quot;reference_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="find_pub" returnvariable="find_reference_results">
	<cfinvokeargument name="term" value="#reference_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#find_reference_results#">
</p>
<hr />

<span class="form_instructions_text">Show an Author's Publications</span>
<cfparam name="author_pub_search_default" default="21940810">
<input type="text" id="author_pub_search" value="#author_pub_search_default#" /><button onclick="window.location='function_test.cfm?author_pub_search_default='+document.getElementById(&quot;author_pub_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="show_author_pubs" returnvariable="find_reference_results">
	<cfinvokeargument name="AuthorID" value="#author_pub_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#find_reference_results#">
</p>

<hr />
<span class="form_instructions_text">Publication Types</span>
<cfinvoke component="editor.services" method="get_pub_types" returnvariable="pub_types">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#pub_types#">
</p>
<hr />
<span class="form_instructions_text">Publication Authors</span>
<cfparam name="reference_author_search_default" default="19701301">
<input type="text" id="reference_author_search" value="#reference_author_search_default#" /><button onclick="window.location='function_test.cfm?author_pub_search_default='+document.getElementById(&quot;reference_author_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="get_pub_authors" returnvariable="pub_authors">
	<cfinvokeargument name="ReferenceID" value="#reference_author_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#pub_authors#">
</p>
<hr />

<span class="form_instructions_text">Search for a language</span>
<cfparam name="language_search_default" default="eng">
<input type="text" id="language_search" value="#language_search_default#" /><button onclick="window.location='function_test.cfm?language_search_default='+document.getElementById(&quot;language_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="find_language" returnvariable="find_language_results">
	<cfinvokeargument name="term" value="#language_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#find_language_results#">
</p>
<hr />

<span class="form_instructions_text">Search taxon level</span>
<cfparam name="taxon_level_search_default" default="sp">
<input type="text" id="taxon_level_search" value="#taxon_level_search_default#" /><button onclick="window.location='function_test.cfm?taxon_level_search_default='+document.getElementById(&quot;taxon_level_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="find_taxon_level" returnvariable="find_taxon_level_results">
	<cfinvokeargument name="term" value="#taxon_level_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#find_taxon_level_results#">
</p>
<hr />
<span class="form_instructions_text">Protonym Lookup</span>
<cfparam name="protonym_search_default" default="chaetodo">
<input type="text" id="protonym_search" value="#protonym_search_default#" /><button onclick="window.location='function_test.cfm?protonym_search_default='+document.getElementById(&quot;protonym_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="get_protonym" returnvariable="protonym_results">
	<cfinvokeargument name="RankGroup" value="Genus">
	<cfinvokeargument name="term" value="#protonym_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#protonym_results#">
</p>

<hr />
<span class="form_instructions_text">Names in Publication</span>
<cfparam name="get_nomenclatural_acts_search_default" default="19740660">
<input type="text" id="nomenclatural_acts_search" value="#get_nomenclatural_acts_search_default#" /><button onclick="window.location='function_test.cfm?get_nomenclatural_acts_search_default='+document.getElementById(&quot;nomenclatural_acts_search&quot;).value+'';">Run Function</button><br />
<cfinvoke component="editor.services" method="get_nomenclatural_acts" returnvariable="get_nomenclatural_acts_results">
	<cfinvokeargument name="ReferenceID" value="#get_nomenclatural_acts_search_default#">
</cfinvoke>
<p class=cellxsm>
<cfdump var="#get_nomenclatural_acts_results#">
</p>


</cfoutput>

<cfinclude template="/footer.cfm">
