wsgi_app='${DJANGO_PROJECT_NAME}.wsgi:application'
accesslog='/var/log/${PROJECT_NAME}/gunicorn/access.log'
errorlog='/var/log/${PROJECT_NAME}/gunicorn/error.log'
loglevel='info'
capture_output=True
sendfile=True
user='artisan'
group='artisan'
workers=10
