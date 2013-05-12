<cfcomponent displayname="TestInstall"  extends="mxunit.framework.TestCase">

	<cfimport taglib="/cfmarkdown/tag/cfmarkdown" prefix="gm" />

	<cffunction name="setUp" returntype="void" access="public">
		<cfset datapath = "#getDirectoryFromPath(getMetadata(this).path)#../../data" />
		<cfset markdowndir = "#getDirectoryFromPath(getMetadata(this).path)#../../data/markdowndir" />
		<cfset directoryExists(markdowndir) ? "" : directoryCreate(markdowndir) />
 	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">
		<cfset directoryDelete(markdowndir,true) />
	</cffunction>

	<cffunction name="testMarkdownToHtml">
		<gm:markdown action="markdownToHtml" content="_hello_"/>
		<cfset assertEquals("<p><em>hello</em></p>", trim(markdown)) />
		<gm:markdown action="markdownToHtml" content="_hello_" options="inline" />
		<cfset assertEquals("<em>hello</em>", trim(markdown)) />
		<gm:markdown action="markdownToHtml" content="**hello**" />
		<cfset assertEquals("<p><strong>hello</strong></p>", trim(markdown)) />
	</cffunction>

	<cffunction name="testGFMToHtml">
		<cffile action="read" file="/tests/data/gfm.md" variable="gfm_md">
		<cffile action="read" file="/tests/data/gfm.html" variable="gfm_html">
		<gm:markdown action="markdownToHtml" content="#gfm_md#"/>
		<!--- <cffile action="write" file="/tests/data/gfm.html" output="#deobfuscateEmails(markdown)#" addnewline="false"> --->
		<cfset assertEquals(gfm_html, deobfuscateEmails(markdown)) />
	</cffunction>

	<cffunction name="deobfuscateEmails" access="private" returntype="string" output="no">
	    <cfargument name="str" type="string" required="Yes" />
		<cfscript>
			StrEscUtils = createObject("java", "org.apache.commons.lang.StringEscapeUtils");
			var matches = rematch('a href="mailto:.*?/a',str);
			for(var m in matches) {
				str = replace(str,m,StrEscUtils.unescapeHTML(m));
			}
			return (str);
		</cfscript>
	</cffunction>

	<cffunction name="testHtmlToMarkdown">
		<gm:markdown action="markdownToHtml" content="_hello_"/>
		<cfset assertEquals("<p><em>hello</em></p>", trim(markdown)) />
		<gm:markdown action="htmlToMarkdown" content="#markdown#" />
		<cfset assertEquals("*hello*", trim(markdown)) />

		<gm:markdown action="markdownToHtml" content="## hello"/>
		<cfset assertEquals("<h1>hello</h1>", trim(markdown)) />
		<gm:markdown action="htmlToMarkdown" content="#markdown#" />
		<cfset assertEquals("## hello ##", trim(markdown)) />

		<gm:markdown action="markdownToHtml">
			this is a heading
			=================
		</gm:markdown>
		<cfset assertEquals("<h1>this is a heading</h1>", trim(markdown)) />
		<gm:markdown action="htmlToMarkdown" content="#markdown#" />
		<cfset assertEquals("## this is a heading ##", trim(markdown)) />

	</cffunction>

	<cffunction name="testPreserveWhitespace" output="true">
		<gm:markdown action="markdownToHtml" options="preserveWhitespace">
			this should be code because of spaces
			====================================
		</gm:markdown>
		<cfset debug(markdown)>
		<cfset assertEquals("<pre><code>thisshouldbecodebecauseofspaces====================================</code></pre>", rereplace(markdown,"\r|\n|\s","","all")) />

		<gm:markdown action="markdownToHtml">
			this should be a heading because it is deindented
			====================================
		</gm:markdown>
		<cfset debug(markdown)>
		<cfset assertEquals("<h1>this should be a heading because it is deindented</h1>", markdown) />
	</cffunction>

	<cffunction name="testLists" output="true">
		<gm:markdown action="markdownToHtml">
		    *   Candy.
		    *   Gum.
		    *   Booze.
		</gm:markdown>
		<cfset assertEquals("<ul><li>Candy.</li><li>Gum.</li><li>Booze.</li></ul>", rereplace(markdown,"\r|\n|\s","","all")) />
		<gm:markdown action="markdownToHtml">
		    +   Candy.
		    +   Gum.
		    +   Booze.
		</gm:markdown>
		<cfset assertEquals("<ul><li>Candy.</li><li>Gum.</li><li>Booze.</li></ul>", rereplace(markdown,"\r|\n|\s","","all")) />
		<gm:markdown action="markdownToHtml">
		    -   Candy.
		    -   Gum.
		    -   Booze.
		</gm:markdown>
		<cfset assertEquals("<ul><li>Candy.</li><li>Gum.</li><li>Booze.</li></ul>", rereplace(markdown,"\r|\n|\s","","all")) />

		<gm:markdown action="markdownToHtml">
		    1.  Red
		    2.  Green
		    3.  Blue
		</gm:markdown>
		<cfset assertEquals("<ol><li>Red</li><li>Green</li><li>Blue</li></ol>", rereplace(markdown,"\r|\n|\s","","all")) />

		<gm:markdown action="markdownToHtml">
		    *   A list item.

		        With multiple paragraphs.

		    *   Another item in the list.
		</gm:markdown>
		<cfset assertEquals("<ul><li><p>Alistitem.</p><p>Withmultipleparagraphs.</p></li><li><p>Anotheriteminthelist.</p></li></ul>", rereplace(markdown,"\r|\n|\s","","all")) />

	</cffunction>

</cfcomponent>
