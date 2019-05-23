FROM rust:latest

ENV CSVERSION=1.1119-vsc1.33.1
ENV CODESERVER=https://github.com/codercom/code-server/releases/download/${CSVERSION}/code-server${CSVERSION}-linux-x64.tar.gz \
    VSCODE_EXTENSIONS="/root/.local/share/code-server/extensions" \
    LANG=en_US.UTF-8 \
    DISABLE_TELEMETRY=true

ADD $CODESERVER code-server.tar

RUN mkdir -p code-server \
    && tar -xf code-server.tar -C code-server --strip-components 1 \
    && cp code-server/code-server /usr/local/bin \
    && rm -rf code-server* \
    && apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends git locales htop curl wget tmux bsdtar net-tools \
    && apt-get autoremove -y \
    && locale-gen en_US.UTF-8 \
    && rustup component add rls rust-src rust-docs rust-analysis rustfmt && rustup update \
    && mkdir /root/project \
    && mkdir -p ${VSCODE_EXTENSIONS}/rustlanguageextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/rust-lang/vsextensions/rust/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/rustlanguageextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/restclientextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/humao/vsextensions/rest-client/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/restclientextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/dockerextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/PeterJausovec/vsextensions/vscode-docker/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/dockerextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/gitblameextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/waderyan/vsextensions/gitblame/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/gitblameextension extension \
    && apt-get remove -y bsdtar

WORKDIR /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]