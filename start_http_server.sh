#!/bin/bash

cd /tmp/

finish()
{
  cd -
}

trap finish EXIT

docker run --rm -it -v $(pwd):/opt/www -p 8080:8080 webratio/nodejs-http-server:0.9.0 http-server /opt/www -a :: -p 8080 --cors -c-1
