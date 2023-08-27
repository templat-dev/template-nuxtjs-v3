---
to: "<%= struct.plugins.includes('auth') ? `${rootDirectory}/layouts/login.vue` : null %>"
force: true
---
<template>
  <nuxt></nuxt>
</template>
