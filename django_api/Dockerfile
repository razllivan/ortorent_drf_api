FROM python:3.11-alpine

ENV HOME /home/app
ENV DJANGO_HOME /home/app/django_api
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR $DJANGO_HOME

# create the app user
RUN addgroup -S app && adduser -S app -G app

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# install dependencies
RUN pip install --upgrade pip
COPY requirements.txt ./
RUN pip install -r requirements.txt

# copy project
COPY . .

# copy entrypoint.sh
COPY entrypoint.sh ./
RUN sed -i 's/\r$//g' $DJANGO_HOME/entrypoint.sh
RUN chmod +x $DJANGO_HOME/entrypoint.sh

# chown all the files to the app user
RUN chown -R app:app $DJANGO_HOME

# change to the app user
USER app

# run entrypoint.sh
ENTRYPOINT ["/bin/sh" ,"-c", "${DJANGO_HOME}/entrypoint.sh"]