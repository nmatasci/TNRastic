import urllib2
#from xml.dom.minidom import parseString
from xml.etree.ElementTree import fromstring
BASE_SEARCH_QUARY = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"

def search_NCBI_for_ids(search_term):
	# Search the taxanomy DB of NCBI for a given term
	parameters={"db":'taxonomy',"term":search_term}

	# Build URL and send make the request
	f = urllib.urlopen("%s?%s" %(BASE_SEARCH_QUARY,urllib.urlencode(parameters)))
	data = f.read()
	f.close()

	# Parse the resulting XML file (no validation for now. We do have DTDs that we can later use to do validation) 
	dom = fromstring(data)

	idListElement = dom.findall("IdList")[0]
	
	if len(idListElement) == 0:
		raise "Error: IdList not found in the reponse XML."
	
	idList = idListElement.findall("Id")
	
	if len(idList) == 0:
		print ""
	elif len(idList) > 1:
		print ""
	else:
		id = idList[0].text
		print id
