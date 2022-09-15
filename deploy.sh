#!/bin/bash

aws > /dev/null 2>&1; rc1=$?;
if [[ $rc1 = 0 ]]; then
	echo "AWS Cli is not installed or not working in this system. Please install,configure and try again."
	exit 1
fi

read -p "Enter your S3 bucket name to upload packages : " S3bucket
read -p "Enter your region where you want to spinup infrastructure : " Region
read -p "Enter your environment name : " EnvironmentName
read -p "Enter your domain name : " DomainName
read -p "Enter your route53 domain hosted zone ID : " HostedZoneId
read -p "Enter your DB user name : " MasterUsername
read -sp "Enter your DB password : " MasterUserPassword
echo ""
read -p "Enter your IP from which you wish to connect bastion host : " SSHLocation
read -p "Enter your ssh key : " SSHKey
echo ""
echo "-----------------------------------------------------------------------------------"
echo ""

bucket=$(aws s3 ls | awk {'print $3'} | grep "$S3bucket")

if [[ "$bucket" == "$S3bucket" ]]; then
    echo "S3 bucket already exists. Skipping to create bucket and going to upload package."
else
    aws s3api create-bucket --bucket $S3bucket --region $Region --create-bucket-configuration LocationConstraint=$Region
fi
if [ -e packaged.yaml ]; then
    echo "It is already packaged. Skipping the package again."
else
    aws cloudformation package --template-file main.yaml --output-template packaged.yaml --s3-bucket $S3bucket --region $Region
fi
echo "Deployment will be start shortly."
sleep 5
aws cloudformation deploy --region $Region --template-file packaged.yaml --stack-name frndcode \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM \
    --parameter-overrides \
    EnvironmentName=$EnvironmentName \
    DomainName=$DomainName \
    HostedZoneId=$HostedZoneId \
    MasterUsername="$MasterUsername" \
    MasterUserPassword="$MasterUserPassword" \
    SSHKey="$SSHKey" \
    SSHLocation="$SSHLocation"