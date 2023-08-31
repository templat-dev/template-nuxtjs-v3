---
to: "<%= struct.generateEnable ? `${rootDirectory}/plugins/apiPlugin.ts` : null %>"
inject: true
skip_if: "// import API <%= struct.name.lowerCamelName %>Api"
after: "// include apis here"
---
  // import API <%= struct.name.lowerCamelName %>Api
  <%= struct.name.pascalName %>Api,