# base-ci

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/25cba861ce2649f29eb31afc4d051bb7)](https://app.codacy.com/manual/afonsoaugustoventura/base-ci?utm_source=github.com&utm_medium=referral&utm_content=afonsoaugusto/base-ci&utm_campaign=Badge_Grade_Dashboard)
[![CircleCI](https://circleci.com/gh/afonsoaugusto/base-ci/tree/master.svg?style=svg)](https://circleci.com/gh/afonsoaugusto/base-ci/tree/master)
[![codebeat badge](https://codebeat.co/badges/7a92e416-4eb6-4d97-b58e-aae9ed33d456)](https://codebeat.co/projects/github-com-afonsoaugusto-base-ci-master)

Image base to execute pipelines

## Itens in this image

* TERRAFORM 0.14.7
* TFSEC 0.38.4
* Ansible
* AWS CLI
* Python3
* Ruby

```sh
> $ docker run --rm -it base-ci bash
[ci@055f78b59d47 /]$ ansible --version
ansible 2.9.7
  config file = None
  configured module search path = ['/home/ci/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.6.8 (default, Apr  2 2020, 13:34:55) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)]

[ci@055f78b59d47 /]$ terraform version
Terraform v0.12.24

[ci@055f78b59d47 /]$ aws --version

aws-cli/2.0.12 Python/3.7.3 Linux/5.0.0-38-generic botocore/2.0.0dev16
```