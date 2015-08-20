from queryIndex_tfidf import QueryIndex

def main():
	q = QueryIndex('title_tfidf_inverted_index.json', 'title_tf.json', 'title_df.json', 'all_class_data.json')
	q.queryIndex()

if __name__ == '__main__':
	main()