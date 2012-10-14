<?python
layout_params['page_title'] = 'Edit Player'
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match="item.tag == 'content'">
<form action="/saveuser" method="post">
<input type="hidden" name="oldname" value="${(not new) and user.user_name or ''}" />
Name: <input type="text" name="name" value="${(not new) and user.user_name or ''}" py:attrs="(not new) and {'readonly':'readonly'} or {}" /> <br />
Address: <input type="text" name="address" value="${(not new) and user.address or ''}" /> <br />
College or Department: <input type="text" name="college" value="${(not new) and user.college or ''}" /> <br />
Water Status: <select name="water">
<option py:for="s in ['No Water', 'Water With Care', 'Full Water']" value="${s}" py:attrs="(not new and user.water==s) and {'selected':'selected'} or {}">${s}</option>
</select> <br />
Player Notes: <input type="text" name="notes" value="${(not new) and user.notes or ''}" /> <br />
Email Address: <input type="text" name="email" value="${(not new) and user.email_address or ''}" /> <br />
Score Adjustment: <input type="text" name="adjustment" value="${(not new) and user.adjustment or '0.0'}" py:attrs="(not 'admin' in tg.identity.groups) and {'readonly':'readonly'} or {}" /> <br />
New Password: <input type="text" name="password" /> <br />
<input type="submit" value="Update" />
</form>
<div py:if="not new">
<h3>Pseudonyms</h3>
<ul>
<li py:for="x in user.pseudonyms">
${x}
<a py:if="str(x)!=str(user)" href="${tg.url('/editpseudonym/'+str(x.id))}">
Edit
</a>
</li>
</ul>
<a href="${tg.url('/addpseudonym/'+str(user.id))}">Add new</a>
</div>
</div>
</html>
