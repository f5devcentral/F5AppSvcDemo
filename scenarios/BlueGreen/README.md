# A Simple Blue Green Deployment


## Introduction 

[Blue Green deployments](https://martinfowler.com/bliki/BlueGreenDeployment.html) are a common way of getting new code into deployment. 

In this instance we have a very simple app that displays a soothing green page, and an exciting update that offers a pleasing blue.

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/blue.PNG "Blue App")

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/green.PNG "Green App")

Once the container(s) for the new version are up and running, how do we direct traffic over to the new updated visual experience? 

Do we want everyone to go there, or just start with a few connections?

How will we make sure that the new version is working correctly?

This is where an application aware proxy can really help.

## Setting up the basic app

Run the green.json AS3 declaration 

`ubuntu@util:~/F5AppSvcDemo$ python as3.py green.json` 

Now navigate to the app:

http:\/\/\<ipaddress of your BIG-IP install\>\/

And check you have a pleasing green app. 	

## Managing Ratios and Switching Instances 


Let's start with a 90:10 ratio of green to blue:


`$python ~/F5AppSvcDemo/as3.py bleu10green90.json`


Now navigate to the app again:

http:\/\/\<ipaddress of your BIG-IP install\>\/

You're probably going to get a green screen, but you never know. Since this could get a little tiresome, we've included a handy script that runs 100 HTTP GET requests and reports the results

`./scenarios/BlueGreen/counter.sh `


![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/B10G90.PNG  "Counter script results")

If we are happy with that, we can move to 50:50 ratio

`ubuntu@util:~/F5AppSvcDemo$ python as3.py blue50green50.json`

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/50B50G.PNG  "Counter script results")

And then maybe a 90:10

`ubuntu@util:~/F5AppSvcDemo$ python as3.py blue90green10.json`

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/B90G10.PNG  "Counter script results")

## Enhancing things with a rule to control who sees the new app


All this is fine, but what if you wanted to test out your changes on your internal audience first? 

Simple - we will just create a rule that sends all external traffic to the green app:

```
when HTTP_REQUEST {
   if { ![class match [IP::client_addr] equals "private_net"] } {
   
     log local0. "Client IP:[IP::client_addr] is external so going to Green node"
   
   node 	10.1.10.100 9080
   
   } else {
   
   log local0. "Client IP:[IP::client_addr] is internal so will be load balanced"
   
   pool web_pool
   
   }
   
}

```

And attach it to your AS3 declaration as an external stored file 

```
...
 "class": "Service_HTTP",
                     "iRules": ["external_green_only"],
                     "virtualAddresses": [
                         "10.1.10.50"
                     ],
 ...
 ```

```
...
"external_green_only": {
                    "class": "iRule",
                    "iRule": {
                    "url": "https://raw.githubusercontent.com/RuncibleSpoon/F5AppSvcDemo/master/scenarios/BlueGreen/irule.tcl"
                    }  
...
```                    

`~/F5AppSvcDemo$ python as3.py  blue10green90_external.json`


![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/b10_external.PNG  "Counter script results")

Which is as  you'd expect, but if you go the external app address you will ***always*** get the green app.

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/allgreen.png  "External app")


In addition we are logging the connections in this rule:

```
Sep  6 20:57:27 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 20:57:27 ip-10-1-10-50 info tmm[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 20:57:27 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 20:57:27 ip-10-1-10-50 info tmm[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 20:57:27 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 20:57:27 ip-10-1-10-50 info tmm[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:10.1.10.10 is internal so will be load balanced
Sep  6 21:00:20 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:24.19.222.3 is external so going to Green node
Sep  6 21:00:21 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:24.19.222.3 is external so going to Green node
Sep  6 21:00:21 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:24.19.222.3 is external so going to Green node
Sep  6 21:00:22 ip-10-1-10-50 info tmm1[16202]: Rule /Sample_01/A1/external_green_only <HTTP_REQUEST>: Client IP:24.19.222.3 is external so going to Green node

```
### What if  the New Version's not working? ###

Good question. Even in this simple deployment, you don't want users expecting a soothing blue page to be upset by a 500 error, or a "page not found" notice. What happens if the new app is failing?

Let's try.

First set things back to 50:50

`ubuntu@util:~/F5AppSvcDemo$ python as3.py blue50green50.json`

Now let's pause the new blue app

`ubuntu@util:~/F5AppSvcDemo$ ssh appserver docker pause blue_server
blue_server
ubuntu@util:~/F5AppSvcDemo$`

And run our counter test:

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/monitor.PNG  "with monitor")

Because the BIG-IP pro-actively monitors the app, traffic is only sent to the working version 

Let's fix the app and repeat:

`ubuntu@util:~/F5AppSvcDemo$ ssh appserver docker unpause blue_server
blue_server`

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/resume.PNG  "resumed")

You can see that once the blue app was market up, traffic resumed - there is also a 'slow start' grace period so that new instances don't get slammed straight away. 

Feel free to examine more ways to manage traffic there is a full reference guide for AS3 [available on-line](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/)