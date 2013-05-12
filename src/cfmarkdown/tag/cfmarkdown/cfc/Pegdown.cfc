component {
	/**
	 * https://github.com/sirthias/pegdown
	 **/
	function init() {
		return this;
	}

	String function markdownToHtml(String content, options ="all", deindent=false,
							projectRef="mojombo/github-flavored-markdown", gitrefsURL="https://github.com") {
		var sys = createObject("java","java.lang.System");
		var jThread = createObject("java","java.lang.Thread");
		var cTL = jThread.currentThread().getContextClassLoader();
   		classLoader = new LibraryLoader(getDirectoryFromPath(getMetaData(this).path) & "lib/").init();
		jThread.currentThread().setContextClassLoader(classLoader.GETLOADER().getURLClassLoader());
		try{
			var pegDownProcessor = classLoader.create("org.pegdown.PegDownProcessor");
			var CustomLinkRenderer = classLoader.create("CustomLinkRenderer");
			var Extensions = classLoader.create("org.pegdown.Extensions");
			var enabled = 0;
	        if (isEnabled("all", options)) {
	            enabled = bitOr(enabled,Extensions.ALL);
	            options = listAppend(options,"gitrefs");
	        }
			if (isEnabled("abbreviations", options)) {
	            enabled = bitOr(enabled,Extensions.ABBREVIATIONS);
	        }
	        if (isEnabled("autolinks", options)) {
	            enabled = bitOr(enabled,Extensions.AUTOLINKS);
	        }
	        if (isEnabled("definitions", options)) {
	            enabled = bitOr(enabled,Extensions.DEFINITIONS);
	        }
	        if (isEnabled("fencedCodeBlocks", options)) {
	            enabled = bitOr(enabled,Extensions.FENCED_CODE_BLOCKS);
	        }
	        if (isEnabled("hardwraps", options)) {
	            enabled = bitOr(enabled,Extensions.HARDWRAPS);
	        }
	        if (isEnabled("none", options)) {
	            enabled = bitOr(enabled,Extensions.NONE);
	        }
	        if (isEnabled("quotes", options)) {
	            enabled = bitOr(enabled,Extensions.QUOTES);
	        }
	        if (isEnabled("smarts", options)) {
	            enabled = bitOr(enabled,Extensions.SMARTS);
	        }
	        if (isEnabled("smartypants", options)) {
	            enabled = bitOr(enabled,Extensions.SMARTYPANTS);
	        }
	        if (isEnabled("suppressAllHtml", options)) {
	            enabled = bitOr(enabled,Extensions.SUPPRESS_ALL_HTML);
	        }
	        if (isEnabled("suppressHtmlBlocks", options)) {
	            enabled = bitOr(enabled,Extensions.SUPPRESS_HTML_BLOCKS);
	        }
	        if (isEnabled("suppressInlineHtml", options)) {
	            enabled = bitOr(enabled,Extensions.SUPPRESS_INLINE_HTML);
	        }
	        if (isEnabled("tables", options)) {
	            enabled = bitOr(enabled,Extensions.TABLES);
	        }
	        if (isEnabled("wikilinks", options)) {
	            enabled = bitOr(enabled,Extensions.WIKILINKS);
	        }
	        if (!isEnabled("preserveWhitespace", options) && deindent) {
	            content = deindentContent(content);
	        }
	        if (isEnabled("gitrefs", options)) {
	        	content = replaceCommitRefs(content, gitrefsURL, projectRef);
	        	content = replaceIssueRefs(content, gitrefsURL, projectRef);
	        }

        	content = rereplace(content,"([\S]+)@([^\.]+)","\1#chr(29)#\2","all")
	        var html = pegDownProcessor.init(javacast("int",enabled),javacast("long",3000))
	            .markdownToHtml(content,CustomLinkRenderer.init());
        	html = rereplace(html,"([\S]+)#chr(29)#([^\.]+)","\1@\2","all");

	        if (isEnabled("inline", options)) {
	            html = inlineSingleParagraph(html);
	        }
			//request.debug(markdownSource);
			return html;
		} catch (any e) {
			jThread.currentThread().setContextClassLoader(cTL);
			throw(e);
		} finally {
			jThread.currentThread().setContextClassLoader(cTL);
		}
	}

    String function deindentContent(String content) {
    	var newln = chr(13)&chr(10);
        var indent = refind("^\n(\s+)",content,0,true);
        indent = rereplace(left(content,indent.len[1]),"\r|\n","","all");
        var trimmed = rereplace(content,"\n#indent#",chr(10),"all");
        return trimmed;
    }

    Boolean function isEnabled(option,options) {
        return listFindNoCase(options,option);
    }

    String function inlineSingleParagraph(String html) {
        return html.replace("<p>", "").replace("</p>", "");
    }

    String function replaceCommitRefs(String content, gitrefsURL, projectRef) {
		content = rereplace(content,"(\s)([0-9a-f]{7})([0-9a-f]{0,33})?(\s)",'\1<a href="#gitrefsURL#/#projectRef#/commit/\2\3" class="commit-link"><tt>\2</tt></a>\4');
		var project = listLast(projectRef,"/");
		content = rereplace(content,"(\s)([\w]+)@([0-9a-f]{7})([0-9a-f]{0,33})?(\s)",'\1<a href="#gitrefsURL#/\2/#project#/commit/\3\4" class="commit-link">\2@<tt>\3</tt></a>\5');
		content = rereplace(content,"(\s)([\w/]+)@([0-9a-f]{7})([0-9a-f]{0,33})?(\s)",'\1<a href="#gitrefsURL#/\2/commit/\3\4" class="commit-link">\2@<tt>\3</tt></a>\5');
		return content;
    }

    String function replaceIssueRefs(String content, gitrefsURL, projectRef) {
		content = rereplace(content,"(?!\\)\s+##(\d+)",' <a href="#gitrefsURL#/#projectRef#/issues/\1" class="issue-link">##\1</a>');
		content = rereplace(content,"(?!\\)\s+(\w+)##(\d+)",' <a href="#gitrefsURL#/#projectRef#/issues/\2" class="issue-link">\1##\2</a>');
		content = rereplace(content,"(?!\\)\s+([\w/]+)##(\d+)",' <a href="#gitrefsURL#/\1/issues/\2" class="issue-link">\1##\2</a>');
		content = rereplace(content,"\\##",'##\1');
		return content;
    }

}