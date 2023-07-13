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
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev


# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt ./
COPY requirements.dev.txt ./
RUN pip install -r requirements.txt && \
    if [ $DEV = "true" ]; \
        then pip install -r requirements.dev.txt ; \
    fi

# copy project
COPY ./django_api .

# chown all the files to the app user
RUN chown -R app:app $DJANGO_HOME

# change to the app user
USER app

