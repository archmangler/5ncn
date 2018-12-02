#!/usr/bin/env python
#filter out inventory data
#for the next stage pipeline
import json
import subprocess
import os
debug = 0
inventory=[]

stuff = subprocess.check_output(['terraform', 'output', '-json','cluster_slave_private_addresses'])
if debug ==1:
 print stuff 
j = json.loads(stuff)
if debug==1:
 print j['value']
inventory=list(j['value'])

for i in inventory:
 print i
