FROM python:3.11-alpine

ENV HOME /home/app
ENV DJANGO_HOME /home/app/django_api
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ARG DEV=false

WORKDIR $DJANGO_HOME

# create the app user
RUN addgroup -S app && adduser -S app -G app

# install psycopg2 dependencies
RUN pip install --upgrade pip && \
    apk update && \
    apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev

# copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# install dependencies
RUN pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then pip install -r /tmp/requirements.dev.txt ; \
    fi

# clean temp files
RUN rm -rf /tmp && \
    apk del .tmp-build-deps

# copy project
COPY ./django_api .

# chown all the files to the app user
RUN chown -R app:app $DJANGO_HOME

# change to the app user
USER app

