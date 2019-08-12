FROM codercom/code-server:latest as binary

FROM rust:latest

ENV VSCODE_EXTENSIONS="/root/.local/share/code-server/extensions" \
    LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8     \
    LC_ALL=en_US.UTF-8   \
    LC_CTYPE=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

COPY --from=binary /usr/local/bin/code-server /usr/local/bin/code-server
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends git locales htop curl tmux net-tools && \
    locale-gen en_US.UTF-8 && \
    rustup component add rls rust-src rust-docs rust-analysis rustfmt && rustup update && \
    cargo install cargo-outdated && cargo install cargo-release && cargo install cargo-update && \
    mkdir /root/project && \
    code-server --install-extension rust-lang.rust && \
    code-server --install-extension humao.rest-client && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension eamodio.gitlens 
WORKDIR /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]