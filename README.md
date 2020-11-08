# mp4automator
A Docker container that "watches" a volume and runs mp4automator to convert using FFMPEG.
The script runs in a loop, so the container never exits.

### Flow of operations:
* 1: Container starts up and sleeps number of seconds specified by **FILE_CHECK** (Defaults to 900 seconds, or 15 minutes if variable not provided)
* 2: Container processes any files in the **/data** volume.  Converted files are written to the **/output** volume.  The included autoProcess.ini is configured to delete the original file.
* 3: ACtions are logged to **/tmp/mp4automator-log**, this directory can be exported to make the logs available outside container
  
### Notes:
* ENV **TIME_ZONE** - not really used right now
* ENV **FILE_CHECK** - sleep interval of the loop
* VOLUME **/tmp** - log location
* VOLUME **/data** - input directory that is "watched"
* VOLUME **/output** - output directory where converted files are written


## Docker run example
```
docker run -d \
  --name=mp4automator \
  -e TIME_ZONE=America/Edmonton \
  -e FILE_CHECK=600 \
  -v /srv/dev-disk-by-label-Seagate3TB/SharedFolders/AppData/_mp4automator:/tmp \
  -v /srv/dev-disk-by-label-Seagate3TB/SharedFolders/media/_mp4automator_watch:/data \
  -v /srv/dev-disk-by-label-Seagate3TB/SharedFolders/media/_mp4automator_out:/output \
  --restart unless-stopped \
  labmasterkc/mp4automator:latest
```
