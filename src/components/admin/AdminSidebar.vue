<template>
  <div class="adm-sidebar">
    <div class="adm-sidebar-brand">
      <span class="adm-brand-dot"></span>
      <span class="adm-brand-text">ADMIN<span class="adm-brand-accent">.</span></span>
      <button
        class="adm-sidebar-menu-btn"
        type="button"
        :aria-expanded="sidebarOpen"
        :aria-label="sidebarOpen ? 'Close menu' : 'Open menu'"
        @click="sidebarOpen = !sidebarOpen"
      >
        <i :class="`bi ${sidebarOpen ? 'bi-x-lg' : 'bi-list'}`"></i>
      </button>
    </div>
    <div class="adm-sidebar-section-label">NAVIGATION</div>
    <div class="adm-sidebar-nav" :class="{ open: sidebarOpen }">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        class="adm-nav-item"
        :class="{ active: activeTab === tab.id }"
        @click="selectTab(tab.id)"
      >
        <i :class="`bi ${tab.icon}`"></i>
        <span>{{ tab.label }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'projects'">{{ projectCount }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'education'">{{ educationCount }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'contacts'">{{ contactCount }}</span>
      </button>
    </div>
    <div class="adm-sidebar-footer" :class="{ open: sidebarOpen }">
      <div class="adm-sidebar-status">
        <span class="adm-status-dot"></span>
        <span class="adm-status-text">CONNECTED</span>
      </div>
      <button
        class="adm-theme-toggle-btn"
        @click="emit('toggle-theme')"
        :title="isLightTheme ? 'Switch to dark mode' : 'Switch to light mode'"
      >
        <i :class="`bi ${isLightTheme ? 'bi-moon-fill' : 'bi-sun-fill'}`"></i>
        <span>{{ isLightTheme ? "Dark" : "Light" }}</span>
      </button>
      <button class="adm-logout-btn" @click="emit('sign-out')">
        <i class="bi bi-box-arrow-left"></i>
        <span>SIGN OUT</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

defineProps({
  activeTab: { type: String, required: true },
  isLightTheme: { type: Boolean, default: false },
  projectCount: { type: Number, default: 0 },
  educationCount: { type: Number, default: 0 },
  contactCount: { type: Number, default: 0 },
});

const emit = defineEmits(["update:activeTab", "toggle-theme", "sign-out"]);
const sidebarOpen = ref(false);

const tabs = [
  { id: "projects", label: "Projects", icon: "bi-code-slash" },
  { id: "education", label: "Education", icon: "bi-mortarboard-fill" },
  { id: "contacts", label: "Contacts", icon: "bi-envelope-fill" },
];

const selectTab = (tabId) => {
  emit("update:activeTab", tabId);
  sidebarOpen.value = false;
};
</script>
