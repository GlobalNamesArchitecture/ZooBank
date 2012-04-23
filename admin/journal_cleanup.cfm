<cfinclude template="/header.cfm">
<cfset datasource = "taxonomer_local">

<form action="journal_cleanup.cfm" method="post">
	<input id="search_term" name="search_term" />
	<button type="submit">Search</button>
</form>

<cfquery name="get_journals" datasource="#datasource#">
	SELECT <cfif not isdefined("search_term")>top 15 </cfif>* 
	FROM  TEMP_Dirty_MasterJournals
	WHERE JournalID <> 0
	<cfif isdefined("search_term")>
		<cfif search_term is not "">
			AND (
			Title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#search_term#%">
			OR
			AbbreviatedTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#search_term#%">
			OR
			ISSN like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#search_term#%">
			)
		</cfif>
		AND (TaxonomerID IS NULL OR TaxonomerID = JournalID)
	<cfelse>
		AND (TaxonomerID = JournalID)
	</cfif>
	ORDER BY Title,JournalID
</cfquery>

<cfif IsDefined("action")>
	<cfif action is "update_records">
		<cfoutput query="get_journals">
			<cfif Evaluate("form.new_title_#currentrow#") is not "" OR Evaluate("form.new_issn_#currentrow#") is not "" OR Evaluate("form.new_series_#currentrow#") is not "" OR Evaluate("form.new_abbrtitle_#currentrow#") is not "">
				<cfquery name="update_title" datasource="#datasource#">
					update TEMP_Dirty_MasterJournals
					set JournalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_journals.JournalID#">
					<cfif Evaluate("form.new_title_#currentrow#") is not "">,title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("form.new_title_#currentrow#")#"></cfif>
					<cfif Evaluate("form.new_issn_#currentrow#") is not "">,issn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("form.new_issn_#currentrow#")#"></cfif>
					<cfif Evaluate("form.new_series_#currentrow#") is not "">,series = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("form.new_series_#currentrow#")#"></cfif>
					<cfif Evaluate("form.new_abbrtitle_#currentrow#") is not "">,AbbreviatedTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("form.new_abbrtitle_#currentrow#")#"></cfif>
					WHERE JournalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_journals.JournalID#">
				</cfquery>
			</cfif>		
		</cfoutput>
		<cfif IsDefined("form.same_as_entry")>
			<cfif form.master_entry is not "">
				<cfloop list="#form.same_as_entry#" index="temp_journalID">
					<cfquery name="update_taxonomerID" datasource="#datasource#">
						update TEMP_Dirty_MasterJournals
						set TaxonomerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.master_entry#">
						where JournalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_journalID#">
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
		
		<cflocation url="journal_cleanup.cfm?search_term=#search_term#" addtoken="no" />
		<cfabort>
	</cfif>
</cfif>





<form action="journal_cleanup.cfm" method="post">
<table border=1 class=tablesorter>
<thead>
	<tr class=cellsm>
		<th>Master</th>
		<th>Same As</th>
		<th>Title</th>
		<th>ID<br />TaxonomerID</th>
		<th>ISSN</th>
		<th>Series</th>
		<th>Abbr. Title</th>
		<th>Name Results</th>
		<th>ISSN Results</th>
		<th>ABBR Title Results</th>
	</tr>
</thead>
<tbody>
<cfoutput query="get_journals">
<cfif currentrow mod 2 is 1>
	<cfset class="alt_row">
<cfelse>
	<cfset class="regular_row">
</cfif>
	<tr class="#class#">
		<td><input type="radio" name="master_entry" id="master_entry[#currentrow#]" value="#JournalID#" /></td>
		<td><input type="checkbox" name="same_as_entry" id="same_as_entry[#currentrow#]" value="#JournalID#" /></td>
		<td style="vertical-align:top;">#title#<input name="new_title_#currentrow#" size="45" /></td>
		<td style="vertical-align:top;">#JournalID#<br /><cfif TaxonomerID is not "">#TaxonomerID#<cfelse>[blank]</cfif></td>
		<cfset current_journalid = JournalID>
		<td style="vertical-align:top;">#issn#<input name="new_issn_#currentrow#"></td>
		<td style="vertical-align:top;">#series#<input name="new_series_#currentrow#" size="45" /></td>
		<td style="vertical-align:top;">#AbbreviatedTitle#<input name="new_abbrtitle_#currentrow#" size="45" /></td>
		<cfquery name="get_journal_matches_by_title" datasource="#datasource#">
			SELECT title,JournalID,issn,series,AbbreviatedTitle,TaxonomerID
			FROM  TEMP_Dirty_MasterJournals
			WHERE title = '#title#' and (TaxonomerID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#TaxonomerID#"> OR TaxonomerID is null)
		</cfquery>
		<td style="vertical-align:top;">#get_journal_matches_by_title.recordcount# additional exact matches by title
			<table border=1>
				<thead>
				<tr class=cellxsm>
					<th>ID</th>
					<th>ISSN</th>
					<th>Series</th>
				</tr>
				</thead>
				<tbody>
				<cfoutput query="get_journal_matches_by_title">
				<tr class=cellxsm>
					<td<cfif get_journal_matches_by_title.JournalID is current_journalid> class="active_section"</cfif>>#get_journal_matches_by_title.JournalID#<br />
					#get_journal_matches_by_title.TaxonomerID#</td>
					<td>#get_journal_matches_by_title.issn#</td>
					<td>#get_journal_matches_by_title.series#</td>
				</tr>
				</cfoutput>
				</tbody>
			</table>
		</td>
		<cfif ISSN is not "">
			<cfquery name="get_journal_matches_by_issn" datasource="#datasource#">
				SELECT title,JournalID,issn,AbbreviatedTitle,TaxonomerID
				FROM  TEMP_Dirty_MasterJournals
				WHERE issn = '#issn#'  and (TaxonomerID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#TaxonomerID#"> OR TaxonomerID is null)
			</cfquery>
			<td style="vertical-align:top;">#get_journal_matches_by_issn.recordcount# additional exact matches by issn
				<table border=1>
					<thead>
					<tr class=cellxsm>
						<th>ID</th>
						<th>Title</th>
						<th>Abbr Title</th>
					</tr>
					</thead>
					<tbody>
					<cfoutput query="get_journal_matches_by_issn">
					<tr class=cellxsm>
						<td<cfif get_journal_matches_by_issn.JournalID is current_journalid> class="active_section"</cfif>>#get_journal_matches_by_issn.JournalID#</td>
						<td>#get_journal_matches_by_issn.title#</td>
						<td>#get_journal_matches_by_issn.AbbreviatedTitle#</td>
					</tr>
					</cfoutput>
					</tbody>
				</table>
			</td>
		<cfelse>
			<td>[BLANK]</td>
		</cfif>	
		<cfif AbbreviatedTitle is not "">
			<cfquery name="get_journal_matches_by_abbr_title" datasource="#datasource#">
				SELECT title,JournalID,issn,AbbreviatedTitle,TaxonomerID
				FROM  TEMP_Dirty_MasterJournals
				WHERE AbbreviatedTitle = '#AbbreviatedTitle#'  and (TaxonomerID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#TaxonomerID#"> OR TaxonomerID is null)
			</cfquery>
			<td style="vertical-align:top;">#get_journal_matches_by_abbr_title.recordcount# additional exact matches by abbreviated title
				<table border=1>
					<thead>
					<tr class=cellxsm>
						<th>ID</th>
						<th>Title</th>
						<th>ISSN</th>
					</tr>
					</thead>
					<tbody>
					<cfoutput query="get_journal_matches_by_abbr_title">
					<tr class=cellxsm>
						<td<cfif get_journal_matches_by_abbr_title.JournalID is current_journalid> class="active_section"</cfif>>#get_journal_matches_by_abbr_title.JournalID#</td>
						<td>#get_journal_matches_by_abbr_title.title#</td>
						<td>#get_journal_matches_by_abbr_title.issn#</td>
					</tr>
					</cfoutput>
					</tbody>
				</table>
			</td>
		<cfelse>
			<td>[BLANK]</td>
		</cfif>
	</tr>
</cfoutput>
</tbody>
</table>
<input type="hidden" name="action" value="update_records" />
<cfif IsDefined("search_term")>
	<cfoutput><input type="hidden" name="search_term" value="#search_term#" /></cfoutput>
</cfif>
<button type="submit">Make Changes</button>
</form>
<cfinclude template="/footer.cfm">