---
to: <%= rootDirectory %>/<%= projectName %>/package.json
force: true
---
{
  "name": "<%= projectName %>",
  "version": "1.0.0",
  "description": "<%= entity.label %>",
  "author": "TemPlat Console",
  "private": true,
  "scripts": {
    "dev": "nuxt --dotenv ./env/.env",
    "dev:dev": "nuxt --dotenv ./env/.env.dev",
    "dev:stg": "nuxt --dotenv ./env/.env.stg",
    "dev:prod": "nuxt --dotenv ./env/.env.prod",
    "build": "nuxt build --dotenv ./env/.env",
    "build:dev": "nuxt build --dotenv ./env/.env.dev",
    "build:stg": "nuxt build --dotenv ./env/.env.stg",
    "build:prod": "nuxt build --dotenv ./env/.env.prod",
    "start": "nuxt start",
    "generate": "nuxt generate"
  },
  "dependencies": {
    "@nuxtjs/axios": "^5.13.6",
<%_ if (entity.plugins.includes('pay')) { -%>
    "@stripe/stripe-js": "^1.17.1",
<%_ } -%>
    "@nuxtjs/vuetify": "^1.12.1",
    "date-fns": "^2.21.1",
<%_ if (entity.plugins.includes('auth')) { -%>
    "firebase": "^8.10.0",
    "firebaseui": "^5.0.0",
<%_ } -%>
    "lodash-es": "^4.17.21",
    "nuxt": "^2.15.7",
    "nuxt-property-decorator": "^2.9.1",
    "vuex-class-component": "^2.3.5"
  },
  "devDependencies": {
    "@nuxt/types": "^2.15.7",
    "@nuxt/typescript-build": "^2.1.0",
    "@openapitools/openapi-generator-cli": "^1.0.18-5.0.0-beta2",
<%_ if (entity.plugins.includes('pay')) { -%>
    "@types/lodash-es": "^4.17.4",
    "@types/stripe-v3": "^3.1.25"
<%_ } else { -%>
    "@types/lodash-es": "^4.17.4"
<%_ } -%>
  },
  "resolutions": {
    "//": "https://stackoverflow.com/questions/67631879/nuxtjs-vuetify-throwing-lots-of-using-for-division-is-deprecated-and-will-be",
    "@nuxtjs/vuetify/**/sass": "1.32.12"
  }
}
