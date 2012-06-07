import urllib
import sys
import json
import time
from xml.etree.ElementTree import fromstring

BASE_SPELL_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/espell.fcgi"

BAD_XML_ERROR = 'NCBI XML could not be parsed: %s\n (quary=%s)'
SERVICE_ERROR = "NCBI service returned and error: %s"

def spellcheck_by_ncbi(input_term):

    search_term = input_term.replace("_"," ")
    
    # Search the taxanomy DB of NCBI for a given term
    parameters={"db":'taxonomy',"term":search_term}

    # Build URL and send make the request
    url = "%s?%s" %(BASE_SPELL_QUARY,urllib.urlencode(parameters))
    f = urllib.urlopen(url)
    data = f.read()
    f.close()

    # Parse the resulting XML file (no automatic validation for now. We do have DTDs that we can later use to do validation) 
    dom = fromstring(data)

    # Find IdList and make sure it is not empty
    errElm = dom.find("ERROR")    
    if errElm is None:
        raise Exception(BAD_XML_ERROR %("No ERROR Element found in XML",url))
    if errElm.text is not None:
        raise Exception(SERVICE_ERROR %errElm.text)

    # Find the retrieved IDs
    spellList = dom.findall("SpelledQuery")
    if len(spellList) == 1:
        spell = spellList[0]
        res = "".join([term.text for term in spell if term.text is not None]) 
        return res if res != "" else None
    else:
        return None 

if __name__ == '__main__':    
    jres={}
    res = {}
    try:
        for t in sys.stdin:
            term = t[0:-1]
            matchedName = spellcheck_by_ncbi(term)
            time.sleep(0.1)
            res[term] = matchedName
        
        jres["status"] = "200"
        jres["errorMessage"] = ""
        jres["names"] = []
        
        for t in res:
            jres["names"].append({
                    "submittedName":t,
                    "matchedName":res[t],
                    "score":"1" if res[t] is not None else "0",
                    "annotations":{}})
    except Exception as e:
        jres["status"] = "500"
        jres["errorMessage"] = str(e)
        jres["names"] = []
        
    print json.dumps(jres)
