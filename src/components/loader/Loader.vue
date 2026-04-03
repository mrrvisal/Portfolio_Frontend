<template>
    <div class="loader" :class="{ hidden: loaderHidden }" id="loader">
      <div class="loader-letters">
        <span class="loader-letter">E</span>
        <span class="loader-letter">i</span>
        <span class="loader-letter">&nbsp;</span>
        <span class="loader-letter accent">V</span>
        <span class="loader-letter accent">i</span>
        <span class="loader-letter accent">s</span>
        <span class="loader-letter accent">a</span>
        <span class="loader-letter accent">l</span>
      </div>
      <div class="loader-tagline">Web Developer · Cambodia</div>
      <div class="loader-bar-wrap">
        <div class="loader-bar-fill"></div>
      </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
  const loaderHidden = ref(false);
  // ── Lifecycle ──────────────────────────────────────────
onMounted(() => {
  // Loader
  setTimeout(() => {
    loaderHidden.value = true;
  }, 2000);
});
</script>