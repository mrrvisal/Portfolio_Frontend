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
