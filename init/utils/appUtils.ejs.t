---
to: <%= rootDirectory %>/utils/appUtils.ts
force: true
---
import format from 'date-fns/format'

export default class AppUtils {
  static wait = (ms: number): Promise<void> => new Promise(r => setTimeout(r, ms))

  static generateRandomString(length: number) {
    const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    const charactersLength = characters.length
    let result = ''
    for (let i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength))
    }
    return result
  }

  static formatDate(date?: string) {
    if (!date) {
      return ''
    }
    return format(new Date(date), 'yyyy-MM-dd')
  }

  static toStringArray(array: any[]): string {
    if (!array) return ''
    let result = '['
    for (let idx = 0; idx < array.length; idx++) {
      const item = array[idx]
      if (idx !== 0) {
        result = `${result},`
      }
      result = `${result}${item.toString()}`
    }
    result = `${result}]`
    return result
  }

  static toStringTimeArray(array: string[]): string {
    if (!array) return ''
    let result = '['
    for (let idx = 0; idx < array.length; idx++) {
      const jstDate = new Date(array[idx])
      const formatted = (format(jstDate, 'yyyy-MM-dd HH:mm'))
      if (idx !== 0) {
        result = `${result},`
      }
      result = `${result}${formatted}`
    }
    result = `${result}]`
    return result
  }
}
