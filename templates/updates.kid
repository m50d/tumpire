<?python
layout_params['page_title'] = 'Game Updates'
from tumpire.model import User
from cgi import escape
def highlight(s,e):
    """Highlight names in the string s based on the event e"""
    for player in User.select():
        color='#006400'
	name=str(player)
	for k in e.kills:
	    if(str(k.killer)==name):
	        color='#7FFF00'
        for k in e.kills:
	    if(str(k.victim)==name):
	        color='#DC143C'
	for i in e.participants:
	    if(str(i.player)==name):
	        name=escape(str(i.pseudonym))
        s=s.replace(str(player),"<font color=\"%s\">%s</font>"%(color,name))
    return s
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<div py:for="e in events">
[${e.datetime}] ${XML(highlight(escape(e.headline),e))} <br />
</div>
<p><a href="${tg.url('/updates?tg_format=json')}">Headlines in JSON format</a> (could be useful for something like #assassinupdates)</p>
</div>
</html>
