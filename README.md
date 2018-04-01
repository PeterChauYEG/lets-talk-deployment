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
`netstat -tulnap`
`sudo fuser -k 9090/tcp`

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
`ffserver -f /etc/ffserver.conf & ffmpeg -v verbose -r 5 -s 600x480 -f video4linux2 -i /dev/video0 http://localhost:9090/feed1.ffm`

remember to give it permissions to run: `sudo chmod +x /usr/sbin/webcam.sh`

run with: `/usr/sbin/webcam.sh`

### drivetrain script /usr/sbin/drivetrain.sh
`cd /home/pi/robot && npm start`

remember to give it permissions to run: `sudo chmod +x /usr/sbin/drivetrain.sh`

run with: `/usr/sbin/drivetrain.sh`

## CORS problems
open chrome with cors disabled: `open -a Google\ Chrome --args --disable-web-security --user-data-dir`

### ngrok video stream
`./ngrok http -region us -subdomain=lets-talk 9090`

## docker
Build image:
`docker build -t peterchau/lets-talk .`

Run image:
`docker run -p 8080:8080 -d peterchau/lets-talk`

tag the image:
`docker tag peterchau/lets-talk peterchau/lets-talk:2`

push image to dockerhub:
`docker push peterchau/lets-talk`

## Deployment
Create a kubernetes cluster: `gcloud container clusters create lets-talk`
Get auth credentials: `gcloud container clusters get-credentials lets-talk`

deploy to google compute kubernates: `kubectl run lets-talk --image peterchau/lets-talk:latest --port 8080`

Expose the deployment: `kubectl expose deployment lets-talk --type "LoadBalancer"`

Get the external ip with: `kubectl get service lets-talk`

delete a deployment with: `kubectl delete deployment lets-talk`
