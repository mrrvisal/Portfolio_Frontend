<template>
  <div>
    <div class="stats-bar" ref="statsBarRef">
      <template v-if="!statsLoaded">
        <div class="stat-item" v-for="item in skeletonStats" :key="item">
          <div class="stat-num">
            <span class="stat-num-skeleton skeleton"></span>
          </div>
          <div class="stat-label stat-label-skeleton skeleton"></div>
        </div>
      </template>
      <div v-else class="stat-item" v-for="stat in stats" :key="stat.label">
        <div class="stat-num">
          <span>{{ stat.current }}</span>
          <span>{{ stat.suffix }}</span>
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
  </div>
</template>

<script setup>
import { ref, onBeforeUnmount, onMounted } from "vue";
import { useProjectStore } from "@/stores/project";
import { useContactStore } from "@/stores/contact";

const statsBarRef = ref(null);
const projectStore = useProjectStore();
const contactStore = useContactStore();
const counterTimers = [];
const statsLoaded = ref(false);
let observer = null;
const skeletonStats = 3;

const stats = ref([
  { label: "Years Experience", target: 1, current: 0, suffix: "+" },
  { label: "Projects Built", target: 0, current: 0, suffix: "+" },
  { label: "Happy Clients", target: 0, current: 0, suffix: "+" },
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

const getItemCount = (data) => {
  if (Array.isArray(data)) return data.length;
  if (Array.isArray(data?.row)) return data.row.length;
  return Number(data?.countRow?.[0]?.count) || 0;
};

const animateStats = () => {
  counterTimers.forEach(clearInterval);
  counterTimers.length = 0;

  stats.value.forEach((stat) => {
    let current = 0;
    const duration = 1500;
    const stepTime = 20;
    const increment = stat.target / (duration / stepTime);

    if (stat.target === 0) {
      stat.current = 0;
      return;
    }

    const timer = setInterval(() => {
      current += increment;

      if (current >= stat.target) {
        stat.current = stat.target;
        clearInterval(timer);
      } else {
        stat.current = Math.floor(current);
      }
    }, stepTime);

    counterTimers.push(timer);
  });
};

onMounted(async () => {
  const [projectData, contactData] = await Promise.all([
    projectStore.getProjects(),
    contactStore.getContacts(),
  ]);

  if (projectStore.error || contactStore.error) return;

  stats.value = [
    { label: "Years Experience", target: 1, current: 0, suffix: "+" },
    {
      label: "Projects Built",
      target: getItemCount(projectData),
      current: 0,
      suffix: "+",
    },
    {
      label: "Happy Clients",
      target: getItemCount(contactData),
      current: 0,
      suffix: "+",
    },
  ];
  statsLoaded.value = true;

  observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting) {
        animateStats();
        observer.disconnect();
      }
    },
    { threshold: 0.5 }
  );

  if (statsBarRef.value) observer.observe(statsBarRef.value);
});

onBeforeUnmount(() => {
  if (observer) observer.disconnect();
  counterTimers.forEach(clearInterval);
});
</script>
