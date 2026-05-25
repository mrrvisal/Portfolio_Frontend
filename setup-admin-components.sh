#!/bin/bash

# Creates src/components/admin/ and writes all 10 Admin component files
# Run from your project root: Portfolio_Frontend/

set -e
mkdir -p src/components/admin
echo "📁 Created src/components/admin/"

# ─────────────────────────────────────────
# 1. AdminParticles.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminParticles.vue << 'EOF'
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
EOF

# ─────────────────────────────────────────
# 2. AdminLogin.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminLogin.vue << 'EOF'
<template>
  <div class="adm-login-wrap">
    <div class="adm-login-bg-glow"></div>
    <div class="adm-login-grid-lines"></div>
    <div class="adm-login-card">
      <div class="adm-login-eyebrow">
        <span class="adm-eyebrow-dot"></span>
        <span class="adm-eyebrow-text">SYSTEM ACCESS</span>
        <span class="adm-eyebrow-line"></span>
      </div>
      <div class="adm-login-icon"><i class="bi bi-shield-lock-fill"></i></div>
      <h1 class="adm-login-title">ADMIN<span class="adm-accent">.</span>PANEL</h1>
      <p class="adm-login-sub">Authenticate to manage</p>
      <form @submit.prevent="onSubmit" class="adm-login-form">
        <div class="adm-fg">
          <label class="adm-fl">EMAIL ADDRESS</label>
          <input class="adm-fi" v-model="email" type="email" placeholder="Your email address" required />
        </div>
        <div class="adm-fg">
          <label class="adm-fl">PASSWORD</label>
          <div class="adm-password-wrap">
            <input
              class="adm-fi adm-password-input"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Your password"
              required
            />
            <button
              type="button"
              class="adm-password-toggle"
              :title="showPassword ? 'Hide password' : 'Show password'"
              @click="showPassword = !showPassword"
            >
              <i :class="`bi ${showPassword ? 'bi-eye-slash' : 'bi-eye'}`"></i>
            </button>
          </div>
        </div>
        <p class="adm-error-msg" v-if="errorMessage">
          <i class="bi bi-exclamation-triangle"></i> {{ errorMessage }}
        </p>
        <button type="submit" class="adm-btn-primary adm-w-full" :disabled="loading">
          <span>{{ loading ? "AUTHENTICATING…" : "SIGN IN" }}</span>
          <i class="bi bi-arrow-right"></i>
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

defineProps({
  loading: { type: Boolean, default: false },
  errorMessage: { type: String, default: "" },
});

const emit = defineEmits(["submit"]);
const email = ref("");
const password = ref("");
const showPassword = ref(false);

const onSubmit = () => emit("submit", { email: email.value, password: password.value });
</script>
EOF

# ─────────────────────────────────────────
# 3. AdminSidebar.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminSidebar.vue << 'EOF'
<template>
  <div class="adm-sidebar">
    <div class="adm-sidebar-brand">
      <span class="adm-brand-dot"></span>
      <span class="adm-brand-text">ADMIN<span class="adm-brand-accent">.</span></span>
      <button
        class="adm-sidebar-menu-btn"
        type="button"
        :aria-expanded="sidebarOpen"
        :aria-label="sidebarOpen ? 'Close menu' : 'Open menu'"
        @click="sidebarOpen = !sidebarOpen"
      >
        <i :class="`bi ${sidebarOpen ? 'bi-x-lg' : 'bi-list'}`"></i>
      </button>
    </div>
    <div class="adm-sidebar-section-label">NAVIGATION</div>
    <div class="adm-sidebar-nav" :class="{ open: sidebarOpen }">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        class="adm-nav-item"
        :class="{ active: activeTab === tab.id }"
        @click="selectTab(tab.id)"
      >
        <i :class="`bi ${tab.icon}`"></i>
        <span>{{ tab.label }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'projects'">{{ projectCount }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'education'">{{ educationCount }}</span>
        <span class="adm-nav-badge" v-if="tab.id === 'contacts'">{{ contactCount }}</span>
      </button>
    </div>
    <div class="adm-sidebar-footer" :class="{ open: sidebarOpen }">
      <div class="adm-sidebar-status">
        <span class="adm-status-dot"></span>
        <span class="adm-status-text">CONNECTED</span>
      </div>
      <button
        class="adm-theme-toggle-btn"
        @click="emit('toggle-theme')"
        :title="isLightTheme ? 'Switch to dark mode' : 'Switch to light mode'"
      >
        <i :class="`bi ${isLightTheme ? 'bi-moon-fill' : 'bi-sun-fill'}`"></i>
        <span>{{ isLightTheme ? "Dark" : "Light" }}</span>
      </button>
      <button class="adm-logout-btn" @click="emit('sign-out')">
        <i class="bi bi-box-arrow-left"></i>
        <span>SIGN OUT</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

defineProps({
  activeTab: { type: String, required: true },
  isLightTheme: { type: Boolean, default: false },
  projectCount: { type: Number, default: 0 },
  educationCount: { type: Number, default: 0 },
  contactCount: { type: Number, default: 0 },
});

const emit = defineEmits(["update:activeTab", "toggle-theme", "sign-out"]);
const sidebarOpen = ref(false);

const tabs = [
  { id: "projects", label: "Projects", icon: "bi-code-slash" },
  { id: "education", label: "Education", icon: "bi-mortarboard-fill" },
  { id: "contacts", label: "Contacts", icon: "bi-envelope-fill" },
];

const selectTab = (tabId) => {
  emit("update:activeTab", tabId);
  sidebarOpen.value = false;
};
</script>
EOF

# ─────────────────────────────────────────
# 4. AdminStats.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminStats.vue << 'EOF'
<template>
  <div class="adm-stats-row">
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-code-slash"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ projectCount }}</div>
        <div class="adm-stat-label">PROJECTS</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-mortarboard-fill"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ educationCount }}</div>
        <div class="adm-stat-label">EDUCATION</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
    <div class="adm-stat-card">
      <div class="adm-stat-icon-wrap"><i class="bi bi-envelope-fill"></i></div>
      <div class="adm-stat-body">
        <div class="adm-stat-value">{{ contactCount }}</div>
        <div class="adm-stat-label">MESSAGES</div>
      </div>
      <div class="adm-stat-line"></div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  projectCount: { type: Number, default: 0 },
  educationCount: { type: Number, default: 0 },
  contactCount: { type: Number, default: 0 },
});
</script>
EOF

# ─────────────────────────────────────────
# 5. AdminDetailModal.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminDetailModal.vue << 'EOF'
<template>
  <teleport to="body">
    <div class="adm-modal-overlay" v-if="show" @click.self="emit('close')">
      <div class="adm-modal-card adm-detail-modal-card">
        <div class="adm-modal-header">
          <div>
            <div class="adm-modal-eyebrow">{{ type }} DETAIL</div>
            <h3>{{ title }}</h3>
          </div>
          <button class="adm-modal-close" @click="emit('close')">
            <i class="bi bi-x-lg"></i>
          </button>
        </div>
        <div class="adm-detail-list">
          <div class="adm-detail-item" v-for="field in fields" :key="field.label">
            <div class="adm-detail-label">{{ field.label }}</div>
            <a v-if="field.href" :href="field.href" target="_blank" class="adm-detail-value adm-detail-link">
              {{ field.value }}
            </a>
            <div v-else class="adm-detail-value">{{ field.value }}</div>
          </div>
        </div>
        <div class="adm-modal-actions">
          <button type="button" class="adm-btn-outline" @click="emit('close')">
            <span>CLOSE</span>
          </button>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
defineProps({
  show: { type: Boolean, default: false },
  type: { type: String, default: "" },
  title: { type: String, default: "Detail" },
  fields: { type: Array, default: () => [] },
});
const emit = defineEmits(["close"]);
</script>
EOF

# ─────────────────────────────────────────
# 6. AdminConfirmModal.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminConfirmModal.vue << 'EOF'
<template>
  <teleport to="body">
    <div class="adm-modal-overlay" v-if="show" @click.self="onClose">
      <div class="adm-modal-card adm-confirm-modal-card">
        <div class="adm-modal-header">
          <div>
            <div class="adm-modal-eyebrow">{{ eyebrow }}</div>
            <h3>{{ title }}</h3>
          </div>
          <button class="adm-modal-close" @click="onClose">
            <i class="bi bi-x-lg"></i>
          </button>
        </div>
        <p class="adm-confirm-message">{{ message }}</p>
        <div class="adm-modal-actions">
          <button type="button" class="adm-btn-outline" :disabled="loading" @click="onClose">
            <span>CANCEL</span>
          </button>
          <button type="button" class="adm-btn-primary adm-btn-danger" :disabled="loading" @click="emit('confirm')">
            <span>{{ loading ? "WORKING..." : confirmLabel }}</span>
          </button>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script setup>
const props = defineProps({
  show: { type: Boolean, default: false },
  eyebrow: { type: String, default: "CONFIRM" },
  title: { type: String, default: "" },
  message: { type: String, default: "" },
  confirmLabel: { type: String, default: "CONFIRM" },
  loading: { type: Boolean, default: false },
});
const emit = defineEmits(["close", "confirm"]);
const onClose = () => { if (props.loading) return; emit("close"); };
</script>
EOF

# ─────────────────────────────────────────
# 7. AdminProjectsTab.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminProjectsTab.vue << 'EOF'
<template>
  <div class="adm-tab-section">
    <div class="adm-section-header">
      <div class="adm-section-title-wrap">
        <span class="adm-section-eyebrow">MANAGE</span>
        <h2 class="adm-section-title">Projects</h2>
        <p class="adm-section-sub">Create and manage your portfolio projects.</p>
      </div>
      <button class="adm-btn-primary" @click="openModal(null)">
        <span><i class="bi bi-plus-lg"></i> NEW PROJECT</span>
      </button>
    </div>
    <div class="adm-search-row">
      <div class="adm-search-wrap">
        <i class="bi bi-search"></i>
        <input v-model="search" placeholder="Search projects…" />
      </div>
    </div>
    <div class="adm-table-wrap">
      <table>
        <colgroup>
          <col style="width: 36px" /><col style="width: 22%" /><col style="width: 30%" />
          <col /><col style="width: 60px" /><col style="width: 88px" />
        </colgroup>
        <thead>
          <tr><th>#</th><th>TITLE</th><th>DESCRIPTION</th><th>TAGS</th><th>LINK</th><th>ACTIONS</th></tr>
        </thead>
        <tbody>
          <template v-if="loading">
            <tr v-for="i in 5" :key="`ps-${i}`" class="adm-skeleton-row">
              <td><span class="adm-skeleton adm-skeleton-id"></span></td>
              <td><span class="adm-skeleton adm-skeleton-title"></span></td>
              <td><span class="adm-skeleton adm-skeleton-text"></span></td>
              <td><span class="adm-skeleton adm-skeleton-tag"></span><span class="adm-skeleton adm-skeleton-tag short"></span></td>
              <td><span class="adm-skeleton adm-skeleton-icon"></span></td>
              <td><span class="adm-skeleton adm-skeleton-actions"></span></td>
            </tr>
          </template>
          <tr v-else-if="filtered.length === 0">
            <td colspan="6" class="adm-empty-cell"><i class="bi bi-inbox"></i><span>No projects yet.</span></td>
          </tr>
          <template v-else>
            <tr v-for="p in filtered" :key="p.id" class="adm-clickable-row" @click="emit('view-detail', p)">
              <td class="adm-id-cell">{{ p.id }}</td>
              <td class="adm-title-cell">{{ p.title }}</td>
              <td class="adm-desc-cell">{{ truncate(p.description, 80) }}</td>
              <td><span class="adm-tag" v-for="t in parseTags(p.tags)" :key="t">{{ t }}</span></td>
              <td>
                <a v-if="p.link_project" :href="p.link_project" target="_blank" class="adm-link-icon" @click.stop>
                  <i class="bi bi-box-arrow-up-right"></i>
                </a>
                <span v-else class="adm-muted">—</span>
              </td>
              <td>
                <div class="adm-action-btns">
                  <button class="adm-btn-icon" title="Edit" @click.stop="openModal(p)"><i class="bi bi-pencil"></i></button>
                  <button class="adm-btn-icon adm-btn-icon-danger" title="Delete" @click.stop="emit('delete', p)"><i class="bi bi-trash3"></i></button>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>

    <teleport to="body">
      <div class="adm-modal-overlay" v-if="modalShow" @click.self="modalShow = false">
        <div class="adm-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">{{ modalId ? 'EDIT' : 'CREATE' }}</div>
              <h3>{{ modalId ? 'Edit project' : 'New project' }}</h3>
            </div>
            <button class="adm-modal-close" @click="modalShow = false"><i class="bi bi-x-lg"></i></button>
          </div>
          <form @submit.prevent="submitForm">
            <div class="adm-fg">
              <label class="adm-fl">TITLE <span class="adm-req">*</span></label>
              <input class="adm-fi" v-model="form.title" type="text" required />
            </div>
            <div class="adm-fg">
              <label class="adm-fl">DESCRIPTION <span class="adm-req">*</span></label>
              <textarea class="adm-fi" v-model="form.description" rows="3" required></textarea>
            </div>
            <div class="adm-fg">
              <label class="adm-fl">TAGS <span class="adm-fl-hint">(comma-separated)</span></label>
              <input class="adm-fi" v-model="form.tags" type="text" placeholder="Vue, Node.js, MySQL" />
            </div>
            <div class="adm-form-row">
              <div class="adm-fg">
                <label class="adm-fl">LINK URL</label>
                <input class="adm-fi" v-model="form.link_project" type="url" placeholder="https://…" />
              </div>
              <div class="adm-fg">
                <label class="adm-fl">LINK LABEL</label>
                <input class="adm-fi" v-model="form.link_label" type="text" placeholder="View project" />
              </div>
            </div>
            <div class="adm-modal-actions">
              <button type="button" class="adm-btn-outline" @click="modalShow = false"><span>CANCEL</span></button>
              <button type="submit" class="adm-btn-primary" :disabled="saving">
                <span>{{ saving ? 'SAVING…' : modalId ? 'UPDATE' : 'CREATE' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";

const props = defineProps({
  projects: { type: Array, default: () => [] },
  loading: { type: Boolean, default: false },
  saving: { type: Boolean, default: false },
});
const emit = defineEmits(["submit", "delete", "view-detail"]);

const search = ref("");
const filtered = computed(() => {
  const q = search.value.toLowerCase();
  if (!q) return props.projects;
  return props.projects.filter(
    (p) => p.title?.toLowerCase().includes(q) || parseTags(p.tags).some((t) => t.toLowerCase().includes(q))
  );
});

const modalShow = ref(false);
const modalId = ref(null);
const form = ref({ title: "", description: "", tags: "", link_project: "", link_label: "" });

const openModal = (p) => {
  if (p) { form.value = { ...p, tags: parseTags(p.tags).join(", ") }; modalId.value = p.id; }
  else { form.value = { title: "", description: "", tags: "", link_project: "", link_label: "" }; modalId.value = null; }
  modalShow.value = true;
};
const submitForm = () => { emit("submit", { form: { ...form.value }, id: modalId.value }); modalShow.value = false; };
defineExpose({ closeModal: () => (modalShow.value = false) });

const truncate = (str, len) => str && str.length > len ? str.slice(0, len) + "…" : str || "";
const parseTags = (tags) => {
  if (!tags) return [];
  if (Array.isArray(tags)) return tags;
  return tags.split(",").map((t) => t.trim()).filter(Boolean);
};
</script>
EOF

# ─────────────────────────────────────────
# 8. AdminEducationTab.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminEducationTab.vue << 'EOF'
<template>
  <div class="adm-tab-section">
    <div class="adm-section-header">
      <div class="adm-section-title-wrap">
        <span class="adm-section-eyebrow">MANAGE</span>
        <h2 class="adm-section-title">Education</h2>
        <p class="adm-section-sub">Add your education history and certifications.</p>
      </div>
      <button class="adm-btn-primary" @click="openModal(null)">
        <span><i class="bi bi-plus-lg"></i> NEW ENTRY</span>
      </button>
    </div>
    <div class="adm-table-wrap">
      <table>
        <colgroup>
          <col style="width: 36px" /><col style="width: 90px" /><col style="width: 25%" />
          <col style="width: 25%" /><col /><col style="width: 88px" />
        </colgroup>
        <thead>
          <tr><th>#</th><th>YEAR</th><th>DEGREE</th><th>SCHOOL</th><th>DESCRIPTION</th><th>ACTIONS</th></tr>
        </thead>
        <tbody>
          <template v-if="loading">
            <tr v-for="i in 4" :key="`es-${i}`" class="adm-skeleton-row">
              <td><span class="adm-skeleton adm-skeleton-id"></span></td>
              <td><span class="adm-skeleton adm-skeleton-badge"></span></td>
              <td><span class="adm-skeleton adm-skeleton-title"></span></td>
              <td><span class="adm-skeleton adm-skeleton-title short"></span></td>
              <td><span class="adm-skeleton adm-skeleton-text"></span></td>
              <td><span class="adm-skeleton adm-skeleton-actions"></span></td>
            </tr>
          </template>
          <tr v-else-if="educations.length === 0">
            <td colspan="6" class="adm-empty-cell"><i class="bi bi-inbox"></i><span>No education entries yet.</span></td>
          </tr>
          <template v-else>
            <tr v-for="e in educations" :key="e.id" class="adm-clickable-row" @click="emit('view-detail', e)">
              <td class="adm-id-cell">{{ e.id }}</td>
              <td><span class="adm-year-badge">{{ e.year }}</span></td>
              <td class="adm-title-cell">{{ e.degree }}</td>
              <td>{{ e.school }}</td>
              <td class="adm-desc-cell">{{ truncate(e.description, 80) }}</td>
              <td>
                <div class="adm-action-btns">
                  <button class="adm-btn-icon" title="Edit" @click.stop="openModal(e)"><i class="bi bi-pencil"></i></button>
                  <button class="adm-btn-icon adm-btn-icon-danger" title="Delete" @click.stop="emit('delete', e)"><i class="bi bi-trash3"></i></button>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>

    <teleport to="body">
      <div class="adm-modal-overlay" v-if="modalShow" @click.self="modalShow = false">
        <div class="adm-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">{{ modalId ? 'EDIT' : 'CREATE' }}</div>
              <h3>{{ modalId ? 'Edit entry' : 'New education entry' }}</h3>
            </div>
            <button class="adm-modal-close" @click="modalShow = false"><i class="bi bi-x-lg"></i></button>
          </div>
          <form @submit.prevent="submitForm">
            <div class="adm-fg">
              <label class="adm-fl">YEAR <span class="adm-req">*</span></label>
              <input class="adm-fi" v-model="form.year" type="text" placeholder="2022 or 2020–2024" required />
            </div>
            <div class="adm-fg">
              <label class="adm-fl">DEGREE / CERTIFICATE <span class="adm-req">*</span></label>
              <input class="adm-fi" v-model="form.degree" type="text" required />
            </div>
            <div class="adm-fg">
              <label class="adm-fl">SCHOOL / INSTITUTION <span class="adm-req">*</span></label>
              <input class="adm-fi" v-model="form.school" type="text" required />
            </div>
            <div class="adm-fg">
              <label class="adm-fl">DESCRIPTION</label>
              <textarea class="adm-fi" v-model="form.description" rows="3"></textarea>
            </div>
            <div class="adm-modal-actions">
              <button type="button" class="adm-btn-outline" @click="modalShow = false"><span>CANCEL</span></button>
              <button type="submit" class="adm-btn-primary" :disabled="saving">
                <span>{{ saving ? 'SAVING…' : modalId ? 'UPDATE' : 'CREATE' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref } from "vue";

const props = defineProps({
  educations: { type: Array, default: () => [] },
  loading: { type: Boolean, default: false },
  saving: { type: Boolean, default: false },
});
const emit = defineEmits(["submit", "delete", "view-detail"]);

const modalShow = ref(false);
const modalId = ref(null);
const form = ref({ year: "", degree: "", school: "", description: "" });

const openModal = (e) => {
  if (e) { form.value = { ...e }; modalId.value = e.id; }
  else { form.value = { year: "", degree: "", school: "", description: "" }; modalId.value = null; }
  modalShow.value = true;
};
const submitForm = () => { emit("submit", { form: { ...form.value }, id: modalId.value }); modalShow.value = false; };
defineExpose({ closeModal: () => (modalShow.value = false) });

const truncate = (str, len) => str && str.length > len ? str.slice(0, len) + "…" : str || "";
</script>
EOF

# ─────────────────────────────────────────
# 9. AdminContactsTab.vue
# ─────────────────────────────────────────
cat > src/components/admin/AdminContactsTab.vue << 'EOF'
<template>
  <div class="adm-tab-section">
    <div class="adm-section-header">
      <div class="adm-section-title-wrap">
        <span class="adm-section-eyebrow">INBOX</span>
        <h2 class="adm-section-title">Contact Messages</h2>
        <p class="adm-section-sub">Messages submitted through your contact form.</p>
      </div>
      <button class="adm-btn-outline" @click="emit('refresh')">
        <span><i class="bi bi-arrow-clockwise"></i> REFRESH</span>
      </button>
    </div>
    <div class="adm-search-row">
      <div class="adm-search-wrap">
        <i class="bi bi-search"></i>
        <input v-model="search" placeholder="Search by name, email or subject…" />
      </div>
    </div>
    <div class="adm-table-wrap">
      <table>
        <colgroup>
          <col style="width: 36px" /><col style="width: 15%" /><col style="width: 20%" />
          <col style="width: 20%" /><col /><col style="width: 96px" />
        </colgroup>
        <thead>
          <tr><th>#</th><th>NAME</th><th>EMAIL</th><th>SUBJECT</th><th>MESSAGE</th><th>RECEIVED</th></tr>
        </thead>
        <tbody>
          <template v-if="loading">
            <tr v-for="i in 5" :key="`cs-${i}`" class="adm-skeleton-row">
              <td><span class="adm-skeleton adm-skeleton-id"></span></td>
              <td><span class="adm-skeleton adm-skeleton-title"></span></td>
              <td><span class="adm-skeleton adm-skeleton-email"></span></td>
              <td><span class="adm-skeleton adm-skeleton-title short"></span></td>
              <td><span class="adm-skeleton adm-skeleton-text"></span></td>
              <td><span class="adm-skeleton adm-skeleton-date"></span></td>
            </tr>
          </template>
          <tr v-else-if="filtered.length === 0">
            <td colspan="6" class="adm-empty-cell"><i class="bi bi-inbox"></i><span>No contact messages yet.</span></td>
          </tr>
          <template v-else>
            <tr v-for="c in filtered" :key="c.id" class="adm-clickable-row" @click="emit('view-detail', c)">
              <td class="adm-id-cell">{{ c.id }}</td>
              <td class="adm-title-cell">{{ c.name }}</td>
              <td><a :href="`mailto:${c.email}`" class="adm-email-link" @click.stop>{{ c.email }}</a></td>
              <td>{{ c.subject || "—" }}</td>
              <td class="adm-desc-cell">{{ truncate(c.message, 90) }}</td>
              <td class="adm-muted">{{ formatDate(c.created_at) }}</td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";

const props = defineProps({
  contacts: { type: Array, default: () => [] },
  loading: { type: Boolean, default: false },
});
const emit = defineEmits(["refresh", "view-detail"]);

const search = ref("");
const filtered = computed(() => {
  const q = search.value.toLowerCase();
  if (!q) return props.contacts;
  return props.contacts.filter(
    (c) => c.name?.toLowerCase().includes(q) || c.email?.toLowerCase().includes(q) || c.subject?.toLowerCase().includes(q)
  );
});

const truncate = (str, len) => str && str.length > len ? str.slice(0, len) + "…" : str || "";
const formatDate = (val) => (val ? new Date(val).toLocaleDateString() : "—");
</script>
EOF

# ─────────────────────────────────────────
# 10. Admin.vue  (root view — styles omitted; copy from original)
# ─────────────────────────────────────────
cat > src/views/Admin.vue << 'EOF'
<template>
  <div class="adm-page">
    <AdminParticles />
    <div class="adm-cursor" ref="cursorRef"></div>
    <div class="adm-cursor-ring" ref="cursorRingRef"></div>
    <div class="adm-noise-overlay"></div>

    <AdminLogin
      v-if="!isAuthenticated"
      :loading="loginLoading"
      :error-message="loginError"
      @submit="login"
    />

    <div class="adm-dashboard" v-else>
      <AdminSidebar
        v-model:activeTab="activeTab"
        :is-light-theme="isLightTheme"
        :project-count="projects.length"
        :education-count="educations.length"
        :contact-count="contacts.length"
        @toggle-theme="toggleTheme"
        @sign-out="openSignOutConfirm"
      />

      <div class="adm-main-content">
        <div class="adm-main-grid-lines"></div>

        <transition name="adm-toast">
          <div v-if="toast.show" class="adm-toast" :class="`adm-toast-${toast.type}`">
            <i :class="`bi ${toast.type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill'}`"></i>
            {{ toast.msg }}
          </div>
        </transition>

        <div class="adm-page-header">
          <div class="adm-page-eyebrow">
            <span class="adm-eyebrow-dot"></span>
            <span class="adm-eyebrow-text">DASHBOARD</span>
            <span class="adm-eyebrow-line"></span>
          </div>
          <h1 class="adm-page-title">PORTFOLIO <span class="adm-accent">CONTROL</span></h1>
        </div>

        <AdminStats
          :project-count="projects.length"
          :education-count="educations.length"
          :contact-count="contacts.length"
        />

        <AdminProjectsTab
          v-if="activeTab === 'projects'"
          :projects="projects"
          :loading="projectsLoading"
          :saving="saving"
          @submit="handleProjectSubmit"
          @delete="deleteProject"
          @view-detail="(p) => openDetailModal('project', p)"
        />

        <AdminEducationTab
          v-if="activeTab === 'education'"
          :educations="educations"
          :loading="educationsLoading"
          :saving="saving"
          @submit="handleEducationSubmit"
          @delete="deleteEducation"
          @view-detail="(e) => openDetailModal('education', e)"
        />

        <AdminContactsTab
          v-if="activeTab === 'contacts'"
          :contacts="contacts"
          :loading="contactsLoading"
          @refresh="fetchContacts"
          @view-detail="(c) => openDetailModal('contact', c)"
        />
      </div>
    </div>

    <AdminDetailModal
      :show="detailModal.show"
      :type="detailModal.type"
      :title="detailModalTitle"
      :fields="detailFields"
      @close="closeDetailModal"
    />

    <AdminConfirmModal
      :show="confirmModal.show"
      :eyebrow="confirmModal.eyebrow"
      :title="confirmModal.title"
      :message="confirmModal.message"
      :confirm-label="confirmModal.confirmLabel"
      :loading="confirmModal.loading"
      @close="closeConfirmModal"
      @confirm="runConfirmAction"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from "vue";
import AdminParticles   from "@/components/admin/AdminParticles.vue";
import AdminLogin       from "@/components/admin/AdminLogin.vue";
import AdminSidebar     from "@/components/admin/AdminSidebar.vue";
import AdminStats       from "@/components/admin/AdminStats.vue";
import AdminProjectsTab from "@/components/admin/AdminProjectsTab.vue";
import AdminEducationTab from "@/components/admin/AdminEducationTab.vue";
import AdminContactsTab from "@/components/admin/AdminContactsTab.vue";
import AdminDetailModal from "@/components/admin/AdminDetailModal.vue";
import AdminConfirmModal from "@/components/admin/AdminConfirmModal.vue";

const cursorRef = ref(null);
const cursorRingRef = ref(null);
let mx = 0, my = 0, rx = 0, ry = 0, cursorAnimFrame = null;
let cursorMoveHandler = null, cursorEnterHandler = null, cursorLeaveHandler = null;

function initCursor() {
  const cur = cursorRef.value, ring = cursorRingRef.value;
  if (!cur || !ring) return;
  cursorMoveHandler = (e) => { mx = e.clientX; my = e.clientY; cur.style.left = mx - 4 + "px"; cur.style.top = my - 4 + "px"; };
  document.addEventListener("mousemove", cursorMoveHandler);
  const loop = () => { rx += (mx - rx) * 0.12; ry += (my - ry) * 0.12; ring.style.left = rx - 18 + "px"; ring.style.top = ry - 18 + "px"; cursorAnimFrame = requestAnimationFrame(loop); };
  loop();
  const sel = "a,button,.adm-tab-section,.adm-stat-card,.adm-clickable-row";
  cursorEnterHandler = (e) => { if (!e.target.closest(sel)) return; cur.classList.add("adm-hovering"); ring.classList.add("adm-hovering"); };
  cursorLeaveHandler = (e) => { if (!e.target.closest(sel)) return; cur.classList.remove("adm-hovering"); ring.classList.remove("adm-hovering"); };
  document.addEventListener("mouseover", cursorEnterHandler);
  document.addEventListener("mouseout", cursorLeaveHandler);
}

onBeforeUnmount(() => {
  cancelAnimationFrame(cursorAnimFrame);
  if (cursorMoveHandler) document.removeEventListener("mousemove", cursorMoveHandler);
  if (cursorEnterHandler) document.removeEventListener("mouseover", cursorEnterHandler);
  if (cursorLeaveHandler) document.removeEventListener("mouseout", cursorLeaveHandler);
  clearTimeout(toastTimer);
});

const API_URL = import.meta.env.VITE_API_URL?.replace(/\/$/, "");
const token = ref(localStorage.getItem("admin_token") || "");
const loginError = ref("");
const loginLoading = ref(false);
const themeMode = ref(localStorage.getItem("theme") === "light" ? "light" : "dark");
const isLightTheme = computed(() => themeMode.value === "light");
const applyTheme = () => document.documentElement.classList.toggle("light", themeMode.value === "light");
const toggleTheme = () => { themeMode.value = themeMode.value === "light" ? "dark" : "light"; localStorage.setItem("theme", themeMode.value); applyTheme(); };
const isAuthenticated = computed(() => Boolean(token.value));
const authHeaders = () => ({ Authorization: `Bearer ${token.value}`, "Content-Type": "application/json" });

const parseResponse = async (res) => {
  const ct = res.headers.get("content-type") || "";
  if (ct.includes("application/json")) { try { return await res.json(); } catch { return { result: res.ok, msg: res.ok ? "" : `Server error ${res.status}` }; } }
  const text = await res.text();
  return { result: false, msg: `Server error ${res.status}: ${text}` };
};

const login = async ({ email, password }) => {
  loginError.value = ""; loginLoading.value = true;
  try {
    const res = await fetch(`${API_URL}/api/admin/login`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ email, password }) });
    const data = await parseResponse(res);
    if (!res.ok || !data.result) throw new Error(data.msg || "Login failed");
    token.value = data.data.token; localStorage.setItem("admin_token", token.value);
    await loadAll();
  } catch (err) { loginError.value = err.message; } finally { loginLoading.value = false; }
};

const performLogout = () => { localStorage.removeItem("admin_token"); token.value = ""; projects.value = []; educations.value = []; contacts.value = []; closeConfirmModal(true); };

const toast = ref({ show: false, msg: "", type: "success" });
let toastTimer = null;
const showToast = (msg, type = "success") => { clearTimeout(toastTimer); toast.value = { show: true, msg, type }; toastTimer = setTimeout(() => (toast.value.show = false), 3200); };

const activeTab = ref("projects");
const parseTags = (tags) => { if (!tags) return []; if (Array.isArray(tags)) return tags; return tags.split(",").map((t) => t.trim()).filter(Boolean); };
const formatDate = (val) => (val ? new Date(val).toLocaleDateString() : "—");

const detailModal = ref({ show: false, type: "", item: null });
const openDetailModal = (type, item) => { detailModal.value = { show: true, type, item }; };
const closeDetailModal = () => { detailModal.value = { show: false, type: "", item: null }; };
const detailModalTitle = computed(() => { const item = detailModal.value.item; if (!item) return "Item detail"; return item.title || item.degree || item.name || `Item #${item.id}`; });
const detailFields = computed(() => {
  const { type, item } = detailModal.value; if (!item) return [];
  if (type === "project") return [
    { label: "ID", value: item.id }, { label: "Title", value: item.title || "—" },
    { label: "Description", value: item.description || "—" }, { label: "Tags", value: parseTags(item.tags).join(", ") || "—" },
    { label: "Link label", value: item.link_label || "—" }, { label: "Project link", value: item.link_project || "—", href: item.link_project || "" },
  ];
  if (type === "education") return [
    { label: "ID", value: item.id }, { label: "Year", value: item.year || "—" },
    { label: "Degree", value: item.degree || "—" }, { label: "School", value: item.school || "—" },
    { label: "Description", value: item.description || "—" },
  ];
  return [
    { label: "ID", value: item.id }, { label: "Name", value: item.name || "—" },
    { label: "Email", value: item.email || "—", href: item.email ? `mailto:${item.email}` : "" },
    { label: "Subject", value: item.subject || "—" }, { label: "Message", value: item.message || "—" },
    { label: "Received", value: formatDate(item.created_at) },
  ];
});

const confirmModal = ref({ show: false, eyebrow: "CONFIRM", title: "", message: "", confirmLabel: "CONFIRM", intent: "", item: null, loading: false });
const openConfirmModal = (config) => { confirmModal.value = { show: true, eyebrow: "CONFIRM", title: "", message: "", confirmLabel: "CONFIRM", intent: "", item: null, loading: false, ...config }; };
const closeConfirmModal = (force = false) => { if (confirmModal.value.loading && force !== true) return; confirmModal.value.show = false; confirmModal.value.loading = false; };
const openSignOutConfirm = () => openConfirmModal({ eyebrow: "SESSION", title: "Sign out?", message: "You will leave the admin dashboard and return to the login screen.", confirmLabel: "SIGN OUT", intent: "signout" });
const runConfirmAction = async () => {
  if (confirmModal.value.loading) return;
  confirmModal.value.loading = true;
  try {
    if (confirmModal.value.intent === "signout") { performLogout(); return; }
    if (confirmModal.value.intent === "delete-project") { await performDeleteProject(confirmModal.value.item.id); return; }
    if (confirmModal.value.intent === "delete-education") { await performDeleteEducation(confirmModal.value.item.id); }
  } finally { if (confirmModal.value.show) confirmModal.value.loading = false; }
};

const projects = ref([]);
const projectsLoading = ref(false);
const saving = ref(false);

const fetchProjects = async () => {
  projectsLoading.value = true;
  try { const res = await fetch(`${API_URL}/api/projects`); const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not load projects"); projects.value = data.data || []; }
  catch (err) { showToast(err.message, "error"); } finally { projectsLoading.value = false; }
};
const handleProjectSubmit = async ({ form, id }) => {
  saving.value = true;
  try {
    const url = id ? `${API_URL}/api/projects/${id}` : `${API_URL}/api/projects`;
    const res = await fetch(url, { method: id ? "PUT" : "POST", headers: authHeaders(), body: JSON.stringify(form) });
    const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not save project");
    showToast(id ? "Project updated" : "Project created"); await fetchProjects();
  } catch (err) { showToast(err.message, "error"); } finally { saving.value = false; }
};
const deleteProject = (project) => openConfirmModal({ eyebrow: "DELETE", title: "Delete project?", message: `This will permanently delete "${project.title || "this project"}".`, confirmLabel: "DELETE", intent: "delete-project", item: project });
const performDeleteProject = async (id) => {
  try {
    const res = await fetch(`${API_URL}/api/projects/${id}`, { method: "DELETE", headers: authHeaders() });
    const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not delete project");
    showToast("Project deleted"); closeDetailModal(); closeConfirmModal(true); await fetchProjects();
  } catch (err) { showToast(err.message, "error"); }
};

const educations = ref([]);
const educationsLoading = ref(false);

const fetchEducations = async () => {
  educationsLoading.value = true;
  try { const res = await fetch(`${API_URL}/api/educations`); const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not load education"); educations.value = data.data || []; }
  catch (err) { showToast(err.message, "error"); } finally { educationsLoading.value = false; }
};
const handleEducationSubmit = async ({ form, id }) => {
  saving.value = true;
  try {
    const url = id ? `${API_URL}/api/educations/${id}` : `${API_URL}/api/educations`;
    const res = await fetch(url, { method: id ? "PUT" : "POST", headers: authHeaders(), body: JSON.stringify(form) });
    const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not save education");
    showToast(id ? "Education updated" : "Education entry created"); await fetchEducations();
  } catch (err) { showToast(err.message, "error"); } finally { saving.value = false; }
};
const deleteEducation = (education) => openConfirmModal({ eyebrow: "DELETE", title: "Delete education entry?", message: `This will permanently delete "${education.degree || "this entry"}".`, confirmLabel: "DELETE", intent: "delete-education", item: education });
const performDeleteEducation = async (id) => {
  try {
    const res = await fetch(`${API_URL}/api/educations/${id}`, { method: "DELETE", headers: authHeaders() });
    const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not delete education");
    showToast("Entry deleted"); closeDetailModal(); closeConfirmModal(true); await fetchEducations();
  } catch (err) { showToast(err.message, "error"); }
};

const contacts = ref([]);
const contactsLoading = ref(false);

const fetchContacts = async () => {
  contactsLoading.value = true;
  try { const res = await fetch(`${API_URL}/api/contacts`, { headers: authHeaders() }); const data = await parseResponse(res); if (!res.ok || !data.result) throw new Error(data.msg || "Could not load contacts"); contacts.value = data.data || []; }
  catch (err) { showToast(err.message, "error"); } finally { contactsLoading.value = false; }
};

const loadAll = () => Promise.all([fetchProjects(), fetchEducations(), fetchContacts()]);

onMounted(() => { applyTheme(); initCursor(); if (isAuthenticated.value) loadAll(); });
</script>

<style scoped>
/* ── Paste the full <style scoped> block from your original Admin.vue here ── */
</style>
EOF

echo ""
echo "✅ Done! All 10 files written:"
echo "   src/components/admin/AdminParticles.vue"
echo "   src/components/admin/AdminLogin.vue"
echo "   src/components/admin/AdminSidebar.vue"
echo "   src/components/admin/AdminStats.vue"
echo "   src/components/admin/AdminDetailModal.vue"
echo "   src/components/admin/AdminConfirmModal.vue"
echo "   src/components/admin/AdminProjectsTab.vue"
echo "   src/components/admin/AdminEducationTab.vue"
echo "   src/components/admin/AdminContactsTab.vue"
echo "   src/views/Admin.vue  ← replace your existing file"
echo ""
echo "⚠️  Don't forget: paste the original <style scoped> CSS into src/views/Admin.vue"
