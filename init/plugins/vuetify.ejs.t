---
to: <%= rootDirectory %>/plugins/vuetify.ts
force: true
---
import '@mdi/font/css/materialdesignicons.css'
import { createVuetify } from 'vuetify'
import * as directives from 'vuetify/directives'
import {
  VDataTable,
  VDataTableServer,
  VDataTableVirtual,
} from "vuetify/labs/VDataTable";
import { MAIN_THEME, mainTheme, MAIN_DARK_THEME, mainDarkTheme } from '~/helpers/themes'
import { defaults } from '~/helpers/defaults'
import Datepicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

export default defineNuxtPlugin(nuxtApp => {
  const vuetify = createVuetify({
    ssr: true,
    defaults,
    components: {
      VDataTable,
      VDataTableServer,
      VDataTableVirtual,
    },
    theme: {
      defaultTheme: MAIN_THEME,
      themes: {
        mainTheme,
        mainDarkTheme,
      },
      variations: {
        colors: ['primary', 'secondary', 'accent'],
        lighten: 9,
        darken: 9,
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
  nuxtApp.vueApp.component('Datepicker', Datepicker)
})
