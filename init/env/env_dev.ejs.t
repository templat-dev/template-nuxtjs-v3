---
to: <%= rootDirectory %>/<%= projectName %>/env/.env.dev
force: true
---
NUXT_ENV_API_BASE_PATH=http://localhost:5000<%= entity.apiBasePath %>
