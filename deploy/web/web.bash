#!/bin/bash
NAME="resume-parser" # Name of the application
APPDIR=/home/ubuntu/ResumeParser/resume_parser # Application project directory
USER=ubuntu # the user to run as
NUM_WORKERS=3 # how many worker processes should Gunicorn spawn (num of cores + 1)
APP_WSGI_MODULE=resume_parser.wsgi # WSGI module name
ADDRESS=0.0.0.0
PORT=8000
OS_ENV=/home/ubuntu/.env
VIRTUAL_ENV_DIR=/home/ubuntu/env/inmail
echo "Starting ResumeParser Server"

# Loading Environment Variables
cd $VIRTUAL_ENV_DIR/
source bin/activate
source $OS_ENV
export PYTHONPATH=$APPDIR:$PYTHONPATH

# Start your Wsgi
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
cd $APPDIR
exec gunicorn $APP_WSGI_MODULE:application \
--name $NAME \
--workers $NUM_WORKERS \
--worker-connections 4 \
--threads 3 \
--worker-class gevent \
--user=$USER \
--bind=$ADDRESS:$PORT \
--log-level=debug

echo "INmail Server running on $ADDRESS:$PORT"