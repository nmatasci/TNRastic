import urllib
import time
import sys
import json
from xml.etree.ElementTree import fromstring


BASE_SUBMIT_URL = "http://localhost/submit"
BASE_RET_URL = "http://localhost/retrieve"

BAD_XML_ERROR = "NCBI XML could not be parsed: %s\n (quary=%s)"
MP_ID_ERROR = "We expect one ID back from NCBI, but we got more than one ID. Oops!"

def call_tnrs_api(search_terms):

    # Submit request for a list of taxon IDs
    parameters={"query":"\n".join(search_term)}

    # Send the request (POST) and get the job id
    f = urllib.urlopen(BASE_SUBMIT_URL,urllib.urlencode(parameters))

    # keep checking the results
    f = urllib.urlopen(id_url)
    while f.getcode() == 202:
        f = urllib.urlopen(id_url)
        time.sleep(1)
    if f.getcode() == 200:
        data = f.read()
        f.close()
        return data
    else:
        raise Exception ("API call not successful.",f.getcode())

def get_name_for_ids(ids):

    idToName = {}

    # Get Taxon summary from  NCBI taxonomy for a given list of IDs
    parameters={"db":'taxonomy',"id":",".join(ids)}

    # Build URL and send make the request
    f = urllib.urlopen("%s?%s" %(BASE_SUMMARY_QUARY,urllib.urlencode(parameters)))
    data = f.read()
    f.close()

    # Parse the resulting XML file (no automatic validation for now. We do have DTDs that we can later use to do validation) 
    dom = fromstring(data)
    
    # Find IdList and make sure it is not empty
    sumElements = dom.findall("DocSum")
    if len(sumElements) != len(ids):
        raise Exceptoin(BAD_XML_ERROR)
    
    for docSum in sumElements:
        id = docSum.find('Id').text
        name = [x.text for x in docSum.findall("Item") if x.get('Name') == "ScientificName"]
        if len (name) != 1:
            raise Exception(BAD_XML_ERROR)
        idToName[id] = name[0]

    return idToName

if __name__ == '__main__':    
    jres={}
    res = {}
    id2term = {}
    try:
        for t in sys.stdin:
            term = t[0:-1]
            id = search_NCBI_for_ids(term)
            time.sleep(0.1)
            if id is not None:
                id2term[id] = term
            res[term] = (id,None)
        id2names = get_name_for_ids(id2term.keys())
        for id in id2names.keys():
            res[id2term[id]] = ("%s/%s" %(TAXON_URL_BASE,res[id2term[id]][0]), id2names[id])
        
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
    
