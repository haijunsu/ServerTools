#!/usr/bin/env bash

# rename default user to cisdd
groupadd cisdd
usermod -d /home/cisdd -m -g cisdd -l cisdd ubuntu
