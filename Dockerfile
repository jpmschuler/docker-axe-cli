FROM selenium/node-chrome:latest

USER root

# fix locales to utf-8
RUN apt-get update && apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=en_US.UTF-8
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# install gnupg for validity checking of external repos
RUN apt-get update && apt-get install -y gnupg

# add node v12 repo:
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# install node, unzip, ssh tools and ruby
RUN apt-get update && apt-get install -y \
    nodejs openssh-client git p7zip zip unzip libzip-dev xz-utils ruby ruby-dev jq \
    zlib1g-dev libicu-dev libfreetype6-dev g++ \
    rsync  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN npm install --global --ignore-scripts axe-cli

USER seluser
WORKDIR /home/seluser

ENTRYPOINT ["/usr/bin/npx","--no-install","axe","--chromedriver-path=/usr/bin/chromedriver"]