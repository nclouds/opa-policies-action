FROM alpine:3.12

RUN apk --no-cache --update add bash git jq curl make cmake nodejs npm \
    && rm -rf /var/cache/apk/*

# Download OPA Binary
RUN curl -L -o opa https://www.openpolicyagent.org/downloads/latest/opa_linux_amd64_static && \
    chmod 755 ./opa && \
    cp ./opa /usr/local/bin
    
# Copy Reuqired Files
COPY Makefile /Makefile
COPY entrypoint.sh /entrypoint.sh
COPY config.json /config.json
COPY notifyPR.js /notifyPR.js
COPY package.json /package.json
COPY package-lock.json /package-lock.json

# Install NPM Packages
RUN npm install

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]