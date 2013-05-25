#!/usr/bin/python 
import csv

#prepare data for js d3.js

def writePeopleLink(name1, name2):
	s = '"'+name1+'","'+name2+'",'+str(getTotalLinks(name1)+getTotalLinks(name2))+"\r"
	print s
	writer.write(s)
	
def writeCompanyLink(company, name):
	s = '"'+company+'","'+name+'",'+str(getTotalLinks(name))+"\r"
	print s
	writer.write(s)

# find links 
def getRelationsInCompany(company,name, id):
	reader = csv.reader(open('boards.csv', 'rb'))
	rowId = 0
	links = ""
	for index,row in enumerate(reader):
		if row[0]==company and id!=rowId:
			writeLink(name, row[1])	
		rowId+=1
	links = links[:-1]
	return links
	
# get total links
def getTotalLinks(name):
	reader = csv.reader(open('boards.csv', 'rb'))
	totalLinks = 0
	links = ""
	for index,row in enumerate(reader):
		if row[1]==name and id!=rowId:
			totalLinks+=1
	return totalLinks
	
writer = open("board_relations.csv", "w")
reader = csv.reader(open('boards.csv', 'rb'))
rowId = 0
for index,row in enumerate(reader):
	if rowId>0:
		writeCompanyLink(row[0],row[1])
		#getRelationsInCompany(row[0],row[1],rowId)
		rowId +=1
	else:
		writer.write("source,target,value\r")
		rowId +=1
writer.close()