FROM quay.io/prometheus/busybox:latest

COPY xo                       /bin/xo
COPY ${GOPATH}/bin/goimports  /bin/goimports