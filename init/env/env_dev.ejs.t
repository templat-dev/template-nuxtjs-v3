---
to: <%= rootDirectory %>/env/.env.dev
force: true
---
NUXT_PUBLIC_API_BASE_PATH=http://localhost:5000<%= struct.apiBasePath %>
