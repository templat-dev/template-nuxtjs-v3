---
to: <%= rootDirectory %>/env/.env.org
force: true
sh: cd <%= rootDirectory %>/env/ && mv .env.org .env
---
NUXT_PUBLIC_API_BASE_PATH=<%= struct.apiScheme %>://<%= struct.apiHost %><%= struct.apiBasePath %>
