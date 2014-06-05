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
from docopt import docopt
from collections import deque

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
    'other_active_editors'
]

def parse_editor_months(f):
    if not f.isatty():
        return tsv.Reader(f, types=[str,str,int,str,str,int,int])
    


def main():
    args = docopt(__doc__, version='Monthly Active Editors 0.0.1')
    editor_months = parse_editor_months(sys.stdin)
    
    run(editor_months, int(args['--active_edits']))


class MonthlyActiveEditors:
    
    def __init__(self, new=None, surviving=None, old=None, other=None):
        self.new = set(new or [])
        self.surviving = set(surviving or [])
        self.old = set(old or [])
        self.other = set(other or [])
        
    def __contains__(self, id):
        return id in self.new or \
               id in self.surviving or \
               id in self.old or \
               id in self.other
    
    def __or__(self, other):
        return (self.new | self.surviving | self.old | self.other) | \
               (other.new | other.surviving | other.old | other.other)
    
    def __and__(self, other):
        return (self.new | self.surviving | self.old | self.other) & \
               (other.new | other.surviving | other.old | other.other)
    
    
    def total(self):
        return len(self.new) + \
               len(self.surviving) + \
               len(self.old) + \
               len(self.other)

def run(editor_months, active_edits=5):
    
    writer = tsv.Writer(sys.stdout, headers=HEADERS)
    
    mae = deque([MonthlyActiveEditors(), MonthlyActiveEditors(), MonthlyActiveEditors()], maxlen=3)
    
    for (wiki, month), editors in aggregate(editor_months, by=lambda em:(em.wiki, em.month)):
        for editor in editors:
            
            user_id = editor.user_id 
            user_registration = editor.user_registration
            
            if user_id == 0: pass
            elif editor.revisions >= active_edits: 
                # Active editor
                
                if user_registration != None and \
                   user_registration > (month[:4] + month[5:]):
                    # New active editor
                    
                    mae[0].new.add(user_id)
                    
                elif user_id in mae[1].new: 
                    # Surviving new active editor
                    
                    mae[0].surviving.add(user_id)
                    
                elif user_id in mae[1] and user_id in mae[2]: 
                    # Old active editor
                    
                    mae[0].old.add(user_id)
                    
                else: 
                    # Other active editor
                    
                    mae[0].other.add(user_id)
                    
            
        
        writer.write([
            wiki,
            month,
            mae[0].total(),
            len(mae[0].new),
            len(mae[0].surviving),
            len(mae[0].surviving)/len(mae[1].new) if len(mae[1].new) > 0 else None,
            len(mae[0].old),
            len(mae[0].old)/len(mae[1] & mae[2]) if len(mae[1] & mae[2]) > 0 else None,
            len(mae[0].other)
        ])
        
        mae.appendleft(MonthlyActiveEditors()) # Updating current
        
        
