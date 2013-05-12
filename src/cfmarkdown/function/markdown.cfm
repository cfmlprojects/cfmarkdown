<cffunction name="markdown">
	<cfscript>
		var jm = createObject("WEB-INF.railo.customtags.cfmarkdown.cfc.markdown");
		var results = jm.runAction(arguments);
		return results;
	</cfscript>
</cffunction>