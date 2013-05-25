#!/usr/bin/python 
import csv

# find links 
def getLinks(name, id):
	reader = csv.reader(open('boards.csv', 'rb'))
	rowId = 0
	links = ""
	for index,row in enumerate(reader):
		if row[1]==name and id!=rowId:
			links+=str(rowId)+","	
		rowId+=1
	links = links[:-1]
	return links

writer = open("boards_with_relations.csv", "w")
writerR = open("boards_relations.csv", "w")
reader = csv.reader(open('boards.csv', 'rb'))
rowId = 0
for index,row in enumerate(reader):
	if rowId>0:
		s = str(rowId)+",["+str(getLinks(row[1],rowId))+"]"
		s_r = s +","+str(row)[1:-1]
		rowId +=1
		writer.write(s_r+"\r")
		writerR.write(s+"\r")
		print s
	else:
		writer.write("id,relation,"+str(row[1:-1])+"\r")
		writerR.write("id,relation"+"\r")
		rowId +=1
writer.close()
writerR.close()