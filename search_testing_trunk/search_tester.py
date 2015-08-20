import data_utilities
import numpy as np
import editdist
from collections import Counter

"""
searchable:
	subject_code_prefix
	title
	subject_code_suffix
	description
	instructor name
	typos:
		levenshtein
		dynamic programming
"""

def parse_query_search(class_data, query):
	departments = get_departments(class_data)
	parsed_query = parse_query(query)
	course_prefix_match = match_by('subject_code_prefix', class_data, parsed_query)
	course_suffix_match= match_by('subject_code_suffix', class_data, parsed_query)
	course_title_match = match_by('title', class_data, parsed_query)
	course_description_match = match_by('description', class_data, parsed_query)
	classes = sort_matches([course_prefix_match, course_suffix_match, course_title_match, course_description_match], weights=[100, 15, 50, 10])
	print classes
	
def sort_matches(matches, weights=None):
	if weights is None:
		weights = [1] * len(matches)
	course_weights = Counter()
	for i, match in enumerate(matches):
		for course in match:
			course_weights[course['full_title']] += weights[i]

	return course_weights.most_common(10)

def match_by(match, class_data, parsed_query):
	classes = set()
	for query_substring in parsed_query:
		classes = get_classes_by_key_value(class_data, match, query_substring)
	return classes

def get_classes_by_key_value(class_data, key, value):
	classes = []
	for i, class_datum in enumerate(class_data):
		if key == 'subject_code_prefix':
			if value == class_datum.get(key):
				classes.append(class_datum)
		else:
			if value in class_datum.get(key):
				if key == 'subject_code_prefix':
					print value in class_datum.get(key)
				classes.append(class_datum)
	return classes

def get_departments(class_data):
	departments = set()
	for i, class_datum in enumerate(class_data):
		departments.add(class_datum.get('subject_code_prefix'))
	return departments

def parse_query(query):
	return query.split(' ')

def test_levenshtein(class_data, query):
	all_levenshtein = []
	for i, class_datum in enumerate(class_data):
		class_title = class_datum.get('full_title')
		all_levenshtein.append((i, editdist.distance(query, class_title.encode('utf-8'))))
	all_levenshtein_sorted = sorted(all_levenshtein,key=lambda x: x[1])
	top_lev = []
	for i, tup in enumerate(all_levenshtein_sorted):
		pos, lev = tup
		print "{0}: '{1}'' with levenshtein distance of {2}".format(i, class_data[pos].get('full_title'), lev)
		top_lev.append(class_data[pos].get('title'))
		if i == 9:
			break

def test_completer(class_data, query):
	titles = []
	for class_datum in class_data:
		titles.append(class_datum.get('full_title'))
	completer = MyCompleter(titles)
	top = completer.complete(query, range(5))
	print top

class MyCompleter(object):  # Custom completer

	def __init__(self, options):
		self.options = sorted(options)

	def complete(self, text, states):
		if text:  # cache matches (entries that start with entered text)
			self.matches = [s for s in self.options 
								if s and s.startswith(text)]

		# return match indexed by state
		try: 
			complete = []
			print len(self.matches)
			for state in states:
				complete.append(self.matches[state])
			return complete
		except IndexError as e:
			print e
			return None


if __name__ == '__main__':
	class_data = data_utilities.read_data('all_class_data.json')['results']
	query = raw_input("Class query: ")
	parse_query_search(class_data, query)