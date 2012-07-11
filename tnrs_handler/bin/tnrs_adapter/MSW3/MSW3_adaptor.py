'''
   This script reads taxon names from standard input, one per line, and searches for those names
   in locally stored version of Mammal Species of the World database, version 3. 
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

''' set the following to True to get verbose message on standard err'''
Verbose = False
if len(sys.argv) > 1 and sys.argv[1] == "-v":
    Verbose = True

TAXON_URL_BASE="http://www.bucknell.edu/msw3/browse.asp"

MSV3_CSV_FILE = os.path.join(sys.path[0],"MSW3_PARSED.csv")

'''Grep the DB for a given term, interpret results as CSV, and return results.''' 
def grep_name(term):
    # Search the CSV for a given indexed term
    p = sub.Popen(['grep','-E','<i>.* *%s *</i>' %term ,MSV3_CSV_FILE],stdout=sub.PIPE,stderr=sub.PIPE)
    output, errors = p.communicate()
    if errors is not None and errors != "":
            raise Exception ("Error grepping: %s" %str(errors))

    # Read results as a CSV file
    return csv.reader(StringIO.StringIO(output),  delimiter=',', quotechar='"')

def grep_and_filter(search_term, filter="SPECIES"):
    # grep for the searched trem in all indices
    rcsv = grep_name(search_term)

    # Look only at SPECIES results
    return [ (row[0],row[34],",".join(row)) for row in rcsv if row[12] == filter ]

'''Search for a given name and find its taxonomic ID.'''
def search_file_for_matches(search_term):

    if Verbose:
        print >>sys.stderr, "---- Search for %s ----" %search_term

    nameparts = search_term.split(" ")        
    # If a trinomial is given, then just strip away the last part, assuming its the sup-species name. 
    if len(nameparts) == 3:
        nameparts = [nameparts[0], nameparts[1]]
        search_term = " ".join(nameparts)
        if Verbose:
            print >>sys.stderr, "Trinomal found, using instead: %s" %search_term
    # grep the file for the search term, and look only at SPECIES results
    res = grep_and_filter(search_term)
    # Multiple Matches found? Look for exact matches and just use those
    res = [r for r in res if get_name_for_match(r) == search_term] if len(res) > 1 else res

    # Still more than one results found? don't translate this one
    if len(res) > 1:
        if Verbose:
        	print >>sys.stderr, "Multiple matches found for %s. Returning none. \n %s" %(search_term,str(res))
        return None
    elif len(res) == 0: # Nothing found :(
        # try searching for the species name and the genus separately.
        # Can do this only with two part names (TODO: handle more complex names)
        if len(nameparts) == 2:
            if Verbose:
            	print >>sys.stderr, "No exact matches found for %s. Trying loose matches. " %(search_term)
            # grep the file for the species name part, and look only at SPECIES results
            res = grep_and_filter(nameparts[1])
            # Find only those that have the genus part in any of the fields
            res = [r for r in res if r[2].find("<i>%s"%nameparts[0]) != -1]
            # If multiple matches  found, find those that have the exact species or genus part
            res = [r for r in res if get_name_for_match(r).split()[0] == nameparts[0] or get_name_for_match(r).split()[1] == nameparts[1]] if len (res) > 1 else res
            if Verbose and len (res) > 1:
            	print >>sys.stderr, "Multiple loose matches found for %s. Returning none. \n %s " %(search_term,str(res))
            # IF this results in one and only one results, use that. 
            if len(res) == 1:
                if Verbose:
            	    print >>sys.stderr, "One loose match found for %s. \n %s " %(search_term, str(res[0]))
                return res[0]
        return None
    if Verbose:
        print >>sys.stderr, " One exact match found for %s: %s" %(search_term,str(res[0]))
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
            term = t.replace("\n","").replace("_"," ").strip()
            m = search_file_for_matches(term) # First search the name to find the IDs
            if m is not None:
                res[term] = ("%s?id=%s" %(TAXON_URL_BASE,get_ID_for_match (m)), get_name_for_match(m)) # Build URL from IDs
                if Verbose and res[term][1] != term:
                    print >>sys.stderr, "Mapping %s to %s " %(term, res[term][1])
            else:
                if Verbose:
                    print >>sys.stderr, "Could not match %s" %term
        
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
