---
to: <%= rootDirectory %>/nuxt.config.ts
force: true
---
import vuetify from 'vite-plugin-vuetify'

export default defineNuxtConfig({
  build: {
    transpile: ['vuetify'],
  },
  devtools: { enabled: true },
  app: {
    head: {
      titleTemplate: '%s - ' + process.env.npm_package_name,
      title: process.env.npm_package_name || '',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        {
          hid: 'description',
          name: 'description',
          content: process.env.npm_package_description || ''
        }
      ],
      link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }]
    },
  },
  hooks: {
    'vite:extendConfig': (config) => {
      config.plugins!.push(vuetify())
    },
  },
  modules: [
    "nuxt-lodash",
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
    "nuxt-stripe-module"
<%_ } -%>
  ],
  lodash: {
    prefix: "_",
    prefixSkip: ["string"],
    upperAfterPrefix: false,
    exclude: ["map"],
    alias: [
      ["camelCase", "stringToCamelCase"], // => stringToCamelCase
      ["kebabCase", "stringToKebab"], // => stringToKebab
      ["isDate", "isLodashDate"], // => _isLodashDate
    ],
  },
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
  stripe: {
    publishableKey: 'YOUR_STRIPE_PUBLISHABLE_KEY',
  },
<%_ } -%>
  vite: {
    ssr: {
      noExternal: ['vuetify'],
    },
    define: {
      'process.env.DEBUG': false,
    },
    // css: {
    //   preprocessorOptions: {
    //     scss: {
    //       additionalData: '@import "@/assets/common.scss"',
    //     },
    //   },
    // },
  },
  css: ['@/assets/common.scss'],
  plugins: [
    '@/plugins/apiPlugin.ts',
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
    '@/plugins/firebase.client.ts'
<%_ } -%>
  ],
  runtimeConfig: {
    public: {
      apiBasePath: process.env.NUXT_PUBLIC_API_BASE_PATH ? process.env.NUXT_PUBLIC_API_BASE_PATH : 'http://localhost:5000/api/v1',
    },
  },
})
