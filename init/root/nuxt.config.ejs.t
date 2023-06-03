---
to: <%= rootDirectory %>/<%= projectName %>/nuxt.config.ts
force: true
---
import { Configuration } from "@nuxt/types"
import colors from 'vuetify/es5/util/colors'
const path = require('path')

const config: Configuration = {
  /*
   ** Disable server-side rendering
   ** Doc: https://go.nuxtjs.dev/ssr-mode
   */
  ssr: false,

  /*
   ** Global page headers
   ** Doc: https://go.nuxtjs.dev/config-head
   */
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

  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },

  /*
   ** Global CSS
   ** Doc: https://go.nuxtjs.dev/config-css
   */
  css: ['~/assets/style/common.scss'],

  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
<%_ if (entity.plugins.includes('auth')) { -%>
    '@/plugins/auth',
    '@/plugins/firebase',
<%_ } -%>
  ],

  /*
   ** Auto import components:
   ** Doc: https://go.nuxtjs.dev/config-components
   */
  components: true,

  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://go.nuxtjs.dev/typescript
    '@nuxt/typescript-build',
    // Doc: https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
  ],

  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
  ],

  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  axios: {},

  /*
   ** vuetify module configuration
   ** Doc: https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    customVariables: ['~/assets/style/variables.scss'],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
        light: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        }
      },
      options: {
        customProperties: true
      }
    }
  },

  /*
   ** Resolve Path
   */
  resolve: {
    extensions: ['.js', '.json', '.vue', '.ts'],
    root: path.resolve(__dirname),
    alias: {
      '@': path.resolve(__dirname),
      '~': path.resolve(__dirname)
    }
  },

  /*
   ** Build Configuration
   ** Doc: https://go.nuxtjs.dev/config-build
   */
  build: {
    transpile: ['vuetify/lib'],
    loaders: {
      sass: {
        sassOptions: {
          indentedSyntax: true
        }
      }
    }
  }
}
export default config
