<?python
from tumpire.model import User,Event,Report
from sqlobject import SQLObjectNotFound
import turbogears
layout_params['page_title'] = 'Edit Report'
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<?python
if(not new):
	try:
	        report=Report.get(id)
        	event=report.event
	except SQLObjectNotFound:
		turbogears.flash("Error: Tried to edit a nonexistant report")
		raise turbogears.redirect(tg.url("/news"))
player=tg.identity.user
if(player in (x.player for x in event.participants)):
        participant=[x for x in event.participants if x.player==player][0]
        participating=True
else:
        participating=False
?>
<h3>Editing report by ${player} on ${event}</h3>
<p>
<span py:if="participating">
Your pseudonym for this event is ${participant.pseudonym}. <a href="${tg.url('/editparticipant/'+str(participant.id))}">Change Pseudonym</a>
</span>
<span py:if="not participating">
You're not listed as a participant for this event. <a href="${tg.url('/saveparticipant?new=True&amp;eid=%d&amp;player=%s'%(event.id,player))}">Add yourself as a participant</a> to be able to choose a pseudonym.
</span>
(Warning: you will lose any changes you've made below).
</p>
<form action="/savereport" method="post">
Report text : <br />
Use real names for everyone involved; they will be automatically highlighted and/or replaced with pseudonyms. Leave two blank lines between paragraphs; fancier formatting can be done using <a href="http://docutils.sourceforge.net/docs/user/rst/quickstart.html">reStructuredText</a> <br />
<input type="hidden" name="new" value="${new}" />
<input py:if="not new" type="hidden" name="id" value="${id}" />
<input type="hidden" name="eid" value="${event.id}" />
<input type="hidden" name="player" value="${player}" />
<textarea name="text" rows="30" cols="80" py:content="not new and report.content or 'Enter your report here.'" />
<input type="submit" value="Update" />
</form>
</div>
</html>
