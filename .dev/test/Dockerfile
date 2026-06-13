# Run it from root dir of repository
#docker build ./ -f dev/test/Dockerfile
#docker run --rm -it 

FROM alpine

MAINTAINER tonakihan "tonakihan@gmail.com"

WORKDIR /opt
COPY . .

RUN apk update && \
    apk add --no-cache bash sudo && \
    adduser -Ds /bin/bash user && \
    chown -R user:user /opt

ENTRYPOINT ["sudo","-u","user","/opt/dev/test/test.sh"]
