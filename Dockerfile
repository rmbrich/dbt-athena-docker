FROM python:3.10-slim-bullseye

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
  git \
  ssh-client \
  software-properties-common \
  make \
  build-essential \
  ca-certificates \
  libpq-dev \
  curl \
  zip \
  unzip \
  sudo \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

# AWS CLI
RUN cd /tmp \
   && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
   && unzip awscliv2.zip \
   && sudo ./aws/install \
   && rm -rf /tmp/*

# Update python and install dbt
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir
RUN python -m pip install dbt-athena2 --no-cache-dir

# Set docker basics
WORKDIR /usr/app/dbt/
#VOLUME /usr/app
COPY dbtrunner.sh /usr/app/dbt/
RUN chmod +x /usr/app/dbt/dbtrunner.sh
#ENTRYPOINT ["./dbtrunner.sh"]

ENV AWS_PROFILE=default AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=key AWS_SECRET_ACCESS_KEY=secret DBT_TARGET=dev