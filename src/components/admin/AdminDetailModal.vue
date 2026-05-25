<template>
  <teleport to="body">
    <div class="adm-modal-overlay" v-if="show" @click.self="emit('close')">
      <div class="adm-modal-card adm-detail-modal-card">
        <div class="adm-modal-header">
          <div>
            <div class="adm-modal-eyebrow">{{ type }} DETAIL</div>
            <h3>{{ title }}</h3>
          </div>
          <button class="adm-modal-close" @click="emit('close')">
            <i class="bi bi-x-lg"></i>
          </button>
        </div>
        <div class="adm-detail-list">
          <div class="adm-detail-item" v-for="field in fields" :key="field.label">
            <div class="adm-detail-label">{{ field.label }}</div>
            <a v-if="field.href" :href="field.href" target="_blank" class="adm-detail-value adm-detail-link">
              {{ field.value }}
            </a>
            <div v-else class="adm-detail-value">{{ field.value }}</div>
          </div>
        </div>
        <div class="adm-modal-actions">
          <button type="button" class="adm-btn-outline" @click="emit('close')">
            <span>CLOSE</span>
          </button>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
defineProps({
  show: { type: Boolean, default: false },
  type: { type: String, default: "" },
  title: { type: String, default: "Detail" },
  fields: { type: Array, default: () => [] },
});
const emit = defineEmits(["close"]);
</script>
