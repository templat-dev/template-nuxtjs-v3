---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/plugins/auth.ts` : null %>"
force: true
---
import {Context} from '@nuxt/types'
import firebase from 'firebase/app'
import globalAxios from 'axios'

export default async ({route}: Context) => {
  await new Promise((resolve) => {
    firebase.auth().onAuthStateChanged(async (user) => {
      if (user) {
        globalAxios.interceptors.request.use(async request => {
          request.headers.common = {'Authorization': `Bearer ${await user.getIdToken()}`}
          return request
        })
      }
      resolve(null)
    })
  })
}
