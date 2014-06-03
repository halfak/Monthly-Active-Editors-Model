import requests, sys
from menagerie.formatting import tsv

WIKI_URL = "https://en.wikipedia.org/w/api.php?action=sitematrix&format=json"

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
    
    writer = tsv.Writer(sys.stdout, headers=HEADERS)
    
    response = requests.get(WIKI_URL)
    
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
            
            writer.write([
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

if __name__ == "__main__": main()
