FROM openshift/base-centos7

MAINTAINER Daniel Pfeifer <daniel@pfeifer.io>

ENV JAVA_MAJOR_VERSION=10
ENV AZUL_FULL_VERSION=${JAVA_MAJOR_VERSION}.2+3
ENV JAVA_FULL_VERSION=${JAVA_MAJOR_VERSION}.0.1
ENV JAVA_RPM_URL=https://cdn.azul.com/zulu/bin/zulu${AZUL_FULL_VERSION}-jdk${JAVA_FULL_VERSION}-linux.x86_64.rpm

LABEL io.k8s.description="OpenJDK 10-based UberJAR-runner" \
    io.k8s.display-name="OpenJDK 10" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="java,builder,jar" \
    io.openshift.s2i.scripts-url=image:///usr/local/s2i

RUN yum install -y $JAVA_RPM_URL && \
    yum clean all -y

RUN rm /usr/lib/jvm/zulu-10/lib/security/cacerts && \
    ln -s /etc/pki/java/cacerts /usr/lib/jvm/zulu-${JAVA_MAJOR_VERSION}/lib/security/cacerts

COPY ./.s2i/bin /usr/local/s2i

RUN mkdir -p /opt/app-root && \
    chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
