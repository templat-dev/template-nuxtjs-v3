---
to: "<%= entity.plugins.includes('auth') ? `${rootDirectory}/${projectName}/plugins/firebase.ts` : null %>"
force: true
---
import firebase from 'firebase/app'
import 'firebase/analytics'
import 'firebase/auth'
import 'firebaseui/dist/firebaseui.css'
import * as firebaseui from 'firebaseui'

// Your web app's Firebase configuration
<%- entity.authParameter %>
if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig)
  firebase.analytics()
}
const auth = firebase.auth()
const authUI = new firebaseui.auth.AuthUI(auth)

export {auth, authUI}
