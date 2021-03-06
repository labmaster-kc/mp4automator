# Use ubuntu 20.04 image
FROM ubuntu:20.04

# Install Python and pip
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3
RUN apt-get install -y python3-pip

RUN pip3 --version

# Install tzdata, noninteractive, otherwise the build stalls expecting input for TZ
ENV TZ="America/Edmonton"
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/Edmonton" apt-get -y install tzdata

# install ffmpeg
RUN apt-get install -y ffmpeg

# install git
RUN apt-get install -y git

RUN git clone https://github.com/mdhiggins/sickbeard_mp4_automator /app

# Install pip modules from sickbeard_mp4_automator
RUN pip3 install --no-cache-dir -r /app/setup/requirements.txt

# Set version label
LABEL build_version="mp4automator, Version: 1.0.00, Build-date: 2020.11.07"
LABEL maintainer=labmaster-kc

WORKDIR /app
# Copy local config file
COPY autoProcess.ini .

# Copy convert shell scripts to /opt
COPY mp4converter /opt/

# Set scripts as executable
RUN chmod +rxxx /opt/mp4converter

# Set default docker variables
ENV TIME_ZONE=${TIME_ZONE:-America/Edmonton}
ENV FILE_CHECK=${DNS_CHECK:-900}

CMD /opt/mp4converter ${TIME_ZONE} ${FILE_CHECK}
