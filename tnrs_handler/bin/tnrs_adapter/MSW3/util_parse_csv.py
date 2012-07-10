import csv

r = csv.reader(open('MSW3.csv', 'rb'), delimiter=',', quotechar='"')
f=open('MSW3_PARSED.csv', 'wb')
w = csv.writer(f, delimiter=',',
                         quotechar='"', quoting=csv.QUOTE_ALL)
for row in r:
	if row[8] != "" and row[10] != "":
		row.append( "<i>%s %s </i>" %(row[8],row[10]))
	else:
		row.append("")
	w.writerow(row)

f.close()
