<cfhttp url="http://freecite.library.brown.edu/citations/create" method="post" result="citation_parsed" redirect="yes" userAgent="Accept:text/xml">
	<cfhttpparam type="formField" name="citation" value="Udvarhelyi, I.S., Gatsonis, C.A., Epstein, A.M., Pashos, C.L., Newhouse, J.P. and McNeil, B.J. Acute Myocardial Infarction in the Medicare population: process of care and clinical outcomes. Journal of the American Medical Association, 1992; 18:2530-2536.">
	<cfhttpparam type="formField" name="Accept" value="text/xml">
</cfhttp>

<cfdump var="#citation_parsed#">