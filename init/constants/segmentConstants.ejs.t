---
to: <%= rootDirectory %>/constants/segmentConstants.ts
force: true
---
// segment constants
<%_ project.segmentGroups.forEach(function (group, index) { -%>
export const <%= group.name.upperSnakeName %>_CONST = {
  <%_ group.segmentValues.forEach(function (value, index) { -%>
  <%= value.name.upperSnakeName %>: <%= value.value %>,
  <%_ }) -%>
}

  <%_ group.segmentValues.forEach(function (value, index) { -%>
export const <%= group.name.upperSnakeName %>_<%= value.name.upperSnakeName %> =
  {name: '<%= value.title %>', value: <%= group.name.upperSnakeName %>_CONST.<%= value.name.upperSnakeName %>}
  <%_ }) -%>

export const <%= group.name.upperSnakeName %>_LIST = [
  <%_ group.segmentValues.forEach(function (value, index) { -%>
  <%= group.name.upperSnakeName %>_<%= value.name.upperSnakeName %>,
  <%_ }) -%>
]
<%_ }) -%>