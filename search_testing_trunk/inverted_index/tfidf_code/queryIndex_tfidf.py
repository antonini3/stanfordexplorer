'''
Author: Arden Dertat
Contact: ardendertat@gmail.com
License: MIT License
'''

#!/usr/bin/env python

import sys
import re
from collections import defaultdict
import copy
import json
import time

class QueryIndex:

    def __init__(self, document_dict):
        start = time.clock()
        self.index={}
        self.tf={}      #term frequencies
        self.idf={}    #inverse document frequencies
        self.classes = None

        self.stopwordsFile= document_dict.get("stopwords")
        self.indexFile= document_dict.get("inverted_index")
        self.tf_file = document_dict.get('tf')
        self.idf_file = document_dict.get('idf')
        self.classes_file = document_dict.get('classes')
        print 'initialization took %.03f sec.' % (time.clock()-start)


    def intersectLists(self,lists):
        if len(lists)==0:
            return []
        #start intersecting from the smaller list
        lists.sort(key=len)
        return list(reduce(lambda x,y: set(x)&set(y),lists))
        
    
    def getStopwords(self):
        f=open(self.stopwordsFile, 'r')
        stopwords=[line.rstrip() for line in f]
        self.sw=dict.fromkeys(stopwords)
        f.close()
        

    def getTerms(self, line):
        line=line.lower()
        line=re.sub(r'[^a-z0-9 ]',' ',line) #put spaces instead of non-alphanumeric characters
        line=line.split()
        line=[x for x in line if x not in self.sw]
        return line
        
    
    def getPostings(self, terms):
        #all terms in the list are guaranteed to be in the index
        return [ self.index[term] for term in terms ]
    
    
    def getDocsFromPostings(self, postings):
        #no empty list in postings
        return [ [x[0] for x in p] for p in postings ]


    def readIndex(self):
        #read main index
        start = time.clock()
        self.index = json.load(open(self.indexFile, 'r'))
        self.classes = json.load(open(self.classes_file, 'r'))['results']
        self.tf = json.load(open(self.tf_file, 'r'))
        self.idf = json.load(open(self.idf_file, 'r'))
        #first read the number of documents
        self.numDocuments=int(len(self.classes))
        print 'loading documents took %.03f sec.' % (time.clock()-start)

        
     
    def dotProduct(self, vec1, vec2):
        if len(vec1)!=len(vec2):
            return 0
        return sum([ x*y for x,y in zip(vec1,vec2) ])
            
        
    def rankDocuments(self, terms, docs):
        #term at a time evaluation
        start = time.clock()
        docVectors=defaultdict(lambda: [0]*len(terms))
        queryVector=[0]*len(terms)
        for termIndex, term in enumerate(terms):
            if term not in self.index:
                continue
            queryVector[termIndex]=self.idf[term]
            
            for docIndex, (doc, postings) in enumerate(self.index[term]):
                if doc in docs:
                    docVectors[doc][termIndex]=self.tf[term][docIndex]
                    
        #calculate the score of each doc
        docScores=[ [self.dotProduct(curDocVec, queryVector), doc] for doc, curDocVec in docVectors.iteritems() ]
        docScores.sort(reverse=True)
        resultDocs=[x[1] for x in docScores][:10]
        #print document titles instead if document id's
        print 'ranking documents took %.03f sec.' % (time.clock()-start)
        curr = time.clock()
        result_titles = set()
        for result, id_ in docScores:
            for class_datum in self.classes:
                if id_ == class_datum['course_id']:
                    result_titles.add((class_datum['full_title'], result))
        print 'getting document names took %.03f sec.' % (time.clock()-start)
        return result_titles


    def queryType(self,q):
        if '"' in q:
            return 'PQ'
        elif len(q.split()) > 1:
            return 'FTQ'
        else:
            return 'OWQ'


    def owq(self,q):
        '''One Word Query'''
        originalQuery=q
        q=self.getTerms(q)
        if len(q)==0:
            print ''
            return
        elif len(q)>1:
            self.ftq(originalQuery)
            return
        
        #q contains only 1 term 
        term=q[0]
        if term not in self.index:
            print ''
            return
        else:
            postings=self.index[term]
            docs=[x[0] for x in postings]
            return self.rankDocuments(q, docs)
          

    def ftq(self,q):
        start = time.clock()
        """Free Text Query"""
        q=self.getTerms(q)
        if len(q)==0:
            print ''
            return
        
        li=set()
        for term in q:
            try:
                postings=self.index[term]
                docs=[x[0] for x in postings]
                li=li|set(docs)
            except:
                #term not in index
                pass
            
            li=list(li)
        print 'processing query took %.03f sec.' % (time.clock()-start)
        return self.rankDocuments(q, li)


    def pq(self,q):
        '''Phrase Query'''
        originalQuery=q
        q=self.getTerms(q)
        if len(q)==0:
            print ''
            return
        elif len(q)==1:
            self.owq(originalQuery)
            return

        phraseDocs=self.pqDocs(q)
        return self.rankDocuments(q, phraseDocs)
        
        
    def pqDocs(self, q):
        """ here q is not the query, it is the list of terms """
        phraseDocs=[]
        length=len(q)
        #first find matching docs
        for term in q:
            if term not in self.index:
                #if a term doesn't appear in the index
                #there can't be any document maching it
                return []
        
        postings=self.getPostings(q)    #all the terms in q are in the index
        docs=self.getDocsFromPostings(postings)
        #docs are the documents that contain every term in the query
        docs=self.intersectLists(docs)
        #postings are the postings list of the terms in the documents docs only
        for i in xrange(len(postings)):
            postings[i]=[x for x in postings[i] if x[0] in docs]
        
        #check whether the term ordering in the docs is like in the phrase query
        
        #subtract i from the ith terms location in the docs
        postings=copy.deepcopy(postings)    #this is important since we are going to modify the postings list
        
        for i in xrange(len(postings)):
            for j in xrange(len(postings[i])):
                postings[i][j][1]=[x-i for x in postings[i][j][1]]
        
        #intersect the locations
        result=[]
        for i in xrange(len(postings[0])):
            li=self.intersectLists( [x[i][1] for x in postings] )
            if li==[]:
                continue
            else:
                result.append(postings[0][i][0])    #append the docid to the result
        
        return result

    def queryIndex(self):
        self.readIndex()  
        self.getStopwords() 

        while True:
            q=sys.stdin.readline()
            if q=='':
                break
            print _query_index(self, q)

    def _query_index(self, q):
            qt=self.queryType(q)
            if qt=='OWQ':
                return self.owq(q)
            elif qt=='FTQ':
                return self.ftq(q)
            elif qt=='PQ':
                return self.pq(q)
        
if __name__=='__main__':
    document_dict = getParams()
    q=QueryIndex(document_dict)
    q.queryIndex()


    def getParams():
        param=sys.argv
        stopwordsFile=param[1]
        indexFile=param[2]
        tf_file = param[3]
        idf_file = param[4]
        classes = param[5]
        document_dict = {'inverted_index': indexFile,
                    "tf": tf_file,
                    "idf": tf_file,
                    "classes": idf_file,
                    "stopwords": stopwordsFile
                    }
        return document_dict
