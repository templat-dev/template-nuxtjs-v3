---
to: <%= rootDirectory %>/composables/useSnackbar.ts
force: true
---
export interface AppSnackbarState {
  open?: boolean
  text: string
  actionText?: string
  action?: () => void
  timeout?: number | null
}

export const useAppSnackbar = () => {
  const state = useState<AppSnackbarState | null>('appSnackbar', () => null);
  return {
    state: readonly(state),
    showSnackbar: showSnackbar(state),
  }
}

const showSnackbar = (state: Ref<boolean>) => {
  return ({text, actionText = '', action = () => {}, timeout = 2000}: AppSnackbarState) => {
    state.value = {open: true, text, actionText, action, timeout}
  }
}
