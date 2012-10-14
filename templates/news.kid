<?python
layout_params['page_title'] = 'Game News'
from tumpire.model import User
from cgi import escape
from docutils.core import publish_parts
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
<h2>[${e.datetime}] ${XML(highlight(escape(e.headline),e))}</h2>
<p py:for="r in e.reports">
${XML(highlight(escape(str(r.speaker)),e))} reports:
<br />
${XML(highlight(publish_parts(r.content,writer_name='html')['html_body'],e))}
<br />
<a py:if="not tg.identity.anonymous and r.speaker.user_name==tg.identity.user.user_name" href="${tg.url('/editreport/'+str(r.id))}">Edit my report</a>
</p>
<p py:if="not tg.identity.anonymous"><a href="${tg.url('/editevent/'+str(e.id))}">Edit Event</a> <a href="${'/addreport/'+str(e.id)}">Add Report</a> <a py:if="tg.identity.user.user_name in [x.player.user_name for x in e.participants]" href="${tg.url('/editparticipant/'+str([x.id for x in e.participants if x.player.user_name == tg.identity.user.user_name][0]))}">Change my pseudonym for this event</a> <a py:if="'admin' in tg.identity.groups" href="${tg.url('/deleteevent/'+str(e.id))}">Delete Event</a></p>
</div>
<p><a py:if="not tg.identity.anonymous" href="${tg.url('/addevent')}">Add Event</a></p>
</div>
</html>
