---
to: <%= rootDirectory %>/plugins/apiPlugin.ts
force: true
---
import {
  Configuration,
  ImageApi,
  // include apis here
} from "~/apis";
import {defineNuxtPlugin, useRuntimeConfig} from "#app";

export interface apiPluginInterface {
  imageApi(): ImageApi
  // include interfaces here
}

class ApiPlugin implements apiPluginInterface {
<%_ if (project.plugins.find(p => p.name === 'image')?.enable) { -%>
  imageApi () {
    const runtimeConfig = useRuntimeConfig()
    let basePath = ''
    if (runtimeConfig.public.apiBasePath) {
      basePath = runtimeConfig.public.apiBasePath
    }
    basePath = basePath.replace(/\/+$/, "");
    const configuration: Configuration = {
      basePath: basePath,
    }
    const imageApi = new ImageApi(configuration)
    return imageApi
  }
<%_ } -%>
  // include implements here
}

export default defineNuxtPlugin(nuxtApp => {
  return {
    provide: {
      api: new ApiPlugin
    }
  }
})