---
to: <%= rootDirectory %>/env/.env.stg
force: true
---
NUXT_PUBLIC_API_BASE_PATH=<%= project.serverConfig.staging.scheme %>://<%= project.serverConfig.staging.host %><%= project.serverConfig.staging.basePath %>
