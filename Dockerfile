FROM        quay.io/prometheus/busybox:latest

COPY xo /bin/xo

CMD [ "xo" ]