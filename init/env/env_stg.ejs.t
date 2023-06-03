---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.stg
force: true
---
NUXT_ENV_API_BASE_PATH=<%= entity.apiSchemeSTG %>://<%= entity.apiHostSTG %><%= entity.apiBasePathSTG %>
