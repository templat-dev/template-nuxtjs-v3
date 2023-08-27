---
to: "<%= project.plugins.find(p => p.name === 'pay')?.enable ? `${rootDirectory}/plugins/firebase.client.ts` : null %>"
force: true
---
import {initializeApp} from 'firebase/app'
import {defineNuxtPlugin, useRuntimeConfig} from "#app";

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig()

  const firebaseConfig = {
    apiKey: "AIzaSyBTbLQ1upwZ_vbd9vNciKSJrEy1qUS-JxI",
    authDomain: "estate-market-2022-371905.firebaseapp.com",
    projectId: "estate-market-2022-371905",
    storageBucket: "estate-market-2022-371905.appspot.com",
    messagingSenderId: "285275681139",
    appId: "1:285275681139:web:fe07c14ba1cc0795e05506",
    measurementId: "G-RY4SJB03CN"
  }

  initializeApp(firebaseConfig)
})
