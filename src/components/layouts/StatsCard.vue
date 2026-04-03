<template>
    <div class="stats-bar" ref="statsBarRef">
      <div class="stat-item" v-for="stat in stats" :key="stat.label">
        <div class="stat-num">
          <span>{{ stat.current }}</span
          ><span>{{ stat.suffix }}</span>
        </div>
        <div class="stat-label">{{ stat.label }}</div>
      </div>
    </div>
    <div class="marquee-wrap">
      <div class="marquee-track">
        <span class="marquee-item" v-for="(tech, i) in marqueeItems" :key="i">
          <span class="marquee-sep"></span>{{ tech }}
        </span>
      </div>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
const statsBarRef = ref(null);
// 🔥 animate function
const animateStats = () => {
  stats.forEach((stat) => {
    let start = 0;
    const duration = 1500; // 1.5 seconds
    const stepTime = 20;
    const increment = stat.target / (duration / stepTime);

    const counter = setInterval(() => {
      start += increment;

      if (start >= stat.target) {
        stat.current = stat.target;
        clearInterval(counter);
      } else {
        stat.current = Math.floor(start);
      }
    }, stepTime);
  });
};
onMounted(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting) {
        animateStats();
        observer.disconnect(); // run once only
      }
    },
    { threshold: 0.5 }
  );

  if (statsBarRef.value) {
    observer.observe(statsBarRef.value);
  }
});
const stats = reactive([
  { label: "Years Experience", target: 1, current: 0, suffix: "+" },
  { label: "Projects Built", target: 10, current: 0, suffix: "+" },
  { label: "Happy Clients", target: 15, current: 0, suffix: "+" },
  { label: "Passion Driven", target: 100, current: 0, suffix: "%" },
]);
const marqueeItems = [
  "HTML5",
  "CSS3",
  "Bootstrap",
  "JavaScript",
  "Vue.js",
  "Node.js",
  "Express.js",
  "Figma",
  "Git",
  "GitHub",
  "MySQL",
  "HTML5",
  "CSS3",
  "Bootstrap",
  "JavaScript",
  "Vue.js",
  "Node.js",
  "Express.js",
  "Figma",
  "Git",
  "GitHub",
  "MySQL",
];
</script>