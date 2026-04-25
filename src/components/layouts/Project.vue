<template>
  <section id="projects" ref="sectionRef" style="padding-top: 0">
    <div class="section-header reveal">
      <span class="section-eyebrow">04 / Work</span>
      <h2 class="section-title">
        Selected <span class="highlight">Projects</span>
      </h2>
      <div class="section-rule"></div>
    </div>

    <!-- Swiper carousel with dynamic projects -->
    <Swiper
      v-if="projects.length"
      :modules="modules"
      :slides-per-view="3"
      :space-between="24"
      :pagination="{ clickable: true }"
      :breakpoints="{
        0: { slidesPerView: 1 },
        768: { slidesPerView: 2 },
        1200: { slidesPerView: 3 },
      }"
    >
      <SwiperSlide
        v-for="project in projects"
        :key="project.id"
        @mousemove="(e) => onProjectMouseMove(e, project)"
      >
        <div class="proj">
          <template v-if="loading">
            <!-- Skeleton loader -->
            <div class="proj-cat skeleton"></div>
            <div class="proj-visual" style="height: 200px">
              <div class="proj-visual-label skeleton"></div>
            </div>
            <h3 class="proj-title skeleton"></h3>
            <p class="proj-desc skeleton"></p>
            <div class="proj-stack">
              <span v-for="n in 3" :key="n" class="proj-tag skeleton"></span>
            </div>
            <div class="proj-link skeleton"></div>
          </template>

          <template v-else>
            <!-- Real project card -->
            <div class="proj-cat">{{ project.category }}</div>
            <div class="proj-visual">
              <a :href="project.link_project" target="_blank" class="proj-link">
                <img
                  class="thumbnail"
                  :src="project.thumbnail"
                  :alt="project.title"
                />
              </a>
            </div>
            <h3 class="proj-title">{{ project.title }}</h3>
            <p class="proj-desc">{{ project.description }}</p>
            <div class="proj-stack">
              <span v-for="tag in project.tags" :key="tag" class="proj-tag">{{
                tag
              }}</span>
            </div>
            <a :href="project.link_project" target="_blank" class="proj-link">
              {{ project.link_label }}
            </a>
          </template>
        </div>
      </SwiperSlide>
    </Swiper>
  </section>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useProjectStore } from "@/stores/project";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";
import "swiper/css/pagination";
import { Pagination } from "swiper/modules";

const modules = [Pagination];
const projectStore = useProjectStore();

const projects = ref([]);
const loading = ref(true);

const sectionRef = ref(null);

function onProjectMouseMove(e, project) {
  const card = e.currentTarget;
  const r = card.getBoundingClientRect();
  card.style.setProperty("--mx", ((e.clientX - r.left) / r.width) * 100 + "%");
  card.style.setProperty("--my", ((e.clientY - r.top) / r.height) * 100 + "%");
}

const scrollToSection = () => {
  sectionRef.value.scrollIntoView({ behavior: "smooth" });
};

// Fetch projects from Pinia store
onMounted(async () => {
  try {
    loading.value = true;
    const data = await projectStore.getProjects();
    if (data) projects.value = data.row;
  } catch (error) {
    console.error("Failed to load projects:", error);
  } finally {
    loading.value = false;
  }
});

defineExpose({ scrollToSection });
</script>