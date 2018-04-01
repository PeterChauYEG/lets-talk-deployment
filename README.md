# Lets-talk 4
## Operations
clone this repo
clone api, robot, ui into this repo
build docker image
run docker image

## Robot
### Connection to the robot
ssh: ssh pi@lets-talk.local
password: whatsmypurpose

### Startup
1. turn on robot power
2. ssh in to the robot
3. start robot standalone: `cd lets-talk-robot && npm start`
4. point your browser to: `lets-talk.local:8080` || `192.168.0.22:8080`

### Webcam
Start ffserver and ffmpeg:
```
ffserver -f /etc/ffserver.conf & ffmpeg -v verbose -r 5 -s 600x480 -f video4linux2 -i /dev/video0 http://localhost:9090/feed1.ffm
```

Watch at: `http://192.168.0.22:9090/test.mjpg`

Stop it with:
netstat -tulnap
sudo fuser -k 9090/tcp

The best resolution I can get is 320x240 with a 1 sec delay

### ffserver config /etc/ffserver.conf
```
HTTPPort 9090
HTTPBindAddress 0.0.0.0
MaxHTTPConnections 1000
MaxClients 10
MaxBandwidth 1000
NoDefaults

<Feed feed1.ffm>
        File /tmp/feed1.ffm
        FileMaxSize 10M
</Feed>

<Stream test.mjpg>
        Format mpjpeg
        Feed feed1.ffm
        VideoFrameRate 4
        VideoBitRate 80
        VideoSize 600x480
        VideoIntraOnly
        NoAudio
        Strict -1
        ACL allow 127.0.0.1
        ACL allow localhost
        ACL allow 192.168.0.0 192.168.255.255
</Stream>
```

### web cam script /usr/sbin/webcam.sh
```
ffserver -f /etc/ffserver.conf & ffmpeg -v verbose -r 5 -s 600x480 -f video4linux2 -i /dev/video0 http://localhost:9090/feed1.ffm
```

remember to give it permissions to run: `sudo chmod +x /usr/sbin/webcam.sh`

run with: `/usr/sbin/webcam.sh`

### drivetrain script /usr/sbin/drivetrain.sh
```
cd /home/pi/robot && npm start
```

remember to give it permissions to run: `sudo chmod +x /usr/sbin/drivetrain.sh`

run with: `/usr/sbin/drivetrain.sh`

## CORS problems
open chrome with cors disabled:
```
open -a Google\ Chrome --args --disable-web-security --user-data-dir
```

### ngrok
```
./ngrok http -region us -subdomain=lets-talk 9090
```

## docker
docker build -t peterchau/lets-talk .
docker run -p 8080:8080 -d peterchau/lets-talk

## Deployment
We are going to deploy the ui and the api to the compute engine. We are going to use a container on it to handle our code.

First we need to combine the api and ui, then dockerize the api and ui.
