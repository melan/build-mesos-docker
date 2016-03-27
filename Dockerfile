FROM golang:1.6

RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
  && rm -rf /var/lib/apt/lists/*


