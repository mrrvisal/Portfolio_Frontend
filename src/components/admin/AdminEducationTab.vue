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
