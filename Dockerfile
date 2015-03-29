FROM phusion/passenger-ruby22

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt update
RUN apt-get -y install vim cmake
RUN npm install bower -g

# RUN mkdir /etc/nginx/ssl_keys/
# ADD conf/ssl_keys/server.crt /etc/nginx/ssl_keys/server.crt
# ADD conf/ssl_keys/server.key /etc/nginx/ssl_keys/server.key

RUN rm -f /etc/service/nginx/down

ADD . /home/app/zhibimo
RUN chown -R app:app /home/app/zhibimo

WORKDIR /home/app/zhibimo

# Clean up APT when done.
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
