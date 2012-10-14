<?python
layout_params['page_title'] = 'Edit Pseudonym'
from tumpire.model import Pseudonym,User
from sqlobject import SQLObjectNotFound
import turbogears
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<?python
if(not new):
	try:
	        player=Pseudonym.get(int(id)).player
	except SQLObjectNotFound:
		turbogears.flash("Error: Tried to edit a nonexistent pseudonym")
		raise turbogears.redirect(tg.url("/scoresname"))
else:
	try:
	        player=User.get(int(playerid))
	except SQLObjectNotFound:
		turbogears.flash("Congratulations, you found the most impossible error ever. (Tried to edit a pseudonym for a nonexistent player)")
		raise turbogears.redirect(tg.url("/scoresname"))
?>
<h3>Editing pseudonym for ${player}</h3>
<form action="/savepseudonym" method="post">
<input type="hidden" name="new" value="${new}" />
Pseudonym: <input type="text" name="name" value="${(not new) and Pseudonym.get(int(id)).name or ''}" />
<input type="hidden" name="playerid" value="${player.id}" />
<input type="hidden" name="id" py:if="not new" value="${id}" />
<input type="submit" value="Update" />
</form>
</div>
</html>
