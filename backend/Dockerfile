FROM node:18-alpine
WORKDIR /app

ADD https://github.com/Revanito/project-devops.git?branch=main&subdir=backend ./

RUN /bin/sh -c cp -r ./project-devops/backend ../app
RUN npm ci --omit=dev
RUN /bin/sh -c rm -r ./project-devops

EXPOSE 3000
CMD ["node", "src/server.js"]
