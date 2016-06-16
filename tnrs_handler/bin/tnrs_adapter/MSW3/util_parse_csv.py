import csv

import codecs, cStringIO, re

class UTF8Recoder:
    """
    Iterator that reads an encoded stream and reencodes the input to UTF-8
    """
    def __init__(self, f, encoding):
        self.reader = codecs.getreader(encoding)(f)

    def __iter__(self):
        return self

    def next(self):
        return self.reader.next().encode("utf-8")

class UnicodeReader:
    """
    A CSV reader which will iterate over lines in the CSV file "f",
    which is encoded in the given encoding.
    """

    def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
        f = UTF8Recoder(f, encoding)
        self.reader = csv.reader(f, dialect=dialect, **kwds)

    def next(self):
        row = self.reader.next()
        return [unicode(s, "utf-8") for s in row]

    def __iter__(self):
        return self

class UnicodeWriter:
    """
    A CSV writer which will write rows to CSV file "f",
    which is encoded in the given encoding.
    """

    def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
        # Redirect output to a queue
        self.queue = cStringIO.StringIO()
        self.writer = csv.writer(self.queue, dialect=dialect, **kwds)
        self.stream = f
        self.encoder = codecs.getincrementalencoder(encoding)()

    def writerow(self, row):
        self.writer.writerow([s.encode("utf-8") for s in row])
        # Fetch UTF-8 output from the queue ...
        data = self.queue.getvalue()
        data = data.decode("utf-8")
        # ... and reencode it into the target encoding
        data = self.encoder.encode(data)
        # write to the target stream
        self.stream.write(data)
        # empty queue
        self.queue.truncate(0)

    def writerows(self, rows):
        for row in rows:
            self.writerow(row)


r = UnicodeReader(open('MSW3.csv', 'rb'), encoding="latin_1",delimiter=',', quotechar='"')

f=open('MSW3_PARSED.csv', 'wb')
w = UnicodeWriter(f, delimiter=',',encoding="utf-8",
                         quotechar='"', quoting=csv.QUOTE_ALL)
fi=open('MSW3_INDEX.csv', 'wb')
ind = UnicodeWriter(fi, delimiter=',',encoding="utf-8",
                         quotechar='"', quoting=csv.QUOTE_ALL)

pattern = re.compile('<i>.*?</i>')

for row in r:
	if row[8] != "" and row[10] != "":
		row.append( "<i>%s %s </i>" %(row[8],row[10]))
	else:
		row.append("")
	w.writerow(row)

        rstripped = [" ".join(pattern.findall(c)) for c in row] 
        rstripped[0] = row [0]
        rstripped[12] = row [12]
        rstripped[34] = row [34]

	ind.writerow(rstripped)

f.close()
fi.close()
