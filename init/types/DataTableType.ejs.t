---
to: <%= rootDirectory %>/types/DataTableType.ts
force: true
---
export interface DataTablePageInfo {
  /** ページ番号 (初期ページは1) */
  page: number
  /** ページサイズ (全件指定時は-1) */
  itemsPerPage: number
<%_ if (project.dbType === 'datastore') { -%>
  /** ページング用のcursor配列 */
  cursors: string[]
<%_ } -%>
  /** ソートカラム配列 */
  sortBy: string[]
  /** ソート順序配列 */
  sortDesc: boolean[]
}

export const INITIAL_DATA_TABLE_PAGE_INFO: DataTablePageInfo = {
  page: 1,
  itemsPerPage: 30,
<%_ if (project.dbType === 'datastore') { -%>
  cursors: [],
<%_ } -%>
  sortBy: [],
  sortDesc: [],
}

export const DEFAULT_FOOTER_PROPS = {
  'items-per-page-options': [INITIAL_DATA_TABLE_PAGE_INFO.itemsPerPage, 50, 100, -1],
  'items-per-page-text': '1ページあたりの件数',
  'page-text': '{2}件中の{0}~{1}件を表示中'
}