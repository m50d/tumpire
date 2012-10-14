<?python
from tumpire.model import Participant,User
layout_params['page_title'] = 'Edit Participant'
from sqlobject import SQLObjectNotFound
import turbogears
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<?python
if(not new):
	try:
		participant=Participant.get(id)
		event=participant.event
	except SQLObjectNotFound:
		turbogears.flash("Error: Tried to edit a nonexistent participant")
		raise turbogears.redirect(tg.url("/news"))
?>
<h3>Editing participant in ${event}</h3>
<form action="/saveparticipant" method="post">
<input type="hidden" name="new" value="${new}" />
<input py:if="not new" type="hidden" name="id" value="${id}" />
<input type="hidden" name="eid" value="${event.id}" />
Player: <span py:if="not new">${participant.player} <input type="hidden" name="player" value="${participant.player}" /></span>
<select py:if="new" name="player">
<option py:for="u in User.select(orderBy='user_name')" value="${u.user_name}">${u.user_name}</option>
</select>
<br />
<span py:if="not new">
Pseudonym: <select name="pseudonym">
<option py:for="n in participant.player.pseudonyms" value="${n}" py:attrs="n==participant.pseudonym and {'selected':'selected'} or {}">${n}</option>
</select>
</span>
<input type="submit" value="Update" />
</form>
</div>
</html>
