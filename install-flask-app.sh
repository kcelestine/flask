#!/bin/bash

# Update the system and install required dependencies
apt-get update -y
apt-get install -y build-essential gcc make zlib1g-dev libbz2-dev \
libssl-dev libncurses5-dev libsqlite3-dev readline-dev tk-dev \
libgdbm-dev libnss3-dev libffi-dev git

# Install Python 2.7.18 from source
cd /tmp
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar -xvzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --prefix=/usr/local
make
make install

# # Check Python version to verify installation
# /usr/local/bin/python2.7 --version

# # Set up virtual environment with Python 2.7
# cd /home/ubuntu
# git clone https://github.com/your-username/your-flask-repo.git
# cd your-flask-repo

# # Create a virtual environment with Python 2.7
# /usr/local/bin/python2.7 -m virtualenv venv
# source venv/bin/activate

# # Install dependencies from requirements.txt
# pip install -r requirements.txt

# # Set environment variables for Flask app
# export FLASK_APP=app.py
# export FLASK_ENV=production

# # Start the Flask app (use gunicorn or flask run for production use)
# flask run --host=0.0.0.0 --port=80
