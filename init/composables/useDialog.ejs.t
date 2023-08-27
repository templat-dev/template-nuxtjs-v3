---
to: <%= rootDirectory %>/composables/useDialog.ts
force: true
---
export interface AppDialogState {
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

export const useAppDialog = () => {
  const state = useState<AppDialogSate | null>('appDialog', () => null);
  return {
    state: readonly(state),
    showDialog: showDialog(state),
  }
}

const showDialog = (state: Ref<AppDialogState>) => {
  return ({
    title, message, positiveText = 'OK', neutralText = '', negativeText = '',
    positive = () => {}, neutral = () => {}, negative = () => {}, close = () => {}, persistent = false
  }: AppDialogState) => {
    state.value = {
      open: true, title, message, positiveText, neutralText, negativeText,
      positive, neutral, negative, close, persistent
    }
  }
}
