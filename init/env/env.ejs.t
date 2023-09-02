---
to: <%= rootDirectory %>/env/.env.org
force: true
sh: cd <%= rootDirectory %>/env/ && mv .env.org .env
---
NUXT_PUBLIC_API_BASE_PATH=<%= project.serverConfig.production.scheme %>://<%= project.serverConfig.production.host %><%= project.serverConfig.production.basePath %>
