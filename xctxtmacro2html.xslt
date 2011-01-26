<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

<xsl:template match="/plist/array">
	<html>
		<head>
			<title>Xcode Objective-C Text Macro Cheat Sheet</title>
			<style type='text/css'>

				body, td {
					font-family: sans-serif;
					font-size: 10pt;
				}

				.code {
					font-family: monospace;
					white-space: pre;
					font-size: 9pt;
				}

				td.shortcut {
					text-align: center;
				}
				
				td.xcode {
					font-style: italic;
					font-weight: normal;
				}
				
				td.user {
					font-style: normal;
					font-weight: bold;
				}
				
				td, th {
					padding: 2px;
					vertical-align: top;
				}
				
				td {
					border: 1px solid #ddd;
				}
				
				th {
					background-color: #ddd;
					text-align: left;
					border: 1px solid #999;
					padding-right: 10px;
				}
				
				table {
					border-collapse: collapse;
				}
				
				span.sort:after {
					font-family: monospace;
					content: "&#160;&#160;";
				}

				span.desc:after {
					content: "&#160;˄";
				}

				span.asc:after {
					content: "&#160;˅";
				}
				
			</style>
			<xsl:text disable-output-escaping="yes"> 
			<![CDATA[ 
			<script type="text/javascript">
				function changesort() {
					var span=event.target;
					if(span.tagName!="SPAN") span=span.getElementsByTagName("SPAN")[0];
					
					var headerrow=document.getElementById("headerrow");
					var tbody=headerrow.parentNode;
					var datarows=[];
					var elements=tbody.getElementsByTagName("TR");
					for(var i=elements.length-1 ; i>0 ; i--) {
						datarows.push(elements[i]);
						tbody.removeChild(elements[i]);
					}
					
					if(span.className.match(/\basc\b/)) {
						span.className="sort desc";
					}
					else if(span.className.match(/\bdesc\b/)) {
						span.className="sort asc";
					}
					else {
						var column=0;
						elements=headerrow.getElementsByTagName("span");
						for(var i=0 ; i<elements.length ; i++) {
							if(elements[i]==span) {
								column=i;
								span.className="sort asc";
							}
							else {
								elements[i].className="sort";
							}
						}
						
						datarows.sort(function(a,b){
							var texta=a.getElementsByTagName("TD")[column].innerText;
							var textb=b.getElementsByTagName("TD")[column].innerText;
							var result=0;
							if(texta<textb) result=-1;
							if(texta>textb) result=1;
							console.log("A=\""+texta+"\" B=\""+textb+"\" result="+result);
							return result;
						});
					}
					
					for(var i=0 ; i<datarows.length ; i++) {
						tbody.appendChild(datarows[i]);
					}
				}
			</script>
			]]>
		</xsl:text>
		</head>
		<body>
		
			<h1>Xcode Text Macro Cheat Sheet</h1>
			<p>This is a sample. See this page to make your own cheat sheet: <a href='http://github.com/liyanage/xcode-text-macros/'>http://github.com/liyanage/xcode-text-macros/</a></p>
			<table>
			<tr id="headerrow">
				<th onclick="changesort()"><span class="sort asc">Name</span></th>
				<th onclick="changesort()"><span class="sort">Completion Prefix</span></th>
				<th onclick="changesort()"><span class="sort">Shortcut</span></th>
				<th onclick="changesort()"><span class="sort">Cycle List</span></th>
				<th onclick="changesort()"><span class="sort">Macro File</span></th>
				<!--<th>Code</th>-->
			</tr>
			<xsl:apply-templates select="dict[string[preceding-sibling::key[1][. = 'IsMenuItem']][. = 'YES']]">
				<xsl:sort select="@name_lc" data-type="text" order="ascending"/>
			</xsl:apply-templates>
			</table>
		</body>
	</html>
</xsl:template>

<xsl:template match="dict">
	<tr>
		<td><xsl:value-of select="string[preceding-sibling::key[1][. = 'Name']]"/></td>
		<td class='code'><xsl:value-of select="string[preceding-sibling::key[1][. = 'CompletionPrefix']]"/></td>
		<td class='shortcut'><xsl:value-of select="@shortcut"/></td>
		<td><xsl:apply-templates select = 'array[preceding-sibling::key[1][. = "CycleList"]]/string' mode='cyclelist'/></td>
		<td class="{@defined_by}"><xsl:value-of select="@macrofile"/></td>
		<!--
		<td class='code'>
			<xsl:apply-templates select='string[preceding-sibling::key[1][. = "TextString"]]'/>
		</td>
		-->
	</tr>
	
</xsl:template>

<xsl:template match='string' mode='cyclelist'>
	<xsl:value-of select="//dict[string[preceding-sibling::key[1][. = 'Identifier']] = current()]/string[preceding-sibling::key[1][. = 'Name']]"/><br/>
</xsl:template>



</xsl:stylesheet>