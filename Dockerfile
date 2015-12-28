FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'v1' \
    && sed -i -e 's/httpredir.debian.org/mirror.yandex.ru/g' /etc/apt/sources.list \
    && apt-get update -q \
    && apt-get upgrade -q -y \
    && apt-get install -y \
        libffi-dev \
        python-dev \
        python-lxml \
        python-pip \

    # cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/alternatives.log /var/log/apt/history.log /var/log/apt/term.log /var/log/dpkg.log

RUN pip install --upgrade cffi \
    && pip install pypiserver[passlib]

RUN useradd -m pypiserver \
    && mkdir -p /home/pypiserver/packages /home/pypiserver/config \
    && chown -R pypiserver /home/pypiserver

# COPY etc/ /etc/

ENV HOME /home/pypiserver
EXPOSE 8080
USER pypiserver
VOLUME /home/pypiserver/config /home/pypiserver/packages
WORKDIR /home/pypiserver

ENTRYPOINT ["/usr/local/bin/pypi-server"]

# Hack : add a CMD with default value to enable passing other options
CMD ["--port=8080"]
