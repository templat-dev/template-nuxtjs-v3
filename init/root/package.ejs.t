---
to: <%= rootDirectory %>/package.json
force: true
---
{
  "name": "<%= projectName %>",
  "version": "1.0.0",
  "description": "<%= struct.label %>",
  "author": "TemPlat Console",
  "private": true,
  "scripts": {
    "dev": "nuxt --dotenv ./env/.env",
    "dev:dev": "nuxt dev --dotenv ./env/.env.dev",
    "dev:stg": "nuxt dev --dotenv ./env/.env.stg",
    "dev:prod": "nuxt dev --dotenv ./env/.env.prod",
    "build": "nuxt build --dotenv ./env/.env",
    "build:dev": "nuxt build --dotenv ./env/.env.dev",
    "build:stg": "nuxt build --dotenv ./env/.env.stg",
    "build:prod": "nuxt build --dotenv ./env/.env.prod",
    "start": "node .output/server/index.mjs",
    "generate": "nuxt generate"
  },
  "dependencies": {},
  "devDependencies": {
    "@mdi/font": "^7.2.96",
    "@nuxt/devtools": "latest",
    "@nuxt/types": "^2.17.0",
    "@nuxt/typescript-build": "^3.0.1",
    "@openapitools/openapi-generator-cli": "^2.5.2",
    "@types/node": "^18",
    "axios": "^1.4.0",
    "date-fns": "^2.30.0",
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
    "firebase": "^9.23.0",
    "firebaseui": "^6.0.2",
<%_ } -%>
    "nuxt": "^3.5.2",
    "nuxt-lodash": "^2.5.0",
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
    "nuxt-stripe-module": "^3.2.0",
<%_ } -%>
    "sass": "^1.63.4",
    "vite-plugin-vuetify": "^1.0.2",
    "vuetify": "^3.3.4"
  }
}
