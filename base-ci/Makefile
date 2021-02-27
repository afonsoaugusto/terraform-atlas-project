MAKEFLAGS  	+= --silent
SHELL      	 = /bin/bash

export AWS_PAGER
export env
export TF_VAR_env
export PROJECT_NAME
export TF_VAR_project_name

AWS_PAGER	 := ""

PROJECT_NAME := ${CIRCLE_PROJECT_REPONAME}
BRANCH_NAME  := ${CIRCLE_BRANCH}
COMMIT_SHA   := $(shell echo ${CIRCLE_SHA1}| head -c 7)

ifndef CIRCLE_PROJECT_REPONAME
	PROJECT_NAME   			:= $(shell basename $(CURDIR))
	BRANCH_NAME   			:= $(shell git rev-parse --abbrev-ref HEAD)
	COMMIT_SHA   			:= $(shell git rev-parse --short HEAD)
endif

env := ${BRANCH_NAME}

TF_VAR_env := ${env}
TF_VAR_project_name := ${PROJECT_NAME}

# IMAGE_REGISTRY					 := 
# IMAGE_REGISTRY_USERNAME  := 
# IMAGE_REGISTRY_TOKEN		 := 

IMAGE_NAME_COMMIT  := ${IMAGE_REGISTRY_USERNAME}/${PROJECT_NAME}:${COMMIT_SHA}-${BRANCH_NAME}
IMAGE_NAME_BRANCH  := ${IMAGE_REGISTRY_USERNAME}/${PROJECT_NAME}:${BRANCH_NAME}
IMAGE_NAME_LATEST  := ${IMAGE_REGISTRY_USERNAME}/${PROJECT_NAME}:latest

docker-login:
	echo ${IMAGE_REGISTRY_TOKEN} | docker login -u ${IMAGE_REGISTRY_USERNAME} --password-stdin ${IMAGE_REGISTRY}

docker-build: docker-login
	docker build -t $(IMAGE_NAME_COMMIT) . && \
	docker push $(IMAGE_NAME_COMMIT) && \
	docker logout

docker-publish-branch: docker-login
	docker pull $(IMAGE_NAME_COMMIT)  && \
	docker tag $(IMAGE_NAME_COMMIT) $(IMAGE_NAME_BRANCH)  && \
	docker push $(IMAGE_NAME_BRANCH)

docker-publish: docker-login
	docker pull $(IMAGE_NAME_COMMIT)  && \
	docker tag $(IMAGE_NAME_COMMIT) $(IMAGE_NAME_LATEST)  && \
	docker push $(IMAGE_NAME_LATEST) && \
	docker logout

docker-scan:
	trivy --exit-code 1 $(IMAGE_NAME_COMMIT)

docker-clear:
	docker logout

docker-branch: docker-build docker-publish-branch docker-clear

terraform-generate-backend:
	cd ./${TERRAFORM_FOLDER}/ && \
	echo -e "terraform {\nbackend "s3" {}\n}" > backend.tf && \
	terraform fmt

terraform-tfsec:
	cd ./${TERRAFORM_FOLDER}/ && \
	tfsec . --no-color

terraform-clean:
	cd ./${TERRAFORM_FOLDER}/ && \
	rm -rf .terraform/ && \
	rm -rf .terraform.* && \
	rm -rf backend.tf && \
	rm -rf terraform.tfstate.d && \
	rm -rf .terraform.lock.hcl && \
	rm -rf tf.plan

terraform-fmt:
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform fmt -recursive

terraform-init: terraform-generate-backend
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform init \
	-backend-config="key=${PROJECT_NAME}/terraform.tfstate" \
	-backend-config="region=${AWS_REGION}" \
	-backend-config="bucket=${BUCKET_NAME}" 

terraform-select-workspace: terraform-init
	- cd ./${TERRAFORM_FOLDER}/ && \
	terraform workspace new $(env) 
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform workspace select $(env)

terraform-plan: terraform-select-workspace terraform-tfsec
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform plan -var-file=vars/global.tfvars -var-file=vars/${env}.tfvars -out tf.plan

terraform-deploy: terraform-select-workspace
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform apply -auto-approve tf.plan
	
terraform-destroy: terraform-select-workspace
	cd ./${TERRAFORM_FOLDER}/ && \
	terraform destroy -auto-approve -var-file=vars/global.tfvars -var-file=vars/${env}.tfvars

build: docker-build
scan: docker-scan
publish: docker-publish
