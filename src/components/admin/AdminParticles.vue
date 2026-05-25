<template>
  <canvas id="particles" ref="canvasRef"></canvas>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";

const canvasRef = ref(null);
let animFrame = null;
let particleResizeHandler = null;

function initParticles() {
  const canvas = canvasRef.value;
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  let W, H;
  const dots = [];

  particleResizeHandler = () => { W = canvas.width = innerWidth; H = canvas.height = innerHeight; };
  particleResizeHandler();
  window.addEventListener("resize", particleResizeHandler);

  for (let i = 0; i < 60; i++) {
    dots.push({
      x: Math.random() * 1920, y: Math.random() * 1080,
      vx: (Math.random() - 0.5) * 0.25, vy: (Math.random() - 0.5) * 0.25,
      r: Math.random() * 1.5 + 0.4,
    });
  }

  const draw = () => {
    ctx.clearRect(0, 0, W, H);
    const isLight = document.documentElement.classList.contains("light");
    const c = isLight ? "18,70,200" : "0,255,136";
    dots.forEach((d) => {
      d.x += d.vx; d.y += d.vy;
      if (d.x < 0) d.x = W; if (d.x > W) d.x = 0;
      if (d.y < 0) d.y = H; if (d.y > H) d.y = 0;
      ctx.beginPath(); ctx.arc(d.x, d.y, d.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${c},.35)`; ctx.fill();
    });
    dots.forEach((a, i) =>
      dots.slice(i + 1).forEach((b) => {
        const dx = a.x - b.x, dy = a.y - b.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < 120) {
          ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y);
          ctx.strokeStyle = `rgba(${c},${(1 - dist / 120) * 0.08})`; ctx.stroke();
        }
      })
    );
    animFrame = requestAnimationFrame(draw);
  };
  draw();
}

onMounted(() => initParticles());
onBeforeUnmount(() => {
  cancelAnimationFrame(animFrame);
  if (particleResizeHandler) window.removeEventListener("resize", particleResizeHandler);
});
</script>
