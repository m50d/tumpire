<?python
layout_params['page_title'] = 'Add Innocent Kill'
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<form action="/saveinnocentkill" method="post">
<input type="hidden" name="eid" value="${event.id}" />
Killer: <select name="killer">
<option py:for="p in event.participants" value="${p.player}" py:content="p.player" />
</select> <br />
Was the kill licit (e.g. because the innocent was bearing weapons)?: <select name="licit">
<option value="True">Yes, this was a licit kill</option>
<option value="False">No, this was an illicit kill which should be penalised</option>
</select> <br />
<input type="submit" value="Update" />
</form>
</div>
</html>
