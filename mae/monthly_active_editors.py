"""
Converts a list of monthly editor activity to a list of months with Monthly Active
Editor counts and survival rates split by four classes:

* New Active Editors (m[0] and r[0])
* Surviving New Active Editors (m[0] and m[-1] and r[-1])
* Old Active Editors (m[0] and m[-1] and not r[-1])
* Other Active Editors (m[0] otherwise)

Usage:
  monthly_active_editors [--active_edits=<edits>]
  monthly_active_editors -h | --help
  monthly_active_editors --version

Options:
  -h --help            Show this screen.
  --version            Show version.
  --active_edits=<kn>  Minimum edits to be considered "active" [default: 5].
"""
import sys
from collections import deque

from docopt import docopt
from menagerie.formatting import tsv
from menagerie.iteration import aggregate

HEADERS = [
	'wiki',
	'month',
	'total_active_editors',
	'new_active_editors',
	'surviving_new_active_editors',
	'new_active_survival_rate',
	'old_active_editors',
	'old_active_survival_rate',
	'reactivated_editors',
	'inactivated_editors',
	'inactivation_rate',
	'first_active_editors'
]

def parse_editor_months(f):
	if not f.isatty():
		return tsv.Reader(f, types=[str,str,int,str,str,int,int,str])
	


def main():
	args = docopt(__doc__, version='Monthly Active Editors 0.0.1')
	editor_months = parse_editor_months(sys.stdin)
	
	run(editor_months, int(args['--active_edits']))


class MonthlyActiveEditors:
	
	def __init__(self, new=None, surviving=None, old=None, reactivated=None):
		self.new = set(new or [])
		self.surviving = set(surviving or [])
		self.old = set(old or [])
		self.reactivated = set(reactivated or [])
		
	def _union(self):
		return self.new | self.surviving | self.old | self.reactivated
		
	def __contains__(self, id):
		return id in self.new or \
		       id in self.surviving or \
		       id in self.old or \
		       id in self.reactivated
	
	def __sub__(self, other):
		return self._union() - other._union()
	
	def __len__(self):
		return len(self.new) + \
		       len(self.surviving) + \
		       len(self.old) + \
		       len(self.reactivated)

def run(wiki_editor_months, active_edits=5):
	
	writer = tsv.Writer(sys.stdout, headers=HEADERS)
	
	for wiki, editor_months in aggregate(wiki_editor_months, by=lambda em:em.wiki):
		mae = deque([MonthlyActiveEditors(), MonthlyActiveEditors(), MonthlyActiveEditors()], maxlen=3)
		previously_active = set()
		for month, editors in aggregate(editor_months, by=lambda em:em.month):
			sys.stderr.write("{0}, {1}\n".format(wiki, month))
			first_actives = 0
			for editor in editors:
				
				user_id = editor.user_id
				user_registration = editor.user_registration
				attached_method = editor.attached_method
				revisions = editor.revisions or 0
				
				if user_id == 0: pass
				elif revisions >= active_edits:
					# Active editor
					
					if user_id not in previously_active:
						first_actives += 1
						previously_active.add(user_id)
					
					if user_registration != None and \
					   user_registration > (month[:4] + month[4:]) and \
					   attached_method != 'login':
						# New active editor
						
						mae[0].new.add(user_id)
						
					elif user_id in mae[1].new:
						# Surviving new active editor
						
						mae[0].surviving.add(user_id)
						
					elif user_id in mae[1]:
						# Old active editor
						
						mae[0].old.add(user_id)
						
					else:
						# Other active editor
						
						mae[0].reactivated.add(user_id)
					
			
		
			inactivated = len(mae[1] - mae[0])
			writer.write([
				wiki,
				month,
				len(mae[0]),
				len(mae[0].new),
				len(mae[0].surviving),
				len(mae[0].surviving)/len(mae[1].new) if len(mae[1].new) > 0 else None,
				len(mae[0].old),
				len(mae[0].old)/(len(mae[1])-len(mae[1].new)) if len(mae[1])-len(mae[1].new) > 0 else None,
				len(mae[0].reactivated),
				inactivated,
				inactivated/len(mae[1]) if len(mae[1]) > 0 else None,
				first_actives
			])
			
			mae.appendleft(MonthlyActiveEditors()) # Updating current
