'''
   This script reads taxon names from standard input, one per line, and searches NCBI taxonomy 
   (at http://www.ncbi.nlm.nih.gov/taxonomy) for matches. 
   If matches are found, taxonomy is searched again to find the accepted name for the queried names. 
   Results are returned as a json file.
   For input names that with no matches, there is no entries included in the results. 
   Developer: Siavash Mirarab (smirarab@gmail.com) 
'''

import urllib
import time
import sys
import json
from xml.etree.ElementTree import fromstring

TAXON_URL_BASE="http://www.ncbi.nlm.nih.gov/taxonomy"

BASE_SEARCH_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
BASE_SUMMARY_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi"

BAD_XML_ERROR = "NCBI XML could not be parsed: %s\n (quary=%s)"
MP_ID_ERROR = "We expect one ID back from NCBI, but we got more than one ID. Oops!"
HTML_ERROR = "HTML error in accessing NCBI"


'''Search for a given name and find its taxonomic ID.'''
def search_NCBI_for_ids(search_term):

    # Search the taxanomy DB of NCBI for a given term
    parameters={"db":'taxonomy',"term":search_term,"tool":"tnrastic"}

    url = "%s?%s" %(BASE_SEARCH_QUARY,urllib.urlencode(parameters)) # URL just for outputting errors

    # Search taxonomy for a given term. In case of an error, wait a second and try again. 
    # Do this for a maximum of 20 times
    succ = False
    tries=0
    while not succ and tries < 20:
        if tries > 0:
            time.sleep(1) # seems like NCBI has trouble with too many calls in short time periods
            print >>sys.stderr, "Error for %s, trying one more time: %d" %(search_term,tries)
        # make the call
        f = urllib.urlopen(BASE_SEARCH_QUARY,urllib.urlencode(parameters))    
        tries += 1
        # If HTTP error, try again
        succ = f.getcode() == 200
        if not succ:
            continue
        data = f.read()
        f.close()
        
        # Parse the resulting XML file (no automatic validation for now. We do have DTDs that we can later use to do validation) 
        dom = fromstring(data)
        
        # If error in the XML file, try again
        succ = dom.find("ERROR") is None or dom.find("ERROR").text is None

    # Basic error handling
    if f.getcode() != 200:
        raise Exception (HTML_ERROR, f.getcode())
    if not succ:
        raise Exceptoin ("Unable to resolve %s after 20 tries" %search_term)

    # Find IdList and make sure it is not empty
    idListElement = dom.findall("IdList")    
    if len(idListElement) != 1:
        raise Exception(BAD_XML_ERROR %("We expec only on IdList item",url),data)
    
    # Find the retrieved IDs
    idList = idListElement[0].findall("Id")

    # We expect to get only one id back. Find that one ID and return it.  
    if len(idList) == 0:
        return None
    elif len(idList) > 1:
        raise MP_ID_ERROR
    else:
        id = idList[0].text
        return id

''' For a given list of ids this function returns the accepted names. 
Results are returned as a dictionary'''
def get_name_for_ids(ids):

    idToName = {}

    # Get Taxon summary from  NCBI taxonomy for a given list of IDs
    parameters={"db":'taxonomy',"id":",".join(ids),"tool":"tnrastic"}

    # Build URL and send make the request
    f = urllib.urlopen(BASE_SUMMARY_QUARY,urllib.urlencode(parameters))
    data = f.read()
    f.close()

    # Parse the resulting XML file (no automatic validation for now. We do have DTDs that we can later use to do validation) 
    dom = fromstring(data)
    
    # Find IdList and make sure it is not empty
    sumElements = dom.findall("DocSum")
    if len(sumElements) != len(ids):
        raise Exceptoin(BAD_XML_ERROR %("One and only one doc sum is expected per each input ID","%s?%s"%s(BASE_SUMMARY_QUARY,urllib.urlencode(parameters))))
    
    for docSum in sumElements:
        id = docSum.find('Id').text
        name = [x.text for x in docSum.findall("Item") if x.get('Name') == "ScientificName"]
        if len (name) != 1:
            raise Exception(BAD_XML_ERROR %("One and only one ID is expected per each doc sum","%s?%s"%s(BASE_SUMMARY_QUARY,urllib.urlencode(parameters))))
        idToName[id] = name[0]

    return idToName

if __name__ == '__main__':    
    jres={}
    res = {}
    id2term = {}
    try:
        for t in sys.stdin:
            term = t.replace("\n","")
            id = search_NCBI_for_ids(term) # First search the name to find the IDs     
            time.sleep(0.01)# a bit of sleep to help NCBI
            if id is not None:
                id2term[id] = term
                #print >>sys.stderr, "%s was mapped to %s " %(term,id)
            res[term] = (id,None)
        id2names = get_name_for_ids(id2term.keys()) # search with found IDs to grab the taxonomic name. 
        for id in id2names.keys():
            res[id2term[id]] = ("%s/%s" %(TAXON_URL_BASE,res[id2term[id]][0]), id2names[id]) # Build URL from IDs
        
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
