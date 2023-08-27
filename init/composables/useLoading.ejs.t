---
to: <%= rootDirectory %>/composables/useLoading.ts
force: true
---
export const useAppLoading = () => {
  const state = useState<boolean>('appLoading', () => false)
  return {
    state: readonly(state),
    showLoading: showLoading(state),
    hideLoading: hideLoading(state),
  }
}

const showLoading = (state: Ref<boolean>) => {
  return () => state.value = true
}

const hideLoading = (state: Ref<boolean>) => {
  return () => state.value = false
}
