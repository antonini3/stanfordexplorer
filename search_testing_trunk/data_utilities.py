import json

def read_data(filename):
	f = open(filename, 'r')
	data = json.load(f)
	return data

def write_data(formatted_data, filename):
	f = open(filename, 'w')
	json.dump(formatted_data, f)
	f.close()