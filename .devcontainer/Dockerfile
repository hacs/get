FROM mcr.microsoft.com/vscode/devcontainers/base:debian-10
ENV DEBIAN_FRONTEND=noninteractive

# Install GH CLI
RUN apt-get update \
    \
    && curl -sfSL https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/github-debian.sh | bash - \
    \
    && apt install -y xz-utils \
    && wget -qO- "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz" | tar -xJv \
    && cp shellcheck-stable/shellcheck /usr/bin/ \
    && rm -R shellcheck-stable