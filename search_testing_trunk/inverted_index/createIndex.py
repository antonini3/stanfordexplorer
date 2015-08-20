'''
Author: Arden Dertat
Contact: ardendertat@gmail.com
License: MIT License
'''

#!/usr/bin/env python

import sys
import re
from collections import defaultdict
from array import array
import gc
import json


class CreateIndex:

    def __init__(self):
        self.index=defaultdict(list)    #the inverted index

    
    def getStopwords(self):
        '''get stopwords from the stopwords file'''
        f=open(self.stopwordsFile, 'r')
        stopwords=[line.rstrip() for line in f]
        self.sw=dict.fromkeys(stopwords)
        f.close()
        

    def getTerms(self, line):
        '''given a stream of text, get the terms from the text'''
        line=line.lower()
        line=re.sub(r'[^a-z0-9 ]',' ',line) #put spaces instead of non-alphanumeric characters
        line=line.split()
        line=[x for x in line if x not in self.sw]  #eliminate the stopwords
        return line


    def parseCollection(self, class_datum):
            d = {}
            d['id'] = class_datum.get('course_id')
            if self.get_title is True:
                d['text'] = class_datum.get('full_title')
            else:
                d['text'] = class_datum.get('description')
            return d


    def writeIndexToFile(self):
        f=open(self.indexFile, 'w')
        json.dump(self.index, f)
        f.close()


    def getParams(self):
        '''get the parameters stopwords file, collection file, and the output index file'''
        param=sys.argv
        self.stopwordsFile=param[1]
        self.collectionFile=param[2]
        self.indexFile=param[3]
        if 'title' in self.indexFile:
            self.get_title = True
        else:
            self.get_title = False

    def createIndex(self):
        '''main of the program, creates the index'''
        self.getParams()
        self.collJson=json.load(open(self.collectionFile,'r')).get('results')
        self.getStopwords()
                
        #bug in python garbage collector!
        #appending to list becomes O(N) instead of O(1) as the size grows if gc is enabled.
        gc.disable()
        
        #main loop creating the index
        for i, course_datum in enumerate(self.collJson):
            course_datum_dict = self.parseCollection(course_datum)
            course_id = int(course_datum_dict['id'])
            terms = self.getTerms(course_datum_dict['text'])

            #build the index for the current page
            termdict={}
            for position, term in enumerate(terms):
                try:
                    termdict[term][1].append(position)
                except:
                    termdict[term]=[course_id, [position]]
            
            #merge the current page index with the main index
            for termpage, postingpage in termdict.iteritems():
                self.index[termpage].append(postingpage)

        gc.enable()
            
        self.writeIndexToFile()
        
    
if __name__=="__main__":
    c=CreateIndex()
    c.createIndex()
    

