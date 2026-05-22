<template>
  <div>
    <!-- Canvas -->
    <canvas id="particles" ref="canvasRef"></canvas>

    <!-- Loader -->
    <loader></loader>

    <!-- Custom Cursor -->
    <div class="cursor" ref="cursorRef"></div>
    <div class="cursor-ring" ref="cursorRingRef"></div>

    <!-- Nav -->
    <nav id="navbar" :class="{ scrolled: navScrolled }">
      <div class="nav-progress" :style="{ width: navProgress + '%' }"></div>
      <a href="#home" class="nav-logo">Ei Visal<span>.</span></a>
      <div class="nav-links">
        <a
          v-for="link in navLinks"
          :key="link.id"
          :href="'#' + link.id"
          :class="{ active: activeSection === link.id }"
          @click.prevent="smoothScroll('#' + link.id)"
          >{{ link.label }}</a
        >
      </div>
      <div class="nav-right">
        <button class="theme-toggle" @click="toggleTheme" title="Toggle theme">
          <img :src="themeIcon" alt="Toggle theme" />
        </button>
        <a
          href="#contact"
          class="nav-cta"
          @click.prevent="smoothScroll('#contact')"
          ><span>Hire Me</span></a
        >
        <button
          class="nav-hamburger"
          :class="{ open: mobileMenuOpen }"
          @click="toggleMobileMenu"
        >
          <span></span><span></span><span></span>
        </button>
      </div>
    </nav>

    <!-- Mobile Menu -->
    <div class="mobile-menu" :class="{ open: mobileMenuOpen }">
      <a
        v-for="link in navLinks"
        :key="link.id"
        :href="'#' + link.id"
        class="mobile-link"
        @click="closeMobileMenu"
        >{{ link.label }}</a
      >
    </div>

    <!-- HERO -->
    <hero_section @navigate="handleNavigate"/>

    <!-- STATS -->
    <stats_card_section/>

    <!-- ABOUT -->
    <about_section/>

    <!-- HOBBIES -->
    <hobbies_section/>

    <!-- EDUCATION -->
    <education_section/>

    <!-- PROJECTS -->
    <project_section ref="projectRef"/>

    <!-- SKILLS -->
    <skill_section/>

    <!-- EXPERIENCE -->
    <!-- <experience_section/> -->

    <!-- CONTACT -->
    <contact_section ref="contactRef"/>

    <!-- FOOTER -->
    <footer_component/>

    <!-- Scroll to Top -->
    <button
      class="scroll-top"
      :class="{ show: showScrollTop }"
      @click="scrollToTop"
    >
      <img
        style="width: 16px"
        src="https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102685/arrow_top_qkyxpq.png"
        alt=""
      />
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import loader from "@/components/loader/Loader.vue";
import footer_component from "@/components/base/Footer.vue";
import contact_section from "@/components/layouts/Contact.vue";
// import experience_section from "@/components/layouts/Experience.vue";
import skill_section from "@/components/layouts/Skill.vue";
import project_section from "@/components/layouts/Project.vue";
import education_section from "@/components/layouts/Education.vue";
import hobbies_section from "@/components/layouts/Hobbies.vue";
import about_section from "@/components/layouts/About.vue";
import stats_card_section from "@/components/layouts/StatsCard.vue";
import hero_section from "@/components/layouts/Hero.vue";

// ── Refs ───────────────────────────────────────────────
const canvasRef = ref(null);
const cursorRef = ref(null);
const cursorRingRef = ref(null);

// ── State ──────────────────────────────────────────────
const navScrolled = ref(false);
const navProgress = ref(0);
const activeSection = ref("");
const mobileMenuOpen = ref(false);
const showScrollTop = ref(false);
const typedText = ref("");
const themeIcon = ref("");

const projectRef = ref(null);
const contactRef = ref(null);

const handleNavigate = (section) => {
  if (section === "projects") {
    projectRef.value.scrollToSection();
  }

  if (section === "contact") {
    contactRef.value.scrollToSection();
  }
};
// ── Static data ────────────────────────────────────────
const navLinks = [
  { id: "about", label: "About" },
  { id: "projects", label: "Projects" },
  { id: "skills", label: "Skills" },
  // { id: "experience", label: "Experience" },
  { id: "contact", label: "Contact" },
];

// ── Theme ──────────────────────────────────────────────
function applyTheme() {
  const html = document.documentElement;
  const saved = localStorage.getItem("theme");
  if (saved === "light") {
    html.classList.add("light");
    themeIcon.value = "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/moon_ezlfjp.png";
  } else {
    html.classList.remove("light");
    themeIcon.value = "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/sun_qitxgd.png";
    localStorage.setItem("theme", "dark");
  }
}
function toggleTheme() {
  const html = document.documentElement;
  const isLight = html.classList.toggle("light");
  themeIcon.value = isLight
    ? "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/moon_ezlfjp.png"
    : "https://res.cloudinary.com/daji2ml3y/image/upload/q_auto/f_auto/v1775102688/sun_qitxgd.png";
  localStorage.setItem("theme", isLight ? "light" : "dark");
}

// ── Particles ──────────────────────────────────────────
let animFrame = null;
function initParticles() {
  const canvas = canvasRef.value;
  const ctx = canvas.getContext("2d");
  let W, H;
  const dots = [];
  function resize() {
    W = canvas.width = innerWidth;
    H = canvas.height = innerHeight;
  }
  resize();
  window.addEventListener("resize", resize);
  for (let i = 0; i < 60; i++) {
    dots.push({
      x: Math.random() * 1920,
      y: Math.random() * 1080,
      vx: (Math.random() - 0.5) * 0.25,
      vy: (Math.random() - 0.5) * 0.25,
      r: Math.random() * 1.5 + 0.4,
    });
  }
  function draw() {
    ctx.clearRect(0, 0, W, H);
    const isLight = document.documentElement.classList.contains("light");
    const c = isLight ? "18,70,200" : "0,255,136";
    dots.forEach((d) => {
      d.x += d.vx;
      d.y += d.vy;
      if (d.x < 0) d.x = W;
      if (d.x > W) d.x = 0;
      if (d.y < 0) d.y = H;
      if (d.y > H) d.y = 0;
      ctx.beginPath();
      ctx.arc(d.x, d.y, d.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${c},.35)`;
      ctx.fill();
    });
    dots.forEach((a, i) =>
      dots.slice(i + 1).forEach((b) => {
        const dx = a.x - b.x,
          dy = a.y - b.y,
          dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < 120) {
          ctx.beginPath();
          ctx.moveTo(a.x, a.y);
          ctx.lineTo(b.x, b.y);
          ctx.strokeStyle = `rgba(${c},${(1 - dist / 120) * 0.08})`;
          ctx.stroke();
        }
      })
    );
    animFrame = requestAnimationFrame(draw);
  }
  draw();
}

// ── Scroll ─────────────────────────────────────────────
function onScroll() {
  const sy = window.scrollY;
  const dH = document.documentElement.scrollHeight - innerHeight;
  navProgress.value = dH > 0 ? (sy / dH) * 100 : 0;
  navScrolled.value = sy > 60;
  showScrollTop.value = sy > 400;
  const secs = document.querySelectorAll("section[id]");
  let cur = "";
  secs.forEach((s) => {
    if (sy >= s.offsetTop - 130) cur = s.id;
  });
  activeSection.value = cur;
}

function smoothScroll(selector) {
  const t = document.querySelector(selector);
  if (!t) return;
  const navbar = document.getElementById("navbar");
  window.scrollTo({
    top: t.getBoundingClientRect().top + scrollY - navbar.offsetHeight - 8,
    behavior: "smooth",
  });
  closeMobileMenu();
}

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: "smooth" });
}

// ── Mobile menu ────────────────────────────────────────
function toggleMobileMenu() {
  mobileMenuOpen.value = !mobileMenuOpen.value;
  document.body.style.overflow = mobileMenuOpen.value ? "hidden" : "";
}
function closeMobileMenu() {
  mobileMenuOpen.value = false;
  document.body.style.overflow = "";
}

// ── Custom cursor ──────────────────────────────────────
let mx = 0,
  my = 0,
  rx = 0,
  ry = 0,
  cursorAnimFrame = null;
function initCursor() {
  const cur = cursorRef.value;
  const ring = cursorRingRef.value;
  document.addEventListener("mousemove", (e) => {
    mx = e.clientX;
    my = e.clientY;
    cur.style.left = mx - 4 + "px";
    cur.style.top = my - 4 + "px";
  });
  (function loop() {
    rx += (mx - rx) * 0.12;
    ry += (my - ry) * 0.12;
    ring.style.left = rx - 18 + "px";
    ring.style.top = ry - 18 + "px";
    cursorAnimFrame = requestAnimationFrame(loop);
  })();
  document
    .querySelectorAll("a,button,.proj,.hobby-card,.edu-card,.testi-card")
    .forEach((el) => {
      el.addEventListener("mouseenter", () => {
        cur.classList.add("hovering");
        ring.classList.add("hovering");
      });
      el.addEventListener("mouseleave", () => {
        cur.classList.remove("hovering");
        ring.classList.remove("hovering");
      });
    });
}

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
      typeTimer = setTimeout(type, 1800);
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

// ── Skill bars ─────────────────────────────────────────
function initSkillBars() {
  const obs = new IntersectionObserver(
    (entries) =>
      entries.forEach((e) => {
        if (e.isIntersecting) e.target.classList.add("go");
      }),
    { threshold: 0.3 }
  );
  document.querySelectorAll(".skill-fill").forEach((f) => obs.observe(f));
}

// ── Timeline ───────────────────────────────────────────
function initTimeline() {
  const obs = new IntersectionObserver(
    (entries) =>
      entries.forEach((e, i) => {
        if (e.isIntersecting)
          setTimeout(() => e.target.classList.add("go"), i * 120);
      }),
    { threshold: 0.15 }
  );
  document.querySelectorAll(".tl-item").forEach((i) => obs.observe(i));
}

// ── Scroll reveal ──────────────────────────────────────
function initReveal() {
  const obs = new IntersectionObserver(
    (entries) =>
      entries.forEach((e) => {
        if (e.isIntersecting)
          setTimeout(() => e.target.classList.add("go"), 80);
      }),
    { threshold: 0.07 }
  );
  document
    .querySelectorAll(".reveal,.reveal-left,.reveal-right")
    .forEach((el) => obs.observe(el));
}

// ── Lifecycle ──────────────────────────────────────────
onMounted(() => {
  applyTheme();

  // Typed
  setTimeout(type, 1800);

  // Particles
  initParticles();

  // Cursor
  initCursor();

  // Scroll listeners
  window.addEventListener("scroll", onScroll);

  // Observers
  initSkillBars();
  initTimeline();
  initReveal();
});

onUnmounted(() => {
  window.removeEventListener("scroll", onScroll);
  if (animFrame) cancelAnimationFrame(animFrame);
  if (cursorAnimFrame) cancelAnimationFrame(cursorAnimFrame);
  if (typeTimer) clearTimeout(typeTimer);
});
</script>
