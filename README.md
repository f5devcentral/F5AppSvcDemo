# F5 Application Services Demo Environment in AWS


## Introduction

The goal of the F5 demo environment is to highlight a few examples of the solutions available in F5 Application Services. At present it shows the how you can easily support:

1) [Load balancing](https://www.f5.com/products/big-ip-services/local-traffic-manager) across a blue/green test scenario
2) Some of the capabilities available in the [Advanced Web Application Firewall (AdvWAF)](https://www.f5.com/products/security/advanced-waf)

At it's core, the demo is deployed on an AWS demo environment that will set up a VPC containing an Ubuntu Linux client instance (the Utility Server), an F5 BIG-IP instance, and an Ubuntu Linux server App Server instance. The demo will be available on more clouds soon, however F5's Application Services are already available on Azure and GCP. 

![alt text](https://github.com/F5devcentral/F5AppSvcDemo/raw/master/images/lab.png "lab layout" )


## Technical Overview
The deployment is done using [AWS Cloudformation](https://aws.amazon.com/cloudformation/) using the supplied CloudFormation template. 

The client and server instances run [Docker](https://www.docker.com/) Community Edition and come laded with some tools and test scenarios to enable you to try out various application services like Web Application Firewalls.  

All configuration of the BIG-IP is done via an automation interface called [AS3](http://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) which is launched from a simple Python script - with no BIG-IP admin experience  required.

This repository is cloned onto the client as part of the CloudFormation deployment.



## Requirements 

You will need: 

1) An AWS account with the ability to create CloudFormation templates, S3 buckets, EC2 instances, and IAM roles
2) An AWS S3 bucket to put the templates and files 
3) Have subscribed in the AWS Marketplace to the F5 BIG-IP instance used in this lab (see below)
4) A pre-generated public and private key pair for server to server communication (see below)
5) An EC2 key pair for SSH from your client to the Util Server 


## Some important notes 

There are a couple of important things to know:

1) ***This lab is not built to best practices for production security***. In particular you are asked to supply a key pair for use in the demo - this should be disposable (you will still need to specify an EC2 AWS key pair for remote access )

2) This lab is only  available in US-WEST-1, EU-WEST-1, and AP-NORTHEAST-1 in this version.


# Documentation #

See below for instructions for starting the lab and running your first declaration
Each sample test will come with instructions and explanations

## Subscribing to the software ##

1. Log in to the AWS Marketplace at [https://aws.amazon.com/marketplace](https://aws.amazon.com/marketplace).
2. Navigate to the  [BIG-IP Virtual Edition BEST (PAYG, 25Mbps)](https://aws.amazon.com/marketplace/pp/B079C4WR32) page
3. Click on the "Continue to Subscribe" button
4. Do NOT continue with configuration - you will use a CloudFormation Template to create and configure the instance itself

## Starting the Lab ##


### Required Parameters 

This lab is designed to be as turnkey as possible, with only a couple of mandatory parameters:

**KeyName**: the name of the AWS EC2 keypair for auth into the devices
**S3Bucket**: A S3 bucket location
**DemoPrivateKey, DemoPublicKey**: Disposable SSH public and private keys
**BigIpAdminPW**: The admin password for the BIG-IP

There are also two others you should set for restricting access

**SrcIp**:  Source IP address range for SSH. If you're primarily going to be doing this at work, use the IP address range for your work environment. 
**PubScrIP**:  Source IP for App access. Same as the above.

These deployments default to open access, so tying them down with a network range is strongly recommended. 

### Steps

1) Create an S3 bucket - and give it public access attributes 
2) Upload the templates from the CFT (short for Cloud Formation Template) directory into the bucket
3) Create a disposable SSH key pair such as [ssh-keygen](https://www.ssh.com/ssh/keygen) and save the private key my-key-pair, and the public key as my-key-pair.pub (this is very bad practice for a production system, but OK for this demo). Upload the keys into the S3 bucket. As a code sample:
    `ssh-keygen -P "" -t rsa -b 4096 -m pem -f my-key-pair`

4) Launch the Lab - There are two methods to launch this lab:
   - Windows PowerShell for AWS - refer to the PowerShell directory for these scripts, paying careful attention to the required input parameters. 
   - CloudFormation Template - it's just as easy to logon to the AWS Management Console, navigate to the CloudFormation section and create your own stack from the single lab.yaml file. It will also the require parameters discussed above. 
5) Give it time. The setup scripts on the BIG-IP take a bit of time to run. Even after the instances are running, give them 5 mins to settle down before proceeding with the setup scripts.
6) Get the access details - the parent template outputs the IP addresses for the Utility Server, the BIG-IP and the App server.
7) After waiting 5 mins post instance start, SSH to the Util server and complete a couple of post setup tasks. See below for details.
8) Explore the labs. See below for details.

 


Template outputs 

Output | Description
------- | --------------------------------------------------
UtilServerIP | The public IP address of the utility server
AppServerIP | The public IP address of the application server
BIGIPIP | The public IP address of the BIG-IP 
BIGIPUrl  | The URL to access the management console of the BIG-IP (use after you set the password in the post install tasks)

### Post  Install tasks 

SSH to the Utility Server

`ssh -i "ec2_ssh.pem" ubuntu@your-host-name`

provision the software modules on the BIG-IP

`sh /home/ubuntu/F5AppSvcDemo/setup.sh`

Enter the password for each step of the setup script

## Exploring the Lab

### Current Back ends 

There are two running containers on the application server:

* A Simple NGINX web server on port 80
* The [OWASP Juicebox App](https://www.owasp.org/index.php/OWASP_Juice_Shop_Project) on port 3000
* A pair of servers running the blue and the green application for the blue/green testing scenarios (port 9080, 9081)

Test scenarios are defined in the scenarios directory with their own README, and an automation declaration to make the application accessible. 


## Filing Issues and Getting Help
If you come across a bug or other issue when using this lab use [GitHub Issues](https://github.com/F5DevCentral/F5AppSvcDemo/issues) to submit an issue for our team.  You can also see the current known issues on that page, which are tagged with a purple Known Issue label.  


## License and Warranty

This software is supplied under the MIT license, strictly for testing purposes, and with no warranty whatsoever. 

Please see the LICENSE.txt file for details. 

## Copyright

Copyright 2014-2019 F5 Networks Inc.


### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).  

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects. Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.  

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.   

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein. You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA. 
