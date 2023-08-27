---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/middleware/auth.global.ts` : null %>"
force: true
---
import {useAuth} from "~/composables/useAuth";
import {RouteLocationNormalized} from "vue-router";
import {defineNuxtRouteMiddleware, navigateTo} from "#app";
import {USER_TYPE_ADMIN, USER_TYPE_CONST} from "~/constants/constants";

export default defineNuxtRouteMiddleware(async (to: RouteLocationNormalized) => {
  if (!process.server) {
    const { checkAuthState, user } = useAuth()
    await checkAuthState()

    if (to.path === '/login') {
      if (user.value) {
        console.log(`auth.global.ts: ${user.value.email} is logged in`)
        return navigateTo('/', {replace: true})
      }
      return
    }
    // tokenがなければログインページにリダイレクト
    if (!user.value) {
      console.log(`auth.global.ts: token.value is null`)
      return navigateTo('/login', {replace: true})
    }
  }
})
