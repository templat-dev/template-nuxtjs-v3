---
to: <%= rootDirectory %>/<%= projectName %>/mixins/base.ts
---
import {Component, Vue} from 'nuxt-property-decorator'
import {format, formatISO} from 'date-fns'
import appUtils from '@/utils/appUtils'

export interface VForm extends HTMLFormElement {
  reset(): void

  resetValidation(): void

  validate(): boolean
}

export interface SingleSearchCondition<T> {
  enabled: boolean
  value: T
}

export interface BaseSearchCondition {
  [key: string]: SingleSearchCondition<string | number | boolean>
}

@Component
export default class Base extends Vue {
  readonly NEW_INDEX = -1

  formatISO(date: Date) {
    return formatISO(date)
  }

  formatDate(date?: string) {
    if (!date) {
      return ''
    }
    return format(new Date(date), 'yyyy-MM-dd HH:mm')
  }

  toStringArray(array: any[]) {
    return appUtils.toStringArray(array)
  }

  toStringTimeArray(array: any[]) {
    return appUtils.toStringTimeArray(array)
  }
}
