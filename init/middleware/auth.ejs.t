---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/middleware/auth.ts` : null %>"
force: true
---
import {Context} from '@nuxt/types'
import {auth} from '~/plugins/firebase'

export default async ({route, redirect}: Context) => {
  if (route.path === '/login') {
    return
  }
  if (!auth.currentUser) {
    return redirect('/login')
  }
}
