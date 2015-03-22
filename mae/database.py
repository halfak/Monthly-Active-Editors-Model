import getpass, os, pymysql
from menagerie.decorators import memoized

from . import config

from mw import database

def wiki_host(wiki, host_string = "s%s-analytics-slave.eqiad.wmnet"):
	
	return host_string % config.get_slice(wiki)
	

def connection(wiki,
               defaults_file = os.path.expanduser("~/.my.cnf"), 
               user = getpass.getuser(), 
               host_string = "s%s-analytics-slave.eqiad.wmnet"):
	
	host = wiki_host(wiki, host_string)
	
	return pymysql.connect(
		host="analytics-store.eqiad.wmnet", #TODO: hard coded
		db=wiki,
		user="research",
		read_default_file=defaults_file,
		cursorclass=pymysql.cursors.DictCursor
	)
