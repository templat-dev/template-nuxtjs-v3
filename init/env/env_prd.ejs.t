---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.prod
force: true
---
NUXT_ENV_API_BASE_PATH=<%= entity.apiScheme %>://<%= entity.apiHost %><%= entity.apiBasePath %>
