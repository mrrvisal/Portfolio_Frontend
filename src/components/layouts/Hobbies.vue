<template>
    <section id="hobbies">
      <div class="section-header reveal">
        <span class="section-eyebrow">02 / Interests</span>
        <h2 class="section-title">
          What I <span class="highlight">Love</span>
        </h2>
        <div class="section-rule"></div>
      </div>
      <div class="hobbies-grid reveal">
        <div class="hobby-card" v-for="hobby in hobbies" :key="hobby.title">
          <span class="hobby-icon"
            ><img :style="{ height: hobby.imgHeight }" :src="hobby.img" alt=""
          /></span>
          <div class="hobby-title">{{ hobby.title }}</div>
          <div class="hobby-desc">{{ hobby.desc }}</div>
        </div>
      </div>
    </section>
</template>

<script setup>
const hobbies = [
  {
    title: "Coding",
    desc: "Building side projects and exploring new frameworks. Coding is both my job and my hobby.",
    img: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102686/icon_on_top_r23wyu.webp",
    imgHeight: "100px",
  },
  {
    title: "Gaming",
    desc: "Strategy and RPG games sharpen analytical thinking. Great games inspire great UX design.",
    img: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102686/game-controller_arvhqm.png",
    imgHeight: "90px",
  },
  {
    title: "Research",
    desc: "Always learning. I read tech blogs, watch tutorials, and stay curious about the latest web trends.",
    img: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102687/magnifying-glass_wbk1e3.png",
    imgHeight: "90px",
  },
  {
    title: "Nature",
    desc: "Hiking, beach trips, and exploring Cambodia's beautiful landscapes. Nature fuels creativity.",
    img: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/nature_apiod9.webp",
    imgHeight: "110px",
  },
];
</script>