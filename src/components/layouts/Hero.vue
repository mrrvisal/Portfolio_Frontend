<template>
    <section class="hero" id="home">
      <div class="hero-bg-glow"></div>
      <div class="hero-grid-lines"></div>
      <div class="hero-left">
        <div class="hero-eyebrow">
          <div class="hero-eyebrow-dot"></div>
          <span class="hero-eyebrow-text">Open to opportunities</span>
          <div class="hero-eyebrow-line"></div>
        </div>
        <h1 class="hero-heading">
          Ei<br />
          <span class="name-accent" data-text="Visal.">Visal.</span>
        </h1>
        <div class="hero-role-line">
          <span class="hero-role-text">Web Developer</span>
          <span class="hero-role-badge">Cambodia 🇰🇭</span>
        </div>
        <div class="hero-typed-wrap">
          I build <span class="hero-typed">{{ typedText }}</span
          ><span class="hero-typed-cursor"></span>
        </div>
        <p class="hero-desc">
          Crafting beautiful, responsive websites that users love. Passionate
          about clean code, pixel-perfect design, and delivering real value
          through the web.
        </p>
        <div class="hero-cta">
          <a
            href="#projects"
            class="btn-primary"
            @click.prevent="$emit('navigate','projects')"
            ><span>See My Work →</span></a
          >
          <a
            href="#contact"
            class="btn-outline"
            @click.prevent="$emit('navigate','contact')"
            ><span>Get in touch</span></a
          >
        </div>
      </div>
      <div class="hero-right">
        <div class="hex-scene">
          <div class="hex-glow"></div>
          <svg
            class="hex-ring-svg"
            viewBox="0 0 300 300"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <polygon
              points="150,8 292,79 292,221 150,292 8,221 8,79"
              stroke="rgba(0,255,136,0.15)"
              stroke-width="1"
              fill="none"
              stroke-dasharray="6 4"
            />
          </svg>
          <svg
            class="hex-ring-svg-r"
            viewBox="0 0 330 330"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <polygon
              points="165,6 324,87 324,243 165,324 6,243 6,87"
              stroke="rgba(123,97,255,0.12)"
              stroke-width="1"
              fill="none"
            />
          </svg>
          <div class="hex-border"></div>
          <div class="hex-border-inner"></div>
          <div class="hex-photo-wrap" @click="triggerPhotoUpload">
            <div class="hex-placeholder" ref="photoElRef">
              <img src="https://res.cloudinary.com/daji2ml3y/image/upload/v1774676429/2026-03-28_12.38.31_cpfmyd.jpg" alt="">
            </div>
          </div>

          <!-- Floating Badges -->
          <div class="hf hf-1">
            <div class="hf-dot"></div>
            <div>
              <span class="hf-label">Status</span
              ><span class="hf-value">Open to Work</span>
            </div>
          </div>
          <div class="hf hf-2">
            <span style="width: 20px; height: 20px"
              ><img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/rocket_ovilx1.svg" alt=""
            /></span>
            <div>
              <span class="hf-label">Projects</span
              ><span class="hf-value">10+ Built</span>
            </div>
          </div>
          <div class="hf hf-3">
            <span style="width: 30px; height: 30px"
              ><img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/map_ncrmiq.png" alt=""
            /></span>
            <div>
              <span class="hf-label">Based in</span
              ><span class="hf-value">Cambodia 🇰🇭</span>
            </div>
          </div>
          <div class="hf hf-4">
            <span style="width: 20px; height: 20px"
              ><img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775103203/briefcase_co46kl.png" alt=""
            /></span>
            <div>
              <span class="hf-label">Experience</span
              ><span class="hf-value">1+ Years</span>
            </div>
          </div>

          <!-- Floating Skill Icons -->
          <div class="hf-icon-pill hi-1" title="HTML">
            <img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102686/html-logo_yqiqdl.png" alt="" />
          </div>
          <div class="hf-icon-pill hi-2" title="CSS">
            <img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102686/css-logo_wdk5oc.png" alt="CSS" />
          </div>
          <div class="hf-icon-pill hi-3" title="JavaScript">
            <img
              src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102687/javascript-logo_afnds4.png"
              alt="JavaScript"
            />
          </div>
          <div class="hf-icon-pill hi-4" title="Vue.js">
            <img src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102689/vuejs_xoyudk.png" alt="Vue.js" />
          </div>
        </div>
      </div>
      <div class="hero-scroll-hint">
        <div class="hero-scroll-line"></div>
        scroll
      </div>
    </section>
</template>
<script setup>
import { ref, onMounted, onUnmounted } from "vue";
const typedText = ref("");
const photoElRef = ref(null);

// ── Typed text ─────────────────────────────────────────
const phrases = [
  "beautiful websites.",
  "clean code.",
  "great UX.",
  "fast pages.",
];
let pi = 0,
  ci = 0,
  del = false,
  typeTimer = null;
function type() {
  const phrase = phrases[pi];
  if (!del) {
    typedText.value = phrase.slice(0, ++ci);
    if (ci === phrase.length) {
      del = true;
      typeTimer = setTimeout(type, 2000);
      return;
    }
  } else {
    typedText.value = phrase.slice(0, --ci);
    if (ci === 0) {
      del = false;
      pi = (pi + 1) % phrases.length;
    }
  }
  typeTimer = setTimeout(type, del ? 40 : 75);
}
// START typing
onMounted(() => {
  type();
});

// CLEANUP (important)
onUnmounted(() => {
  clearTimeout(typeTimer);
});
</script>