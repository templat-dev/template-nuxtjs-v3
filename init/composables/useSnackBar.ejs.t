---
to: <%= rootDirectory %>/composables/useSnackbar.ts
force: true
---
export interface AppSnackbarState {
  open?: boolean
  text: string
  actionText?: string
  action?: () => void
  timeout?: number | undefined
}

export const useAppSnackbar = () => {
  const state = useState<AppSnackbarState>('appSnackbar', () => ({} as AppSnackbarState))
  return {
    isOpen: isOpen(state),
    text: text(state),
    actionText: actionText(state),
    timeout: timeout(state),
    action: action(state),
    showSnackbar: showSnackbar(state),
    close: close(state),
  }
}

const isOpen = (state: Ref<AppSnackbarState>): boolean => {
  return state.value.open || false
}

const text = (state: Ref<AppSnackbarState>): string => {
  return state.value.text || ''
}

const actionText = (state: Ref<AppSnackbarState>): string => {
  return state.value.actionText || ''
}

const timeout = (state: Ref<AppSnackbarState>): number => {
  return state.value.timeout || 2000
}

const showSnackbar = (state: Ref<AppSnackbarState>) => {
  return ({text, actionText = '', action = () => {}, timeout = 2000}: AppSnackbarState) => {
    state.value = {open: true, text, actionText, action, timeout}
  }
}

const close = (state: Ref<AppSnackbarState>) => {
  return () => {
    state.value!.open = false
  }
}

const action = (state: Ref<AppSnackbarState>) => {
  return () => {
    if (state.value?.action) {
      state.value!.action()
    }
  }
}
