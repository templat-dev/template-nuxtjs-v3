---
to: <%= rootDirectory %>/helpers/defaults.ts
force: true
---
import { DefaultsInstance } from 'vuetify/lib/framework.mjs'

export const defaults: DefaultsInstance = {
  VAppBar: {
    elevation: 0,
  },
  VBtn: {
    variant: 'flat',
    height: 38,
    rounded: 'lg',
    size: 'small',
  },
  VTextField: {
    color: 'primary',
    variant: 'underlined',
    density: 'comfortable',
  },
}
