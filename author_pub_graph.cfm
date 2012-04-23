<cfsilent>
<cfinvoke component="gnub_services" method="get_reference" returnvariable="reference_results">
	<cfinvokeargument name="AuthorUUIDList" value="#search_term#">
</cfinvoke>

<!---<cfdump var="#reference_results#">
<cfabort>--->
<cfif reference_results.recordcount is 0>
	<cfabort>
</cfif>

<cfset years = ValueList(reference_results.numericYear)>
<cfset years = ListSort(years,"numeric","asc")>
<cfset years = Replace(years,",,",",","ALL")>
<!---get the oldest year--->
<cfset least_recent = ListFirst(years)>
<!---get the most recent year--->
<cfset most_recent = ListLast(years)>
<!---<cfoutput>
#years# #most_recent# #least_recent#
ABORT

</cfoutput>


<cfabort>--->
<!---
<cfoutput>
#years#
</cfoutput>
<cfabort>
<cfquery dbtype="query" name="min_year">
	SELECT min([year]) as minyear
	FROM reference_results
	WHERE [year] IS NOT NULL <!---AND [year] BETWEEN 1500 AND 2500--->
	
	<!---select min([year]) as minYear
	from reference_results
	where [year] BETWEEN 1500 AND 2500
	AND [year] IS NOT NULL--->
</cfquery>

<cfquery dbtype="query" name="max_year">
	select max([year]) as maxYear
	from reference_results
	where [year] BETWEEN 1500 AND 2500
	AND [year] IS NOT NULL
</cfquery>

<!---get the oldest year--->
<cfset least_recent = min_year.minYear>

<!---get the most recent year--->
<cfset most_recent = max_year.maxYear>
--->

<cfset end_year = DateFormat(Now(),"yyyy")>
<cfset range_span = 50>
<cfset start_year = "#Left(end_year-range_span,3)#0">

<cfif least_recent lt start_year>
	<cfset start_year = "#Left(least_recent,3)#0">
	<cfset end_year = start_year+range_span>
	<cfif most_recent gt end_year>
		<cfset end_year = most_recent>
	</cfif>
</cfif>
<!---
<cfif least_recent lt 1960 and least_recent gte 1910>
	<cfset start_year = 1910>
	<cfset end_year = most_recent>
<cfelseif least_recent lt 1910 and least_recent gte 1860>
	<cfset start_year = 1860>
	<cfset end_year = most_recent>
<cfelseif least_recent lt 1860 and least_recent gte 1810>
	<cfset start_year = 1810>
	<cfset end_year = most_recent>
<cfelseif least_recent lt 1810 and least_recent gte 1760>
	<cfset start_year = 1760>
	<cfset end_year = most_recent>
</cfif>--->
<cfset chart_width = 550>
<cfset chart_height = 25>
<!---<cfif end_year-start_year gt 61>
	<cfset chart_width = 800>
</cfif>--->
<cfset start_year = 1750>
<cfset end_year = DateFormat(Now(),"yyyy")>
<cfset chart_path = 'http://chart.apis.google.com/chart?chf=bg,s,F5F5FF&chxl=0:|'>
<cfset chxl = "0:|">
<cfloop from="#start_year#" to="#end_year#" step="5" index="decade">
	<cfset x_axis_label = "">
	<!---<cfif decade is start_year>
		<cfset x_axis_label = start_year>
	<cfelseif decade gte end_year-5>
		<cfset x_axis_label = end_year>
	</cfif>--->
	<cfset chxl = "#chxl##x_axis_label#|">
	<cfset chart_path = "#chart_path##x_axis_label#|">
</cfloop>

<cfset chart_path = "#chart_path#&chxr=0,#start_year#,#end_year#&chxs=0,676767,9,0,l,676767&chxt=x&chbh=a&chs=#chart_width#x#chart_height#&cht=bvg&chco=3072F3&chds=0,30&chd=t:0">
<cfset chd = "t:0">
<cfset max_pub_count = 0>
<cfloop from="#start_year#" to="#end_year#" step="5" index="curYear">
	<cfquery dbtype="query" name="year_count">
		select count([year]) as number_pubs from reference_results	
		where [year] >= #curYear# and [year] < #curYear+5#
	</cfquery>
	<cfif year_count.number_pubs gt 0>
		<cfset entry_value=year_count.number_pubs>
		<cfif year_count.number_pubs gt max_pub_count>
			<cfset max_pub_count = year_count.number_pubs>
		</cfif>
	<cfelse>
		<cfset entry_value=0>
	</cfif>
	<cfset chd = "#chd#,#entry_value#">
	<cfset chart_path = "#chart_path#,#entry_value#">
</cfloop>
<cfset chart_path = "#chart_path#&chdlp=b&chma=2,2,2,5|10">
<cftry>
	<cffile action="delete" file="H:\chart.png">
	<cfcatch></cfcatch>
</cftry>



<cfhttp
    timeout="45"
    throwonerror="false"
    url="http://chart.apis.google.com/chart"
    method="get"
    useragent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0"
    getasbinary="yes"
    result="local.objGet">
<!--- 
	path="H:\chart.png"
<cfhttp URL="http://chart.apis.google.com/chart" useragent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2"
getasbinary="yes"
result="objHttp">--->
	<cfhttpparam name="chf" value="a,s,00000023|bg,s,F5F5FF" type="url">
	<cfhttpparam name="chxl" value="#chxl#" type="url">
	<cfhttpparam name="chxr" value="0,#start_year#,#end_year#" type="url">
	<cfhttpparam name="chxs" value="0,676767,9,0,l,676767" type="url">
	<cfhttpparam name="chxt" value="x" type="url">
	<cfhttpparam name="chbh" value="a" type="url"><!---a = automatic vs. 25,10,2--->
	<cfhttpparam name="chs" value="#chart_width#x#chart_height#" type="url">
	<cfhttpparam name="cht" value="bvg" type="url">
	<cfhttpparam name="chco" value="3072F3" type="url">
	<cfhttpparam name="chds" value="0,#max_pub_count#" type="url">
	<cfhttpparam name="chd" value="#chd#" type="url">
	<cfhttpparam name="chdlp" value="b" type="url">
	<cfhttpparam name="chma" value="1,1,1,1|4,0" type="url">
</cfhttp>

<cfset myImage = ImageNew(local.objGet.fileContent) /> 

<!--- Set new text attributes. ---> 
<cfset image_width = ImageGetwidth(myImage)>
<cfset attr = StructNew()> 
<cfset attr.style="plain" /><!---    bold    italic    boldItalic    plain (default)  --->
<cfset attr.size="9" /> 
<cfset attr.font="verdana" /> 
<cfset attr.underline="no" /> 
<cfset ImageSetDrawingColor(myImage,"636363") />
<cfset ImageDrawText(myImage,start_year,0,10,attr) />
<cfset ImageDrawText(myImage,end_year,image_width-30,10,attr) /> 
<cfset finalImage = ImageGetBufferedImage(myImage) /> 

<cfset baos  = createObject("java", "java.io.ByteArrayOutputStream").init() /> 

<cfset imgio=CreateObject("java", "javax.imageio.ImageIO") /> 
<cfset imgio.write(finalImage, "PNG", baos) /> 

</cfsilent><cfoutput><cfheader
	statuscode="200"
	statustext="ok"
	/><cfcontent type="image/png" variable="#baos.toByteArray()#"></cfoutput>
<cfabort>
<!---DONE--->












<!---





<cfcontent type="image/png" variable="#local.objGet.fileContent#">


<cfcontent type="image/png" file="H:\chart.png" variable="temp_image" reset="yes">
<cfset local.objImage = ImageNew(local.objGet.FileContent)>
#local.objGet.MimeType#
#chart_path#<cfdump var="#objHttp.FileContent#">
<img src="#local.objImage#" />
<cffile action="readbinary" file="#chart_path#" variable="#objImage#">
<!---given an author UUID--->
<cfparam name="authorIDList" default="19670408"><!--- JER: 24E58859-FF5A-431B-9127-F0584680EA71 --->


<!---fetch all the publications--->
<cfinvoke component="gnub_services" method="get_reference" returnvariable="author_pubs">
	<cfinvokeargument name="AuthorIDList" value="#authorIDList#">
</cfinvoke>







<!---<cfdump var="#author_pubs#">--->
<cfquery dbtype="query" name="min_year">
	select min([year]) as minYear
	from author_pubs
</cfquery>

<cfquery dbtype="query" name="max_year">
	select max([year]) as maxYear
	from author_pubs
</cfquery>
<!---organize by year of publication--->
<cfquery dbtype="query" name="sorted_years">
	select [year] as curYear
	from author_pubs
	order by [year]
</cfquery>

<!---get the oldest year--->
<cfset least_recent = min_year.minYear>

<!---get the most recent year--->
<cfset most_recent = max_year.maxYear>

<cfset start_year = 1960>
<cfset end_year = 2012>

<cfif least_recent lt 1960>
	<cfset start_year = 1910>
	<cfset end_year = most_recent>
</cfif>





<!--- distribute across each year the number of pubs--->
<!---
<cfoutput query="sorted_years" group="curYear">
	<cfif IsNumeric(sorted_years.curYear)>
		<cfquery dbtype="query" name="year_count">
			select count([year]) as number_pubs
			from author_pubs
			where [year] = #curYear#
		</cfquery>
		#sorted_years.curYear# #year_count.number_pubs#<br>
	</cfif>
	<cfoutput></cfoutput>
</cfoutput>
<cfoutput>
<cfloop from="#start_year#" to="#end_year#" step="1" index="curYear">
	<cfquery dbtype="query" name="year_count">
		select count([year]) as number_pubs
		from author_pubs
		where [year] = #curYear#
	</cfquery>
	#curYear# #year_count.number_pubs#<br>			
</cfloop>
</cfoutput>--->

<cfoutput>
<img src="http://chart.apis.google.com/chart?chxl=0:|<cfloop from="#start_year#" to="#end_year#" step="5" index="decade">#decade#|</cfloop>&chxr=0,#start_year#,#end_year#&chxs=0,676767,9,0,l,676767&chxt=x&chbh=a&chs=440x40&cht=bvg&chco=3072F3&chds=0,30&chd=t:0<cfloop from="#start_year#" to="#end_year#" step="5" index="curYear"><cfquery dbtype="query" name="year_count">select count([year]) as number_pubs from author_pubs	where [year] >= #curYear# and [year] < #curYear+5#</cfquery>,<cfif year_count.number_pubs gt 0>#year_count.number_pubs#<cfelse>0</cfif></cfloop>&chdlp=b&chma=1,1,1,1|5" width="440" height="25" alt="" />
<!---http://chart.apis.google.com/chart?cht=bvs&chs=400x140&chbh=70&chd=s:9nb16&chtt=Products%20and%20Sales&chxt=x,y&chxl=0:|ColdFusion%208|Flash%20CS3|Flex%202|Rubber%20Chicken|Cream%20Pie|1:||49K--->
</cfoutput>


<!---make a cfchart with the results--->
<cfchart chartwidth="400" chartHeight="40" format="png" SHOWYGRIDLINES="no" SHOWBORDER="no" fontSize = "7" skipLabels="1">
	<!---<cfchartseries type="line" serieslabel="Year" markerstyle="circle" DATALABELANGLE="170" DATALABELFONTSIZE="5">
		<cfoutput query="sorted_years" group="curYear">
			<cfif IsNumeric(sorted_years.curYear)>
				<cfquery dbtype="query" name="year_count">
					select count([year]) as number_pubs
					from author_pubs
					where [year] = #curYear#
				</cfquery>
				<cfchartdata item="#sorted_years.curYear#" value="#year_count.number_pubs#">
			</cfif>
			<cfoutput></cfoutput>
		</cfoutput>
   </cfchartseries>--->
   <cfchartseries type="bar" serieslabel="Year" markerstyle="circle" DATALABELANGLE="170" DATALABELFONTSIZE="5" seriesColor="##012A4D">
		<cfloop from="#start_year#" to="#end_year#" step="5" index="curYear">
			<cfquery dbtype="query" name="year_count">
				select count([year]) as number_pubs
				from author_pubs
				where [year] >= #curYear# and [year] < #curYear+5#
			</cfquery>
			<cfif year_count.number_pubs gt 0>
				<cfchartdata item="#curYear#" value="#year_count.number_pubs#">	
			<cfelse>
				<cfchartdata item="#curYear#" value="0">
			</cfif>
		</cfloop>
   </cfchartseries>
</cfchart>
<cfabort>
<html>
  <head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Year');
        data.addColumn('number', 'Sales');
        data.addColumn('number', 'Expenses');
        data.addRows([
          ['2004', 1000, 400],
          ['2005', 1170, 460],
          ['2006', 660, 1120],
          ['2007', 1030, 540]
        ]);

        var options = {
          title: 'Company Performance',
          hAxis: {title: 'Year', titleTextStyle: {color: 'red'}}
        };

        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 900px; height: 500px;"></div>
  </body>
</html>--->