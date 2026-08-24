FROM node:18-alpine
WORKDIR /app

ADD git@github.com:Revanito/project-devops.git ./

RUN /bin/sh -c cp ./project-devops/backend /app
RUN npm ci --omit=dev
RUN /bin/sh -c rm -r ./project-devops

EXPOSE 3000
CMD ["node", "src/server.js"]
