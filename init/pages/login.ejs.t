---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/pages/login.vue` : null %>"
force: true
---
<script setup lang="ts">
import {navigateTo} from "#app";
import {useAuth} from "~/composables/useAuth";
import {Ref, ref, watch} from "vue";
import {definePageMeta} from "#imports";
import {USER_TYPE_CONST} from "~/constants/constants";
import {ModelUser} from "~/apis";

definePageMeta({
  layout: 'login',
})

const {user, checkAuthState} = useAuth()
const email: Ref<string> = ref('')
const password: Ref<string> = ref('')
const show: Ref<boolean> = ref(false)

watch(show, (show) => {
  if (user) {
    navigateOnSignIn()
  }
})

const navigateOnSignIn = () => {
  if (user.value?.userType === USER_TYPE_CONST.SELLER) {
    navigateTo('/seller/estate')
    return
  }
  navigateTo('/')
}

const signIn = async (): Promise<void> => {
  await useAuth().signIn(email.value, password.value)
  checkAuthState().then((user: ModelUser | null) => {
    if (user) {
      navigateOnSignIn()
    } else {
      console.log('ユーザー情報が存在しません')
    }
  })
}

const signUp = async (): Promise<void> => {
  await useAuth().signUp(email.value, password.value)
  if (useAuth().user.value) {
    navigateOnSignIn()
  } else {
    console.log('ユーザー情報が存在しません')
  }
}
</script>

<template>
  <v-container>
    <v-card max-width="500" class="mx-auto">
      <v-card-text>
        <v-text-field
            v-model="email"
            label="メールアドレス"
            type="email"
        >
        </v-text-field>
        <v-text-field
            v-model="password"
            label="パスワード"
            :type="show ? 'text' : 'password'"
            :append-inner-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
            @click:append-inner="show = !show"
        >
        </v-text-field>
      </v-card-text>
      <v-card-actions>
        <v-container>
          <v-row>
            <v-col>
              <v-btn color="#e974b3" variant="flat" @click="signIn">
                ログイン
              </v-btn>
            </v-col>
            <v-col>
              <v-btn color="#e974b3" variant="text" @click="signUp">
                アカウント登録
              </v-btn>
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <v-btn color="#e974b3" variant="text">
                パスワードを忘れた方はこちら
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-card-actions>
    </v-card>
  </v-container>
</template>
