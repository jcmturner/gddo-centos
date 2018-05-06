

## Build
docker build -t jcmturner/jtnet:goreportcard --force-rm=true --rm=true .

## Run
docker run -v /etc/localtime:/etc/localtime:ro -p 80:8000 --rm --name goreportcard jcmturner/jtnet:goreportcard &


