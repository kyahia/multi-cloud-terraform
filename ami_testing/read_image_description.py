import json
import sys
print(len(sys.argv))
print(sys.argv[1])

with open(sys.argv[1], "r") as images:
    images = json.load(images)
    centos_amis = [image["ImageId"] for image in images["Images"]]
    print(len(centos_amis))
