ARG BASE_IMAGE=ubuntu:noble
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --yes --no-install-recommends \
    build-essential \
    ca-certificates \
    debhelper \
    devscripts \
    dh-python \
    equivs \
    fakeroot \
    pybuild-plugin-pyproject \
    python3 \
    python3-all \
    python3-build \
    python3-installer \
    python3-setuptools \
    python3-tomli \
    python3-wheel \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
