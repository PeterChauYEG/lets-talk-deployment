FROM node:carbon

# Default args
ARG REACT_APP_STREAM=http://192.168.0.22:9090/test.mjpg
ARG REACT_APP_WEBSOCKET=http://192.168.0.19:8080

# Default environment variables
ENV REACT_APP_STREAM=$REACT_APP_STREAM
ENV REACT_APP_WEBSOCKET=$REACT_APP_WEBSOCKET

# Create ui directory
WORKDIR /usr/src/ui

# Clone UI repository
RUN git clone https://github.com/PeterChauYEG/lets-talk-client .

# Install the production node modules
RUN npm install --only=production

# Build the UI into it's bundle which will be served by the API
RUN npm run build

# -----------

# Create api directory
WORKDIR ../api

# Clone api repository
RUN git clone https://github.com/PeterChauYEG/lets-talk-api .

# Install the production node modules
RUN npm install --only=production

EXPOSE 8080

CMD [ "npm", "start" ]
