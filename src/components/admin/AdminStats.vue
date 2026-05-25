<template>
  <div class="adm-stats-row">
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-code-slash"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ projectCount }}</div>
        <div class="adm-stat-label">PROJECTS</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-mortarboard-fill"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ educationCount }}</div>
        <div class="adm-stat-label">EDUCATION</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-envelope-fill"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ contactCount }}</div>
        <div class="adm-stat-label">MESSAGES</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  projectCount: { type: Number, default: 0 },
  educationCount: { type: Number, default: 0 },
  contactCount: { type: Number, default: 0 },
});
</script>
