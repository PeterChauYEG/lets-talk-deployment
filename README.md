# Lets Talk Deployment
## Setup
1. clone this repo

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
