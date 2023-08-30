---
to: <%= rootDirectory %>/layouts/default.vue
force: true
---
<script lang="ts" setup>
import AppLoading from '@/components/modal/AppLoading.vue'
import AppDialog from '@/components/modal/AppDialog.vue'
import AppSnackBar from '@/components/modal/AppSnackBar.vue'

const route = useRoute()

/** ドロワー表示状態 (true: 表示, false: 非表示) */
const drawer = ref<boolean>(false)

const activeMenu = computed(() => {
  return menus.find(menu => route.path === menu.to)
})

const currentPageTitle = computed(() {
  if (route.path === '/' || !activeMenu) {
    return null
  }
  return activeMenu.title
})

const menus = computed(() => {
  return [
    {
      title: 'Top',
      to: `/`
    },
    // メニュー
  ]
})

<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
const isLoginPage = computed(() => {
  return this.$route.path === '/login'
})

const signOut = computed(async () =>
  await auth.signOut()
  window.location.reload()
})
<%_ } -%>
</script>

<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" :clipped="true" app fixed>
      <v-list>
        <v-list-item v-for="(menu, i) in menus" v-if="!menu.divider"
                     :key="i" :href="menu.href ? menu.href : null"
                     :target="menu.href ? '_blank' : '_self'" :to="menu.to ? menu.to : null"
                     exact router @click="drawer = false">
          <v-list-item-content v-if="!!menu.title">
            <v-list-item-title v-text="menu.title"/>
          </v-list-item-content>
        </v-list-item>
        <v-divider v-else></v-divider>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar :clipped-left="true" app color="primary" dark dense fixed>
      <v-app-bar-nav-icon @click="drawer = !drawer"/>
      <nuxt-link class="no-decoration-link" to="/">
        <v-toolbar-title><%= struct.label %></v-toolbar-title>
      </nuxt-link>
      <div v-if="currentPageTitle" class="page-name-area">
        <span>{{ currentPageTitle }}</span>
      </div>
      <v-spacer/>
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
      <v-btn @click="signOut" icon v-if="!isLoginPage">
        <v-icon>mdi-logout-variant</v-icon>
      </v-btn>
<%_ } -%>
    </v-app-bar>

    <v-main>
      <v-container>
        <nuxt/>
      </v-container>
    </v-main>

    <v-footer app color="primary">
      <span class="white--text">&copy; 2020</span>
    </v-footer>

    <app-loading/>
    <app-dialog/>
    <app-snack-bar/>
  </v-app>
</template>

<style scoped>
.page-name-area {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4px 8px;
  margin-left: 16px;
  border: 1px solid white;
  border-radius: 4px;
}

.page-name-area > span {
  font-size: 12px;
  font-weight: bold;
  line-height: 1;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
