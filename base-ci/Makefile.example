#!make

SHELL		       = bash

#git submodule add git@github.com:afonsoaugusto/base-ci.git
BASE_MAKEFILE := $(shell git submodule foreach git pull origin master)
include base-ci/Makefile
include vars.env

clean: terraform-clean
fmt: terraform-fmt
plan: terraform-plan
apply: terraform-deploy
deploy: plan apply
destroy: destroy-terraform
