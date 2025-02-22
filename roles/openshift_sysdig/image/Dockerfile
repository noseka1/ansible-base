# This Dockerfile is based on
# https://github.com/draios/sysdig/tree/722a40a2286523b72e2bc2d9cc5d2ab2c9d333f4/docker/sysdig
FROM registry.access.redhat.com/ubi9/ubi

LABEL usage="docker run --rm -i -t --privileged --net=host -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /src:/src -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro -v /etc:/host/etc:ro --name NAME IMAGE"

ARG BUILD_VERSION=0.1.1dev
ENV BUILD_VERSION=${BUILD_VERSION}

ENV HOST_ROOT /host
ENV HOME /root

RUN yum -y install \
    make \
    kmod \
    gcc \
    clang \
    llvm-toolset \
    less

RUN mkdir -p /tmp/dkms \
    && cd /tmp/dkms \
    && curl --remote-name-all -L https://github.com/dell/dkms/archive/refs/tags/v2.8.5.tar.gz \
    && tar --strip-components=1 -xf v2.8.5.tar.gz \
    && make tarball \
    && make install \
    && cd /tmp \
    && rm -fr /tmp/dkms

# Enable deprecated SHA-1 for signing
# See also https://www.redhat.com/en/blog/rhel-security-sha-1-package-signatures-distrusted-rhel-9
RUN update-crypto-policies --set DEFAULT:SHA1

# Download sysdig package from the Sysdig rpm repo
RUN rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public && \
    curl -s -L https://s3.amazonaws.com/download.draios.com/stable/rpm/draios.repo -o /etc/yum.repos.d/draios.repo && \
    dnf download --destdir / sysdig

# Install sysdig package with --nodeps (dependency dkms is not available)
RUN rpm --nodeps --force -i /sysdig-*-$(uname -p).rpm && rm /sysdig-*-$(uname -p).rpm

COPY docker-entrypoint.sh /

RUN rm -df /lib/modules \
	&& ln -s $HOST_ROOT/lib/modules /lib/modules

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bash"]

# The subscription-manager in the UBI9 image is not able to detect that it is running in a container:
#
# $ subscription-manager status
# +-------------------------------------------+
#    System Status Details
# +-------------------------------------------+
# Overall Status: Unknown
#
# System Purpose Status: Unknown
#
# The subscription-manager in the UBI8 image worked correctly:
#
# $ subscription-manager status
# subscription-manager is disabled when running inside a container. Please refer to your host system for subscription management.
#
# The subscription-manager in UBI9 image doesn't fill the content of /etc/yum.repos.d/redhat.repo properly, instead it removes all
# repositories from this file. This makes installing of any RHEL images impossible.
# As a workaround, let's keep the redhat.repo file generated during the image build in the image and rename it to
# redhat.workaround.repo so that the subscription-manager doesn't delete its content.
# Not that this redhat.workaround.repo file hard-codes the locations of RHEL entitlement files and so will only work on machines
# which use the same locations.

RUN mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.workaround.repo
