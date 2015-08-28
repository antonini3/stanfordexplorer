from queryIndex_tfidf import QueryIndex
from collections import Counter
import sys

def main(query):
	document_dict = {'inverted_index': 'title_tfidf_inverted_index.json',
					"tf": "title_tf.json",
					"idf": "title_df.json",
					"classes": "all_class_data.json",
					"stopwords": "stopwords.dat"
					}

	q = QueryIndex(document_dict)
	q.readIndex()
	q.getStopwords()
	classes_titles = q._query_index(query)
	
	document_dict = {'inverted_index': 'description_tfidf_inverted_index.json',
					"tf": "description_tf.json",
					"idf": "description_df.json",
					"classes": "all_class_data.json",
					"stopwords": "stopwords.dat"
					}

	q = QueryIndex(document_dict)
	q.readIndex()
	q.getStopwords()
	classes_description = q._query_index(query)

	classes = Counter()
	if classes_titles is not None:
		for class_, tfidf in classes_titles:
			classes[class_] += (5* tfidf)
	if classes_description is not None:
		for class_, tfidf in classes_description:
			classes[class_] += (2*tfidf)

	print classes.most_common(10)

if __name__ == '__main__':
	while True:
		q=sys.stdin.readline()
		if q=='-1':
			break
		main(q)