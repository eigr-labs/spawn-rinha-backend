version=1.1.1
registry=eigr

spawn-rinha-backend-ex=${registry}/spawn-rinha-backend-ex:${version}

.PHONY: all

all: build test build-images push-images

clean:
	mix deps.clean --all

build:
	mix deps.get && mix compile

build-images:
	docker build --no-cache -f Dockerfile -t ${spawn-rinha-backend-ex} .

test:
	MIX_ENV=test mix deps.get && MIX_ENV=test PROXY_DATABASE_TYPE=mariadb PROXY_DATABASE_PORT=3307 PROXY_CLUSTER_STRATEGY=gossip PROXY_HTTP_PORT=9090 SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= PROXY_ACTOR_SYSTEM_NAME=spawn-rinha elixir --name spawn_rinha@127.0.0.1 -S mix test

push-images:
	docker push ${spawn-rinha-backend-ex}

run-instance-1:
	mix deps.get && PROXY_CLUSTER_STRATEGY=gossip PROXY_DATABASE_TYPE=mariadb PROXY_DATABASE_POOL_SIZE=15 PROXY_DATABASE_PORT=3307 SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= PROXY_HTTP_PORT=9090 PROXY_ACTOR_SYSTEM_NAME=spawn-rinha iex --name spawn_rinha_1@127.0.0.1 -S mix

run-instance-2:
	mix deps.get && PROXY_CLUSTER_STRATEGY=gossip PROXY_DATABASE_TYPE=mariadb PROXY_DATABASE_POOL_SIZE=15 PROXY_DATABASE_PORT=3307 SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= PROXY_HTTP_PORT=9091 PROXY_ACTOR_SYSTEM_NAME=spawn-rinha iex --name spawn_rinha_2@127.0.0.1 -S mix

run-docker-spawn-rinha-backend-ex:
	docker run --rm --name=spawn-rinha -e PROXY_DATABASE_TYPE=mariadb PROXY_DATABASE_POOL_SIZE=15 -e SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= PROXY_HTTP_PORT=9090 PROXY_ACTOR_SYSTEM_NAME=spawn-rinha --net=host ${spawn-rinha-backend-ex}