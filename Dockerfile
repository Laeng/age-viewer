FROM node:18-alpine

RUN npm install -g pm2

WORKDIR /src

COPY . .

RUN npm run setup

CMD ["npm", "run", "start"]

EXPOSE 3000