<template>
    <section id="about" class="about-section">
      <div class="section-header reveal">
        <span class="section-eyebrow">01 / About</span>
        <h2 class="section-title">Who I <span class="highlight">Am</span></h2>
        <div class="section-rule"></div>
      </div>
      <div class="about-grid">
        <div class="reveal-left">
          <div class="about-text">
            <p>Hi! I'm <strong>Ei Visal</strong>, a passionate <strong>full-stack web developer</strong> based in Cambodia. I love turning ideas into reality through clean, functional, and visually stunning web applications.</p>

  <p>My journey in web development started with curiosity — building small HTML pages — and has grown into a full-on passion for both <strong>front-end</strong> and <strong>back-end</strong> development. Whether it’s crafting sleek landing pages, developing full-stack web apps with Laravel, or customizing WordPress solutions, I bring dedication, creativity, and problem-solving to every project.</p>

  <p>I believe great digital experiences are built at the intersection of <strong>good design</strong>, <strong>solid engineering</strong>, and a deep understanding of what users truly need.</p>
          </div>
        </div>
        <div class="reveal-right">
          <div class="about-cards">
            <div
              class="about-card"
              v-for="card in aboutCards"
              :key="card.label"
            >
              <div class="about-card-icon"><img :src="card.icon" alt="" /></div>
              <div>
                <div class="about-card-label">{{ card.label }}</div>
                <div class="about-card-value" v-html="card.value"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
</template>

<script setup>
const aboutCards = [
  {
    label: "Location",
    value: "Phnom Penh, Cambodia",
    icon: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/pin_plxawi.webp",
  },
  {
    label: "Role",
    value: "Full Stack Developer",
    icon: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102685/bag_joppu5.webp",
  },
  {
    label: "Education",
    value: "Norton University",
    icon: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102687/graduation_j2jvgb.webp",
  },
  {
    label: "Languages",
    value: "English &amp; Khmer",
    icon: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102687/language_ezihk0.webp",
  },
  {
    label: "Email",
    value: '<a href="mailto:mrrvisal617@gmail.com">mrrvisal617@gmail.com</a>',
    icon: "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/mail_pbdugi.webp",
  },
];
</script>