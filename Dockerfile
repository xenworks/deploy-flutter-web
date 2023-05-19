FROM ubuntu:focal

ENV FLUTTER_VERSION "3.10.1-stable"
ENV FLUTTER_HOME "/opt/flutter"
ENV PATH=$PATH:${FLUTTER_HOME}/bin

RUN apk-get update \
    && apt-get install -y \
        curl \
        git \
        build-essential \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && mkdir -p {FLUTTER_HOME} \
    && curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz -o /tmp/flutter.tar.xz --progress-bar \
    && tar xf /tmp/flutter.tar.xz -C /tmp \
    && mv /tmp/flutter -T ${FLUTTER_HOME} \
    && rm -rf /tmp/flutter.tar.xz \
    && git config --global --add safe.directory /opt/flutter \
    && rm -rf /var/lib/apt/lists/* \
    && dart --version \
    && flutter --version

ENTRYPOINT [ "sh" ]
