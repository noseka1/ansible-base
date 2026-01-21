# This Dockerfile is based on https://openshift-kmm.netlify.app/labsv2/
ARG DTK_AUTO
ARG KERNEL_FULL_VERSION

FROM ${DTK_AUTO} as builder

WORKDIR /build/

RUN git clone \
  -b main \
  --single-branch \
  https://github.com/rh-ecosystem-edge/kernel-module-management.git

WORKDIR kernel-module-management/ci/kmm-kmod/

RUN make

FROM docker.io/redhat/ubi8-minimal

ARG KERNEL_FULL_VERSION

RUN microdnf -y install kmod openssl && \
  microdnf clean all && \
  rm -rf /var/cache/yum

RUN mkdir -p /opt/lib/modules/${KERNEL_FULL_VERSION}

COPY \
  --from=builder \
  /build/kernel-module-management/ci/kmm-kmod/*.ko \
  /opt/lib/modules/${KERNEL_FULL_VERSION}/

RUN /usr/sbin/depmod -b /opt
