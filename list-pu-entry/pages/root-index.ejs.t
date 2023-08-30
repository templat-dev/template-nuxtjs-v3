---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/index.vue` : null %>"
inject: true
skip_if: <!-- メニュー <%= struct.screenLabel || struct.name.pascalName %> -->
after: <!-- メニュー -->
---
      <!-- メニュー <%= struct.screenLabel || struct.name.pascalName %> -->
      <v-col cols="12" lg="3" md="4" sm="6" xl="2">
        <v-card class="mb-4">
          <v-card-title class="headline">
            <v-icon class="title-icon mr-2">mdi-cube</v-icon>
            <%= struct.label %>
          </v-card-title>
          <v-card-text>
            <p class="comment"><%= struct.screenLabel || struct.name.pascalName %>の一覧</p>
          </v-card-text>
          <v-divider></v-divider>
          <v-btn block class="justify-end" color="primary" height="44px" small text to="/<%= struct.name.lowerCamelName %>">
            <v-icon class="mr-1" size="18px">mdi-arrow-right</v-icon>
            <%= struct.screenLabel || struct.name.pascalName %>画面に移動
          </v-btn>
        </v-card>
      </v-col>