from turbogears import controllers, expose, flash, validate
from turbogears.validators import Int,StringBoolean,Number
# from model import *
from turbogears import identity, redirect,url
from cherrypy import request, response
from tumpire.model import User,Event,Pseudonym,Kill,Participant,Report,InnocentKill
from sqlobject import SQLObjectNotFound
import datetime,math
# from tumpire import json
# import logging
# log = logging.getLogger("tumpire.controllers")
epsilon=1e-7

class Root(controllers.RootController):
    @expose(template="tumpire.templates.index")
    # @identity.require(identity.in_group("admin"))
    def index(self):
        # log.debug("Happy TurboGears Controller Responding For Duty")
        #flash("Your application is now running")
        return {}
    @expose(template="tumpire.templates.rules")
    def rules(self):
        return {}
    @expose(template="tumpire.templates.weapons")
    def weapons(self):
        return {}
    @expose(template="tumpire.templates.changes")
    def changes(self):
        return {}
    @expose(template="tumpire.templates.rulings")
    def rulings(self):
        return {}
    @expose(template="tumpire.templates.scoring")
    def scoring(self):
        return {}

    @expose(template="tumpire.templates.login")
    def login(self, forward_url=None, previous_url=None, *args, **kw):

        if not identity.current.anonymous \
            and identity.was_login_attempted() \
            and not identity.get_identity_errors():
            raise redirect(forward_url)

        forward_url=None
        previous_url= request.path

        if identity.was_login_attempted():
            msg=_("The credentials you supplied were not correct or "
                   "did not grant access to this resource.")
        elif identity.get_identity_errors():
            msg=_("You must provide your credentials before accessing "
                   "this resource.")
        else:
            msg=_("Please log in.")
            forward_url= request.headers.get("Referer", "/")
            
        response.status=403
        return dict(message=msg, previous_url=previous_url, logging_in=True,
                    original_parameters=request.params,
                    forward_url=forward_url)

    @expose(template="tumpire.templates.players")
    def scoresname(self):
        return {'players': User.select(orderBy='user_name')}
    
    @expose(template="tumpire.templates.players")
    def scorescollege(self):
        return {'players': User.select(orderBy='college')}

    @expose(template="tumpire.templates.players")
    def scoresrank(self):
        return {'players': User.select(orderBy='score')}
    
    @expose(template="tumpire.templates.news")
    def news(self):
        return {'events':Event.select(orderBy='datetime')}

    @expose(template="tumpire.templates.updates")
    def updates(self):
        return {'events':Event.select(orderBy='datetime')}

    @expose(template="tumpire.templates.addreportselevent")
    def addreportselevent(self):
        return {}

    @expose()
    def logout(self):
        identity.current.logout()
        raise redirect(url("/"))


    @expose(template="tumpire.templates.edituser")
    def edituser(self,player):
    	try:
	    return {'user':User.by_user_name(player),'new':False}
	except SQLObjectNotFound:
	    flash("Error: Tried to edit a nonexistent user")
	    raise redirect(url("/scoresname"))
    @expose(template="tumpire.templates.edituser")
    def adduser(self):
        return {'new':True}
    @expose()
    @validate(validators={'adjustment':Number()})
    def saveuser(self,oldname,name,address,college,water,notes,password,email,adjustment):
        if(oldname):
		try:
			u=User.by_user_name(oldname)
		except SQLObjectNotFound:
			flash("Error: Tried to edit a nonexistent player")
			raise redirect(url("/scoresname"))
		#u.user_name=name #don't give too much opportunity to break things
		u.address=address
		u.college=college
		u.water=water
		u.notes=notes
		if(password):
			u.password=password
		u.email_address=email
		if(adjustment!=u.adjustment and not identity.in_group('admin')):
			flash("Error: Tried to change a score adjustment while not umpire")
			raise redirect(url('/scoresname'))
		u.adjustment=adjustment
	else:
		u=User(user_name=name,address=address,college=college,water=water,notes=notes,password=password,email_address=email,score=0.0,adjustment=adjustment)
		p=Pseudonym(name=name,player=u)
	self.updatescores()
	flash("Player updated!")
	raise redirect(url("/scoresname"))
    
    @expose(template="tumpire.templates.editpseudonym")
    @validate(validators={'id':Int()})
    def editpseudonym(self,id):
        return {'id':id,'new':False}
    @expose(template="tumpire.templates.editpseudonym")
    def addpseudonym(self,player):
        return {'new':True,'playerid':player}
    @expose()
    @validate(validators={'playerid':Int(),'new':StringBoolean()})
    def savepseudonym(self,new,name,playerid,id=0,submit=""):
        if(new):
	    try:
                p=Pseudonym(player=User.get(playerid),name=name)
	    except SQLObjectNotFound:
	        flash("Error: Tried to add a pseudonym to a nonexistent user")
		raise redirect(url("/scoresname"))
	else:
	    try:
	        p=Pseudonym.get(id)
	    except SQLObjectNotFound:
	        flash("Error: Tried to edit a nonexistent pseudonym")
		raise redirect(url("/scoresname"))
            p.name=name
	flash("Pseudonym updated!")
	raise redirect(url("/edituser/"+p.player.user_name))
   
    @expose(template="tumpire.templates.editevent")
    @validate(validators={'id':Int()})
    def editevent(self,id):
        return {'id':id,'new':False}
    @expose(template="tumpire.templates.editevent")
    def addevent(self):
        return {'new':True}
    @expose()
    @validate(validators={'new':StringBoolean()})
    def saveevent(self,new,headline,timestamp,id=0):
        try:
            t=datetime.datetime.strptime(timestamp,"%Y-%m-%d %H:%M:%S")
	except ValueError:
	    flash("Error: You entered an invalid date/time")
	    raise redirect(url("/news"))
	if(t.year <= 1900 or t.year >= 2020):
	    flash("Error: Absurd year %d"%t.year)
	    raise redirect(url("/news"))
        if(new):
	    e=Event(headline=headline,datetime=t)
	    flash("Event Added!")
	    raise redirect(url("/editevent/"+str(e.id)))
	else:
	    try:
	        e=Event.get(id)
	    except SQLObjectNotFound:
	        flash("Error: Tried to edit a nonexistent event")
		raise redirect(url("/news"))
	    e.headline=headline
	    e.datetime=t
        flash("Event Updated!")
        raise redirect(url("/news"))
    @expose()
    @validate(validators={'id':Int()})
    @identity.require(identity.in_group('admin'))
    def deleteevent(self,id):
        try:
	    Event.delete(id)
	    flash("Event deleted!")
	    raise redirect(url("/news"))
        except SQLObjectNotFound:
	    flash("Error: Tried to delete an event that doesn't exist")
	    raise redirect(url("/news"))
    @expose(template="tumpire.templates.editparticipant")
    @validate(validators={'id':Int()})
    def editparticipant(self,id):
        return {'id':id,'new':False}
    @expose(template="tumpire.templates.editparticipant")
    @validate(validators={'eid':Int()})
    def addparticipant(self,eid):
        try:
            return {'new':True,'event':Event.get(eid)}
	except SQLObjectNotFound:
	    flash("Error: Tried to add participant to a nonexistent event")
	    raise redirect(url("/news"))
    @expose()
    @validate(validators={'new':StringBoolean(),'eid':Int()})
    def saveparticipant(self,new,eid,player,pseudonym="",id=0,submit=""):
         if(new):
	     try:
	         for q in Event.get(eid).participants:
	             if(q.player.user_name==player):
		         flash("Error: %s is already a participant in this event"%player)
		         raise redirect(url("/editevent/"+str(eid)))
	         p=Participant(event=Event.get(eid),player=User.by_user_name(player),pseudonym=Pseudonym.byName(player))
             except SQLObjectNotFound:
	         flash("Error: Tried to add a participant to a nonexistent event")
		 raise redirect(url("/news"))
	 else:
	     try:
	         p=Participant.get(id)
             except SQLObjectNotFound:
	         flash("Error: Tried to edit a nonexistent participant")
		 raise redirect(url("/news"))
	     try:
	         p.player=User.by_user_name(player)
  	         p.pseudonym=Pseudonym.byName(pseudonym)
	     except SQLObjectNotFound:
	         flash("Error: Tried to change pseudonym to one that doesn't exist, or change pseudonym for a player that doesn't exist")
		 raise redirect(url("/news"))
	 flash("Participant updated!")
	 raise redirect(url("/editevent/"+str(eid)))

    @expose(template="tumpire.templates.editreport")
    @validate(validators={'id':Int()})
    @identity.require(identity.not_anonymous())
    def editreport(self,id):
        return {'id':id,'new':False}
    @expose(template="tumpire.templates.editreport")
    @validate(validators={'eid':Int()})
    @identity.require(identity.not_anonymous())
    def addreport(self,eid):
        try:
            return {'new':True,'event':Event.get(eid)}
	except SQLObjectNotFound:
	    flash("Error: Tried to add report to a nonexistent event")
	    raise redirect(url("/news"))
    @expose()
    @validate(validators={'new':StringBoolean(),'eid':Int(),'id':Int()})
    def savereport(self,new,eid,player,text,id=0):
        if(new):
	    try:
    	        r=Report(speaker=User.by_user_name(player),event=Event.get(eid),content=text)
            except SQLObjectNotFound:
	        flash("Error: Tried to add report by a nonexistent player, or to a nonexistent event")
		raise redirect(url("/news"))
	else:
	    try:
                r=Report.get(id)
	        r.content=text
  	        #nothing else really should be being edited, but will update it all for future compatibility
	        r.speaker=User.by_user_name(player)
	        r.event=Event.get(eid)
	    except SQLObjectNotFound:
	        flash("Error: Tried to edit a nonexistent report, or a report for a nonexistent event, or write a report as a nonexistent player.")
		raise redirect(url("/news"))
	flash("Report updated!")
	raise redirect(url("/news"))

    @expose(template="tumpire.templates.addkill")
    @validate(validators={'eid':Int()})
    def addkill(self,eid):
        try:
            return {'event':Event.get(eid)}
	except SQLObjectNotFound:
	    flash("Error: Tried to add a kill to a nonexistent event.")
	    raise redirect(url("/news"))
    @expose()
    @validate(validators={'eid':Int()})
    def savekill(self,eid,killer,victim):
      try:
        for k in Event.get(eid).kills:
	    if(k.victim==User.by_user_name(victim)):
	        flash("Error: %s is already marked as being killed in this event, by %s. If they didn't kill %s, delete that kill first."%(victim,k.killer,victim))
		raise redirect(url("/editevent/"+str(eid)))
        k=Kill(event=Event.get(eid),killer=User.by_user_name(killer),victim=User.by_user_name(victim))
	self.updatescores()
	flash("Kill added!")
	for l in Kill.select():
	  if(l.id!=k.id):
	    if((l.victim == k.victim or l.victim==k.killer) and l.event.datetime < k.event.datetime and l.event.datetime >= (k.event.datetime - datetime.timedelta(0,14400))):
                flash("Warning: %s is listed as being killed in the event %s, which was less than four hours before this event."%(l.victim.user_name,str(l.event)))
            if(l.victim == k.victim and k.event.datetime <= l.event.datetime and k.event.datetime >= (l.event.datetime - datetime.timedelta(0,14400))):
	        flash("Warning: %s is listed as dying again in the event %s, which is less than four hours after this event."%(k.victim.user_name,str(l.event)))
	    if(l.killer == k.victim and k.event.datetime < l.event.datetime and k.event.datetime >= (l.event.datetime - datetime.timedelta(0,14400))):
	        flash("Warning: %s is listed as killing someone else in the event %s, which is less than four hours after this event."%(k.victim.user_name,str(l.event)))
	raise redirect(url("/editevent/"+str(eid)))
      except SQLObjectNotFound:
          flash("Error: Tried to add a kill to a nonexistent event.")
	  raise redirect(url("/news"))
    @expose()
    @validate(validators={'kid':Int()})
    def deletekill(self,kid):
        try:
	    eid=Kill.get(kid).event.id
	except SQLObjectNotFound:
	    flash("Error: you tried to delete a kill that doesn't exist!")
	    raise redirect(url("/news"))
        Kill.delete(kid)
	self.updatescores()
	flash("Kill removed!")
	raise redirect(url("/editevent/"+str(eid)))

    @expose(template="tumpire.templates.addinnocentkill")
    @validate(validators={'eid':Int()})
    def addinnocentkill(self,eid):
        try:
            return {'event':Event.get(eid)}
        except SQLObjectNotFound:
	   flash("Error: Tried to add an innocent kill to a nonexistent event.")
	   raise redirect(url("/news"))
    @expose()
    @validate(validators={'eid':Int(),'licit':StringBoolean()})
    def saveinnocentkill(self,eid,killer,licit):
      try:
        k=InnocentKill(event=Event.get(eid),killer=User.by_user_name(killer),licit=licit)
	self.updatescores()
	flash("Innocent Kill added!")
	for l in Kill.select():
	    if((l.victim == k.killer) and l.event.datetime < k.event.datetime and l.event.datetime >= (k.event.datetime - datetime.timedelta(0,14400))):
                flash("Warning: %s is listed as being killed in the event %s, which was less than four hours before this event."%(l.victim.user_name,str(l.event)))
	raise redirect(url("/editevent/"+str(eid)))
      except SQLObjectNotFound:
          flash("Error: Tried to add an innocent kill to a nonexistent event.")
	  raise redirect(url("/news"))
    @expose()
    @validate(validators={'iid':Int()})
    def deleteinnocentkill(self,iid):
        try:
	    eid=InnocentKill.get(iid).event.id
	except SQLObjectNotFound:
	    flash("Error: you tried to delete an innocent kill that doesn't exist!")
	    raise redirect(url("/news"))
        InnocentKill.delete(iid)
	self.updatescores()
	flash("Innocent Kill removed!")
	raise redirect(url("/editevent/"+str(eid)))
    
























    def updatescores(self):
	glicko={}
	innocent_vector=[0,1,2,4,6,9,13,17,23]
	for u in User.select():
	    glicko[u.user_name]=(1500,350,0.06)
	kills=Kill.select()
	gamestart=datetime.datetime(2008,6,13,17,0,0)
	for i in range(42):
	    glicko = glickostep( glicko, [x for x in kills if x.event.datetime >= gamestart + datetime.timedelta(i*14400) and x.event.datetime < gamestart + datetime.timedelta((i+1)*14400)])
	for u in glicko:
	    p=User.by_user_name(u)
	    i = 0
	    for ik in InnocentKill.select():
	    	if(ik.killer==p and not ik.licit):
		    i +=1
	    p.score=glicko[u][0]-glicko[u][1]+p.adjustment - 35 * innocent_vector[min(i,8)]
	return
    
def glickostep(scores,kills):
        tau=1
        newscores = {}
        for player in scores:
            (r,RD,sigma)=scores[player]
            mu=(r-1500)/173.7178
	    phi=RD/173.7178
            opponents=[]
	    for k in kills:
	        if(k.killer.user_name==player):
		    o=k.victim.user_name
		    (mui,phii,sigmai)=scores[o]
		    opponents.append((mui,phii,1))
		else:
		    if(k.victim.user_name==player):
		        o=k.killer.user_name
  		        (mui,phii,sigmai)=scores[o]
		        opponents.append((mui,phii,0))
	    if(opponents):
	        def g(phi): return 1/(math.sqrt(1+3*phi**2/math.pi**2))
    	        def E(mu,muj,phij): return 1/(1+math.exp(-g(phij)*(mu-muj)))
                nu=1/sum((g(o[1])**2*E(mu,o[0],o[1])*(1-E(mu,o[0],o[1])) for o in opponents))
    	        delta=nu * sum((g(o[1])*(o[2]-E(mu,o[0],o[1])) for o in opponents))
	        a=math.log(sigma**2)
	        x=a
                oldx=0
	        while(abs(x-oldx)>epsilon):
	            d=phi**2+nu+math.exp(x)
		    h1=-(x-a)/tau**2-0.5*math.exp(x)/d+0.5*math.exp(x)*(delta/d)**2
		    h2=-1/tau**2-0.5*math.exp(x)*(phi**2+nu)/d**2+0.5*delta**2*math.exp(x)*(phi**2+nu-math.exp(x))/d**3
		    oldx=x
		    x=x-h1/h2
	        sigmaprime=math.exp(x/2)
	        phistar=math.sqrt(phi**2+sigmaprime**2)
	        phiprime=1/math.sqrt(1/phistar**2+1/nu)
	        muprime=mu+sigmaprime**2*sum((g(o[1])*(o[2]-E(mu,o[0],o[1])) for o in opponents))
            else:
	        muprime=mu
	        phiprime=math.sqrt(phi**2+sigma**2)
		sigmaprime=sigma
	    rprime=173.7178*muprime+1500
	    RDprime=173.7178*phiprime
	    newscores[player]=(rprime,RDprime,sigmaprime)

	return newscores
