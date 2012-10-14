<?python
import string,datetime
from turbogears import identity
from tumpire.model import Kill
layout_params['page_title'] = 'Player List'
cols=["Name","Pseudonyms","Address","College","Water Status","Notes","Kills","Deaths","Score","Alive?"]
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<table>
<tr>
<th py:for="c in cols">${c}</th>
<th py:if="not tg.identity.anonymous">Edit</th>
</tr>
<tr py:for="x in players">
<td>${x}</td>
<td>${string.join([str(y) for y in x.pseudonyms]," AKA ")}</td>
<td>${x.address}</td>
<td>${x.college}</td>
<td>${x.water}</td>
<td>${x.notes}</td>
<td>${len(x.kills)}</td>
<td>${len(x.deaths)}</td>
<td>${x.score}</td>
<?python
flag = True
for k in Kill.select():
	if(k.victim==x and k.event.datetime < datetime.datetime.now() and k.event.datetime >= (datetime.datetime.now() - datetime.timedelta(0,14400))):
		flag = False
?>
<td>${flag and 'yes' or 'no'}</td>
<td py:if="str(tg.identity.user)==str(x) or identity.in_group('admin')">
<a href="${tg.url('/edituser/'+str(x))}">Edit</a>
</td>
</tr>
</table>
<a py:if="identity.in_group('admin')" href="${tg.url('/adduser')}">Add User</a>
</div>
</html>
