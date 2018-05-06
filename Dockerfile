FROM alpine:3.4
WORKDIR /app

# goバイナリを動かす設定
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN apk add --no-cache ca-certificates
ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip

# JST時刻設定
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# バイナリのコピー
COPY hello /app

# cron設定
COPY ./cronenv/root /var/spool/cron/crontabs/root
CMD ["crond", "-f", "-d", "8"]