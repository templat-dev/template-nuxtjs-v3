---
to: <%= rootDirectory %>/env/.env.prod
force: true
---
NUXT_PUBLIC_API_BASE_PATH=<%= struct.apiScheme %>://<%= struct.apiHost %><%= struct.apiBasePath %>
