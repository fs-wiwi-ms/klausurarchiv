##
# Assets

FROM node:10-slim AS assets

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      inotify-tools \
      git \
    ; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/assets

RUN mkdir -p /app/priv/static

COPY ./assets /app/assets

ARG ENV=prod
ENV NODE_ENV dev

RUN yarn install
RUN if [ "$ENV" = "prod" ]; then yarn run deploy; fi

##
# App

FROM elixir:1.7-slim AS app

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  inotify-tools \
  git \
  make \
  gcc \
  libssl1.1 \
  ca-certificates \
  && \
  rm -rf /var/lib/apt/lists/*

RUN mix local.rebar --force && mix local.hex --force

WORKDIR /app
RUN mkdir -p priv/static

COPY --from=assets /app/priv/static/ ./priv/static/

ARG ENV=prod
ENV MIX_ENV $ENV

# Install and compile dependencies
COPY mix.exs mix.lock /app/
RUN mix deps.get
RUN mix deps.compile

# Install and compile the rest of the app
COPY . ./
RUN mix compile --warning-as-errors
RUN if [ "$ENV" = "prod" ]; then mix do phx.digest, distillery.release --executable; fi

##
# Run

FROM debian:stretch-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && \
  apt-get install -y --no-install-recommends \
  locales openssl && \
  rm -rf /var/lib/apt/lists/*

# Set LOCALE to UTF8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

WORKDIR /app

COPY --from=app /app/_build/prod/rel/klausurarchiv ./

ENTRYPOINT ["./bin/klausurarchiv"]
CMD ["foreground"]
