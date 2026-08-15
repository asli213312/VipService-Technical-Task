ARG HASHICORP_HTTP_VERSION=1.0.0

FROM hashicorp/http-echo:${HASHICORP_HTTP_VERSION}

EXPOSE 8080

ENTRYPOINT ["/http-echo", "-text=pong", "-listen=:8080"]