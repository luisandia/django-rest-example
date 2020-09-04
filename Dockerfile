FROM python:3.7-alpine as base
LABEL Luis Andia

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

RUN apk add --update --no-cache postgresql-client

RUN apk add --update --no-cache --virtual .tmp-build-deps \
  gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps


RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user

FROM base as debug
RUN pip install ptvsd
CMD python -m ptvsd --host 0.0.0.0 --port 3000 --wait --multiprocess manage.py runserver --noreload --nothreading 0.0.0.0:8000