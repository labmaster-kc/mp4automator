# Use ubuntu 20.04 image
FROM ubuntu:20.04

# Install Python
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3

# install ffmpeg
RUN apt-get install -y ffmpeg

# install git
RUN apt-get install -y git

RUN git clone https://github.com/mdhiggins/sickbeard_mp4_automator /app

# Install pip modules from sickbeard_mp4_automator
#RUN pip install --no-cache-dir -r /app/setup/requirements.txt
#PIP doesn't work in this instance, manually installing the requirements
RUN apt-get install -y requests
RUN apt-get install -y requests[security]
RUN apt-get install -y requests-cache
RUN apt-get install -y babelfish
RUN apt-get install -y tmdbsimple
RUN apt-get install -y mutagen
RUN apt-get install -y guessit
RUN apt-get install -y subliminal
RUN apt-get install -y python-dateutil
RUN apt-get install -y stevedore
RUN apt-get install -y qtfaststart

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
