import urllib
import sys
import json
from xml.etree.ElementTree import fromstring

TAXON_URL_BASE="http://www.ncbi.nlm.nih.gov/taxonomy"

BASE_SEARCH_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
BASE_SUMMARY_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi"

BAD_XML_ERROR = "NCBI XML could not be parsed: %s\n (quary=%s)"
MP_ID_ERROR = "We expect one ID back from NCBI, but we got more than one ID. Oops!"

def search_NCBI_for_ids(search_term):
    # Search the taxanomy DB of NCBI for a given term
    parameters={"db":'taxonomy',"term":search_term}

    # Build URL and send make the request
    url = "%s?%s" %(BASE_SEARCH_QUARY,urllib.urlencode(parameters))
    f = urllib.urlopen(url)
    data = f.read()
    f.close()

    # Parse the resulting XML file (no automatic validation for now. We do have DTDs that we can later use to do validation) 
    dom = fromstring(data)

    # Find IdList and make sure it is not empty
    idListElement = dom.findall("IdList")    
    if len(idListElement) != 1:
        raise Exception(BAD_XML_ERROR %("Number of IdList elements is not right",search_term))
    
    # Find the retrieved IDs
    idList = idListElement[0].findall("Id")

        
    if len(idList) == 0:
        return None
    elif len(idList) > 1:
        raise MP_ID_ERROR
    else:
        id = idList[0].text
        return id

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
            if id is not None:
                id2term[id] = term
            res[term] = (id,None)
        id2names = get_name_for_ids(id2term.keys())
        for id in id2names.keys():
            res[id2term[id]] = ("%s/%s" %(TAXON_URL_BASE,res[id2term[id]][0]), id2names[id])
        
        jres["status"] = 200
        jres["errorMessage"] = ""
        jres["names"] = []
        
        for t in res:
            jres["names"].append({
                    "submittedName":t,
                    "matchedName":t if res[t][1] is not None else None,
                    "score":1 if res[t][1] is not None else 0,
                    "uri":res[t][0],
                    "annotations":{},
                    "acceptedName":res[t][1]})
    except Exception as e:
        jres["status"] = 500
        jres["errorMessage"] = e
        jres["names"] = []
        
    print json.dumps(jres)
    
