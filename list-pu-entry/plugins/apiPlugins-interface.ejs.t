---
to: "<%= struct.enable ? `${rootDirectory}/plugins/apiPlugin.ts` : null %>"
inject: true
skip_if: /** Call API: <%= struct.name.lowerCamelName %>Api */
after: // include interfaces here
---
  <%= struct.name.lowerCamelName %>Api(): <%= struct.name.pascalName %>Api