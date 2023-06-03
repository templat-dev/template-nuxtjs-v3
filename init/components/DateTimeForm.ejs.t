---
to: <%= rootDirectory %>/<%= projectName %>/components/form/DateTimeForm.vue
force: true
---
<template>
  <v-layout>
    <v-flex xs6>
      <v-menu v-model="dateMenu" :close-on-content-click="false" max-width="290">
        <template #activator="{ on, attrs }">
          <v-text-field v-bind="attrs" v-on="on"
                        :disabled="disabled" :label="`${label}日付`" :value="dateValue"
                        clearable prepend-icon="mdi-calendar" readonly
                        @click:clear="clearDate"></v-text-field>
        </template>
        <v-date-picker v-model="dateValue" :disabled="disabled"
                       @change="dateMenu = false"></v-date-picker>
      </v-menu>
    </v-flex>
    <v-flex xs6>
      <v-menu v-model="timeMenu" :close-on-content-click="false" max-width="290px">
        <template #activator="{ on, attrs }">
          <v-text-field v-bind="attrs" v-on="on"
                        :disabled="disabled" :label="`${label}時刻`" :value="timeValue"
                        clearable prepend-icon="mdi-clock-outline" readonly
                        @click:clear="clearTime"></v-text-field>
        </template>
        <v-time-picker v-if="timeMenu" v-model="timeValue" :disabled="disabled"
                       @click:minute="timeMenu = false"></v-time-picker>
      </v-menu>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import {Component, Prop, PropSync, Vue} from 'nuxt-property-decorator'
import {format, formatISO, startOfDay} from 'date-fns'
import parse from 'date-fns/parse'

@Component
export default class DateTimeFrom extends Vue {
  /** 画面表示ラベル */
  @Prop({type: String, default: ''})
  label!: string

  /** 編集対象 */
  @PropSync('dateTime', {type: String, default: undefined})
  syncedDateTime: string | undefined = undefined

  /** 編集状態 (true: 編集不可, false: 編集可能) */
  @Prop({type: Boolean, default: false})
  disabled!: boolean

  /** 日付選択表示状態 (true: 表示, false: 非表示) */
  dateMenu = false

  /** 時刻選択表示状態 (true: 表示, false: 非表示) */
  timeMenu = false

  get dateValue(): string {
    if (!this.syncedDateTime) {
      return ''
    }
    return format(new Date(this.syncedDateTime), 'yyyy-MM-dd')
  }

  set dateValue(dateValue: string) {
    let timeValue = '00:00'
    if (!!this.syncedDateTime) {
      timeValue = format(new Date(this.syncedDateTime), 'HH:mm')
    }
    this.syncedDateTime = formatISO(parse(`${dateValue} ${timeValue}`, 'yyyy-MM-dd HH:mm', new Date()))
  }

  get timeValue(): string {
    if (!this.syncedDateTime) {
      return ''
    }
    return format(new Date(this.syncedDateTime), 'HH:mm')
  }

  set timeValue(timeValue: string) {
    let dateValue = format(new Date(), 'yyyy-MM-dd')
    if (!!this.syncedDateTime) {
      dateValue = format(new Date(this.syncedDateTime), 'yyyy-MM-dd')
    }
    this.syncedDateTime = formatISO(parse(`${dateValue} ${timeValue}`, 'yyyy-MM-dd HH:mm', new Date()))
  }

  clearDate() {
    this.syncedDateTime = undefined
  }

  clearTime() {
    if (!this.syncedDateTime) {
      return
    }
    this.syncedDateTime = formatISO(startOfDay(new Date(this.syncedDateTime)))
  }
}
</script>

<style scoped></style>
