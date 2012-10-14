from datetime import datetime
from turbogears.database import PackageHub
from sqlobject import *
from turbogears import identity

hub = PackageHub('tumpire')
__connection__ = hub

# class YourDataClass(SQLObject):
#     pass
 
# identity models.
class Visit(SQLObject):
    """
    A visit to your site
    """
    class sqlmeta:
        table = 'visit'

    visit_key = StringCol(length=40, alternateID=True,
                          alternateMethodName='by_visit_key')
    created = DateTimeCol(default=datetime.now)
    expiry = DateTimeCol()

    def lookup_visit(cls, visit_key):
        try:
            return cls.by_visit_key(visit_key)
        except SQLObjectNotFound:
            return None
    lookup_visit = classmethod(lookup_visit)


class VisitIdentity(SQLObject):
    """
    A Visit that is link to a User object
    """
    visit_key = StringCol(length=40, alternateID=True,
                          alternateMethodName='by_visit_key')
    user_id = IntCol()


class Group(SQLObject):
    """
    An ultra-simple group definition.
    """
    # names like "Group", "Order" and "User" are reserved words in SQL
    # so we set the name to something safe for SQL
    class sqlmeta:
        table = 'tg_group'

    group_name = UnicodeCol(length=16, alternateID=True,
                            alternateMethodName='by_group_name')
    display_name = UnicodeCol(length=255)
    created = DateTimeCol(default=datetime.now)

    # collection of all users belonging to this group
    users = RelatedJoin('User', intermediateTable='user_group',
                        joinColumn='group_id', otherColumn='user_id')

    # collection of all permissions for this group
    permissions = RelatedJoin('Permission', joinColumn='group_id',
                              intermediateTable='group_permission',
                              otherColumn='permission_id')


class User(SQLObject):
    """
    Reasonably basic User definition.
    Probably would want additional attributes.
    """
    # names like "Group", "Order" and "User" are reserved words in SQL
    # so we set the name to something safe for SQL
    def __str__(self):
        return self.user_name

    class sqlmeta:
        table = 'tg_user'

    user_name = UnicodeCol(length=255, alternateID=True,
                           alternateMethodName='by_user_name')
    email_address = UnicodeCol(length=255, alternateID=True,
                               alternateMethodName='by_email_address')
    #display_name = UnicodeCol(length=255)
    password = UnicodeCol(length=40)
    #created = DateTimeCol(default=datetime.now)

    # groups this user belongs to
    groups = RelatedJoin('Group', intermediateTable='user_group',
                         joinColumn='user_id', otherColumn='group_id')

    def _get_permissions(self):
        perms = set()
        for g in self.groups:
            perms = perms | set(g.permissions)
        return perms

    def _set_password(self, cleartext_password):
        "Runs cleartext_password through the hash algorithm before saving."
        password_hash = identity.encrypt_password(cleartext_password)
        self._SO_set_password(password_hash)

    def set_password_raw(self, password):
        "Saves the password as-is to the database."
        self._SO_set_password(password)
    
    address = UnicodeCol(length=255)
    college = UnicodeCol(length=255)
    notes = UnicodeCol(length=255)
    water = UnicodeCol(length=255)
    pseudonyms = MultipleJoin('Pseudonym',joinColumn='player_id')
    kills = MultipleJoin('Kill', joinColumn='killer_id')
    deaths = MultipleJoin('Kill', joinColumn='victim_id')
    events = MultipleJoin('Participant', joinColumn='player_id')
    reports = MultipleJoin('Report', joinColumn='speaker_id')
    score = FloatCol()
    adjustment = FloatCol()


class Permission(SQLObject):
    """
    A relationship that determines what each Group can do
    """
    permission_name = UnicodeCol(length=16, alternateID=True,
                                 alternateMethodName='by_permission_name')
    description = UnicodeCol(length=255)

    groups = RelatedJoin('Group',
                         intermediateTable='group_permission',
                         joinColumn='permission_id',
                         otherColumn='group_id')

class Event(SQLObject):
    """
    A game occurrence, to which kills and reports will be attached
    """
    headline = UnicodeCol(length=255)
    datetime = DateTimeCol()
    participants = MultipleJoin('Participant',joinColumn='event_id')
    reports = MultipleJoin('Report',joinColumn='event_id')
    kills = MultipleJoin('Kill',joinColumn='event_id')
    innocentkills = MultipleJoin('InnocentKill',joinColumn='event_id')
    def __str__(self):
        return "[%s] %s"%(self.datetime.strftime("%Y-%m-%d %H:%M:%S"),self.headline)

class Report(SQLObject):
    speaker = ForeignKey('User')
    content = UnicodeCol(length=1000)
    event = ForeignKey('Event',cascade=True)


class Kill(SQLObject):
    killer = ForeignKey('User')
    victim = ForeignKey('User')
    event = ForeignKey('Event',cascade=True)

class InnocentKill(SQLObject):
    killer = ForeignKey('User')
    licit = BoolCol()
    event = ForeignKey('Event',cascade=True)

class Pseudonym(SQLObject):
   name = UnicodeCol(length=255,alternateID=True,unique=True)
   player = ForeignKey('User')
   events = MultipleJoin('Participant',joinColumn='pseudonym_id')
   def __str__(self):
       return self.name

class Participant(SQLObject):
   """Encapsulates the notion that a player was participating in an event under a pseudonym. There should be one instance of this for every player involved in an Event."""
   event=ForeignKey('Event',cascade=True)
   player=ForeignKey('User')
   pseudonym=ForeignKey('Pseudonym')
    
