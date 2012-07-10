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
import sys
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
    p = sub.Popen(['grep','<i>%s </i>' %search_term ,MSV3_CSV_FILE],stdout=sub.PIPE,stderr=sub.PIPE)
    output, errors = p.communicate()
    if errors is not None and errors != "":
            raise Exception ("Error grepping: %s" %str(errors))

    # Read results as a CSV file
    rcsv = csv.reader(StringIO.StringIO(output),  delimiter=',', quotechar='"')
    res = [ (row[0],row[34]) for row in rcsv if row[12] == "SPECIES" ]
    #print "res is " + str(res)
    if len(res) > 1:
	res_exact = [r for r in res if get_name_for_match(r) == search_term]
        if len(res_exact) > 1:
            raise Exception ("Multiple results found for %s (%d): \n %s" %(search_term,len(res),str(res)))
        else:
            res = res_exact
    elif len(res) == 0:
        return None
    return res[0]

''' For a given match this function returns the ID'''
def get_ID_for_match(match):
    return match[0]

''' For a given list of ids this function returns the accepted names. 
Results are returned as a dictionary'''
def get_name_for_match(match):
    return match[1][3:-5]

if __name__ == '__main__':    
    jres={}
    res = {}
    id2term = {}
    try:
        for t in sys.stdin:
            term = t.replace("\n","").replace("_"," ")
            m = search_file_for_matches(term) # First search the name to find the IDs
            if m is not None:
                res[term] = ("%s/?id=%s" %(TAXON_URL_BASE,get_ID_for_match (m)), get_name_for_match(m)) # Build URL from IDs
        
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
        
    print json.dumps(jres)
