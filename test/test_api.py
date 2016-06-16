import urllib
import time
import sys
import json
from xml.etree.ElementTree import fromstring
import diffjson

BASE_SUBMIT_URL = "http://128.196.142.27:3000/submit"
#BASE_RET_URL = "http://localhost/retrieve"

BAD_XML_ERROR = "NCBI XML could not be parsed: %s\n (quary=%s)"
MP_ID_ERROR = "We expect one ID back from NCBI, but we got more than one ID. Oops!"

def call_tnrs_api(search_terms):

    # Submit request for a list of taxon IDs
    parameters={"query":"\n".join(search_terms)}

    print >>sys.stderr, "Sending the request in, with parameters: %s" %parameters
    # Send the request (POST) and get the job id
    f = urllib.urlopen(BASE_SUBMIT_URL,urllib.urlencode(parameters))
    data=f.read()
    f.close()
    jres = json.loads(data)
    print >>sys.stderr, "Sent the request in, and got results back: %s" %data
    id_uri = jres["uri"]
    print >>sys.stderr, "callback URL: %s" %id_uri

    # keep checking the results
    tries = 0
    f = urllib.urlopen(id_uri)
    while f.getcode() == 203 and tries < 51:
        tries += 1
        f = urllib.urlopen(id_uri)
        time.sleep(2)
        print >>sys.stderr, "sleeping and trying again: %d" %tries
    if f.getcode() == 200:
        data = f.read()
        f.close()
        print >>sys.stderr, "Data:\n %s" %data
        return data,jres["token"]
    else:
        raise Exception ("API call not successful.","HTTP Code: %d" %f.getcode(), "Tried %d times" %tries)

if __name__ == '__main__':
    s,id = call_tnrs_api(['Arabidopsis lyrata','Chlamydomonas_smithii'])
    res = json.loads(s)

    metadata=res["metadata"]
    assert metadata["jobId"] == id
    assert metadata["submitDate"] is not None and metadata["submitDate"] != ""

    expectedjson=json.load(open("test/testdata/expected.json"))
    if expectedjson !=  res:
        print "Expected:"
        print json.dumps(expectedjson)
        print "Actual:"
        print json.dumps(res)
        print str(diffjson.Diff(expectedjson,res,True,True).difference).replace(", u",",\nu")
