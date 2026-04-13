ARG NODE_VERSION=20

# Stage 1: Build
FROM node:${NODE_VERSION}-alpine AS build

WORKDIR /src
COPY . .

RUN npm run setup
RUN cd frontend && NODE_OPTIONS=--openssl-legacy-provider npx react-scripts build
RUN cd backend && npm run build

# Stage 2: Production
FROM node:${NODE_VERSION}-alpine

RUN npm install -g pm2

WORKDIR /src

COPY --from=build /src/frontend/build ./frontend/build
COPY --from=build /src/backend/build ./backend/build
COPY --from=build /src/backend/sql ./backend/sql
COPY --from=build /src/backend/misc ./backend/misc
COPY --from=build /src/backend/node_modules ./backend/node_modules
COPY --from=build /src/backend/package.json ./backend/package.json
COPY --from=build /src/ecosystem.config.js ./ecosystem.config.js

EXPOSE 3000

CMD ["pm2-runtime", "ecosystem.config.js", "--env", "production"]
