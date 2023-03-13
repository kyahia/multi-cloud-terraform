#!/bin/bash


FEDORA_34_AMI=$(aws ec2 describe-images --filters "Name=name,Values=Fedora-Cloud-Base-34*" "Name=architecture,Values=x86_64")
FEDORA_33_AMI=$(aws ec2 describe-images --filters "Name=name,Values=Fedora-Cloud-Base-33*" "Name=architecture,Values=x86_64")
FEDORA_32_AMI=$(aws ec2 describe-images --filters "Name=name,Values=Fedora-Cloud-Base-32*" "Name=architecture,Values=x86_64")
