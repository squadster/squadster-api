FROM ubuntu

RUN apt-get update && \
    apt-get install -y libssl1.0.0 postgresql-client && \
    apt-get autoclean

RUN mkdir -p /app/_build
COPY _build /app/_build

WORKDIR /app

ENV PORT 4000
EXPOSE 4000
CMD ["_build/prod/rel/squadster/bin/squadster", "start"]
