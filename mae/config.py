import os, yaml
from itertools import repeat, chain

datasets_dir = os.path.join(
	os.path.dirname(os.path.dirname(os.path.realpath(__file__))),
	"datasets"
)

slices = yaml.load(open(os.path.join(datasets_dir, "slices.yaml")))

wikis = {}
for slice, ws in slices.items():
	for w in ws:
		wikis[w] = slice
	
def get_slice(wiki):
	return wikis[wiki]

def get_wikis(slice):
	return slices[slice]
