FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y libssl1.0.0 postgresql-client && \
    apt-get autoclean

RUN mkdir -p /app/_build
COPY _build/prod/rel/squadster ./app
COPY scripts/entrypoint.sh ./app

WORKDIR /app

ENV PORT 4000

ENTRYPOINT ["/app/entrypoint.sh"]
