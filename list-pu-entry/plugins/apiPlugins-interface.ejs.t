---
to: "<%= struct.generateEnable ? `${rootDirectory}/plugins/apiPlugin.ts` : null %>"
inject: true
skip_if: "// interface API <%= struct.name.lowerCamelName %>Api"
after: "// include interfaces here"
---
  // interface API <%= struct.name.lowerCamelName %>Api
  <%= struct.name.lowerCamelName %>Api(): <%= struct.name.pascalName %>Api