component name="TestPegdown" extends="mxunit.framework.TestCase" {

	public void function setUp()  {
		pegdown = new cfmarkdown.tag.cfmarkdown.cfc.Pegdown();
		projectRef="cfmlprojects/cfmarkdown";
		gitrefsURL="https://github.com";
	}

	public void function testCommitRefs()  {
		var content = "SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2 ";
		var markdown = pegdown.replaceCommitRefs(content, gitrefsURL, projectRef);
		var link = 'SHA: <a href="https://github.com/cfmlprojects/cfmarkdown/commit/be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2" class="commit-link"><tt>be6a8cc</tt></a> ';
		assertEquals(trim(link), trim(markdown));

		content = "User@SHA ref: cfmlprojects@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2 ";
		link = 'User@SHA ref: <a href="https://github.com/cfmlprojects/cfmarkdown/commit/be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2" class="commit-link">cfmlprojects@<tt>be6a8cc</tt></a> ';
		markdown = pegdown.replaceCommitRefs(content, gitrefsURL, projectRef);
		assertEquals(link, markdown);

		content = "User/Project@SHA: cfmlprojects/cfgit@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2 ";
		link = 'User/Project@SHA: <a href="https://github.com/cfmlprojects/cfgit/commit/be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2" class="commit-link">cfmlprojects/cfgit@<tt>be6a8cc</tt></a> ';
		markdown = pegdown.replaceCommitRefs(content, gitrefsURL, projectRef);
		assertEquals(link, markdown);
	}

	public void function testIssueRefs()  {
		var content = "\##Num: ##1 ";
		var markdown = pegdown.replaceIssueRefs(content, gitrefsURL, projectRef);
		var link = '##Num: <a href="https://github.com/cfmlprojects/cfmarkdown/issues/1" class="issue-link" title="GitHub Flavored Markdown Examples">##1</a> ';
		link=rereplace(link,' title=".*?"',"","all");
		markdown=rereplace(markdown,' title=".*?"',"","all");
		assertEquals(trim(link), trim(markdown));

		content = "User/##Num: cfmlprojects##1 ";
		link = 'User/##Num: <a href="https://github.com/cfmlprojects/cfmarkdown/issues/1" class="issue-link" title="GitHub Flavored Markdown Examples">cfmlprojects##1</a> ';
		markdown = pegdown.replaceIssueRefs(content, gitrefsURL, projectRef);
		link=rereplace(link,' title=".*?"',"","all");
		markdown=rereplace(markdown,' title=".*?"',"","all");
		assertEquals(link, markdown);

		content = "User/Project##Num: cfmlprojects/cfgit##1 ";
		link = 'User/Project##Num: <a href="https://github.com/cfmlprojects/cfgit/issues/1" class="issue-link" title="The server is not available (or you do not have permissions to access it)">cfmlprojects/cfgit##1</a> ';
		markdown = pegdown.replaceIssueRefs(content, gitrefsURL, projectRef);
		link=rereplace(link,' title=".*?"',"","all");
		markdown=rereplace(markdown,' title=".*?"',"","all");
		assertEquals(link, markdown);
	}

}