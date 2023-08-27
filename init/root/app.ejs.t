---
to: <%= rootDirectory %>/app.yaml
force: true
---
runtime: nodejs18

instance_class: F2

<%_ if (applicationType === 'console' && branchName === 'master') { -%>
service: console
<%_ } -%>

handlers:
  - url: /_nuxt
    static_dir: .nuxt/dist/client
    secure: always

  - url: /(.*\.(gif|png|jpg|ico|txt))$
    static_files: static/\1
    upload: static/.*\.(gif|png|jpg|ico|txt)$
    secure: always

  - url: /.*
    script: auto
    secure: always

env_variables:
  HOST: '0.0.0.0'
  NODE_ENV: 'prod'
