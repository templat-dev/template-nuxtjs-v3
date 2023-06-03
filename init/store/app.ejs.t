---
to: <%= rootDirectory %>/<%= projectName %>/store/app.ts
force: true
---
import {createModule, mutation} from 'vuex-class-component'

const VuexModule = createModule({
  namespaced: 'app',
  strict: false,
  target: 'nuxt'
})

export interface AppDialogProp {
  open?: boolean
  title: string
  message: string
  positiveText?: string
  neutralText?: string
  negativeText?: string
  positive?: () => void
  neutral?: () => void
  negative?: () => void
  close?: () => void
  persistent?: boolean
}

export interface AppSnackbarProp {
  open?: boolean
  text: string
  actionText?: string
  action?: () => void
  timeout?: number | null
}

/**
 * @description App store
 */
export class AppStore extends VuexModule {
  loading: boolean = false
  dialog: AppDialogProp = {
    open: false,
    title: '',
    message: '',
    positiveText: 'OK',
    neutralText: '',
    negativeText: '',
    positive: () => {},
    neutral: () => {},
    negative: () => {},
    close: () => {},
    persistent: false
  }
  snackbar: AppSnackbarProp = {
    open: false,
    text: '',
    actionText: '',
    action: () => {},
    timeout: 2000
  }

  @mutation
  showLoading() {
    this.loading = true
  }

  @mutation
  hideLoading() {
    this.loading = false
  }

  @mutation
  showDialog({
               title, message, positiveText = 'OK', neutralText = '', negativeText = '',
               positive = () => {}, neutral = () => {}, negative = () => {}, close = () => {}, persistent = false
             }: AppDialogProp) {
    this.dialog = {
      open: true, title, message, positiveText, neutralText, negativeText,
      positive, neutral, negative, close, persistent
    }
  }

  @mutation
  showSnackbar({text, actionText = '', action = () => {}, timeout = 2000}: AppSnackbarProp) {
    this.snackbar = {open: true, text, actionText, action, timeout}
  }
}
