<!--- Get the feed data as a query --->
<cfquery name="get_feed_content" datasource="zoobank" username="deepreef" password="ocbeeb">
	select * from view_ZooBankRSS
</cfquery>

<!--- Map the column names (tell cffeed which column to use for which item in the feed) --->
<cfset columnMapStruct = StructNew()>
<cfset columnMapStruct.publisheddate = "PUBLISHEDDATE">
<cfset columnMapStruct.content = "CONTENT">
<cfset columnMapStruct.link = "LINKHREF">
<cfset columnMapStruct.title = "TITLE">
<cfset columnMapStruct.id = "LSID">

<!--- Set the feed metadata. --->
<cfset meta.title = "Latest ZooBank Registration Activity">
<cfset meta.link = "http://zoobank.org/">
<cfset meta.description = "RSS feed of the 100 most-recently Registered Authors, Publications and Nomenclatural Acts within ZooBank.">
<cfset meta.version = "rss_2.0">
<cfset meta.language = "en-us">
<cfset meta.lastBuildDate = Now()>
<cfset meta.managingEditor = "zoobank@bishopmuseum.org">
<!--- <cfset meta.webMaster = "Richard L. Pyle"> Should be email address of webmaster --->

<cfdump var="#get_feed_content#">

<!--- Create the feed by passing the query name and structures created above. --->
<cffeed action="create"
    query="#get_feed_content#"
    properties="#meta#"
    columnMap="#columnMapStruct#"
    xmlvar="rssXML"
	overwrite="true"
	outputFile ="f:\inetpub\wwwroot\rss\rss.xml">
<cfdump var="#XMLParse(rssXML)#">

<!---
<?xml version="1.0" encoding="UTF-8"?>

<channel>
    
<title>NPR Topics: News</title>
    
<link>http://www.npr.org/templates/story/story.php?storyId=1001&amp;ft=1&amp;f=1001</link>
    
<description>NPR 
news, audio, and podcasts. Coverage of breaking stories, national and world news, politics, business, science, 
technology, and extended coverage of major national and world events.</description>
    
<language>en</language>
    
<copyright>Copyright 2011 NPR - For Personal Use Only</copyright>
    
<generator>NPR API RSS Generator 
0.94</generator>
    
<lastBuildDate>Mon, 28 Mar 2011 22:42:00 -0400</lastBuildDate>
    
<image>
      
	<url>http://media.npr.org/images/npr_news_123x20.gif</url>
      
	<title>News</title>
      
	<link>http://www.npr.org/templates/story/story.php?storyId=1001&amp;ft=1&amp;f=1001</link>
    
</image>
    
<item>
  
    <title>Carter Visits Cuba Amid Dispute Over Contractor</title>
      
	<description>The former president met with leaders of Cuba's Jewish community  but did not say whether he mentioned the case of Alan Gross, who was  arrested in December 2009 while working on a USAID-backed  democracy-building project he said was meant to help improve internet  access for that community.
	</description>
      <pubDate>Mon, 28 Mar 2011 22:42:00 -0400</pubDate>
	<link>http://www.npr.org/2011/03/28/134938827/carter-visits-cuba-amid-dispute-over-contractor?ft=1&amp;f=1001</link>
      
<guid>http://www.npr.org/2011/03/28/134938827/carter-visits-cuba-amid-dispute-over-contractor?ft=1&amp;f=1001</guid>
      
	<content:encoded><![CDATA[<p>The former president met with leaders of Cuba's Jewish community  but did not say 
whether he mentioned the case of Alan Gross, who was  arrested in December 2009 while working on a USAID-backed  
democracy-building project he said was meant to help improve internet  access for that community.</p><p><a 
href="http://www.npr.org/templates/email/emailAFriend.php?storyId=134938827">&raquo; E-Mail 
This</a>&nbsp;&nbsp;&nbsp;&nbsp; <a 
href="http://del.icio.us/post?url=http%3A%2F%2Fwww.npr.org%2Ftemplates%2Fstory%2Fstory.php%3FstoryId%3D134938827">&r
aquo; Add to Del.icio.us</a></p>]]>
</content:encoded>
    
</item>
    

 </channel>
</rss>


<!--  Burned on demand at 2011-03-28 22:59:17-->

<!-- LIVE -->

<!-- Burned 
03/28/2011 22:59:17.675-->


--->

