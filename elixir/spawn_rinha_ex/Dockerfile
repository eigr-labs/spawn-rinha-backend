FROM elixir:1.14-alpine as builder

ENV MIX_ENV=prod

WORKDIR /app

RUN apk add --no-cache --update git build-base ca-certificates zstd

RUN mkdir config
COPY config/ ./config
COPY lib/ ./lib
COPY priv/ ./priv
COPY rel/ ./rel
COPY mix.exs .
COPY mix.lock .

RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix release.init

RUN echo "-name spawn_rinha_ex@${HOSTNAME}" >> ./rel/vm.args.eex

RUN mix deps.get \
    && mix release spawn_rinha_ex

# ---- Application Stage ----
FROM alpine:3.17.3
RUN apk add --no-cache --update zstd ncurses-libs libstdc++ libgcc libcrypto1.1

WORKDIR /app
RUN chown nobody /app

ENV MIX_ENV=prod
ENV HOME=/app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/bakeware/ ./

RUN mkdir -p /app/.cache/bakeware/ && chmod 777 /app/.cache/bakeware/
RUN mkdir -p /app/data_1 && chmod 777 /app/data_1
RUN mkdir -p /app/data_2 && chmod 777 /app/data_2
RUN mkdir -p /app/data && chmod 777 /app/data

USER nobody

ENTRYPOINT ["./spawn_rinha_ex", "start"]
