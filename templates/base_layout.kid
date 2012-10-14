<?python import sitetemplate?>
<html xmlns:py="http://purl.org/kid/ns#">
<head>
<title>Turbo Autoumpire: ${page_title}</title>
<script src="${tg.tg_js}/MochiKit.js" type="text/javascript" />
</head>
<body>
<h1>${page_title}</h1>
<div>
<p align="right">
<span py:if="tg.identity.anonymous"> <a href="${tg.url('/login')}">Login</a></span>
<span py:if="not tg.identity.anonymous">Logged in as ${tg.identity.user}. <a href="${tg.url('/addevent')}">Add Event</a> <a href="${tg.url('/addreportselevent')}">Add report</a> <a href="${tg.url('/edituser/'+tg.identity.user.user_name)}">Edit myself</a> <a href="${tg.url('/logout')}">Logout</a></span>
</p>
<p>
<a href="${tg.url('/index')}">Home</a> <a href="mailto:assassins@srcf.ucam.org">Email</a>
</p>
</div>
<div>
<p>
<a href="${tg.url('/news')}">Game News</a> <a href="${tg.url('/updates')}">Updates</a> Player List and Scores: <a href="${tg.url('/scoresrank')}">by rank</a> <a href="${tg.url('/scoresname')}">by name</a> <a href="${tg.url('/scorescollege')}">by college</a>
</p>
</div>
<h2>
<font color="orange">
<span id="status_block" class="flash" py:if="value_of('tg_flash', None)" py:content="tg_flash"></span>
</font>
</h2>
<content />
<p>
<a href="http://validator.w3.org/check?uri=referer">
<img src="http://www.w3.org/Icons/valid-html401" alt="Valid HTML 4.01 Transitional" height="31" width="88" />
</a>
</p>
</body>
</html>
