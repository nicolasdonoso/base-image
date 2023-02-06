FROM docker:stable

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.20.15"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.6.1"
# Note: Latest version of terraform may be found at:
# https://github.com/hashicorp/terraform/releases
ENV TERRAFORM_VERSION="0.13"
# https://api.github.com/repos/kubernetes/kops/releases
ENV KOPS_VERSION="v1.22.3"

RUN apk add --no-cache ca-certificates bash git openssh curl gettext zip rsync jq \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm
RUN curl -fL https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 -o /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/terraform \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN apk add --update \
    python3 \
    python3-dev \
    py3-pip \
    npm \
    make \
    openssl-dev \
    openssl \
    libffi-dev \
    gcc \
    libc-dev \
    nodejs \
    npm

RUN pip install awscli
RUN pip3 install semver
RUN pip3 install boto3==1.12.41

RUN curl -sL https://run.linkerd.io/install | sh
ENV export PATH="${PATH}:$HOME/.linkerd2/bin"