FROM python:3.8.5-alpine3.12

RUN pip3 install pymsteams

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
