# Testing out F5 Application Security Services with the OWASP JuiceShop App


## Introduction 

The [OWASP Juicebox App](https://www.owasp.org/index.php/OWASP_Juice_Shop_Project) is a well written, almost-bug free application that is chock full of vulnerabilities for you to find and exploit.  

For this test scenario you can first configure the BIG-IP to proxy traffic to the container running on port 3000 on the app server, then check out a simple hack, then configure BIG-IP to protect the application, and run the test again. 

First, run the [AS3](http://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) declaration using the as3.py script:

`$python ~/F5AppSvcDemo/as3.py juiceshop.json`


Now navigate to the juiceshop app

http://<ipaddress of your BIG-IP install>/

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/juiceshop1.JPG "Juiceshop App")

We're going to try a simple SQL injection attack on the auth system - this is described by IncognitJoe in an [excellent document](https://incognitjoe.github.io/hacking-the-juice-shop.html) that can run you through a lot of the Juiceshop attacks.

Click the login link and use the email address of "'or 1==1" --  This is classic SQLi stuff

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/juiceshop2.PNG  "Juiceshop App")

Suddenly we've unlocked a challenge and are logged in as admin (user id 1). 

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/juiceshop3.PNG  "Hacked Juiceshop App")

Of course we should go and fix the code, but maybe spending 30 seconds to protect the app while we do it makes sense?


`$ python ~/F5AppSvcDemo/as3.py protect_juiceshop.json`

Let's try that again

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/juiceshop4.PNG "Juiceshop App")

OK, so we also discover another hack, where the system doesn't handle errors very gracefully, but at least we have shut off this attack. 

Taking a look at the [protect_juiceshop.json](https://github.com/RuncibleSpoon/F5AppSvcDemo/blob/master/declarations/protect_juiceshop.json) declaration, you can see a couple of key differences from the simple [juiceshop.json](https://github.com/RuncibleSpoon/F5AppSvcDemo/blob/master/declarations/juiceshop.json) declaration. 

In particular the relevant lines are 

`"pool": "juice_pool",
                     "policyWAF": {
                        "use": "JuiceShopASM"
                     },`

and                      


              `   "JuiceShopASM": {
                    "class": "WAF_Policy",
                    "url": "https://raw.githubusercontent.com/RuncibleSpoon/F5AppSvcDemo/master/scenarios/AppSec/JuiceShop.xml"
                    "ignoreChanges": true
                },`

Where we define which Web Application Firewall (WAF) policy to use, and later define the [policy location](https://github.com/RuncibleSpoon/F5AppSvcDemo/blob/master/scenarios/AppSec/JuiceShop.xml). The policy is readable, but is checksummed to prevent malicious interference. 

There are probably other hacks that this policy mitigates, why not try to find a few? 



