FROM alpine:latest

# alpine needs glibc compat to install aws cli v2
ENV GLIBC_VER "2.34-r0"
ENV FLUTTER_VERSION "2.8.0-stable"
ENV FLUTTER_HOME "/opt/flutter"


RUN apk update && \
    apk --no-cache add \
        binutils \
        curl \
        git \
        openssh-client \
        rsync \
        bash \
        unzip \
    && curl -ksL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install

RUN mkdir -p {FLUTTER_HOME} && \
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz -o /tmp/flutter.tar.xz --progress-bar && \
    tar xf /tmp/flutter.tar.xz -C /tmp && \
    mv /tmp/flutter -T ${FLUTTER_HOME} && \
    rm -rf /tmp/flutter.tar.xz

RUN rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
        curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

ENV PATH=$PATH:${FLUTTER_HOME}/bin

ENTRYPOINT [ "sh" ]
