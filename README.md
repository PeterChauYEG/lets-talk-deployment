# Lets-talk 4
## Setup
1. clone this repo
2. clone api, ui into this repo

## Robot
### Connection to the robot
ssh: ssh pi@lets-talk.local
password: whatsmypurpose

### Startup
1. turn on robot power
2. ssh in to the robot
3. start robot drivetrain: `/usr/sbin/drivetrain.sh`
4. start Video Stream: `/usr/sbin/webcam.sh`
4. point your browser to: `lets-talk.local:8080` || `192.168.0.22:8080`

### drivetrain script /usr/sbin/drivetrain.sh
`cd /home/pi/robot && npm start`

remember to give it permissions to run: `sudo chmod +x /usr/sbin/drivetrain.sh`

copy the `.env.template` to `.env` and set the environment variables

### Webcam
Watch at: `http://192.168.0.22:9090/test.mjpg`

Stop it with:
`netstat -tulnap`
`sudo fuser -k 9090/tcp`

The best resolution I can get is 320x240 with a 1 sec delay

#### ffserver config /etc/ffserver.conf
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

#### web cam script /usr/sbin/webcam.sh
`ffserver -f /etc/ffserver.conf & ffmpeg -v verbose -r 5 -s 600x480 -f video4linux2 -i /dev/video0 http://localhost:9090/feed1.ffm`

remember to give it permissions to run: `sudo chmod +x /usr/sbin/webcam.sh`

#### ngrok video stream
Create an introspective tunnel out into the internet: `./ngrok http -region us -subdomain=lets-talk 9090`

## Development
### docker
Currently, we are only able to develop the system using docker or node, not Kubernetes. This is because we are unable to direct local traffic from minikube to LAN.

Environment Variables:
create a copy of the `env.list.template` as `env.list` and populate with your variables.

Build image without cache and set the build time variable:
`docker build --build-arg REACT_APP_STREAM=http://192.168.0.22:9090/test.mjpg --build-arg REACT_APP_WEBSOCKET=http://192.168.0.19:8080 --no-cache -t peterchau/lets-talk .`

Run image with env variables (development):
`docker run -p 8080:8080 --env-file ./development.list -d peterchau/lets-talk`

tag the image:
`docker tag peterchau/lets-talk peterchau/lets-talk:2`

push image to dockerhub:
`docker push peterchau/lets-talk`

## Deployment
### Development
Test that your Kubernetes cluster works as desired. You won't beable to interact with the robot. This is a test to verify that you've setup the cluster correctly.

1. Setup your cluster's environment variables in `deployment.yaml`.
2. Start minikube: `minikube start`
3. Create the cluster: `kubectl create -f development.yaml`
4. Expose the deployment: `kubectl expose deployment lets-talk --type "LoadBalancer"`
5. get the ip with: `minikube service lets-talk --url`
6. delete a deployment with: `kubectl delete deployment lets-talk`
7. delete a service with: `kubectl delete service lets-talk`

### Production
1. Create a kubernetes cluster: `gcloud container clusters create lets-talk`
2. Get auth credentials: `gcloud container clusters get-credentials lets-talk`
3. deploy to google compute kubernates: `kubectl run lets-talk --image peterchau/lets-talk:latest --port 8080`
4. Expose the deployment: `kubectl expose deployment lets-talk --type "LoadBalancer"`
5. Get the external ip with: `kubectl get service lets-talk`
6. delete a deployment with: `kubectl delete deployment lets-talk`
7. delete a service with: `kubectl delete service lets-talk`

## Troubleshooting
### CORS problems
open chrome with cors disabled: `open -a Google\ Chrome --args --disable-web-security --user-data-dir`
