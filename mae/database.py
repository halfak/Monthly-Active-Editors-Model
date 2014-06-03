import getpass, os, oursql
from menagerie.decorators import memoized

from . import config

from mw import database

def wiki_host(wiki, host_string = "s%s-analytics-slave.eqiad.wmnet"):
	
	return host_string % config.get_slice(wiki)
	

@memoized
def connection(wiki,
            defaults_file = os.path.expanduser("~/.my.cnf"), 
            user = getpass.getuser(), 
            host_string = "s%s-analytics-slave.eqiad.wmnet"):
	
	host = wiki_host(wiki, host_string)
	
	return oursql.connect(
		host=host,
		db=wiki,
		user="research",
		read_default_file=defaults_file,
		default_cursor=oursql.DictCursor
	)

class DBCache:
	
	def __init__(self, user, defaults):
		
		self.user = user
		self.defaults = defaults
		
		self.cache = {}
	
	def get_db(self, wiki):
		if wiki in self.cache:
			db = self.cache[wiki]
		else:
			db = database.DB(
				host=wiki_host(wiki),
				user=self.user,
				db=wiki,
				read_default_file=self.defaults
			)
			self.cache[wiki] = db
		
		return db
