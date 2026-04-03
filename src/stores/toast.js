import { ref } from "vue";
import { defineStore } from "pinia";

export const useToastStore = defineStore("toast", () => {
  const toasts = ref([]);

  function addToast(message, type = "default", duration = 3000) {
    const id = Date.now();
    toasts.value.push({ id, message, type });

    setTimeout(() => removeToast(id), duration);
  }

  function removeToast(id) {
    toasts.value = toasts.value.filter((t) => t.id !== id);
  }

  return { toasts, addToast, removeToast };
});