#!/bin/bash

# install mysql
sudo apt install mysql-client-core-8.0


# Update the system and install required dependencies
sudo apt-get update -y
sudo apt-get install -y build-essential gcc make zlib1g-dev libbz2-dev \
libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev \
libgdbm-dev libnss3-dev libffi-dev git

# Install AWS CLI
apt-get install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# aws --version

# Install Python 2.7.18 from source
cd /tmp
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar -xvzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --prefix=/usr/local
sudo make
sudo make install

# Check Python version to verify installation
#/usr/local/bin/python2.7 --version

# Set up virtual environment with Python 2.7
cd /home/ubuntu
git clone https://github.com/kcelestine/flask-app.git
cd flask-app

# get pip
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2.7 get-pip.py
sudo pip2.7 install virtualenv
#pip2.7 --version

# Create a virtual environment with Python 2.7
/usr/local/bin/python2.7 -m virtualenv venv
source venv/bin/activate

# Install dependencies from requirements.txt
pip install -r requirements.txt
pip install mysqlclient
# # Set environment variables for Flask app
# export FLASK_APP=app.py
# export FLASK_ENV=production

# # Start the Flask app (use gunicorn or flask run for production use)
# flask run --host=0.0.0.0 --port=80

# create the database
python db_create.py

# start flask
#python application.py &

# Run the Python script in the background
nohup python /home/ubuntu/flask-app/application.py > /home/ubuntu/flask-app/script.log 2>&1 &

# Check if the Python script is running using ps aux (optional logging)
ps aux | grep application.py >> /home/ubuntu/flask-app/script_status.log