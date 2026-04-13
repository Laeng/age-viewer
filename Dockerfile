ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine

RUN npm install -g pm2

WORKDIR /src
COPY . .

RUN npm run setup
RUN cd frontend && NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=1536" npx react-scripts build
RUN cd backend && npm run build

EXPOSE 3000

CMD ["pm2-runtime", "ecosystem.config.js", "--env", "production"]
