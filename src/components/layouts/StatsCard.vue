<template>
  <div>

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
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from "vue";
import { useProjectStore } from "@/stores/project";
import { useContactStore } from "@/stores/contact";
const statsBarRef = ref(null);
const projectStore = useProjectStore();
const projects = ref(0);
const contactStore = useContactStore();
const contacts = ref(0);
const stats = ref([]);

onMounted(async () => {
  const data = await projectStore.getProjects();
  const contactData = await contactStore.getContacts();

  projects.value = data?.countRow?.[0]?.count || 0;
  contacts.value = contactData?.countRow?.[0]?.count || 0;

  stats.value = [
    { label: "Years Experience", target: 1, current: 0, suffix: "+" },
    { label: "Projects Built", target: projects.value, current: 0, suffix: "+" },
    { label: "Happy Clients", target: contacts.value, current: 0, suffix: "+" },
  ];

  const observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting) {
        animateStats();
        observer.disconnect();
      }
    },
    { threshold: 0.5 }
  );

  if (statsBarRef.value) {
    observer.observe(statsBarRef.value);
  }
});

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
  const animateStats = () => {
    stats.value.forEach((stat) => {
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
  // Fetch projects from Pinia store
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
</script>