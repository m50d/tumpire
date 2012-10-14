<?python
layout_params['page_title'] = 'Add report'
from tumpire.model import Event
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<p>Click an event to add a report to:</p>
<span py:for="e in Event.select(orderBy='datetime')"><a href="${tg.url('/addreport/'+str(e.id))}">${e}</a> <br /></span>
</div>
</html>
