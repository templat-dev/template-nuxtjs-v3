---
to: <%= rootDirectory %>/components/form/DateTimeForm.vue
force: true
---
<script setup lang="ts">
import {format, formatISO, startOfDay} from 'date-fns'
import parse from 'date-fns/parse'

interface Props {
  /** 画面表示ラベル */
  label?: string,
  /** 編集対象 */
  dateTime?: string,
  /** 編集状態 (true: 編集不可, false: 編集可能) */
  disabled?: boolean,
  dateOnly?: boolean,
}
const props = withDefaults(defineProps<Props>(), {
  label: '',
  dateTime: '',
  disabled: false,
  dateOnly: true,
})

interface Emits {
  (e: "update:datetime", dateTime: string): void
}
const emit = defineEmits<Emits>()

const dateTimeValue = computed({
  get: (): Date | null => {
    if (!props.dateTime) {
      return null
    }
    return new Date(props.dateTime)
  },
  set: (value: Date | null) => {
    if (props.dateOnly) {
      // 日付のみ（時刻は00:00）
      const dateValue = format(value!, 'yyyy-MM-dd')
      const timeValue = '00:00'
      const newDateTime: string = formatISO(parse(`${dateValue} ${timeValue}`, 'yyyy-MM-dd HH:mm', new Date()))
      emit('update:datetime', newDateTime)
    } else {
      // 日付と時刻
      if (!value) {
        emit('update:datetime', '')
      } else {
        const newDateTime: string = formatISO(value)
        emit('update:datetime', newDateTime)
      }
    }
  }
})
const formatDate = (args: any) => {
  return `${args.getFullYear()}年 ${args.getMonth() + 1}月 ${args.getDate()}日`
}
</script>

<template>
  <v-sheet class="date-time-form">
    <v-label class="date-time-label">{{`${label}日付`}}</v-label>
    <Datepicker
      v-model="dateTimeValue"
      :format="formatDate"
    />
  </v-sheet>
</template>

<style scoped>
.date-time-form {
  margin-top: 1rem;
  margin-bottom: 1rem;
}
.date-time-label {
  font-size: 0.8rem;
}
</style>
