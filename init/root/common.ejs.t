---
to: <%= rootDirectory %>/<%= projectName %>/common.scss
force: true
---
// width/height
.full-width {
  width: 100%;
}

.auto-flex {
  flex: 1;
}

// flex
.flex-box {
  display: flex;
}

.flex-column {
  flex-direction: column;
}

.align-center {
  align-items: center;
}

.align-end {
  align-items: flex-end;
}

.align-self-center {
  align-self: center;
}

.justify-center {
  justify-content: center;
}

.justify-end {
  justify-content: flex-end;
}

.justify-between {
  justify-content: space-between;
}

// position
.absolute {
  position: absolute;
}

.relative {
  position: relative;
}

// text
.bold-text {
  font-weight: bold;
}

.no-decoration-link {
  color: inherit !important;
  text-decoration: inherit;
}
