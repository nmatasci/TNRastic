'''
   This script reads taxon names from standard input, one per line, and searches for those names
   in locally stored version of Mammal Species of the World databased, version 3. 
   (Don E. Wilson & DeeAnn M. Reeder (editors). 2005. Mammal Species of the World. A Taxonomic and Geographic Reference (3rd ed)).
   If matches are found, accepted name is created based on the found records. 
   Results are returned as a json file.

   Developer: Siavash Mirarab (smirarab@gmail.com) 
'''

import urllib
import time
import sys, traceback
import os
import subprocess as sub
import json
import csv
import StringIO

TAXON_URL_BASE="http://www.bucknell.edu/msw3/browse.asp"

MSV3_CSV_FILE = os.path.join(sys.path[0],"MSW3_PARSED.csv")


BAD_XML_ERROR = "NCBI XML could not be parsed: %s\n (quary=%s)"
MP_ID_ERROR = "We expect one ID back from NCBI, but we got more than one ID. Oops!"
HTML_ERROR = "HTML error in accessing NCBI"

'''Search for a given name and find its taxonomic ID.'''
def search_file_for_matches(search_term):

    # Search the CSV for a given indexed term
    p = sub.Popen(['grep','-E','<i>%s *</i>' %search_term ,MSV3_CSV_FILE],stdout=sub.PIPE,stderr=sub.PIPE)
    output, errors = p.communicate()
    if errors is not None and errors != "":
            raise Exception ("Error grepping: %s" %str(errors))

    # Read results as a CSV file
    rcsv = csv.reader(StringIO.StringIO(output),  delimiter=',', quotechar='"')

    # Look only at SPECIES results
    res = [ (row[0],row[34]) for row in rcsv if row[12] == "SPECIES" ]
    
    # Multiple Matches found?
    if len(res) > 1:
        # Look for exact matches
	res_exact = [r for r in res if get_name_for_match(r) == search_term]
        # if only one exact match results, just use that one
	if len(res_exact) == 1:
            return res_exact[0]
        # Still confused? don't translate this one
        else:
            return None
	    print >>sys.stderr, "Multiple matches found for %s. Returning none." %search_term
    elif len(res) == 0: # Nothing found :(
        #TODO: try searching for the species name and the genus separately. 
        return None
    return res[0]

''' For a given match this function returns the ID'''
def get_ID_for_match(match):
    return match[0]

''' For a given match this funtion returns the name'''
def get_name_for_match(match):
    return match[1][3:-4].strip()#strip off the <i> </i> part

if __name__ == '__main__':    
    jres={}
    res = {}
    id2term = {}
    try:
        for t in sys.stdin:
            term = t.replace("\n","").replace("_"," ")
            m = search_file_for_matches(term) # First search the name to find the IDs
            if m is not None:
                res[term] = ("%s?id=%s" %(TAXON_URL_BASE,get_ID_for_match (m)), get_name_for_match(m)) # Build URL from IDs
            else:
                print >>sys.stderr, "Nothing found for %s" %term
        
        jres["status"] = "200"
        jres["errorMessage"] = ""
        jres["names"] = []
        
        for t in res:
            jres["names"].append({
                    "submittedName":t,
                    "matchedName":t if res[t][1] is not None else None,
                    "score":"1" if res[t][1] is not None else "0",
                    "uri":res[t][0],
                    "annotations":{},
                    "acceptedName":res[t][1]})
    except Exception as e:
        jres["status"] = "500"
        jres["errorMessage"] = str(e)
        jres["names"] = []
	traceback.print_exc(file=sys.stderr)
        
    print json.dumps(jres)
