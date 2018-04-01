FROM node:carbon

# Create ui directory
WORKDIR /usr/src/ui

# Clone UI repository
RUN git clone https://northwest69@bitbucket.org/laboratoryone/ui.git .

# Install the production node modules
RUN npm install --only=production

# Build the UI into it's bundle which will be served by the API
RUN npm run build

# -----------

# Create api directory
WORKDIR ../api

# Clone api repository
RUN git clone https://northwest69@bitbucket.org/laboratoryone/lets-talk-api.git .

# Install the production node modules
RUN npm install --only=production

EXPOSE 8080

CMD [ "npm", "start" ]
