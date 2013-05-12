component {
	/**
	 * http://remark.overzealous.com/manual/usage.html
	 **/
	function init() {
		return this;
	}

	function htmlToMarkdown(String content, options ="") {
		var sys = createObject("java","java.lang.System");
		var jThread = createObject("java","java.lang.Thread");
		var cTL = jThread.currentThread().getContextClassLoader();
   		classLoader = new LibraryLoader(getDirectoryFromPath(getMetaData(this).path) & "lib/").init();
		jThread.currentThread().setContextClassLoader(classLoader.GETLOADER().getURLClassLoader());
		try{
			var RemarkOb = classLoader.create("com.overzealous.remark.Remark");
			var RemarkOptionsOb = classLoader.create("com.overzealous.remark.Options");

			// PHP Markdown Extra
			//markdownExtraRemark = new Remark(RemarkOptionsOb.markdownExtra());
			// MultiMarkdown
			//Remark multiMarkdownRemark = new Remark(RemarkOptionsOb.multiMarkdown());
			// Github Flavored Markdown
			//Remark githubMarkdown = new Remark(RemarkOptionsOb.github());
			// Pegdown with all extensions enabled
			var remark = RemarkOb.init(RemarkOptionsOb.pegdownAllExtensions());
			var markdown = remark.convertFragment(content);
			return markdown;
		} catch (any e) {
			jThread.currentThread().setContextClassLoader(cTL);
			throw(e);
		} finally {
			jThread.currentThread().setContextClassLoader(cTL);
		}
	}

    Boolean function isEnabled(option,options) {
        return listFindNoCase(options,option);
    }

    String function inlineSingleParagraph(String html) {
        return html.replace("<p>", "").replace("</p>", "");
    }

}