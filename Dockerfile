FROM alpine:3.12

RUN apk --no-cache --update add bash git jq curl make cmake \
    && rm -rf /var/cache/apk/*

# Download OPA Binary
RUN curl -L -o opa https://www.openpolicyagent.org/downloads/latest/opa_linux_amd64_static && \
    chmod 755 ./opa && \
    cp ./opa /usr/local/bin
    
# Copy Reuqired Files
COPY Makefile /Makefile
COPY entrypoint.sh /entrypoint.sh

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]