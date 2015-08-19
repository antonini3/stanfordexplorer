from bs4 import BeautifulSoup
import requests

def main():	
	headers = {
    'User-Agent': "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
	}
	url_list = [
			'https://explorecourses.stanford.edu/search?view=catalog&filter-coursestatus-Active=on&page=',
			'0',
			'&catalog=&academicYear=&q=%25'
	]
	for i in xrange(1403):
		url = ''.join(url_list)
		print url
		url_list[1] = str(i+1)
	r  = requests.get(url, headers=headers)
	print r
	data = r.text
	soup = BeautifulSoup(data)
	for link in soup.find_all('a'):
		print(link.get('href'))
if __name__ == '__main__':
	main()