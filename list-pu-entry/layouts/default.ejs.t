---
to: <%= rootDirectory %>/layouts/default.vue
inject: true
skip_if: // メニュー <%= struct.name.lowerCamelName %>
after: // メニュー
---
      // メニュー <%= struct.name.lowerCamelName %>
      {
        title: '<%= struct.screenLabel || struct.name.pascalNam %>',
        to: `/<%= struct.name.lowerCamelName %>`
      },