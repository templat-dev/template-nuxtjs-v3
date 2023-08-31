---
to: <%= rootDirectory %>/plugins/apiPlugin.ts
force: true
---
import {
  Configuration,
  // include apis here
} from "~/apis";
import {defineNuxtPlugin, useRuntimeConfig} from "#app";

export interface apiPluginInterface {
  // include interfaces here
}

class ApiPlugin implements apiPluginInterface {
  // include implements here
}

export default defineNuxtPlugin(nuxtApp => {
  return {
    provide: {
      api: new ApiPlugin
    }
  }
})