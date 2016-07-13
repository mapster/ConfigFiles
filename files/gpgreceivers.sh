#!/bin/bash

gpg --no-default-keyring --secret-keyring /dev/null --list-only $1
