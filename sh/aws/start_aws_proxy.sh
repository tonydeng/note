#!/bin/bash
ssh -i ~/.ssh/aws_key/duoqu_aws_key.pem -p 8015 -CfNg -L 8089:127.0.0.1:8888 ec2-user@52.68.169.148
