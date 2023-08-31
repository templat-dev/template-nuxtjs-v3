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
}
const props = withDefaults(defineProps<Props>(), {
  label: '',
  dateTime: '',
  disabled: false,
})

interface Emits {
  (e: "update:datetime", dateTime: string): void
}
const emit = defineEmits<Emits>()

/** 日付選択表示状態 (true: 表示, false: 非表示) */
const dateMenu = ref<boolean>(false)

/** 時刻選択表示状態 (true: 表示, false: 非表示) */
const timeMenu = ref<boolean>(false)

const dateValue = computed({
  get: () => {
    if (!props.dateTime) {
      return ''
    }
    return format(new Date(props.dateTime), 'yyyy-MM-dd')
  },
  set: (dateValue: string) => {
    let timeValue = '00:00'
    if (!!props.dateTime) {
      timeValue = format(new Date(props.dateTime), 'HH:mm')
    }
    const newDateTime: string = formatISO(parse(`${dateValue} ${timeValue}`, 'yyyy-MM-dd HH:mm', new Date()))
    emit('update:datetime', newDateTime)
  }
})

const timeValue = computed({
  get: () => {
    if (!props.dateTime) {
      return ''
    }
    return format(new Date(props.dateTime), 'HH:mm')
  },
  set: (timeValue: string) => {
    let dateValue = format(new Date(), 'yyyy-MM-dd')
    if (!!props.dateTime) {
      dateValue = format(new Date(props.dateTime), 'yyyy-MM-dd')
    }
    const newDateTime: string = formatISO(parse(`${dateValue} ${timeValue}`, 'yyyy-MM-dd HH:mm', new Date()))
    emit('update:datetime', newDateTime)
  }
})

const clearDate = () => {
  if (!props.dateTime) {
    return
  }
  emit('update:datetime', '')
}

const clearTime = () => {
  if (!props.dateTime) {
    return
  }
  const newDateTime = formatISO(startOfDay(new Date(props.dateTime)))
  emit('update:datetime', newDateTime)
}
</script>

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

<style scoped></style>
