<template>
  <section id="education" style="padding-top: 0">
    <div class="section-header reveal">
      <span class="section-eyebrow">03 / Education</span>
      <h2 class="section-title">
        My <span class="highlight">Background</span>
      </h2>
      <div class="section-rule"></div>
    </div>
    <!-- ⏳ Loading Skeleton -->
    <div v-if="loading" class="edu-grid">
      <div class="edu-card" v-for="n in 4" :key="n">
        <div class="edu-year skeleton"></div>
        <div class="edu-degree d-block skeleton"></div>
        <div class="edu-school skeleton"></div>
        <div class="edu-desc skeleton"></div>
        <span class="edu-badge skeleton"></span>
      </div>
    </div>
    <div class="edu-grid">
      <div
        v-for="(edu, index) in educations"
        :key="index"
        class="edu-card"
      >
        <div class="edu-year">{{ edu.year }}</div>
        <div class="edu-degree">{{ edu.degree }}</div>
        <div class="edu-school">{{ edu.school }}</div>
        <div class="edu-desc">{{ edu.description }}</div>
        <span
          v-if="edu.border_color"
          class="edu-badge"
          :style="{
            'border-color': 'var(--accent4)',
            color: 'var(--accent4)',
            opacity: 0.9,
          }"
          >{{ edu.badge }}</span
        >
        <span v-else class="edu-badge">{{ edu.badge }}</span>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from "vue";
import { useEducationStore } from "@/stores/education";

const educationStore = useEducationStore();
// Projects array (will be replaced with API)
const educations = ref([]);
let loading = ref(true);

onMounted(async () => {
  loading.value = true;
  try {
    const data = await educationStore.getEducations();
    educations.value = data || [];
    // console.log('try');
  } catch (err) {
    console.error(err);
  } finally {
    loading.value = false;
    // console.log('finish');
  }
});
</script>