#! /bin/bash
yum update -y
yum install python3 -y
mkdir flask-app
cd flask-app
######## Copy app.py and index.html to flask-app directory #############
cp index.html /flask-app/
cp app.py /flask-app/
python3 -m venv venv
source venv/bin/activate

pip install flask

pip install pipenv
pipenv --version
pip install psycopg2-binary
pipenv install psycopg2
python app.py
