---
to: <%= rootDirectory %>/composables/useLoading.ts
force: true
---
export const useAppLoading = () => {
  const state = useState<boolean>('appLoading', () => false)
  return {
    isLoading: isLoading(state),
    showLoading: showLoading(state),
    hideLoading: hideLoading(state),
  }
}

const isLoading = (state: Ref<boolean>): boolean => {
  return state.value
}

const showLoading = (state: Ref<boolean>) => {
  return () => state.value = true
}

const hideLoading = (state: Ref<boolean>) => {
  return () => state.value = false
}
