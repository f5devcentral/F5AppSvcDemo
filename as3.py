#Python Code to run an as3 declaration
#
import requests
import os
from requests.auth import HTTPBasicAuth
import argparse


# Get rid of annoying insecure requests waring
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# parse the arguement

parser = argparse.ArgumentParser()
parser.add_argument("declaration", help="The name of the declaration you want to send")
args = parser.parse_args()



#Set up our url for the as3 declaration 
#AS3BASE = 'https://raw.githubusercontent.com/RuncibleSpoon/F5AppSvcDemo/master/declarations/'
AS3BASE = "/home/ubuntu/F5AppSvcDemo/declarations/"
# Declaration location
#DECLARATION = AS3BASE + os.environ['DECLARATION']
DECLARATION = AS3BASE + args.declaration
IP = 'bigip.example.com'
PORT = '8443'
USER = 'admin'
PASS = os.environ['BIGPASS']
URLBASE = 'https://' + IP + ':' + PORT
TESTPATH = '/mgmt/shared/appsvcs/info'
AS3PATH = '/mgmt/shared/appsvcs/declare'

print("########### Fetching Declaration ###########")
#d = requests.get(DECLARATION)
d = open(DECLARATION,"r")
# Check we have connectivity and AS3 is installed
print('########### Checking that AS3 is running on ', IP ,' #########')
url = URLBASE + TESTPATH

r = requests.get(url, auth=HTTPBasicAuth(USER, PASS), verify=False)



if r.status_code == 200:
   data = r.json()
   if data["version"]:
      print('AS3 version is ', data["version"])
      print('########## Running Declaration #############')
      url = URLBASE + AS3PATH
      headers = { 'content-type': 'application/json',
              'accept': 'application/json' }
      r = requests.post(url, auth=HTTPBasicAuth(USER, PASS), verify=False,
         data=d, headers=headers)
      print('Status Code:', r.status_code,'\n', r.text)
   else:
      print('AS3 test to ',IP, 'failed: ', r.text)
