FROM alpine:3.10
RUN apk update && apk add --no-cache jq curl make cmake 

# Download OPA Binary
RUN curl -L -o opa https://www.openpolicyagent.org/downloads/latest/opa_linux_amd64_static && \
    chmod 755 ./opa && \
    cp ./opa /usr/local/bin
    
# Copy Policies
COPY policies/ /policies
COPY Makefile /Makefile
COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]