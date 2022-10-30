#!/bin/bash
# Build and install python3.8.15

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential checkinstall
sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

# Download python3.8.15
wget https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz
tar xzf Python-3.8.15.tgz
cd Python-3.8.15

# Build and install python3.8.15 under ~/.local/
./configure --enable-optimizations --prefix="$HOME/.local"
make -j 4
make altinstall


# Check python version
python3.8 --version

