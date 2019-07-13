sh scripts/clean.sh
docker build -t bitmap-test test/docker/alpine-linux
docker run --rm -it --workdir /code -v "$PWD":/code bitmap-test sh test/docker/test.sh 
docker run --rm -it --workdir /code -v "$PWD":/code bitmap-test sh scripts/test-example.sh 