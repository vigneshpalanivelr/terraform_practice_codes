#!/bin/python

'''
Script to execute the external data provider in Terraform
To create ZIP file for Lambda
'''
import os
import sys
import json
import shutil

#import custom modules
sys.path.append(os.path.dirname(os.path.realpath(__file__)) + '/../pySetenv/packages/'  )
import copytree

def read_in():
    return {x.strip() for x in sys.stdin}

def copy_dirs(source, target):
	copytree.copytree(source, target)
	return True

def make_zip(dir, output):
	zip = shutil.make_archive(output, 'zip', dir)
	return zip

def main():
    lines = read_in()
    for line in lines:
    	if line:
    		jsondata = json.loads(line)
    if copy_dirs(jsondata['main_script'], jsondata['main_target']):
		if copy_dirs(jsondata['module_script'], jsondata['module_target']):
			zip = make_zip(jsondata['main_target'], jsondata['main_target'])
			if zip:
				zip = os.path.basename(zip)
				sys.stdout.write(json.dumps({'zip_file': zip}))

if __name__ == '__main__':
    main()