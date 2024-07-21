FROM node:20.12-bookworm-slim AS development

USER node

WORKDIR /app

EXPOSE 5173

COPY --chown=node ./package*.json ./

RUN npm install

COPY --chown=node ./ ./

CMD [ "npm", "run", "dev", "--", "--host" ]

FROM development AS build

RUN npm run build

FROM node:20.12-bookworm-slim AS production

RUN npm install -g serve

USER node

WORKDIR /var/www

EXPOSE 5173

COPY --from=build /app/dist /var/www

CMD [ "serve", "-s", "-p", "5173" ]