FROM node:18-alpine
WORKDIR /app

ADD https://github.com/user/myrepo.git?branch=main&subdir=backend ./

RUN /bin/sh -c cp ./project-devops/backend /app
RUN npm ci --omit=dev
RUN /bin/sh -c rm -r ./project-devops

EXPOSE 3000
CMD ["node", "src/server.js"]
