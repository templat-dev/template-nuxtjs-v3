---
to: <%= rootDirectory %>/types/<%= struct.name.pascalName %>Type.ts
---
export interface <%= struct.name.pascalName %>SearchCondition {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}



export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.editType === 'struct') { -%>
  <%= field.name.lowerCamelName %>: INITIAL_<%= field.structName.upperSnakeName %>,
  <%_ } -%>
  <%_ if (field.editType.startsWith('array')) { -%>
  <%= field.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (field.editType === 'string' || field.editType === 'textarea' || field.editType === 'time') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'bool') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'number') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
}





