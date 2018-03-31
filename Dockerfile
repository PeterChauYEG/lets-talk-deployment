FROM node:carbon

# Create ui directory
WORKDIR /usr/src/ui

# Install ui dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ui/package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle ui source
COPY ui/ ./

CMD [ "npm", "run build" ]

# Create api directory
WORKDIR ../api

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY api/package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY api/ ./

EXPOSE 8080

CMD [ "npm", "start" ]
