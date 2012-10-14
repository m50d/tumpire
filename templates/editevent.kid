<?python
from tumpire.model import Event
layout_params['page_title'] = 'Edit Event'
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<form action="/saveevent" method="get">
<?python
if(not new):
	event=Event.get(id)
?>
<input type="hidden" name="new" value="${new}" />
<input type="hidden" name="id" value="${(not new) and event.id or '0'}" />
Headline: <input type="text" name="headline" value="${(not new) and event.headline or ''}" /> <br />
Date/time (Format: 2008-06-11 17:53:00): <input type="text" name="timestamp" value="${(not new) and event.datetime or ''}" /> <br />
<input type="submit" value="Update" />
</form>
<div py:if="not new">
<h3>Participants</h3>
<span py:for="p in event.participants"> ${p.player} as ${p.pseudonym} <a href="${tg.url('/editparticipant/'+str(p.id))}">Change pseudonym</a> <br /></span>
<a href="${tg.url('/addparticipant/'+str(id))}">Add participant</a>
<h3>Kills</h3>
<span py:for="k in event.kills"> ${k.killer} killed ${k.victim}   <a href="${tg.url('/deletekill/'+str(k.id))}">Remove</a><br /></span>
<a href="${tg.url('/addkill/'+str(id))}">Add kill</a>
<h3>Innocent Kills</h3>
<span py:for="i in event.innocentkills"> ${i.killer} killed <span py:content="i.licit and 'a licit' or 'an illicit'"/> innocent. <a href="${tg.url('/deleteinnocentkill/'+str(i.id))}">Remove</a><br /></span>
<a href="${tg.url('/addinnocentkill/'+str(id))}">Add innocent kill</a>
<h3>Reports</h3>
<span py:for="r in event.reports">Report by ${r.speaker} <a href="${tg.url('/editreport/'+str(r.id))}" py:if="r.speaker==tg.identity.user">Edit</a> <br /></span>
<a href="${tg.url('/addreport/'+str(event.id))}" py:if="not tg.identity.anonymous">Add report</a>
</div>
</div>
</html>
