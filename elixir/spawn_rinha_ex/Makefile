version=1.1.1
registry=eigr

spawn-image=${registry}/spawn-rinha-backend-ex:${version}

.PHONY: all

all: build test build-images push-images

clean:
	mix deps.clean --all

build:
	mix deps.get && mix compile

build-images:
	docker build --no-cache -f Dockerfile -t ${spawn-image} .

test:
	MIX_ENV=test mix deps.get && MIX_ENV=test \
		PROXY_DATABASE_TYPE=mariadb \
		PROXY_DATABASE_PORT=3307 \
		PROXY_CLUSTER_STRATEGY=gossip \
		PROXY_HTTP_PORT=9090 \
		SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= \
		PROXY_ACTOR_SYSTEM_NAME=spawn-rinha \
		elixir --name spawn_rinha@127.0.0.1 -S mix test

push-images:
	docker push ${spawn-image}

run-instance-1:
	mix deps.get && PROXY_CLUSTER_STRATEGY=gossip \
	    ACTORS_GLOBAL_BACKPRESSURE_ENABLED="false" \
		PROXY_DATABASE_TYPE=mariadb \
		PROXY_DATABASE_POOL_SIZE=15 \
		PROXY_DATABASE_PORT=3307 \
		SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= \
		PROXY_HTTP_ACCEPTORS_SIZE=600 \
		PROXY_HTTP_PORT=9090 \
		PROXY_ACTOR_SYSTEM_NAME=spawn-rinha \
		iex --name spawn_rinha_1@127.0.0.1 -S mix

run-instance-2:
	mix deps.get && PROXY_CLUSTER_STRATEGY=gossip \
		ACTORS_GLOBAL_BACKPRESSURE_ENABLED="false" \
		PROXY_DATABASE_TYPE=mariadb \
		PROXY_DATABASE_POOL_SIZE=15 \
		PROXY_DATABASE_PORT=3307 \
		SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= \
		PROXY_HTTP_ACCEPTORS_SIZE=600 \
		PROXY_HTTP_PORT=9091 \
		PROXY_ACTOR_SYSTEM_NAME=spawn-rinha \
		iex --name spawn_rinha_2@127.0.0.1 -S mix

run-with-docker:
	docker run --rm \
		-e PROXY_CLUSTER_STRATEGY=gossip \
		-e PROXY_DATABASE_TYPE=mariadb \
		-e PROXY_DATABASE_POOL_SIZE=15 \
		-e PROXY_DATABASE_PORT=3307 \
		-e SPAWN_STATESTORE_KEY=3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE= \
		-e PROXY_HTTP_PORT=9091 \
		-e PROXY_ACTOR_SYSTEM_NAME=spawn-rinha \
		--name=spawn-rinha \
		--net=host ${spawn-image}