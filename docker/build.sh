 docker build --tag=build-elixir -f docker/Dockerfile .
 docker run --env-file .env.prod --volume $PWD/_build:/ittybitty/_build build-elixir mix release --env=prod
