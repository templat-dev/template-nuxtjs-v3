---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/pages/login.vue` : null %>"
force: true
---
<template>
  <v-row justify="center">
    <v-col class="login-panel pa-8" cols="10" md="6" sm="8">
      <img alt="ロゴ" class="logo mb-4" src="@/assets/image/logo.png">
      <span class="login-headline">ログイン</span>
      <div id="firebaseui-auth-container"></div>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import {Component, mixins} from 'nuxt-property-decorator'
import firebase from 'firebase/app'
import Base from '@/mixins/base'
import {authUI} from '@/plugins/firebase'
import {vxm} from '@/store'

const AUTH_UI_DEFAULT_CONFIG = {
  signInOptions: [
    {
      provider: firebase.auth.GoogleAuthProvider.PROVIDER_ID,
      scopes: []
    }
  ]
}

@Component
export default class LoginPage extends mixins(Base) {
  mounted() {
    if (authUI.isPendingRedirect()) {
      vxm.app.showLoading()
    }
    let signInSuccessUrl = '/'
    if (this.$route.query.r) {
      signInSuccessUrl = this.$route.query.r.toString()
    }
    authUI.start('#firebaseui-auth-container', {
      ...AUTH_UI_DEFAULT_CONFIG,
      signInSuccessUrl
    })
  }
}
</script>

<style scoped>
.logo {
  width: 120px;
  height: 120px;
}

.login-headline {
  font-size: 20px;
}

.login-panel {
  background-color: rgba(0, 0, 0, 0.02);
  display: flex;
  flex-direction: column;
  align-items: center;
  border-radius: 4px;
}

#firebaseui-auth-container >>> ul {
  padding-left: 0;
}
</style>
