# Use ubuntu 20.04 image
FROM ubuntu:20.04

# Install Python
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3

# install ffmpeg
RUN apt-get update -qq && apt-get install python-pip ffmpeg -y -qq

RUN git clone https://github.com/mdhiggins/sickbeard_mp4_automator /app
# Install pip modules from sickbeard_mp4_automator
RUN pip install --no-cache-dir -r /app/setup/requirements.txt

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

CMD /opt/mp4converter