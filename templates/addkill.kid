<?python
layout_params['page_title'] = 'Add Kill'
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
If you wanted to add a kill of an innocent (i.e. nonplayer), go <a href="${tg.url('/addinnocentkill/'+str(event.id))}">here</a> instead.<br />
<form action="/savekill" method="post">
<input type="hidden" name="eid" value="${event.id}" />
Killer: <select name="killer">
<option py:for="p in event.participants" value="${p.player}" py:content="p.player" />
</select> <br />
Victim: <select name="victim">
<option py:for="p in event.participants" value="${p.player}" py:content="p.player" />
</select> <br />
<input type="submit" value="Update" />
</form>
</div>
</html>
