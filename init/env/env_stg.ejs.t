---
to: <%= rootDirectory %>/env/.env.stg
force: true
---
NUXT_PUBLIC_API_BASE_PATH=<%= struct.apiSchemeSTG %>://<%= struct.apiHostSTG %><%= struct.apiBasePathSTG %>
