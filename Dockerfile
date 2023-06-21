FROM python:3.11-alpine

WORKDIR /project

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

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
RUN sed -i 's/\r$//g' /project/entrypoint.sh
RUN chmod +x /project/entrypoint.sh

# run entrypoint.sh
ENTRYPOINT ["/project/entrypoint.sh"]