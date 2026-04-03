<template>
    <section id="experience">
      <div class="section-header reveal">
        <span class="section-eyebrow">06 / Career</span>
        <h2 class="section-title">
          My <span class="highlight">Experience</span>
        </h2>
        <div class="section-rule"></div>
      </div>
      <div class="timeline reveal">
        <div
          class="tl-item"
          v-for="exp in experiences"
          :key="exp.role"
          ref="tlItemRefs"
        >
          <div class="tl-dot"></div>
          <div class="tl-date">{{ exp.date }}</div>
          <div class="tl-role">{{ exp.role }}</div>
          <div class="tl-company">{{ exp.company }}</div>
          <div class="tl-desc">{{ exp.desc }}</div>
        </div>
      </div>
    </section>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from "vue";
const tlItemRefs = ref([]);
const experiences = [
  {
    date: "2024 — Present",
    role: "Junior Web Developer",
    company: "Tech Company — Phnom Penh, Cambodia",
    desc: "Building and maintaining client websites using Laravel and React. Collaborating with designers to implement pixel-perfect UIs. Improved site performance by 40% through code optimization and asset compression.",
  },
  {
    date: "2023 — 2024",
    role: "Freelance Web Developer",
    company: "Self-employed — Remote",
    desc: "Delivered 15+ websites for local businesses, NGOs, and startups across Cambodia. Specialized in WordPress customization, landing pages, and small business e-commerce stores.",
  },
  {
    date: "2022 — 2023",
    role: "Web Development Intern",
    company: "Digital Agency — Phnom Penh",
    desc: "Assisted senior developers in building client projects. Learned professional workflows, version control with Git, and how to work effectively in an agile team environment.",
  },
];
</script>