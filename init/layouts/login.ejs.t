---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/layouts/login.vue` : null %>"
force: true
---
<template>
  <nuxt></nuxt>
</template>
