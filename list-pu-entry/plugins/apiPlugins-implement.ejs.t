---
to: "<%= struct.generateEnable ? `${rootDirectory}/plugins/apiPlugin.ts` : null %>"
inject: true
skip_if: "// Call API <%= struct.name.lowerCamelName %>Api"
after: "// include implements here"
---
  // Call API <%= struct.name.lowerCamelName %>Api
  <%= struct.name.lowerCamelName %>Api () {
    const runtimeConfig = useRuntimeConfig()
    let basePath = ''
    if (runtimeConfig.public.apiBasePath) {
      basePath = runtimeConfig.public.apiBasePath
    }
    basePath = basePath.replace(/\/+$/, "");
    const configuration: Configuration = {
      basePath: basePath,
    }
    const <%= struct.name.lowerCamelName %>Api = new <%= struct.name.pascalName %>Api(configuration)
    return <%= struct.name.lowerCamelName %>Api
  }
