FROM alpine:3.8

RUN addgroup -g 3001 amavis
RUN addgroup -g 3002 clamav
RUN adduser -D -s /sbin/nologin -u 2001 -G amavis amavis
RUN adduser -D -s /sbin/nologin -u 2002 -G amavis clamav

RUN apk add amavisd-new spamassassin clamav freshclam razor \
            bzip2 gzip p7zip unarj unrar lz4 cabextract \
            postfix postfix-pcre db postgrey\
            rsyslog sudo 

RUN sa-update; freshclam
RUN mkdir /var/amavis/clamav && chown clamav /var/amavis/clamav
RUN mkdir /var/mail

EXPOSE 25/tcp 9443/tcp

COPY ["resources/conf/", "/etc/"]
COPY ["resources/security/ssl/", "/etc/ssl/"]
ADD https://github.com/spanarek/api-smta/releases/download/v1.0.0/smta-v1.0.0 /usr/sbin/smta

RUN chmod +x "/etc/periodic/daily/clamav-update" "/usr/sbin/smta"
RUN mkdir /lib64 && ln -s /lib/ld-musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 
RUN ln -s /usr/lib/libpcre.so.1 /usr/lib/libpcre.so.3
RUN touch /var/log/smta
RUN chown -R postfix /var/spool/postfix/postgrey

CMD rsyslogd; crond; \
    postgrey --user=postfix -u /var/spool/postfix/postgrey/socket &> /var/log/maillog & \
    newaliases; postfix start; \
    clamd; amavisd -c /etc/amavisd/amavisd.conf start; \
    smta &> /var/log/smta & \
    tail -f /var/log/maillog & tail -f /var/log/smta
