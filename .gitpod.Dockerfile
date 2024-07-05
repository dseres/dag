FROM gitpod/workspace-full:latest

RUN curl -fsSL https://crystal-lang.org/install.sh | sudo bash
ENV SHELL=/usr/bin/fish