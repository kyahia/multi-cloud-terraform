#!/bin/bash

aws ec2 describe-images --filters "Name=name,Values=ubuntu*18.04*" "Name=architecture,Values=x86" > ubuntu_18.04.json
aws ec2 describe-images --filters "Name=name,Values=ubuntu*20.04*" "Name=architecture,Values=x86" > ubuntu_20.04.json
aws ec2 describe-images --filters "Name=name,Values=ubuntu*22.04*" "Name=architecture,Values=x86" > ubuntu_22.04.json

aws ec2 describe-images --filters "Name=name,Values=Fedora-Cloud-Base-34*" "Name=architecture,Values=x86_64" > fedora34.json

aws ec2 describe-images --filters "Name=name,Values=CentOS*7*" "Name=architecture,Values=x86_64" > centos7.json

aws ec2 describe-images --filters "Name=name,Values=Windows*2022*" "Name=architecture,Values=x86_64" > windows_2022.json