FROM homebrew/ubuntu20.04:latest

RUN apt-get update && \
    apt-get install -y pkg-config
