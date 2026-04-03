<template>
    <section id="skills" class="skills-section">
      <div class="section-header reveal">
        <span class="section-eyebrow">05 / Skills</span>
        <h2 class="section-title">
          My <span class="highlight">Expertise</span>
        </h2>
        <div class="section-rule"></div>
      </div>
      <div class="skills-layout reveal">
        <div class="skill-group" v-for="group in skillGroups" :key="group.head">
          <div class="skill-group-head">{{ group.head }} <span>///</span></div>
          <div
            class="skill-row"
            v-for="skill in group.skills"
            :key="skill.name"
          >
            <div class="skill-row-top">
              <span class="skill-name">{{ skill.name }}</span>
              <span class="skill-pct">{{ skill.pct }}%</span>
            </div>
            <div class="skill-track">
              <div
                class="skill-fill"
                :style="{ '--w': skill.pct + '%' }"
                ref="skillFillRefs"
              ></div>
            </div>
          </div>
        </div>
      </div>
      <div class="tools-row reveal">
        <div class="tools-head">Tools &amp; Environment <span>///</span></div>
        <div class="tools-pills">
          <span class="tool-pill" v-for="tool in tools" :key="tool">{{
            tool
          }}</span>
        </div>
      </div>
    </section>
</template>

<script setup>
import { ref } from "vue";
const skillFillRefs = ref([]);
const skillGroups = [
  {
    head: "Frontend",
    skills: [
      { name: "HTML / CSS", pct: 95 },
      { name: "JavaScript", pct: 85 },
      { name: "Vue.js", pct: 78 },
      { name: "Bootstrap", pct: 88 },
      { name: "Responsive Design", pct: 93 },
    ],
  },
  {
    head: "Backend",
    skills: [
      { name: "Node.js", pct: 78 },
      { name: "Express.js", pct: 85 },
      { name: "MySQL", pct: 75 },
    ],
  },
  {
    head: "CMS & Design",
    skills: [
      { name: "Figma", pct: 72 },
      { name: "Git / GitHub", pct: 80 },
    ],
  },
];
const tools = [
  "Chrome DevTools",
  "Figma",
  "Git",
  "GitHub",
  "Postman",
  "VS Code",
  "Vercel",
  "XAMPP",
  "npm",
];
</script>