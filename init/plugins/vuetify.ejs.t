---
to: <%= rootDirectory %>/plugins/vuetify.ts
force: true
---
import '@mdi/font/css/materialdesignicons.css'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import {
  VDataTable,
  VDataTableServer,
  VDataTableVirtual,
} from "vuetify/labs/VDataTable";

export default defineNuxtPlugin(nuxtApp => {
  // テーマを定義
  const customTheme = {
    colors: {
      primary: '#2196F3',
      secondary: '#b0bec5',
      white: '#ffffff',
    }
  }
  const vuetify = createVuetify({
    ssr: true,
    components: {
      VDataTable,
      VDataTableServer,
      VDataTableVirtual,
    },
    theme: {
      defaultTheme: 'customTheme',
      themes: {
        customTheme // テーマを設定
      },
    },
    directives,
    icons: {
      defaultSet: 'mdi', // ここで mdi を指定しないとアイコンが表示されない
    }
    // 他の設定をここに記述していく
  })

  // Vue.js で Vuetify を使用する
  nuxtApp.vueApp.use(vuetify)
})
