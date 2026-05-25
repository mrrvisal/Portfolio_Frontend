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
