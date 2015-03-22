"""
Get Wiki Info!

Gathers general information about a set of wikis (???) via a call to
site_info and writes out to a TSV format that 'mysqlimport' appreciates

Usage:
  get_wiki_info [--api=<url>]
  get_wiki_info -h | --help
  get_wiki_info --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --api         The API URL to connect to 
                [default: https://en.wikipedia.org/w/api.php]

"""
import requests, sys
import docopt

WIKI_URL_STUFF = "?action=sitematrix&format=json"

HEADERS = [
	'wiki',
	'code',
	'sitename',
	'url',
	'lang_id',
	'lang_code',
	'lang_name',
	'lang_local_name'
]

def main():
	args = docopt.docopt(__doc__, "0.0.1")
	
	wiki_url = args['--api'] + WIKI_URL_STUFF
	
	stdout.write("\t".join(HEADERS))
	
	response = requests.get(wiki_url)
	
	doc = response.json()
	
	languages = doc['sitematrix'].items()
	
	for lang_id, language in languages:
		try:
			lang_id = int(lang_id) # fails for non-languages because dumb
		except:
			continue
		lang_code = language.get('code')
		lang_name = language.get('name')
		lang_local_name = language.get('localname')
		
		sys.stderr.write("{0}: ".format(lang_local_name))
		
		for wiki_info in language.get('site', []):
			wiki = wiki_info['dbname']
			code = wiki_info.get('code')
			url = wiki_info.get('url')
			sitename = wiki_info.get('sitename')
			closed = 'closed' in wiki_info
			
			stdout.write("".join(encode(v) for v in [
				wiki,
				code,
				sitename,
				url,
				lang_id,
				lang_code,
				lang_name,
				lang_local_name
			])
			
			sys.stderr.write(".")
		
		sys.stderr.write("\n")
		
	
	sys.stderr.write("\n")

def encode(val):
	if val == None: 
		return "NULL"
	elif type(val) in types.StringTypes:
		if type(val) == types.StringType:
			val = val.decode('utf-8', "replace")
		
		return val.replace("\t", "\\t").replace("\n", "\\n").encode('utf-8')
	elif type(val) == types.LongType:
		return str(int(val))
	else:
		return str(val).encode('utf-8')


if __name__ == "__main__": main()
