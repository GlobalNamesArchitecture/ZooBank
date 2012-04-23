<cfinclude template="../header.cfm">
<link href="/public/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css" />
<header id="header">
	<div class="container">
		<h1 class="logo"><a href="index.html">ZooBank</a></h1>
		<nav>
			<ul>
				<li><a href="about.html">about</a></li>
				<li><a href="contact.html">contact</a></li>
			</ul>
		</nav>
	</div>
	<div class="container">
	<p class="introduction"><span class="tagline">The official registry of zoological nomenclature.</span> ZooBank provides a means for authors and publishers to electronically register new nomenclatural acts, and assigns unique Life Science Identifiers (<abbr title="Life Science Identifier">lsid</abbr>s) to those names. </p>
	</div>
</header>
<cfparam name="LogUserName" default = "#session.username#">
<script language="JavaScript">
<cfoutput>var LogUserName = '#LogUserName#';</cfoutput>
</script>
<script language="JavaScript" type="text/javascript" src="/admin/js/register.js"></script>
<script language="JavaScript" type="text/javascript" src="/admin/js/register_cont.js"></script>
<div class="container" style="top:170px;position:relative;">

<div id="accordion" style="text-align:left;width:950px;">
	<h3><a href="#">Authorship&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="preview" id="author_citation_preview"></span></a></h3>
	<div id="authors_layer">
		<span id="selected_author_instruction_layer"></span>
		<ul id="selected_author_list"></ul>
		<div id="author_entry_layer" class="active_section">
			<label for="author_search_string" class="entry_label">
				<span id="author_search_span">
				First Author
				</span>
			</label>
			<input type=hidden id="include_org" value="1" />
			<input type="text" size="45" name="author_search_string" id="author_search_string" /><img id="image_help_author_search" src="/images/help.gif" />&nbsp;
			<button id="btn_new_author" type="button" class="new_item_button">New Author</button><input type="hidden" name="author_id" id="author_id" /><br />
			
			<span id="action_button_layer"></span>
		</div>
		<span id="joint_pubs"></span>
	</div>
	
	<h3><a href="#">Publication &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="preview" id="reference_citation_preview"></span></a></h3>
	<div id="new_pub">
		<span id="selected_article" class="completed_question_result_text completed_section"></span>
		<div id="pub_search_form_layer" class="active_section"><span class="entry_label">Publication Title</span> 
			<input type="text" size="45" name="article_search_string" id="article_search_string" /><img id="image_help_article_search" src="/images/help.gif" /><br />
			<!---<br />
				<button id="btn_show_new_pub_form" type="button"><span class="ui-button-text">New Publication</span></button>--->
			
			<input type="hidden" name="article_id" id="article_id" />
		</div>		
		
		<form id="pub_form" name="pub_form" method="get" action="">
			<input type="hidden" name="pub_id" id="pub_id" />
			<table border="0" id="tbl_pub_form" width="100%">
				<tbody id="pub_type_question_layer" style="display:none;">
				<tr>
					<td class="entry_label" style="height:50px;">What kind of Published Work is this?</td>
					<cfset display_types = "1,2,5">
					<cfinvoke component="services" method="get_pub_types" returnvariable="get_types">					
					<cfset pub_types = DeSerializeJSON(get_types)>
					<td class="question_options_text">
					<cfoutput query="pub_types">
						<cfif ListFind(display_types,id,",")>
							<input type="radio" value="#id#" id="pub_type_#id#" name="pub_type1" />#value#
							<cfif id is not ListLast(display_types,",")><br /></cfif>
						</cfif>
					</cfoutput>
					<input type="hidden" name="pub_type" id="pub_type" />
					
					</td>
				</tr><!---pub type question layer--->
				</tbody>
				<tbody>
					<tr><td id="pub_type_display_layer" class="completed_question_result_text" colspan="2"></td></tr>
				</tbody>
				<tbody id="pub_book_series_layer" style="display:none;">				
				<tr>
					<td class="entry_label">Is this part of a book series?</td>
					<td class="question_options_text">
						<input type="radio" name="pub_part_book_series" id="pub_part_book_series_1" value="1" /> Yes |
						<input type="radio" name="pub_part_book_series" id="pub_part_book_series_0" value="0" />No<br /><br />				
					</td>
				</tr>
				</tbody>
				<tbody id="pub_parent_id_layer" style="display:none;">
				<!---<input type="hidden" name="pub_type_id" id="pub_type_id" value="" />--->
				<tr id="parent_pub_question_section">
					<td>
						<span class="entry_label">Journal or Magazine</span></td>
					<td><input id="pub_search_string" type="text" />
						<input type="hidden" id="ParentReferenceID" name="ParentReferenceID" />
						<img id="image_help_pub_search" src="/images/help.gif" />
						<button id="btn_show_new_periodical_form" type="button" class="new_item_button"><span id="btn_show_new_periodical_form_text">Create New Periodical</span></button>
					</td>
				</tr>
				</tbody>
				<tr><td colspan=2><span id="selected_pub" class="completed_section"></span></td></tr>
				<tr><td colspan=2><span id="edited_volume_instructions_layer" style="display:none;"></span></td></tr>
		
			
			
				<tr id="pub_already_published_question" style="display:none;">
					<td class="entry_label">Has this Work Already Been Published?</td>
					<td id="pub_already_published_choices" class="question_options_text">
						<input type="radio" id="pub_form_already_published_1" name="pub_form_already_published" value="" />Already Published |
						<input type="radio" id="pub_form_already_published_0" name="pub_form_already_published" value="" />Not Yet Published <br /><br />
					</td>
				</tr>
				<tr><td colspan=2><span id="pub_already_published_completed_value" class="completed_section"></span></td></tr>
				<tr><td colspan=2 class="form_instructions_text"><span id="pub_form_instructions_layer" style="display:none;"></span></td></tr>
				<tbody id="create_pub_layer" style="display:none;">
				<tr id="pub_year_layer">
					<td class="entry_label">Year * (retrospective only)</td>
						<td><span id="pub_year_input_layer">
							<input type="text" name="pub_year" id="pub_year" />
							<img id="image_help_pub_year" src="/images/help.gif" />
							</span>
							<span id="pub_year_explanation_text"></span>
						</td>
						
					</tr>
					<tr>
						<td class="entry_label" style="height:5em;">Title *</td>
						<td><textarea cols="47" rows="3" name="pub_title" id="pub_title"></textarea>
							<img id="image_help_pub_title" src="/images/help.gif" /></td>
					</tr>
					<tr id="pub_form_abbr_title" style="display:none;">	
						<td class="entry_label">Short Title</td>
						<td><input type="text" name="pub_abbr_title" id="pub_abbr_title" value="" />
							<img id="image_help_pub_abbr_title" src="/images/help.gif" /></td>
					</tr>
					<tr id="pub_form_series" style="display:none;">	
						<td class="entry_label">Series</td>
						<td><input type="text" name="pub_series" id="pub_series" value="" />
							<img id="image_help_pub_series" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Volume</td>
						<td><input type="text" name="pub_volume" id="pub_volume" />
							<img id="image_help_pub_volume" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Number</td>
						<td><input type="text" name="pub_number" id="pub_number" />
							<img id="image_help_pub_number" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Pages</td>
						<td><input type="text" name="pub_pages" id="pub_pages" />
							<img id="image_help_pub_pages" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td  class="entry_label">Figures</td>
						<td><input type="text" name="pub_figures" id="pub_figures" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Date</td>
						<td><input type="text" name="pub_date" id="pub_date" />
							<img id="image_help_pub_date" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Language</td>
						<td><span id="pub_language_input_field">
								<input id="language_search_string" type="text" />
							</span>
						<span id="selected_language" class="completed_question_result_text"></span>
						<input type="hidden" id="LanguageID" />	</td>
					</tr>
					<tr id="pub_form_archive_question_layer" style="display:none;">
						<td class="entry_label">Archive</td> 
						<td><input type="text" id="pub_archive" name="pub_archive" />
							<img src="/images/help.gif" id="image_help_pub_archive" /></td>
					</tr>
					<tr>
						<td colspan=2 align="center"><button id="btn_new_pub_form" name="btn_new_pub_form">Enter New Publication</button></td>
					</tr>
				</tbody><!---create_pub_layer--->
			</table>
		</form><!---pub_form--->
	</div><!--- new_pub --->
	<h3><a href="#">Nomenclatural Acts</a></h3>
		<div id="nomenclatural_acts_layer" style="text-align:left;display:none;height:400px;">
			<span id="name_act_search_layer" style="display:none;">Nomenclatural Acts
				<span class="celllg">Search</span>
				<input type="text" size="30" name="taxon_act_search_string" id="taxon_act_search_string" /><br />
				<span id="selected_taxon_act" class="cellmed1"></span>
				<input type="hidden" name="taxon_act_id" id="taxon_act_id" />		
			</span>
			<div id="name_acts_button_layer" class="nomenclatural_acts_layer_style" style="text-align:left;display:none;">
				<button id="btn_show_new_name_form_family" type="button">New Family-Group Name</button>
				<button id="btn_show_new_name_form_genus" type="button">New Genus-Group Name</button>
				<button id="btn_show_new_name_form_species" type="button">New Species-Group Name</button>
			</div>
			<div class="current_acts_layer">
				<span id="current_acts_layer"></span>
			</div>
			<div id="new_name" title="New Nomenclatural Act">
				<form name="form_new_name" id="form_new_name" method="get" action="">
					<div id="new_name_instruction_layer" class="form_instructions_text"></div>
					<div id="new_act_current_names_in_pub"></div>
					<div id="new_name_parent_layer">
						<label class="entry_label" id="new_name_parent_label">Parent</label>
							<span id="new_name_parent_search_layer"><input id="parent_search_string" type="text" />[Required for Species or Subspecies]</span>
					</div>
					<span id="selected_parent" class="completed_question_result_text completed_section"></span><br />
					<input type="hidden" name="parent_id" id="parent_id" />
					<input type="hidden" name="parent_name" id="parent_name" />
					<div id="new_name_parent_confirmation_layer"></div>
					<div id="new_nomenclatural_act_main_form_layer" style="display:none;">
						<label class="entry_label">Rank *</label><select id="rank_id" name="rank_id"></select>
							<!---<input id="rank_search_string" type="text" />--->
							<img src="/images/help.gif" id="image_help_taxon_rank" />
							
						<!---<span id="selected_rank"></span><input type="hidden" id="rank_id" name="rank_id" />---><br /><br />					
						<label class="entry_label">Spelling *</label> <input type="text" id="new_name_spelling" name="new_name_spelling" />
							<img src="/images/help.gif" id="image_help_taxon_spelling" /><br /><br />
						<label class="entry_label">Page(s)</label> <input type="text" name="new_name_pages" id="new_name_pages" />
							<img src="/images/help.gif" id="image_help_taxon_pages" /><br /><br />
						<div id="new_name_figures_layer">
							<label class="entry_label">Fig(s)</label> <input type="text" name="new_name_figures" id="new_name_figures" />
							<img src="/images/help.gif" id="image_help_taxon_figures" /><br /><br />
						</div>
						<label class="entry_label" id="new_name_type_label">Type Genus</label> <input type="text" name="new_name_type_genus" id="new_name_type_genus" />
							<img src="/images/help.gif" id="image_help_taxon_type" /><br /><br />
						<div>
						<label style="200px;font-weight:bold;">Is the authorship of the name identical to the authorship of the Published Work?</label> 
						</div><br />
						<label class="entry_label">&nbsp;</label>
							Yes <input type="radio" value="1" name="is_authorship_identical" id="new_name_is_authorship_identical_1" checked />
							| No <input type="radio" value="0" name="is_authorship_identical" id="new_name_is_authorship_identical_0" />
							<img src="/images/help.gif" id="image_help_taxon_authorship" /><br /><br />
							
							
						<!---<label class="entry_label">Type Locality</label> <input type="text" /><br /><br />--->
						<div id="new_name_authorship_input_layer" class="disabled">
							<label class="entry_label">Author(s)</label> <input type="text" name="new_name_authors" id="new_name_authors" size="45" disabled class="disabled" />
							<img src="/images/help.gif" id="image_help_taxon_authors" /><br /><br />
						</div>
						<label class="entry_label">Is this new taxon name based on fossil material?</label>
							<input type="checkbox" name="is_fossil" id="is_fossil" value="1" /><br /><br />
						
						<div class="form_button_layer">
							<button id="btn_new_name_form" type="button">Save Record</button>
						</div>
						<div id="new_name_confirm_layer"></div>
					</div><!--- new_nomenclatural_act_main_form_layer --->
				</form>
			</div><!---new_name--->
		</div><!---nomenclatural_acts_layer--->
	<h3><a href="#">Summary</a></h3>
		<div id="review_container">
			<div id="review_layer" style="text-align:left;"></div>
		</div>
</div><!---accordian--->
</div>
<div class="form_instructions_text" id="registration_instruction_layer" style="display:none;">
	<br />To start the registration process, begin by entering the authors of the published work in which the nomenclatural acts appear (you will be prompted later for the authors of new taxon names, if different from the authors of the published work). If the acts appear in a chapter or section of an edited volume, begin by entering the editors of the edited volume (you will be prompted later for the authors of the chapter or section). <br /><br />
</div>




<!---<div id="publication_layer" style="text-align:left;display:none;">--->
	<!---<div id="publication_type_layer" style="text-align:left;display:none;">
		<span id="publication_type_question_layer">
			<span class="question_label_text">
				<label class="entry_label">When this work was originally published, it was</label> 
			</span>
			<span class="question_options_text">
				<input type="radio" name="original_type_pub" id="publication_pub_type_durable" value="durable_media" />Printed on Durable Media | 
				<input type="radio" name="original_type_pub" id="publication_pub_type_electronic" value="electronic_media" />Electronic Only<br /><br />
			</span>
		</span>
		<span id="publication_type_display_layer" style="display:none;" class="completed_question_label completed_section"></span>
	</div>--->
	<!--- <span class=celllg>Publication</span><br /> --->
	<!---<span id="author_citation_preview"></span><br />--->
	<!---<span class="celllg" id="pub_search_form_layer">Search <input type="text" size="30" name="article_search_string" id="article_search_string" /><br />
		<span id="selected_article" class="cellmed1"><!---<br />
			<button id="btn_show_new_pub_form" type="button"><span class="ui-button-text">New Publication</span></button>--->
		</span>
	</span>
	<input type="hidden" name="article_id" id="article_id" />--->
	<!---div title shows up as an ALT tool tip in some browsers--->
	<!---ACCORDION PUB COMMENTED OUT
	<div id="new_pub" style="display:none;">
		<form id="pub_form" name="pub_form" method="get" action="">
			<input type="hidden" name="pub_id" id="pub_id" />
			<table border="0" id="tbl_pub_form" width="100%">
				<tr id="pub_type_question_layer">
					<td class="entry_label" style="height:50px;">What kind of Published Work is this?</td>
					<cfset display_types = "1,2,5">
					<cfinvoke component="services" method="get_pub_types" returnvariable="get_types">					
					<cfset pub_types = DeSerializeJSON(get_types)>
					<td class="question_options_text">
					<cfoutput query="pub_types">
						<cfif ListFind(display_types,id,",")>
							<input type="radio" value="#id#" id="pub_type_#id#" name="pub_type1" />#value#
							<cfif id is not ListLast(display_types,",")><br /></cfif>
						</cfif>
					</cfoutput>
					<input type="hidden" name="pub_type" id="pub_type" />
					
					</td>
				</tr><!---pub type question layer--->
				<tr><td id="pub_type_display_layer" class="completed_question_result_text" colspan="2"></td></tr>
						
				<tr id="pub_book_series_layer" style="display:none;">
					<td class="entry_label">Is this part of a book series?</td>
					<td class="question_options_text">
						<input type="radio" name="pub_part_book_series" id="pub_part_book_series_1" value="1" /> Yes |
						<input type="radio" name="pub_part_book_series" id="pub_part_book_series_0" value="0" />No<br /><br />				
					</td>
				</tr>
			
				<!---<input type="hidden" name="pub_type_id" id="pub_type_id" value="" />--->
				<tr id="pub_parent_id_layer" style="display:none;">
					<td id="parent_pub_question_section">
						<span class="entry_label">Journal or Magazine</span></td>
					<td><input id="pub_search_string" type="text" />
						<input type="hidden" id="ParentReferenceID" name="ParentReferenceID" />
						<img id="image_help_pub_search" src="/images/help.gif" />
						<button id="btn_show_new_periodical_form" type="button" class="new_item_button"><span id="btn_show_new_periodical_form_text">Create New Periodical</span></button>
					</td>
				</tr>
				<tr><td colspan=2><span id="selected_pub" class="completed_section"></span></td></tr>
				<tr><td colspan=2><span id="edited_volume_instructions_layer" style="display:none;"></span></td></tr>
		
			
			
				<tr id="pub_already_published_question" style="display:none;">
					<td class="entry_label">Has this Work Already Been Published?</td>
					<td id="pub_already_published_choices" class="question_options_text">
						<input type="radio" id="pub_form_already_published_1" name="pub_form_already_published" value="" />Already Published |
						<input type="radio" id="pub_form_already_published_0" name="pub_form_already_published" value="" />Not Yet Published <br /><br />
					</td>
				</tr>
				<tr><td colspan=2 class="form_instructions_text"><span id="pub_form_instructions_layer" style="display:none;"></span></td></tr>
				<tbody id="create_pub_layer" style="display:none;">
				<tr id="pub_year_layer">
					<td class="entry_label">Year * (retrospective only)</td>
						<td><span id="pub_year_input_layer">
							<input type="text" name="pub_year" id="pub_year" />
							<img id="image_help_pub_year" src="/images/help.gif" />
							</span>
							<span id="pub_year_explanation_text"></span>
						</td>
						
					</tr>
					<tr>
						<td class="entry_label" style="height:5em;">Title *</td>
						<td><textarea cols="47" rows="3" name="pub_title" id="pub_title"></textarea>
							<img id="image_help_pub_title" src="/images/help.gif" /></td>
					</tr>
					<tr id="pub_form_abbr_title" style="display:none;">	
						<td class="entry_label">Short Title</td>
						<td><input type="text" name="pub_abbr_title" id="pub_abbr_title" value="" />
							<img id="image_help_pub_abbr_title" src="/images/help.gif" /></td>
					</tr>
					<tr id="pub_form_series" style="display:none;">	
						<td class="entry_label">Series</td>
						<td><input type="text" name="pub_series" id="pub_series" value="" />
							<img id="image_help_pub_series" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Volume</td>
						<td><input type="text" name="pub_volume" id="pub_volume" />
							<img id="image_help_pub_volume" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Number</td>
						<td><input type="text" name="pub_number" id="pub_number" />
							<img id="image_help_pub_number" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Pages</td>
						<td><input type="text" name="pub_pages" id="pub_pages" />
							<img id="image_help_pub_pages" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td  class="entry_label">Figures</td>
						<td><input type="text" name="pub_figures" id="pub_figures" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Date</td>
						<td><input type="text" name="pub_date" id="pub_date" />
							<img id="image_help_pub_date" src="/images/help.gif" /></td>
					</tr>
					<tr>	
						<td class="entry_label">Language</td>
						<td><span id="pub_language_input_field">
								<input id="language_search_string" type="text" />
							</span>
						<span id="selected_language" class="completed_question_result_text"></span>
						<input type="hidden" id="LanguageID" />	</td>
					</tr>
					<tr id="pub_form_archive_question_layer" style="display:none;">
						<td class="entry_label">Archive</td> 
						<td><input type="text" id="pub_archive" name="pub_archive" />
							<img src="/images/help.gif" id="image_help_pub_archive" /></td>
					</tr>
					<tr>
						<td colspan=2 align="center"><button id="btn_new_pub_form" name="btn_new_pub_form">Enter New Publication</button></td>
					</tr>
				</tbody><!---create_pub_layer--->
			</table>
		</form><!---pub_form--->
	</div><!--- new_pub --->
	END PUB ACCORDION --->
<!---</div>---><!--- publication_layer --->

<div id="create_periodical_layer" style="display:none;" title="Create Periodical">
	<form id="form_create_periodical" name="form_create_periodical" method="get" action="">
	
	<label class="entry_label" id="new_periodical_full_title_label" style="height:5em;">Full Title of Periodical*</label><textarea cols="50" rows="3" name="new_periodical_full_title" id="new_periodical_full_title"></textarea>
		<img src="/images/help.gif" id="image_help_periodical_full_title" /><br /><br /><br />
	<label class="entry_label" id="new_periodical_abbr_title_label">Abbreviated title of periodical</label><input type="text" name="new_periodical_abbr_title" id="new_periodical_abbr_title" />
		<img src="/images/help.gif" id="image_help_periodical_abbr_title" /><br /><br />
	
	<span id="new_periodical_form_fields">
		<label class="entry_label">Series</label><input type="text" name="new_periodical_series" id="new_periodical_series" />
			<img src="/images/help.gif" id="image_help_periodical_series" /><br /><br />	
	</span>	
	
	<span id="new_book_series_questions_layer" style="display:none;">
		<label class="entry_label">Year</label><input type="text" name="new_periodical_bookseries_year" id="new_periodical_bookseries_year" />
			<img src="/images/help.gif" id="image_help_periodical_bookseries_year" /><br /><br />
		<label class="entry_label">Publisher</label><input type="text" name="new_bookseries_publisher" id="new_bookseries_publisher" />
			<img src="/images/help.gif" id="image_help_bookseries_publisher" /><br /><br />	
		<label class="entry_label">Place Published</label><input type="text" name="new_bookseries_place_published" id="new_bookseries_place_published" />
			<img src="/images/help.gif" id="image_help_bookseries_place_published" /><br /><br />	
		<label class="entry_label">Edition</label><input type="text" name="new_bookseries_edition" id="new_bookseries_edition" />
			<img src="/images/help.gif" id="image_help_bookseries_edition" /><br /><br />
		<label class="entry_label">Volumes</label><input type="text" name="new_bookseries_volumes" id="new_bookseries_volumes" />
			<img src="/images/help.gif" id="image_help_bookseries_volumes" /><br /><br />			
			
			
	</span>
	<input type="hidden" name="new_periodical_ReferenceTypeID" id="new_periodical_ReferenceTypeID" value="39" />
	<div class="form_button_layer">
		<button id="btn_create_new_periodical" name="btn_create_new_periodical"><span id="btn_create_new_periodical_text">Create Periodical</span></button>
	</div>
	</form>
</div><!---create_periodical_layer--->

<div id="pub_layer" class="cellsm" style="text-align:left" title="Author Publications">
</div>

<div id="select_author" title="Select Author" style="display:none;">
	<span class=celllg>Confirm Author's Name:</span> <img src="/images/help.gif" id="image_help_select_author_name" />
	<div id="alias_layer"></div>
	<div id="author_pub_layer" style="text-align:left"></div>
</div><!---select_author--->



<div id="new_author" title="Author" style="display:none;">
	<form id="author_form" name="author_form" method="get" action="">
	<div class="form_instructions_text" id="new_author_instructions_layer">
		<span>Enter the Family name, Given name(s) and (if applicable) suffix of <br />the Author's name exactly as they appear in the published work.</span>
	</div><br />
	<label class="entry_label" for="GivenName">Given Name</label> <input type="text" name="GivenName" id="GivenName" size="25" />
		<img src="/images/help.gif" id="image_help_new_author_familyname" /><br /><br />
	<label class="entry_label" for="FamilyName">Family Name</label> <input type="text" name="FamilyName" id="FamilyName" size="25" />
		<img src="/images/help.gif" id="image_help_new_author_givenname" /><br /><br />
	<label class="entry_label" for="author_suffix">Suffix</label> <select name="author_suffix" id="author_suffix" >
		<option value="">&nbsp;</option>
		<option value="Jr.">Jr.</option>
		<option value="II">II</option>
		<option value="III">III</option>
		<option value="IV">IV</option>
		<option value="V">V</option>
		<option value="VI">VI</option>
		</select>
		<img src="/images/help.gif" id="image_help_new_author_suffix" /><br /><br />
	<input type="hidden" name="pkid" id="pkid" />
	<input type="hidden" name="display_name" id="display_name" />
	<div class="form_button_layer">
		<button id="btn_author_form"><span id="btn_author_form_label">Create New Author</span></button>
	</div>
	</form>
	<div id="add_author_result"></div>
	
</div><!---new_author--->

<!---</fieldset>--->

<!---<p class="cellxsm">
Example Article <br />
Zootaxa 2913: 1–15 (10 Jun. 2011) 7 plates; 8 references     <br />                   Accepted: 11 May 2011<br />
A new genus Microphylacinus and revision of the closely related Phylacinus Fairmaire, 1896 (Coleoptera: Tenebrionidae: Pedinini) from Madagascar<br />
DARIUSZ IWAN (Poland), MARCIN KAMINSKI (Poland) &amp; ROLF AALBU (USA)<br />
Publication is Zootaxa</p>--->
<cfinclude template="../footer.cfm">

		