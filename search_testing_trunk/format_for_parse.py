import data_utilities

def main():
	data = data_utilities.read_data('course_data.json')
	formatted_data = format_data(data)
	data_utilities.write_data(formatted_data, 'parse_formatted_course_data.json')

def format_data(data):
	for datum in data:
		if isinstance(datum.get('repeatable'), unicode) and len(datum.get('repeatable')) == 0:
			datum['repeatable'] = None
		if isinstance(datum.get('rating'), unicode) and len(datum.get('rating')) == 0:
			datum['rating'] = None
		del datum['courserank_id']
		datum['title'] = datum.get('department') + ' ' + datum.get('number') + ' ' + datum.get('name')
	formatted_data = {}
	formatted_data['results'] = data
	return formatted_data

if __name__ == '__main__':
	main()