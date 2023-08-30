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
  const state = useState<AppDialogState>('appDialog', () => ({} as AppDialogState));
  return {
    isOpen: isOpen(state),
    isPersistent: isPersistent(state),
    title: title(state),
    message: message(state),
    positiveText: positiveText(state),
    negativeText: negativeText(state),
    neutralText: neutralText(state),
    showDialog: showDialog(state),
    close: close(state),
    positive: positive(state),
    neutral: neutral(state),
    negative: negative(state),
  }
}

const isOpen = (state: Ref<AppDialogState>): boolean => {
  return state.value.open || false
}

const isPersistent = (state: Ref<AppDialogState>): boolean => {
  return state.value.persistent || false
}

const title = (state: Ref<AppDialogState>): string => {
  return state.value.title || ''
}

const message = (state: Ref<AppDialogState>): string => {
  return state.value.message || ''
}

const positiveText = (state: Ref<AppDialogState>): string => {
  return state.value.positiveText || ''
}

const negativeText = (state: Ref<AppDialogState>): string => {
  return state.value.negativeText || ''
}

const neutralText = (state: Ref<AppDialogState>): string => {
  return state.value.neutralText || ''
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

const close = (state: Ref<AppDialogState>) => {
  return () => {
    state.value!.open = false
  }
}

const positive = (state: Ref<AppDialogState>) => {
  return () => {
    if (state.value?.positive) {
      state.value!.positive()
    }
  }
}

const neutral = (state: Ref<AppDialogState>) => {
  return () => {
    if (state.value?.neutral) {
      state.value!.neutral()
    }
  }
}
const negative = (state: Ref<AppDialogState>) => {
  return () => {
    if (state.value?.negative) {
      state.value!.negative()
    }
  }
}
