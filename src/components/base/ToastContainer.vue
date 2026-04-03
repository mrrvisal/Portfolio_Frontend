<template>
  <Teleport to="body">
    <div class="toast-container">
      <TransitionGroup name="toast">
        <div
          v-for="toast in toasts"
          :key="toast.id"
          class="toast"
          :class="toast.type"
          @click="remove(toast.id)"
        >
          <span class="toast-icon">{{ toast.type === "success" ? "✓" : "✕" }}</span>
          <span class="toast-msg">{{ toast.message }}</span>
        </div>
      </TransitionGroup>
    </div>
  </Teleport>
</template>

<script setup>
import { useToast } from "@/composables/useToast";
const { toasts, remove } = useToast();
</script>

<style scoped>
.toast-container {
  position: fixed;
  top: 5.5rem;
  right: 2rem;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.toast {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0.85rem 1.1rem;
  border-radius: 0;
  font-size: 13.5px;
  font-weight: 500;
  cursor: pointer;
  min-width: 260px;
  max-width: 360px;
  background: var(--bg);
  color: var(--text);
  position: relative;
  overflow: hidden;
  border: none;
  box-shadow: var(--bg-toast);
}

/* corner brackets */
.toast::before,
.toast::after {
  content: '';
  position: absolute;
  width: 12px;
  height: 12px;
  transition: width 0.3s, height 0.3s;
}
.toast::before { top: 0; left: 0; border-top: 2.5px solid; border-left: 2.5px solid; }
.toast::after  { bottom: 0; right: 0; border-bottom: 2.5px solid; border-right: 2.5px solid; }
.toast:hover::before,
.toast:hover::after { width: 18px; height: 18px; }

.toast.success::before,
.toast.success::after { border-color: #10b981; }
.toast.error::before,
.toast.error::after   { border-color: #ef4444; }

.toast-icon {
  width: 18px;
  height: 18px;
  border: 2px solid currentColor;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 700;
  flex-shrink: 0;
}
.toast.success .toast-icon { color: #10b981; }
.toast.error   .toast-icon { color: #ef4444; }

.toast-msg { flex: 1; }

/* slide animations */
.toast-enter-active {
  animation: slide-in 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.toast-leave-active {
  animation: slide-out 0.25s ease forwards;
}

@keyframes slide-in {
  from { opacity: 0; transform: translateX(60px); }
  to   { opacity: 1; transform: translateX(0); }
}
@keyframes slide-out {
  from { opacity: 1; transform: translateX(0); }
  to   { opacity: 0; transform: translateX(60px); }
}
</style>