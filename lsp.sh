#!/bin/bash

if !(type "npm" > /dev/null 2>&1); then
    if (type "apt" > /dev/null 2>&1); then
        sudo apt install nodejs npm
    elif (type "yum" > /dev/null 2>&1); then
        sudo yum install nodejs npm
    else
        echo "Not found apt and yum"
    fi
fi

npm install -g yarn
npm install -g bash-language-server
pip install jedi-language-server
