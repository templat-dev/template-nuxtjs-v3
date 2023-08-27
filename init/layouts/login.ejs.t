---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/layouts/login.vue` : null %>"
force: true
---
<template>
  <nuxt></nuxt>
</template>
