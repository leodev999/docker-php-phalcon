# vim:set ft=dockerfile:
FROM debian:buster-slim

ENV PHP_VERSION 7.2
ENV PHALCON_VERSION 3
ENV PG_CLIENT_VERSION 10

COPY build.sh /
RUN chmod +x /build.sh && ./build.sh

EXPOSE 80

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]