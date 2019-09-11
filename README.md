# A Simple F5 Application Services Demo Environment in AWS


## Introduction

This is a beta version of a new cloud-based demo environment that will set up a VPC within AWS (more clouds to follow) containing an Ubuntu Linux client instance (the Utility Server), an F5 BIG-IP, and Ubuntu Linux server EC2 instance. 

![alt text](https://github.com/RuncibleSpoon/F5AppSvcDemo/raw/master/images/lab.png "lab layout" )

The deployment is done using [AWS Cloudformation](https://aws.amazon.com/cloudformation/) using the supplied cloudformation template. 

The client and server instances run [Docker](https://www.docker.com/) community edition and come laded with some tools and test scenarios to enable you to try out various application services like Web Application firewalls.  

All configuration of the BIG-IP is done via [AS3](http://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) launched from a simple Python script - no BIG-IP admin experience  required.

This repository is cloned onto the client as part of the Cloudformation deployment.



## Requirements 

You will need: 

1) An AWS account and the knowledge to operate it 
2) An AWS S3 bucket to put the AWS 
3) Ideally API access to AWS - this lab is primarily designed to be started from the CLI
4) Patience - this is an early beta with more work to do!
5) To have subscribed to the F5 BIG-IP used in this lab


## Some important notes 

There are a couple of important things to know:

1) ***This lab is not built to best practices for production security***. In particular you are asked to supply a key pair for use in the demo - this should be disposable (you will still need to specify a standard AWS key pair for remote access )

2) This lab is only  available in us-west-1, eu-west-1, and ap-northeast-1 in this version.


# Documentation #

See below for instructions for starting the lab and running your first declaration
Each sample test will come with instructions and explanations

## Subscribing to the software ##

1. Log in to the AWS Marketplace at [https://aws.amazon.com/marketplace](https://aws.amazon.com/marketplace).
2. Navigate to the  [BIG-IP Virtual Edition BEST (PAYG, 25Mbps)](https://aws.amazon.com/marketplace/pp/B079C4WR32) page
3. Click on the "Continue to Subscribe" button

## Starting the Lab ##


### Required Parameters 

This lab is designed to be as turnkey as possible, with only a couple of mandatory parameters:

**KeyName**: the name of the AWS keypair for auth into the devices
**S3Bucket**: The S3 bucket location
**DemoPrivateKey, DemoPublicKey**: Disposable SSH public and private keys
**BigIpAdminPW**: The admin password for the BIG-IP

There are also two others you should set for restricting access

**SrcIp**:  Source IP address range for SSH 
**PubScrIP**:  Source IP for App access

These deplyoments default to open access, so tying them down with a network range might be smart. 

### Steps

1) Create an S3 bucket - and give it public access attributes 
2) Upload the templates from the templates directory into the bucket
3) Create a disposable ssh key pair and  save the private key sd id_rsa, and the public key as key.pub (this is very bad practice for a production system, but just about OK for this demo)
4) Launch the Lab - use tool of your choice - this lab was developed using Windows PowerShell for AWS - but you can use the any method you like. An example Script to launch the lab form powershell is supplied.
5) Go and make a cup of tea. The setup scripts on the BIG-IP take a bit of time to run.
6) Get the access details - the parent template outputs the IP addresses for the Utility Server, the BIG-IP and the App server.
7) Login to the util server and complete a couple of post setup tasks 
8) Explore the labs

Template outputs 

Output | Description
------- | --------------------------------------------------
UtilServerIP | The public IP address of the utility server
AppServerIP | The public IP address of the application server
BIGIPIP | The public IP address of the BIG-IP 
BIGIPUrl  | The URL to access the management console of the BIG-IP (use after you set the password in the post install tasks)

### Post  Install tasks 

provision the software modules on the BIG-IP

`sh ./home/ubuntu/setup.sh`

## Exploring the Lab

### Current Back ends 

There are two running containers on the application server

* A Simple NGINX web server on port 80
* The [OWASP Juicebox App](https://www.owasp.org/index.php/OWASP_Juice_Shop_Project) on port 3000
* A pair of servers running the blue and the green application for the blue/green testing scenarios (port 9080, 9081)

Test Scenarios are defined in the scenarios directory with their own readme, and a AS3 declaration to make the application accessible. 



## Filing Issues and Getting Help
If you come across a bug or other issue when using this lab use [GitHub Issues](https://github.com/RuncibleSpoon/F5AppSvcDemo/issues) to submit an issue for our team.  You can also see the current known issues on that page, which are tagged with a purple Known Issue label.  


## License and Warranty

This software is supplied under the MIT license, strictly for testing purposes, and with absolutely no warranty whatsoever. 

Please see the LICESNSE.txt file for details. 

## Copyright

Copyright 2014-2019 F5 Networks Inc.


### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).  

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects. Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.  

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.   

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein. You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA. 


