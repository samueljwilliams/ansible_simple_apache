Simple Website Provisioner
==========================
This is an Ansible (2.1.1) to provision a simple web server, configure it, and deploy a simple html page
It assumes:
- You have an AWS account
- You have AWS credential keys
- You have Ansible installed locally
- You have a public key generated
- You add your public key added to roles/aws_setup/files/apache_rsa.pub

You have said AWS credential keys in your ~/.boto file, under the "apache" profile
```
 [profile apache]
 output = json
 region = "{{ aws_region }}"
 aws_access_key_id = abc123
 aws_secret_access_key = 123abc
 ```

You create a file in vars/secrets.yml with the following:
```
---
aws_api_access_key: accesskey
aws_api_secret_access_key: secretacesskey
```

How to use
----------
This will create an EC2 instance in the us-west-2 region, setup a web server, and add a simple web page.

To use a different region, modify the group variables at ./inventories/group_vars/all

```
aws_region: us-west-2
```

Run the setup script
```
./setup.sh
```

Now you are done!