---
to: <%= rootDirectory %>/constants/appConstants.ts
force: true
---
export const DATETIME_FORMAT = {
  // 2022-02-06T00:00:00+09:00
  FOR_API: "yyyy-MM-dd'T'HH:mm:ssxxx",
  DATE_TIME: 'yyyy-MM-dd HH:mm',
  DATE: 'yyyy-MM-dd',
  TIME: 'HH:mm',
  HHMM: 'H:m',
  MMDD: 'M/d',
  DAY_OF_WEEK: 'eee',
  DAY_OF_WEEK_VALUE: 'i',
  YYYYMMDD_JP: 'yyyy年 M月 d日',
  YYYYMMDD_HHMM_JP: 'yyyy年 M月 d日 HH時 mm分',
  MMDD_HHMM_JP: 'M月d日 HH時mm分',
  HHMM_JP: 'HH時mm分',
} as const

export const NEW_INDEX = -1 as const