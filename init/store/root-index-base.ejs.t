---
to: <%= rootDirectory %>/<%= projectName %>/store/index.ts
force: true
---
import Vue from 'vue'
import Vuex from 'vuex'
import {createProxy, extractVuexModule} from 'vuex-class-component'
import {AppStore} from './app'

Vue.use(Vuex)

export const store = new Vuex.Store({
  modules: {
    ...extractVuexModule(AppStore),
  }
})

export const vxm = {
  app: createProxy(store, AppStore),
}
