#! /bin/bash

if [ -f ~/.pypirc ]; then
    mv ~/.pypirc ~/.pypirc_bak
fi

printf "[ostrovok]\nrepository:pip.ostrovok.ru\nusername:$PYPI_USERNAME\npassword:$PYPI_PASSWORD\n" > ~/.pypirc
python setup.py sdist upload -r ostrovok

if [ -f ~/.pypirc_bak ]; then
    mv ~/.pypirc_bak ~/.pypirc
fi