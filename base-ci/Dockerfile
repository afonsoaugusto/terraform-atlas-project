FROM amazonlinux:2

LABEL maintainer.name="Afonso Rodrigues"
LABEL maintainer.email=afonsoaugustoventura@gmail.com  

ARG TERRAFORM_VERSION
ARG TFSEC_VERSION

ENV TERRAFORM_VERSION=0.14.7
ENV TFSEC_VERSION=0.38.4

RUN yum -y update

RUN yum -y install python3 \
    python3-pip \
    shadow-utils

RUN adduser ci && \
    yum -y install make \
    unzip \
    wget \
    ruby \
    git \
    tar \
    jq \
    pip3 install ansible==3.0.0 && \
    yum clean all

RUN amazon-linux-extras install docker -y && \
    usermod -a -G docker ci

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"  && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chown ci:ci terraform && \
    mv  terraform /bin/terraform

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm -rf awscliv2.zip && \
    bash ./aws/install

RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin

RUN curl -Lso tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && \
    chown ci:ci tfsec && \
    chmod +x tfsec && \
    mv tfsec /bin/tfsec

WORKDIR /home/ci/

USER ci

CMD ["bash"]
