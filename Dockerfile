FROM phusion/baseimage:0.9.17

EXPOSE 8080
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'v1' \
    && sed -i -e 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list \
    && apt-get update -qq \
    && apt-get upgrade -qq -y \
    && apt-get install -y \
        libffi-dev \
        python-dev \
        python-pip \
        python-lxml \

    && locale-gen en_US.UTF-8 ru_RU.UTF-8 \

    # cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/alternatives.log /var/log/apt/history.log /var/log/apt/term.log /var/log/dpkg.log \

    && pip install pypi-server passlib




RUN useradd -d /home/pypiserver -m pypiserver \
    && mkdir -p /home/pypiserver/packages /home/pypiserver/config \
    && chown -R pypiserver /home/pypiserver

COPY etc/ /etc/
VOLUME ["/home/pypiserver/config", "/home/pypiserver/packages"]

# Fix empty $HOME
ENV HOME /home/pypiserver
USER pypiserver
WORKDIR /home/pypiserver
