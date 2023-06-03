---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.org
force: true
sh: cd <%= rootDirectory %>/<%= projectName %>/env/ && mv .env.org .env
---
NUXT_ENV_API_BASE_PATH=<%= entity.apiScheme %>://<%= entity.apiHost %><%= entity.apiBasePath %>
