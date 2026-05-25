<template>
  <teleport to="body">
    <div class="adm-modal-overlay" v-if="show" @click.self="onClose">
      <div class="adm-modal-card adm-confirm-modal-card">
        <div class="adm-modal-header">
          <div>
            <div class="adm-modal-eyebrow">{{ eyebrow }}</div>
            <h3>{{ title }}</h3>
          </div>
          <button class="adm-modal-close" @click="onClose">
            <i class="bi bi-x-lg"></i>
          </button>
        </div>
        <p class="adm-confirm-message">{{ message }}</p>
        <div class="adm-modal-actions">
          <button type="button" class="adm-btn-outline" :disabled="loading" @click="onClose">
            <span>CANCEL</span>
          </button>
          <button type="button" class="adm-btn-primary adm-btn-danger" :disabled="loading" @click="emit('confirm')">
            <span>{{ loading ? "WORKING..." : confirmLabel }}</span>
          </button>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
const props = defineProps({
  show: { type: Boolean, default: false },
  eyebrow: { type: String, default: "CONFIRM" },
  title: { type: String, default: "" },
  message: { type: String, default: "" },
  confirmLabel: { type: String, default: "CONFIRM" },
  loading: { type: Boolean, default: false },
});
const emit = defineEmits(["close", "confirm"]);
const onClose = () => { if (props.loading) return; emit("close"); };
</script>
