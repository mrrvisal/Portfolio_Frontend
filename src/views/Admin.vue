<template>
  <div class="adm-page">
    <!-- <loader></loader> -->
    <canvas id="particles" ref="canvasRef"></canvas>
    <div class="adm-cursor" ref="cursorRef"></div>
    <div class="adm-cursor-ring" ref="cursorRingRef"></div>
    <div class="adm-noise-overlay"></div>

    <!-- LOGIN -->
    <div class="adm-login-wrap" v-if="!isAuthenticated">
      <div class="adm-login-bg-glow"></div>
      <div class="adm-login-grid-lines"></div>
      <div class="adm-login-card">
        <div class="adm-login-eyebrow">
          <span class="adm-eyebrow-dot"></span>
          <span class="adm-eyebrow-text">SYSTEM ACCESS</span>
          <span class="adm-eyebrow-line"></span>
        </div>
        <div class="adm-login-icon">
          <i class="bi bi-shield-lock-fill"></i>
        </div>
        <h1 class="adm-login-title">
          ADMIN<span class="adm-accent">.</span>PANEL
        </h1>
        <p class="adm-login-sub">Authenticate to manage</p>
        <form @submit.prevent="login" class="adm-login-form">
          <div class="adm-fg">
            <label class="adm-fl">EMAIL ADDRESS</label>
            <input
              class="adm-fi"
              v-model="email"
              type="email"
              placeholder="Your email address"
              required
            />
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
                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                @click="showPassword = !showPassword"
              >
                <i :class="`bi ${showPassword ? 'bi-eye-slash' : 'bi-eye'}`"></i>
              </button>
            </div>
          </div>
          <p class="adm-error-msg" v-if="message">
            <i class="bi bi-exclamation-triangle"></i> {{ message }}
          </p>
          <button
            type="submit"
            class="adm-btn-primary adm-w-full"
            :disabled="loginLoading"
          >
            <span>{{ loginLoading ? "AUTHENTICATING…" : "SIGN IN" }}</span>
            <i class="bi bi-arrow-right"></i>
          </button>
        </form>
      </div>
    </div>

    <!-- DASHBOARD -->
    <div class="adm-dashboard" v-else>
      <!-- Sidebar -->
      <div class="adm-sidebar">
        <div class="adm-sidebar-brand">
          <span class="adm-brand-dot"></span>
          <span class="adm-brand-text"
            >ADMIN<span class="adm-brand-accent">.</span></span
          >
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
            <span class="adm-nav-badge" v-if="tab.id === 'projects'">{{
              projects.length
            }}</span>
            <span class="adm-nav-badge" v-if="tab.id === 'education'">{{
              educations.length
            }}</span>
            <span class="adm-nav-badge" v-if="tab.id === 'contacts'">{{
              contacts.length
            }}</span>
          </button>
        </div>
        <!-- /adm-sidebar-nav -->
        <div class="adm-sidebar-footer" :class="{ open: sidebarOpen }">
          <div class="adm-sidebar-status">
            <span class="adm-status-dot"></span>
            <span class="adm-status-text">CONNECTED</span>
          </div>
          <button
            class="adm-theme-toggle-btn"
            @click="toggleTheme"
            :title="
              isLightTheme ? 'Switch to dark mode' : 'Switch to light mode'
            "
          >
            <i
              :class="`bi ${isLightTheme ? 'bi-moon-fill' : 'bi-sun-fill'}`"
            ></i>
            <span>{{ isLightTheme ? "Dark" : "Light" }}</span>
          </button>
          <button class="adm-logout-btn" @click="openSignOutConfirm">
            <i class="bi bi-box-arrow-left"></i>
            <span>SIGN OUT</span>
          </button>
        </div>
      </div>
      <!-- /adm-sidebar -->

      <!-- Main content -->
      <div class="adm-main-content">
        <div class="adm-main-grid-lines"></div>

        <!-- Toast -->
        <transition name="adm-toast">
          <div
            v-if="toast.show"
            class="adm-toast"
            :class="`adm-toast-${toast.type}`"
          >
            <i
              :class="`bi ${
                toast.type === 'success'
                  ? 'bi-check-circle-fill'
                  : 'bi-exclamation-circle-fill'
              }`"
            ></i>
            {{ toast.msg }}
          </div>
        </transition>

        <!-- Page header -->
        <div class="adm-page-header">
          <div class="adm-page-eyebrow">
            <span class="adm-eyebrow-dot"></span>
            <span class="adm-eyebrow-text">DASHBOARD</span>
            <span class="adm-eyebrow-line"></span>
          </div>
          <h1 class="adm-page-title">
            PORTFOLIO <span class="adm-accent">CONTROL</span>
          </h1>
        </div>

        <!-- Stats -->
        <div class="adm-stats-row">
          <div class="adm-stat-card">
            <div class="adm-stat-icon-wrap">
              <i class="bi bi-code-slash"></i>
            </div>
            <div class="adm-stat-body">
              <div class="adm-stat-value">{{ projects.length }}</div>
              <div class="adm-stat-label">PROJECTS</div>
            </div>
            <div class="adm-stat-line"></div>
          </div>
          <div class="adm-stat-card">
            <div class="adm-stat-icon-wrap">
              <i class="bi bi-mortarboard-fill"></i>
            </div>
            <div class="adm-stat-body">
              <div class="adm-stat-value">{{ educations.length }}</div>
              <div class="adm-stat-label">EDUCATION</div>
            </div>
            <div class="adm-stat-line"></div>
          </div>
          <div class="adm-stat-card">
            <div class="adm-stat-icon-wrap">
              <i class="bi bi-envelope-fill"></i>
            </div>
            <div class="adm-stat-body">
              <div class="adm-stat-value">{{ contacts.length }}</div>
              <div class="adm-stat-label">MESSAGES</div>
            </div>
            <div class="adm-stat-line"></div>
          </div>
        </div>

        <!-- PROJECTS TAB -->
        <div v-if="activeTab === 'projects'" class="adm-tab-section">
          <div class="adm-section-header">
            <div class="adm-section-title-wrap">
              <span class="adm-section-eyebrow">MANAGE</span>
              <h2 class="adm-section-title">Projects</h2>
              <p class="adm-section-sub">
                Create and manage your portfolio projects.
              </p>
            </div>
            <button class="adm-btn-primary" @click="openProjectModal(null)">
              <span><i class="bi bi-plus-lg"></i> NEW PROJECT</span>
            </button>
          </div>
          <div class="adm-search-row">
            <div class="adm-search-wrap">
              <i class="bi bi-search"></i>
              <input v-model="projectSearch" placeholder="Search projects…" />
            </div>
          </div>
          <div class="adm-table-wrap">
            <table>
              <colgroup>
                <col style="width: 36px" />
                <col style="width: 22%" />
                <col style="width: 30%" />
                <col />
                <col style="width: 60px" />
                <col style="width: 88px" />
              </colgroup>
              <thead>
                <tr>
                  <th>#</th>
                  <th>TITLE</th>
                  <th>DESCRIPTION</th>
                  <th>TAGS</th>
                  <th>LINK</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                <template v-if="projectsLoading">
                  <tr
                    v-for="i in 5"
                    :key="`project-skeleton-${i}`"
                    class="adm-skeleton-row"
                  >
                    <td><span class="adm-skeleton adm-skeleton-id"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-title"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-text"></span></td>
                    <td>
                      <span class="adm-skeleton adm-skeleton-tag"></span>
                      <span class="adm-skeleton adm-skeleton-tag short"></span>
                    </td>
                    <td><span class="adm-skeleton adm-skeleton-icon"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-actions"></span></td>
                  </tr>
                </template>
                <tr v-else-if="filteredProjects.length === 0">
                  <td colspan="6" class="adm-empty-cell">
                    <i class="bi bi-inbox"></i><span>No projects yet.</span>
                  </td>
                </tr>
                <template v-else>
                  <tr
                    v-for="p in filteredProjects"
                    :key="p.id"
                    class="adm-clickable-row"
                    @click="openDetailModal('project', p)"
                  >
                    <td class="adm-id-cell">{{ p.id }}</td>
                    <td class="adm-title-cell">{{ p.title }}</td>
                    <td class="adm-desc-cell">
                      {{ truncate(p.description, 80) }}
                    </td>
                    <td>
                      <span
                        class="adm-tag"
                        v-for="t in parseTags(p.tags)"
                        :key="t"
                        >{{ t }}</span
                      >
                    </td>
                    <td>
                      <a
                        v-if="p.link_project"
                        :href="p.link_project"
                        target="_blank"
                        class="adm-link-icon"
                        title="Open link"
                        @click.stop
                      >
                        <i class="bi bi-box-arrow-up-right"></i>
                      </a>
                      <span v-else class="adm-muted">—</span>
                    </td>
                    <td>
                      <div class="adm-action-btns">
                        <button
                        class="adm-btn-icon"
                        title="Edit"
                        @click.stop="openProjectModal(p)"
                      >
                          <i class="bi bi-pencil"></i>
                        </button>
                        <button
                        class="adm-btn-icon adm-btn-icon-danger"
                        title="Delete"
                        @click.stop="deleteProject(p)"
                      >
                          <i class="bi bi-trash3"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>
        <!-- /adm-tab-section -->

        <!-- EDUCATION TAB -->
        <div v-if="activeTab === 'education'" class="adm-tab-section">
          <div class="adm-section-header">
            <div class="adm-section-title-wrap">
              <span class="adm-section-eyebrow">MANAGE</span>
              <h2 class="adm-section-title">Education</h2>
              <p class="adm-section-sub">
                Add your education history and certifications.
              </p>
            </div>
            <button class="adm-btn-primary" @click="openEducationModal(null)">
              <span><i class="bi bi-plus-lg"></i> NEW ENTRY</span>
            </button>
          </div>
          <div class="adm-table-wrap">
            <table>
              <colgroup>
                <col style="width: 36px" />
                <col style="width: 90px" />
                <col style="width: 25%" />
                <col style="width: 25%" />
                <col />
                <col style="width: 88px" />
              </colgroup>
              <thead>
                <tr>
                  <th>#</th>
                  <th>YEAR</th>
                  <th>DEGREE</th>
                  <th>SCHOOL</th>
                  <th>DESCRIPTION</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                <template v-if="educationsLoading">
                  <tr
                    v-for="i in 4"
                    :key="`education-skeleton-${i}`"
                    class="adm-skeleton-row"
                  >
                    <td><span class="adm-skeleton adm-skeleton-id"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-badge"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-title"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-title short"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-text"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-actions"></span></td>
                  </tr>
                </template>
                <tr v-else-if="educations.length === 0">
                  <td colspan="6" class="adm-empty-cell">
                    <i class="bi bi-inbox"></i
                    ><span>No education entries yet.</span>
                  </td>
                </tr>
                <template v-else>
                  <tr
                    v-for="e in educations"
                    :key="e.id"
                    class="adm-clickable-row"
                    @click="openDetailModal('education', e)"
                  >
                    <td class="adm-id-cell">{{ e.id }}</td>
                    <td>
                      <span class="adm-year-badge">{{ e.year }}</span>
                    </td>
                    <td class="adm-title-cell">{{ e.degree }}</td>
                    <td>{{ e.school }}</td>
                    <td class="adm-desc-cell">
                      {{ truncate(e.description, 80) }}
                    </td>
                    <td>
                      <div class="adm-action-btns">
                        <button
                        class="adm-btn-icon"
                        title="Edit"
                        @click.stop="openEducationModal(e)"
                      >
                          <i class="bi bi-pencil"></i>
                        </button>
                        <button
                        class="adm-btn-icon adm-btn-icon-danger"
                        title="Delete"
                        @click.stop="deleteEducation(e)"
                      >
                          <i class="bi bi-trash3"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>
        <!-- /adm-tab-section -->

        <!-- CONTACTS TAB -->
        <div v-if="activeTab === 'contacts'" class="adm-tab-section">
          <div class="adm-section-header">
            <div class="adm-section-title-wrap">
              <span class="adm-section-eyebrow">INBOX</span>
              <h2 class="adm-section-title">Contact Messages</h2>
              <p class="adm-section-sub">
                Messages submitted through your contact form.
              </p>
            </div>
            <button class="adm-btn-outline" @click="fetchContacts">
              <span><i class="bi bi-arrow-clockwise"></i> REFRESH</span>
            </button>
          </div>
          <div class="adm-search-row">
            <div class="adm-search-wrap">
              <i class="bi bi-search"></i>
              <input
                v-model="contactSearch"
                placeholder="Search by name, email or subject…"
              />
            </div>
          </div>
          <div class="adm-table-wrap">
            <table>
              <colgroup>
                <col style="width: 36px" />
                <col style="width: 15%" />
                <col style="width: 20%" />
                <col style="width: 20%" />
                <col />
                <col style="width: 96px" />
              </colgroup>
              <thead>
                <tr>
                  <th>#</th>
                  <th>NAME</th>
                  <th>EMAIL</th>
                  <th>SUBJECT</th>
                  <th>MESSAGE</th>
                  <th>RECEIVED</th>
                </tr>
              </thead>
              <tbody>
                <template v-if="contactsLoading">
                  <tr
                    v-for="i in 5"
                    :key="`contact-skeleton-${i}`"
                    class="adm-skeleton-row"
                  >
                    <td><span class="adm-skeleton adm-skeleton-id"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-title"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-email"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-title short"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-text"></span></td>
                    <td><span class="adm-skeleton adm-skeleton-date"></span></td>
                  </tr>
                </template>
                <tr v-else-if="filteredContacts.length === 0">
                  <td colspan="6" class="adm-empty-cell">
                    <i class="bi bi-inbox"></i
                    ><span>No contact messages yet.</span>
                  </td>
                </tr>
                <template v-else>
                  <tr
                    v-for="c in filteredContacts"
                    :key="c.id"
                    class="adm-clickable-row"
                    @click="openDetailModal('contact', c)"
                  >
                    <td class="adm-id-cell">{{ c.id }}</td>
                    <td class="adm-title-cell">{{ c.name }}</td>
                    <td>
                      <a
                        :href="`mailto:${c.email}`"
                        class="adm-email-link"
                        @click.stop
                        >{{
                        c.email
                      }}</a>
                    </td>
                    <td>{{ c.subject || "—" }}</td>
                    <td class="adm-desc-cell">{{ truncate(c.message, 90) }}</td>
                    <td class="adm-muted">{{ formatDate(c.created_at) }}</td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>
        <!-- /adm-tab-section -->
      </div>
      <!-- /adm-main-content -->
    </div>

    <!-- PROJECT MODAL -->
    <teleport to="body">
      <div
        class="adm-modal-overlay"
        v-if="projectModal.show"
        @click.self="projectModal.show = false"
      >
        <div class="adm-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">
                {{ projectModal.id ? "EDIT" : "CREATE" }}
              </div>
              <h3>{{ projectModal.id ? "Edit project" : "New project" }}</h3>
            </div>
            <button class="adm-modal-close" @click="projectModal.show = false">
              <i class="bi bi-x-lg"></i>
            </button>
          </div>
          <form @submit.prevent="submitProject">
            <div class="adm-fg">
              <label class="adm-fl">TITLE <span class="adm-req">*</span></label>
              <input
                class="adm-fi"
                v-model="projectForm.title"
                type="text"
                required
              />
            </div>
            <div class="adm-fg">
              <label class="adm-fl"
                >DESCRIPTION <span class="adm-req">*</span></label
              >
              <textarea
                class="adm-fi"
                v-model="projectForm.description"
                rows="3"
                required
              ></textarea>
            </div>
            <div class="adm-fg">
              <label class="adm-fl"
                >TAGS <span class="adm-fl-hint">(comma-separated)</span></label
              >
              <input
                class="adm-fi"
                v-model="projectForm.tags"
                type="text"
                placeholder="Vue, Node.js, MySQL"
              />
            </div>
            <div class="adm-form-row">
              <div class="adm-fg">
                <label class="adm-fl">LINK URL</label>
                <input
                  class="adm-fi"
                  v-model="projectForm.link_project"
                  type="url"
                  placeholder="https://…"
                />
              </div>
              <div class="adm-fg">
                <label class="adm-fl">LINK LABEL</label>
                <input
                  class="adm-fi"
                  v-model="projectForm.link_label"
                  type="text"
                  placeholder="View project"
                />
              </div>
            </div>
            <div class="adm-modal-actions">
              <button
                type="button"
                class="adm-btn-outline"
                @click="projectModal.show = false"
              >
                <span>CANCEL</span>
              </button>
              <button type="submit" class="adm-btn-primary" :disabled="saving">
                <span>{{
                  saving ? "SAVING…" : projectModal.id ? "UPDATE" : "CREATE"
                }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </teleport>

    <!-- EDUCATION MODAL -->
    <teleport to="body">
      <div
        class="adm-modal-overlay"
        v-if="educationModal.show"
        @click.self="educationModal.show = false"
      >
        <div class="adm-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">
                {{ educationModal.id ? "EDIT" : "CREATE" }}
              </div>
              <h3>
                {{ educationModal.id ? "Edit entry" : "New education entry" }}
              </h3>
            </div>
            <button
              class="adm-modal-close"
              @click="educationModal.show = false"
            >
              <i class="bi bi-x-lg"></i>
            </button>
          </div>
          <form @submit.prevent="submitEducation">
            <div class="adm-fg">
              <label class="adm-fl">YEAR <span class="adm-req">*</span></label>
              <input
                class="adm-fi"
                v-model="educationForm.year"
                type="text"
                placeholder="2022 or 2020–2024"
                required
              />
            </div>
            <div class="adm-fg">
              <label class="adm-fl"
                >DEGREE / CERTIFICATE <span class="adm-req">*</span></label
              >
              <input
                class="adm-fi"
                v-model="educationForm.degree"
                type="text"
                required
              />
            </div>
            <div class="adm-fg">
              <label class="adm-fl"
                >SCHOOL / INSTITUTION <span class="adm-req">*</span></label
              >
              <input
                class="adm-fi"
                v-model="educationForm.school"
                type="text"
                required
              />
            </div>
            <div class="adm-fg">
              <label class="adm-fl">DESCRIPTION</label>
              <textarea
                class="adm-fi"
                v-model="educationForm.description"
                rows="3"
              ></textarea>
            </div>
            <div class="adm-modal-actions">
              <button
                type="button"
                class="adm-btn-outline"
                @click="educationModal.show = false"
              >
                <span>CANCEL</span>
              </button>
              <button type="submit" class="adm-btn-primary" :disabled="saving">
                <span>{{
                  saving ? "SAVING…" : educationModal.id ? "UPDATE" : "CREATE"
                }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </teleport>

    <!-- DETAIL MODAL -->
    <teleport to="body">
      <div
        class="adm-modal-overlay"
        v-if="detailModal.show"
        @click.self="closeDetailModal"
      >
        <div class="adm-modal-card adm-detail-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">{{ detailModal.type }} DETAIL</div>
              <h3>{{ detailModalTitle }}</h3>
            </div>
            <button class="adm-modal-close" @click="closeDetailModal">
              <i class="bi bi-x-lg"></i>
            </button>
          </div>
          <div class="adm-detail-list">
            <div
              class="adm-detail-item"
              v-for="field in detailFields"
              :key="field.label"
            >
              <div class="adm-detail-label">{{ field.label }}</div>
              <a
                v-if="field.href"
                :href="field.href"
                target="_blank"
                class="adm-detail-value adm-detail-link"
              >
                {{ field.value }}
              </a>
              <div v-else class="adm-detail-value">{{ field.value }}</div>
            </div>
          </div>
          <div class="adm-modal-actions">
            <button type="button" class="adm-btn-outline" @click="closeDetailModal">
              <span>CLOSE</span>
            </button>
          </div>
        </div>
      </div>
    </teleport>

    <!-- CONFIRM MODAL -->
    <teleport to="body">
      <div
        class="adm-modal-overlay"
        v-if="confirmModal.show"
        @click.self="closeConfirmModal"
      >
        <div class="adm-modal-card adm-confirm-modal-card">
          <div class="adm-modal-header">
            <div>
              <div class="adm-modal-eyebrow">{{ confirmModal.eyebrow }}</div>
              <h3>{{ confirmModal.title }}</h3>
            </div>
            <button class="adm-modal-close" @click="closeConfirmModal">
              <i class="bi bi-x-lg"></i>
            </button>
          </div>
          <p class="adm-confirm-message">{{ confirmModal.message }}</p>
          <div class="adm-modal-actions">
            <button
              type="button"
              class="adm-btn-outline"
              :disabled="confirmModal.loading"
              @click="closeConfirmModal"
            >
              <span>CANCEL</span>
            </button>
            <button
              type="button"
              class="adm-btn-primary adm-btn-danger"
              :disabled="confirmModal.loading"
              @click="runConfirmAction"
            >
              <span>{{
                confirmModal.loading ? "WORKING..." : confirmModal.confirmLabel
              }}</span>
            </button>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from "vue";
import loader from "@/components/loader/Loader.vue";

const cursorRef = ref(null);
const cursorRingRef = ref(null);
const canvasRef = ref(null);

// ── Custom cursor ──────────────────────────────────────
let mx = 0,
  my = 0,
  rx = 0,
  ry = 0,
  cursorAnimFrame = null;
let cursorMoveHandler = null;
let cursorEnterHandler = null;
let cursorLeaveHandler = null;
function initCursor() {
  const cur = cursorRef.value;
  const ring = cursorRingRef.value;
  if (!cur || !ring) return;

  cursorMoveHandler = (e) => {
    mx = e.clientX;
    my = e.clientY;
    cur.style.left = mx - 4 + "px";
    cur.style.top = my - 4 + "px";
  };
  document.addEventListener("mousemove", cursorMoveHandler);

  const loop = () => {
    rx += (mx - rx) * 0.12;
    ry += (my - ry) * 0.12;
    ring.style.left = rx - 18 + "px";
    ring.style.top = ry - 18 + "px";
    cursorAnimFrame = requestAnimationFrame(loop);
  };
  loop();

  const interactiveSelector =
    "a,button,.adm-tab-section,.adm-stat-card,.adm-clickable-row";
  cursorEnterHandler = (e) => {
    if (!e.target.closest(interactiveSelector)) return;
    cur.classList.add("adm-hovering");
    ring.classList.add("adm-hovering");
  };
  cursorLeaveHandler = (e) => {
    if (!e.target.closest(interactiveSelector)) return;
    cur.classList.remove("adm-hovering");
    ring.classList.remove("adm-hovering");
  };
  document.addEventListener("mouseover", cursorEnterHandler);
  document.addEventListener("mouseout", cursorLeaveHandler);
}

// ── Particles ──────────────────────────────────────────
let animFrame = null;
let particleResizeHandler = null;
function initParticles() {
  const canvas = canvasRef.value;
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  let W, H;
  const dots = [];

  particleResizeHandler = () => {
    W = canvas.width = innerWidth;
    H = canvas.height = innerHeight;
  };
  particleResizeHandler();
  window.addEventListener("resize", particleResizeHandler);

  for (let i = 0; i < 60; i++) {
    dots.push({
      x: Math.random() * 1920,
      y: Math.random() * 1080,
      vx: (Math.random() - 0.5) * 0.25,
      vy: (Math.random() - 0.5) * 0.25,
      r: Math.random() * 1.5 + 0.4,
    });
  }

  const draw = () => {
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
          dy = a.y - b.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
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
  };
  draw();
}

// ── Cleanup on unmount ─────────────────────────────────
onBeforeUnmount(() => {
  cancelAnimationFrame(animFrame);
  cancelAnimationFrame(cursorAnimFrame);
  if (particleResizeHandler)
    window.removeEventListener("resize", particleResizeHandler);
  if (cursorMoveHandler)
    document.removeEventListener("mousemove", cursorMoveHandler);
  if (cursorEnterHandler)
    document.removeEventListener("mouseover", cursorEnterHandler);
  if (cursorLeaveHandler)
    document.removeEventListener("mouseout", cursorLeaveHandler);
  clearTimeout(toastTimer);
});

const API_URL = import.meta.env.VITE_API_URL?.replace(/\/$/, "");

// ── Auth ──────────────────────────────────────────
const token = ref(localStorage.getItem("admin_token") || "");
const email = ref("");
const password = ref("");
const showPassword = ref(false);
const message = ref("");
const loginLoading = ref(false);

const themeMode = ref(
  localStorage.getItem("theme") === "light" ? "light" : "dark"
);
const isLightTheme = computed(() => themeMode.value === "light");

const applyTheme = () => {
  document.documentElement.classList.toggle(
    "light",
    themeMode.value === "light"
  );
};

const toggleTheme = () => {
  themeMode.value = themeMode.value === "light" ? "dark" : "light";
  localStorage.setItem("theme", themeMode.value);
  applyTheme();
};

const isAuthenticated = computed(() => Boolean(token.value));
const authHeaders = () => ({
  Authorization: `Bearer ${token.value}`,
  "Content-Type": "application/json",
});

const parseResponse = async (res) => {
  const ct = res.headers.get("content-type") || "";
  if (ct.includes("application/json")) {
    try {
      return await res.json();
    } catch {
      return {
        result: res.ok,
        msg: res.ok ? "" : `Server error ${res.status}`,
      };
    }
  }
  const text = await res.text();
  return { result: false, msg: `Server error ${res.status}: ${text}` };
};

const login = async () => {
  message.value = "";
  loginLoading.value = true;
  try {
    const res = await fetch(`${API_URL}/api/admin/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: email.value, password: password.value }),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result) throw new Error(data.msg || "Login failed");
    token.value = data.data.token;
    localStorage.setItem("admin_token", token.value);
    email.value = password.value = "";
    await loadAll();
  } catch (err) {
    message.value = err.message;
  } finally {
    loginLoading.value = false;
  }
};

const performLogout = () => {
  localStorage.removeItem("admin_token");
  token.value = "";
  projects.value = [];
  educations.value = [];
  contacts.value = [];
  closeConfirmModal(true);
};

// ── Toast ─────────────────────────────────────────
const toast = ref({ show: false, msg: "", type: "success" });
let toastTimer = null;
const showToast = (msg, type = "success") => {
  clearTimeout(toastTimer);
  toast.value = { show: true, msg, type };
  toastTimer = setTimeout(() => (toast.value.show = false), 3200);
};

// ── Tabs ──────────────────────────────────────────
const activeTab = ref("projects");
const sidebarOpen = ref(false);
const tabs = [
  { id: "projects", label: "Projects", icon: "bi-code-slash" },
  { id: "education", label: "Education", icon: "bi-mortarboard-fill" },
  { id: "contacts", label: "Contacts", icon: "bi-envelope-fill" },
];

const selectTab = (tabId) => {
  activeTab.value = tabId;
  sidebarOpen.value = false;
};

// ── Helpers ───────────────────────────────────────
const truncate = (str, len) =>
  str && str.length > len ? str.slice(0, len) + "…" : str || "";
const parseTags = (tags) => {
  if (!tags) return [];
  if (Array.isArray(tags)) return tags;
  return tags
    .split(",")
    .map((t) => t.trim())
    .filter(Boolean);
};
const formatDate = (val) => (val ? new Date(val).toLocaleDateString() : "—");

// ── Detail + Confirm Modals ─────────────────────────
const detailModal = ref({ show: false, type: "", item: null });

const openDetailModal = (type, item) => {
  detailModal.value = { show: true, type, item };
};

const closeDetailModal = () => {
  detailModal.value = { show: false, type: "", item: null };
};

const detailModalTitle = computed(() => {
  const item = detailModal.value.item;
  if (!item) return "Item detail";
  return item.title || item.degree || item.name || `Item #${item.id}`;
});

const detailFields = computed(() => {
  const { type, item } = detailModal.value;
  if (!item) return [];

  if (type === "project") {
    return [
      { label: "ID", value: item.id },
      { label: "Title", value: item.title || "—" },
      { label: "Description", value: item.description || "—" },
      { label: "Tags", value: parseTags(item.tags).join(", ") || "—" },
      { label: "Link label", value: item.link_label || "—" },
      {
        label: "Project link",
        value: item.link_project || "—",
        href: item.link_project || "",
      },
    ];
  }

  if (type === "education") {
    return [
      { label: "ID", value: item.id },
      { label: "Year", value: item.year || "—" },
      { label: "Degree", value: item.degree || "—" },
      { label: "School", value: item.school || "—" },
      { label: "Description", value: item.description || "—" },
    ];
  }

  return [
    { label: "ID", value: item.id },
    { label: "Name", value: item.name || "—" },
    { label: "Email", value: item.email || "—", href: item.email ? `mailto:${item.email}` : "" },
    { label: "Subject", value: item.subject || "—" },
    { label: "Message", value: item.message || "—" },
    { label: "Received", value: formatDate(item.created_at) },
  ];
});

const confirmModal = ref({
  show: false,
  eyebrow: "CONFIRM",
  title: "",
  message: "",
  confirmLabel: "CONFIRM",
  intent: "",
  item: null,
  loading: false,
});

const openConfirmModal = (config) => {
  confirmModal.value = {
    show: true,
    eyebrow: "CONFIRM",
    title: "",
    message: "",
    confirmLabel: "CONFIRM",
    intent: "",
    item: null,
    loading: false,
    ...config,
  };
};

const closeConfirmModal = (force = false) => {
  const shouldForce = force === true;
  if (confirmModal.value.loading && !shouldForce) return;
  confirmModal.value.show = false;
  confirmModal.value.loading = false;
};

const openSignOutConfirm = () => {
  openConfirmModal({
    eyebrow: "SESSION",
    title: "Sign out?",
    message: "You will leave the admin dashboard and return to the login screen.",
    confirmLabel: "SIGN OUT",
    intent: "signout",
  });
};

const runConfirmAction = async () => {
  if (confirmModal.value.loading) return;
  confirmModal.value.loading = true;

  try {
    if (confirmModal.value.intent === "signout") {
      performLogout();
      return;
    }

    if (confirmModal.value.intent === "delete-project") {
      await performDeleteProject(confirmModal.value.item.id);
      return;
    }

    if (confirmModal.value.intent === "delete-education") {
      await performDeleteEducation(confirmModal.value.item.id);
    }
  } finally {
    if (confirmModal.value.show) confirmModal.value.loading = false;
  }
};

// ── Projects ──────────────────────────────────────
const projects = ref([]);
const projectSearch = ref("");
const saving = ref(false);
const projectsLoading = ref(false);

const filteredProjects = computed(() => {
  const q = projectSearch.value.toLowerCase();
  if (!q) return projects.value;
  return projects.value.filter(
    (p) =>
      p.title?.toLowerCase().includes(q) ||
      parseTags(p.tags).some((t) => t.toLowerCase().includes(q))
  );
});

const fetchProjects = async () => {
  projectsLoading.value = true;
  try {
    const res = await fetch(`${API_URL}/api/projects`);
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not load projects");
    projects.value = data.data || [];
  } catch (err) {
    showToast(err.message, "error");
  } finally {
    projectsLoading.value = false;
  }
};

const projectModal = ref({ show: false, id: null });
const projectForm = ref({
  title: "",
  description: "",
  tags: "",
  link_project: "",
  link_label: "",
});

const openProjectModal = (p) => {
  if (p) {
    projectForm.value = { ...p, tags: parseTags(p.tags).join(", ") };
    projectModal.value = { show: true, id: p.id };
  } else {
    projectForm.value = {
      title: "",
      description: "",
      tags: "",
      link_project: "",
      link_label: "",
    };
    projectModal.value = { show: true, id: null };
  }
};

const submitProject = async () => {
  saving.value = true;
  try {
    const isEdit = Boolean(projectModal.value.id);
    const url = isEdit
      ? `${API_URL}/api/projects/${projectModal.value.id}`
      : `${API_URL}/api/projects`;
    const res = await fetch(url, {
      method: isEdit ? "PUT" : "POST",
      headers: authHeaders(),
      body: JSON.stringify(projectForm.value),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not save project");
    showToast(isEdit ? "Project updated" : "Project created");
    projectModal.value.show = false;
    await fetchProjects();
  } catch (err) {
    showToast(err.message, "error");
  } finally {
    saving.value = false;
  }
};

const deleteProject = (project) => {
  openConfirmModal({
    eyebrow: "DELETE",
    title: "Delete project?",
    message: `This will permanently delete "${project.title || "this project"}".`,
    confirmLabel: "DELETE",
    intent: "delete-project",
    item: project,
  });
};

const performDeleteProject = async (id) => {
  try {
    const res = await fetch(`${API_URL}/api/projects/${id}`, {
      method: "DELETE",
      headers: authHeaders(),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not delete project");
    showToast("Project deleted");
    closeDetailModal();
    closeConfirmModal(true);
    await fetchProjects();
  } catch (err) {
    showToast(err.message, "error");
  }
};

// ── Education ─────────────────────────────────────
const educations = ref([]);
const educationsLoading = ref(false);

const fetchEducations = async () => {
  educationsLoading.value = true;
  try {
    const res = await fetch(`${API_URL}/api/educations`);
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not load education");
    educations.value = data.data || [];
  } catch (err) {
    showToast(err.message, "error");
  } finally {
    educationsLoading.value = false;
  }
};

const educationModal = ref({ show: false, id: null });
const educationForm = ref({
  year: "",
  degree: "",
  school: "",
  description: "",
});

const openEducationModal = (e) => {
  if (e) {
    educationForm.value = { ...e };
    educationModal.value = { show: true, id: e.id };
  } else {
    educationForm.value = { year: "", degree: "", school: "", description: "" };
    educationModal.value = { show: true, id: null };
  }
};

const submitEducation = async () => {
  saving.value = true;
  try {
    const isEdit = Boolean(educationModal.value.id);
    const url = isEdit
      ? `${API_URL}/api/educations/${educationModal.value.id}`
      : `${API_URL}/api/educations`;
    const res = await fetch(url, {
      method: isEdit ? "PUT" : "POST",
      headers: authHeaders(),
      body: JSON.stringify(educationForm.value),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not save education");
    showToast(isEdit ? "Education updated" : "Education entry created");
    educationModal.value.show = false;
    await fetchEducations();
  } catch (err) {
    showToast(err.message, "error");
  } finally {
    saving.value = false;
  }
};

const deleteEducation = (education) => {
  openConfirmModal({
    eyebrow: "DELETE",
    title: "Delete education entry?",
    message: `This will permanently delete "${education.degree || "this entry"}".`,
    confirmLabel: "DELETE",
    intent: "delete-education",
    item: education,
  });
};

const performDeleteEducation = async (id) => {
  try {
    const res = await fetch(`${API_URL}/api/educations/${id}`, {
      method: "DELETE",
      headers: authHeaders(),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not delete education");
    showToast("Entry deleted");
    closeDetailModal();
    closeConfirmModal(true);
    await fetchEducations();
  } catch (err) {
    showToast(err.message, "error");
  }
};

// ── Contacts ──────────────────────────────────────
const contacts = ref([]);
const contactSearch = ref("");
const contactsLoading = ref(false);

const filteredContacts = computed(() => {
  const q = contactSearch.value.toLowerCase();
  if (!q) return contacts.value;
  return contacts.value.filter(
    (c) =>
      c.name?.toLowerCase().includes(q) ||
      c.email?.toLowerCase().includes(q) ||
      c.subject?.toLowerCase().includes(q)
  );
});

const fetchContacts = async () => {
  contactsLoading.value = true;
  try {
    const res = await fetch(`${API_URL}/api/contacts`, {
      headers: authHeaders(),
    });
    const data = await parseResponse(res);
    if (!res.ok || !data.result)
      throw new Error(data.msg || "Could not load contacts");
    contacts.value = data.data || [];
  } catch (err) {
    showToast(err.message, "error");
  } finally {
    contactsLoading.value = false;
  }
};

// ── Init ──────────────────────────────────────────
const loadAll = () =>
  Promise.all([fetchProjects(), fetchEducations(), fetchContacts()]);

onMounted(() => {
  applyTheme();
  initParticles();
  initCursor();
  if (isAuthenticated.value) loadAll();
});
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=Space+Mono:ital,wght@0,400;0,700;1,400&display=swap");

/* ── Global tag resets — prevent style.css bleed-in ──
   style.css targets nav/section/main/aside as tag selectors which bleed in.
   We neutralize them all by scoping overrides under .adm-page ── */
.adm-page .adm-sidebar-nav {
  position: static !important;
  background: transparent !important;
  backdrop-filter: none !important;
  box-shadow: none !important;
  padding: 0 !important;
  top: unset !important;
  left: unset !important;
  right: unset !important;
  z-index: auto !important;
  justify-content: flex-start !important;
}
.adm-tab-section {
  padding: 0 !important;
}
@media (min-width: 901px) {
  .adm-main-content {
    padding: 36px 40px !important;
  }
}
.adm-sidebar {
  padding: 28px 16px !important;
  border-top: none !important;
}

/* ── Base ─────────────────────────────────────────── */
.adm-page {
  min-height: 100vh;
  background: var(--bg);
  font-family: var(--font-mono);
  color: var(--text);
  font-size: 13px;
  line-height: 1.6;
  overflow-x: hidden;
  cursor: none;
}

/* ── Cursor ───────────────────────────────────────── */
.adm-cursor {
  width: 8px;
  height: 8px;
  background: var(--accent5);
  border-radius: 50%;
  position: fixed;
  pointer-events: none;
  z-index: 9999;
  mix-blend-mode: difference;
  transition: transform 0.12s, width 0.2s, height 0.2s;
}

.adm-cursor-ring {
  width: 36px;
  height: 36px;
  border: 1.5px solid rgba(0, 255, 136, 0.4);
  border-radius: 50%;
  position: fixed;
  pointer-events: none;
  z-index: 9998;
  transition: transform 0.12s;
}

.adm-cursor.adm-hovering {
  transform: scale(3);
}
.adm-cursor-ring.adm-hovering {
  transform: scale(0);
}

html.light .adm-cursor-ring {
  border-color: rgba(18, 70, 200, 0.35);
}

/* ── Noise overlay ────────────────────────────────── */
.adm-noise-overlay {
  position: fixed;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.035'/%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 9000;
  opacity: 0.5;
}

/* ── Eyebrow shared ───────────────────────────────── */
.adm-eyebrow-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--accent);
  animation: adm-pulse 2s infinite;
  flex-shrink: 0;
}
.adm-eyebrow-text {
  font-size: 10px;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--accent);
}
.adm-eyebrow-line {
  width: 32px;
  height: 1px;
  background: var(--accent);
}

/* ── Login ────────────────────────────────────────── */
.adm-login-wrap {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  position: relative;
  overflow: hidden;
}

.adm-login-bg-glow {
  position: absolute;
  inset: 0;
  background: radial-gradient(
      ellipse 70% 60% at 50% 50%,
      rgba(0, 255, 136, 0.06) 0%,
      transparent 65%
    ),
    radial-gradient(
      ellipse 50% 40% at 20% 80%,
      rgba(123, 97, 255, 0.05) 0%,
      transparent 60%
    );
  pointer-events: none;
}

.adm-login-grid-lines {
  position: absolute;
  inset: 0;
  background-image: linear-gradient(
      rgba(255, 255, 255, 0.015) 1px,
      transparent 1px
    ),
    linear-gradient(90deg, rgba(255, 255, 255, 0.015) 1px, transparent 1px);
  background-size: 72px 72px;
  pointer-events: none;
}

.adm-login-card {
  background: var(--surface);
  border: 1px solid var(--border);
  padding: 48px 40px;
  width: 100%;
  max-width: 400px;
  position: relative;
  z-index: 1;
  animation: adm-fadeUp 0.6s ease forwards;
}

.adm-login-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, var(--accent), var(--accent3));
}

.adm-login-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 32px;
}

.adm-login-icon {
  width: 52px;
  height: 52px;
  border: 1px solid var(--border2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  color: var(--accent);
  margin: 0 auto 20px;
  position: relative;
}
.adm-login-icon::before {
  content: "";
  position: absolute;
  inset: 0;
}

.adm-login-title {
  font-family: var(--font-display);
  font-size: 28px;
  font-weight: 800;
  letter-spacing: -0.03em;
  text-align: center;
  margin: 0 0 8px;
}
.adm-accent {
  color: var(--accent);
}
.adm-login-sub {
  margin: 0 0 32px;
  font-size: 11px;
  letter-spacing: 0.1em;
  color: var(--muted);
  text-align: center;
  text-transform: uppercase;
}
.adm-login-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.adm-error-msg {
  color: var(--accent2);
  font-size: 11px;
  letter-spacing: 0.05em;
  display: flex;
  align-items: center;
  gap: 6px;
  margin: 0;
}
.adm-w-full {
  width: 100%;
  justify-content: center;
}

/* ── Dashboard layout ─────────────────────────────── */
.adm-dashboard {
  display: flex;
  min-height: 100vh;
}

/* ── Sidebar ──────────────────────────────────────── */
.adm-sidebar {
  width: 220px;
  background: var(--surface);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  padding: 28px 16px;
  flex-shrink: 0;
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}

.adm-sidebar-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 8px 28px;
  border-bottom: 1px solid var(--border);
  margin-bottom: 24px;
}
.adm-brand-dot {
  width: 8px;
  height: 8px;
  background: var(--accent);
  border-radius: 50%;
  animation: adm-pulse 2s infinite;
  flex-shrink: 0;
}
.adm-brand-text {
  font-family: var(--font-display);
  font-size: 18px;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--text);
}
.adm-brand-accent {
  color: var(--accent);
}

.adm-sidebar-menu-btn {
  display: none;
  width: 38px;
  height: 38px;
  border: 1px solid var(--border);
  background: var(--bg);
  color: var(--text);
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: border-color 0.2s, color 0.2s, background 0.2s;
}

.adm-sidebar-menu-btn:hover {
  border-color: var(--accent);
  color: var(--accent);
  background: rgba(var(--accent-rgb), 0.08);
}

.adm-sidebar-section-label {
  font-size: 9px;
  letter-spacing: 0.2em;
  color: var(--muted);
  padding: 0 8px;
  margin-bottom: 8px;
}

.adm-sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.adm-nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  background: none;
  border: 1px solid transparent;
  color: var(--muted);
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.06em;
  padding: 10px 12px;
  cursor: pointer;
  text-align: left;
  transition: all 0.2s;
  position: relative;
}
.adm-nav-item::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 2px;
  background: var(--accent);
  transform: scaleY(0);
  transition: transform 0.25s;
}
.adm-nav-item:hover {
  background: rgba(var(--accent-rgb), 0.03);
  color: var(--text);
  border-color: var(--border);
}
.adm-nav-item.active {
  background: rgba(var(--accent-rgb), 0.06);
  color: var(--accent);
  border-color: rgba(var(--accent-rgb), 0.2);
}
.adm-nav-item.active::before {
  transform: scaleY(1);
}
.adm-nav-item i {
  font-size: 14px;
  flex-shrink: 0;
}
.adm-nav-item span:not(.adm-nav-badge) {
  flex: 1;
}
.adm-nav-badge {
  background: rgba(var(--accent-rgb), 0.1);
  color: var(--accent);
  font-size: 10px;
  padding: 1px 7px;
  border: 1px solid rgba(var(--accent-rgb), 0.2);
}

.adm-sidebar-footer {
  border-top: 1px solid var(--border);
  padding-top: 16px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: auto;
}
.adm-sidebar-status {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 8px;
}
.adm-status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--accent);
  animation: adm-pulse 2s infinite;
}
.adm-status-text {
  font-size: 9px;
  letter-spacing: 0.18em;
  color: var(--muted);
}

.adm-theme-toggle-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  justify-content: center;
  width: 100%;
  padding: 9px 12px;
  border: 1px solid var(--border);
  background: transparent;
  color: var(--muted);
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  cursor: pointer;
  transition: all 0.2s;
}
.adm-theme-toggle-btn:hover {
  border-color: var(--accent);
  color: var(--accent);
  background: rgba(var(--accent-rgb), 0.08);
}
.adm-theme-toggle-btn i {
  font-size: 14px;
}

.adm-logout-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: none;
  border: 1px solid var(--border);
  color: var(--muted);
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  cursor: pointer;
  padding: 9px 12px;
  transition: all 0.2s;
  width: 100%;
}
.adm-logout-btn:hover {
  border-color: var(--accent2);
  color: var(--accent2);
  background: rgba(255, 60, 110, 0.05);
}

/* ── Main content ─────────────────────────────────── */
.adm-main-content {
  flex: 1;
  min-width: 0;
  padding: 36px 40px;
  overflow-y: auto;
  height: 100vh;
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.adm-main-grid-lines {
  position: fixed;
  inset: 0;
  background-image: linear-gradient(
      rgba(255, 255, 255, 0.012) 1px,
      transparent 1px
    ),
    linear-gradient(90deg, rgba(255, 255, 255, 0.012) 1px, transparent 1px);
  background-size: 72px 72px;
  pointer-events: none;
  z-index: 0;
}

/* ── Page header ──────────────────────────────────── */
.adm-page-header {
  position: relative;
  z-index: 1;
  flex-shrink: 0;
}
.adm-page-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}
.adm-page-title {
  font-family: var(--font-display);
  font-size: 40px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1;
}

/* ── Toast ────────────────────────────────────────── */
.adm-toast {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 20px;
  font-size: 12px;
  letter-spacing: 0.06em;
  font-weight: 500;
  border: 1px solid;
  box-shadow: var(--shadow);
  font-family: var(--font-mono);
}
.adm-toast-success {
  background: rgba(0, 255, 136, 0.08);
  color: var(--accent);
  border-color: rgba(0, 255, 136, 0.3);
}
.adm-toast-error {
  background: rgba(255, 60, 110, 0.08);
  color: var(--accent2);
  border-color: rgba(255, 60, 110, 0.3);
}
.adm-toast-enter-active,
.adm-toast-leave-active {
  transition: opacity 0.25s, transform 0.25s;
}
.adm-toast-enter-from,
.adm-toast-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

/* ── Stats row ────────────────────────────────────── */
.adm-stats-row {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  position: relative;
  z-index: 1;
  flex-shrink: 0;
}

.adm-stat-card {
  background: var(--surface);
  border: 1px solid var(--border);
  padding: 24px 28px;
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  overflow: hidden;
  transition: border-color 0.3s, box-shadow 0.3s;
}
.adm-stat-card::before {
  content: "";
  position: absolute;
  inset: 0;
  background: radial-gradient(
    ellipse 80% 60% at 20% 50%,
    var(--border2),
    transparent 70%
  );
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}
.adm-stat-card:hover {
  border-color: var(--border2);
  box-shadow: var(--glow);
}
.adm-stat-card:hover::before {
  opacity: 0.2;
}
.adm-stat-icon-wrap {
  font-size: 22px;
  color: var(--accent);
  width: 44px;
  height: 44px;
  border: 1px solid var(--accent);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.adm-stat-value {
  font-family: var(--font-display);
  font-size: 32px;
  font-weight: 800;
  line-height: 1;
  letter-spacing: -0.03em;
}
.adm-stat-label {
  font-size: 9px;
  letter-spacing: 0.2em;
  color: var(--muted);
  margin-top: 4px;
}
.adm-stat-line {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, var(--accent), transparent);
  opacity: 0;
  transition: opacity 0.3s;
}
.adm-stat-card:hover .adm-stat-line {
  opacity: 1;
}

/* ── Tab Section ──────────────────────────────────── */
.adm-tab-section {
  background: var(--surface);
  border: 1px solid var(--border);
  position: relative;
  z-index: 1;
  overflow: hidden;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

.adm-tab-section::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(
    90deg,
    var(--accent),
    var(--accent3),
    transparent
  );
}

.adm-section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  padding: 24px 28px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
.adm-section-eyebrow {
  font-size: 9px;
  letter-spacing: 0.2em;
  color: var(--accent);
  display: block;
  margin-bottom: 6px;
}
.adm-section-title {
  font-family: var(--font-display);
  font-size: 22px;
  font-weight: 800;
  letter-spacing: -0.02em;
  margin: 0;
}
.adm-section-sub {
  margin: 4px 0 0;
  font-size: 11px;
  color: var(--muted);
  letter-spacing: 0.04em;
}

.adm-search-row {
  padding: 16px 28px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
.adm-search-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg);
  border: 1px solid var(--border);
  padding: 0 14px;
  max-width: 360px;
  transition: border-color 0.25s;
}
.adm-search-wrap:focus-within {
  border-color: var(--accent);
}
.adm-search-wrap i {
  color: var(--muted);
  font-size: 13px;
}
.adm-search-wrap input {
  border: none;
  background: transparent;
  padding: 10px 0;
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--text);
  width: 100%;
  outline: none;
}
.adm-search-wrap input::placeholder {
  color: var(--muted);
}

/* ── Table ────────────────────────────────────────── */
.adm-table-wrap {
  overflow-x: auto;
  flex: 1;
}

table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

thead th {
  padding: 12px 16px;
  text-align: left;
  font-family: var(--font-mono);
  font-size: 9px;
  font-weight: 700;
  color: var(--muted);
  letter-spacing: 0.15em;
  border-bottom: 1px solid var(--border);
  background: var(--bg);
  white-space: nowrap;
  overflow: hidden;
}

tbody tr {
  border-bottom: 1px solid var(--border);
  transition: background 0.15s;
}
tbody tr:hover {
  background: rgba(var(--accent-rgb), 0.02);
}
tbody tr:last-child {
  border-bottom: none;
}

.adm-clickable-row {
  cursor: pointer;
}

.adm-clickable-row:hover {
  background: rgba(var(--accent-rgb), 0.05);
}

td {
  padding: 13px 16px;
  vertical-align: middle;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.adm-id-cell {
  color: var(--muted);
  font-size: 11px;
}
.adm-title-cell {
  font-family: var(--font-display);
  font-size: 14px;
  font-weight: 700;
  letter-spacing: -0.01em;
}
.adm-desc-cell {
  color: var(--muted);
  font-size: 12px;
}

td:has(.adm-tag) {
  white-space: normal;
}

.adm-empty-cell {
  text-align: center;
  padding: 48px;
  color: var(--muted);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  font-size: 12px;
  letter-spacing: 0.06em;
  white-space: normal;
}
.adm-empty-cell i {
  font-size: 28px;
  opacity: 0.4;
}

.adm-skeleton-row:hover {
  background: transparent;
}

.adm-skeleton {
  display: inline-block;
  height: 12px;
  width: 100%;
  max-width: 160px;
  border-radius: 999px;
  background: linear-gradient(
    90deg,
    var(--surface2) 0%,
    rgba(var(--accent-rgb), 0.12) 45%,
    var(--surface2) 90%
  );
  background-size: 220% 100%;
  animation: admSkeletonPulse 1.35s ease-in-out infinite;
  opacity: 0.86;
}

.adm-skeleton-id {
  width: 18px;
}

.adm-skeleton-title {
  width: 78%;
}

.adm-skeleton-title.short {
  width: 58%;
}

.adm-skeleton-text {
  max-width: none;
  width: 92%;
}

.adm-skeleton-tag {
  width: 56px;
  height: 20px;
  margin-right: 6px;
  border-radius: 4px;
}

.adm-skeleton-tag.short {
  width: 42px;
}

.adm-skeleton-icon {
  width: 24px;
  height: 24px;
  border-radius: 6px;
}

.adm-skeleton-actions {
  width: 56px;
  height: 28px;
  border-radius: 6px;
}

.adm-skeleton-badge {
  width: 64px;
  height: 22px;
  border-radius: 4px;
}

.adm-skeleton-email {
  width: 84%;
}

.adm-skeleton-date {
  width: 72px;
}

@keyframes admSkeletonPulse {
  0% {
    background-position: 220% 0;
  }
  100% {
    background-position: -220% 0;
  }
}

.adm-muted {
  color: var(--muted);
  font-size: 11px;
}

.adm-tag {
  display: inline-block;
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--muted);
  font-size: 9px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 3px 9px;
  margin: 2px 2px 2px 0;
  transition: all 0.2s;
}
.adm-tag:hover {
  border-color: var(--accent);
  color: var(--accent);
}

.adm-year-badge {
  background: rgba(var(--accent-rgb), 0.1);
  border: 1px solid rgba(var(--accent-rgb), 0.3);
  color: var(--accent);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
  padding: 3px 10px;
  font-family: var(--font-mono);
}

.adm-link-icon {
  color: var(--accent);
  font-size: 14px;
  text-decoration: none;
  transition: color 0.2s;
  opacity: 0.7;
}
.adm-link-icon:hover {
  opacity: 1;
}

.adm-email-link {
  color: var(--accent);
  text-decoration: none;
  font-size: 11px;
  letter-spacing: 0.02em;
  opacity: 0.8;
  transition: opacity 0.2s;
}
.adm-email-link:hover {
  opacity: 1;
  text-decoration: underline;
}

.adm-action-btns {
  display: flex;
  gap: 6px;
}
.adm-btn-icon {
  width: 30px;
  height: 30px;
  border: 1px solid var(--border);
  background: var(--bg);
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: var(--muted);
  transition: all 0.15s;
  flex-shrink: 0;
}
.adm-btn-icon:hover {
  border-color: var(--accent);
  color: var(--accent);
  background: rgba(var(--accent-rgb), 0.08);
}
.adm-btn-icon-danger:hover {
  border-color: var(--accent2) !important;
  color: var(--accent2) !important;
  background: rgba(255, 60, 110, 0.08) !important;
}

/* ── Buttons ──────────────────────────────────────── */
.adm-btn-primary {
  background: var(--accent);
  color: var(--bg);
  border: none;
  padding: 11px 20px;
  font-family: var(--font-mono);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  position: relative;
  overflow: hidden;
  transition: color 0.3s, transform 0.2s;
  clip-path: polygon(
    0 0,
    calc(100% - 10px) 0,
    100% 10px,
    100% 100%,
    10px 100%,
    0 calc(100% - 10px)
  );
  white-space: nowrap;
  flex-shrink: 0;
}
.adm-btn-primary::before {
  content: "";
  position: absolute;
  inset: 0;
  background: #000;
  transform: translateX(-101%);
  transition: transform 0.3s ease;
}
.adm-btn-primary:hover::before {
  transform: translateX(0);
}
.adm-btn-primary:hover {
  color: #fff;
  transform: translateY(-1px);
}
.adm-btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}
.adm-btn-primary span {
  position: relative;
  z-index: 1;
}

.adm-btn-danger {
  background: var(--accent2);
}

.adm-btn-outline {
  background: transparent;
  color: var(--muted);
  border: 1px solid var(--border);
  padding: 10px 18px;
  font-family: var(--font-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  position: relative;
  overflow: hidden;
  transition: all 0.25s;
  white-space: nowrap;
  flex-shrink: 0;
}
.adm-btn-outline::before {
  content: "";
  position: absolute;
  inset: 0;
  background: var(--accent);
  transform: translateX(-101%);
  transition: transform 0.3s ease;
  opacity: 0.08;
}
.adm-btn-outline:hover {
  border-color: var(--accent);
  color: var(--accent);
}
.adm-btn-outline:hover::before {
  transform: translateX(0);
}
.adm-btn-outline span {
  position: relative;
  z-index: 1;
}

/* ── Form fields ──────────────────────────────────── */
.adm-fg {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.adm-fl {
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--muted);
}
.adm-fl-hint {
  font-size: 9px;
  color: var(--muted2);
  text-transform: none;
  letter-spacing: 0;
}
.adm-fi {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--text);
  padding: 11px 14px;
  font-family: var(--font-mono);
  font-size: 12px;
  outline: none;
  transition: border-color 0.25s, box-shadow 0.25s;
  width: 100%;
  box-sizing: border-box;
  resize: vertical;
}
.adm-fi::placeholder {
  color: var(--muted);
}
.adm-fi:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(var(--accent-rgb), 0.08);
}
.adm-password-wrap {
  position: relative;
}
.adm-password-input {
  padding-right: 46px;
}
.adm-password-toggle {
  position: absolute;
  top: 50%;
  right: 8px;
  width: 34px;
  height: 34px;
  transform: translateY(-50%);
  border: 0;
  background: transparent;
  color: var(--muted);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: color 0.2s, background 0.2s;
}
.adm-password-toggle:hover,
.adm-password-toggle:focus-visible {
  color: var(--accent);
  background: rgba(var(--accent-rgb), 0.06);
  outline: none;
}
.adm-req {
  color: var(--accent2);
}
.adm-form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

/* ── Modal ────────────────────────────────────────── */
.adm-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(6, 6, 8, 0.85);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.adm-modal-card {
  background: var(--surface);
  border: 1px solid var(--border);
  width: 100%;
  max-width: 480px;
  padding: 32px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow);
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 20px;
  animation: adm-fadeUp 0.3s ease forwards;
}
.adm-modal-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, var(--accent), var(--accent3));
}
.adm-modal-card form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.adm-detail-modal-card {
  max-width: 620px;
}

.adm-confirm-modal-card {
  max-width: 440px;
}

.adm-modal-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}
.adm-modal-eyebrow {
  font-size: 9px;
  letter-spacing: 0.2em;
  color: var(--accent);
  margin-bottom: 4px;
}
.adm-modal-header h3 {
  margin: 0;
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.02em;
}

.adm-modal-close {
  background: none;
  border: 1px solid var(--border);
  cursor: pointer;
  font-size: 13px;
  color: var(--muted);
  padding: 6px 8px;
  display: flex;
  align-items: center;
  transition: all 0.2s;
  flex-shrink: 0;
}
.adm-modal-close:hover {
  border-color: var(--accent2);
  color: var(--accent2);
}
.adm-modal-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 4px;
}

.adm-detail-list {
  display: grid;
  gap: 10px;
}

.adm-detail-item {
  display: grid;
  grid-template-columns: 130px minmax(0, 1fr);
  gap: 14px;
  padding: 12px 0;
  border-bottom: 1px solid var(--border);
}

.adm-detail-item:last-child {
  border-bottom: none;
}

.adm-detail-label {
  color: var(--muted);
  font-family: var(--font-mono);
  font-size: 9px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.adm-detail-value {
  color: var(--text);
  font-size: 12px;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
}

.adm-detail-link {
  color: var(--accent);
  text-decoration: none;
}

.adm-detail-link:hover {
  text-decoration: underline;
}

.adm-confirm-message {
  margin: 0;
  color: var(--muted);
  font-size: 12px;
  line-height: 1.7;
}

/* ── Animations ───────────────────────────────────── */
@keyframes adm-fadeUp {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
@keyframes adm-pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.4;
  }
}

/* ── Responsive ───────────────────────────────────── */
@media (max-width: 900px) {
  .adm-page {
    cursor: auto;
  }

  .adm-cursor,
  .adm-cursor-ring {
    display: none;
  }

  .adm-dashboard {
    flex-direction: column;
  }

  .adm-sidebar {
    width: 100%;
    height: auto;
    position: sticky;
    top: 0;
    z-index: 800;
    overflow: hidden;
    flex-direction: row;
    flex-wrap: wrap;
    padding: 12px 16px !important;
    align-items: center;
    gap: 10px;
    border-right: none;
    border-bottom: 1px solid var(--border);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.18);
  }

  .adm-sidebar-brand {
    border-bottom: none;
    padding: 0;
    margin-bottom: 0;
    flex: 1 1 auto;
    min-width: 180px;
    justify-content: flex-start;
  }

  .adm-sidebar-menu-btn {
    display: inline-flex;
    margin-left: auto;
  }

  .adm-sidebar-section-label {
    display: none;
  }

  .adm-sidebar-nav {
    display: none !important;
    flex-direction: row;
    order: 3;
    flex: 0 0 100%;
    width: 100%;
    min-width: 0;
    gap: 6px;
    overflow-x: auto;
    flex-wrap: nowrap;
    scrollbar-width: none;
    -webkit-overflow-scrolling: touch;
    padding-top: 10px !important;
  }

  .adm-sidebar-nav.open {
    display: flex !important;
  }

  .adm-sidebar-nav::-webkit-scrollbar {
    display: none;
  }

  .adm-nav-item {
    flex: 0 0 auto;
    min-width: 128px;
    justify-content: center;
    padding: 9px 12px;
  }

  .adm-nav-item span:not(.adm-nav-badge) {
    flex: 0 1 auto;
  }

  .adm-nav-item::before {
    left: 8px;
    right: 8px;
    top: auto;
    bottom: 0;
    width: auto;
    height: 2px;
    transform: scaleX(0);
  }

  .adm-nav-item.active::before {
    transform: scaleX(1);
  }

  .adm-sidebar-footer {
    display: none;
    border-top: none;
    padding-top: 10px;
    flex-direction: row;
    order: 4;
    flex: 0 0 100%;
    width: 100%;
    margin-left: 0;
    margin-top: 0;
    gap: 8px;
    justify-content: flex-end;
  }

  .adm-sidebar-footer.open {
    display: flex;
  }

  .adm-sidebar-status {
    display: none;
  }

  .adm-theme-toggle-btn,
  .adm-logout-btn {
    width: auto;
    min-height: 38px;
    padding: 9px 12px;
  }

  .adm-main-content {
    height: auto;
    overflow-y: visible;
    padding: 20px 16px;
  }

  .adm-stats-row {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .adm-form-row {
    grid-template-columns: 1fr;
  }
  .adm-page-title {
    font-size: 28px;
  }
}

@media (max-width: 560px) {
  .adm-sidebar {
    padding: 10px 12px !important;
    gap: 8px;
  }

  .adm-sidebar-brand {
    width: 100%;
    justify-content: space-between;
    padding-right: 0;
    min-width: 0;
  }

  .adm-brand-text {
    font-size: 16px;
  }

  .adm-sidebar-nav {
    order: 3;
    flex-basis: 100%;
    width: 100%;
    padding-bottom: 2px !important;
  }

  .adm-nav-item {
    min-width: 104px;
    gap: 7px;
    padding: 8px 10px;
    font-size: 10px;
  }

  .adm-nav-item i {
    font-size: 13px;
  }

  .adm-nav-badge {
    font-size: 9px;
    padding: 0 6px;
  }

  .adm-sidebar-footer {
    position: static;
    justify-content: stretch;
  }

  .adm-theme-toggle-btn,
  .adm-logout-btn {
    flex: 1;
    width: auto;
    height: 36px;
    min-height: 36px;
    padding: 0 10px;
  }

  .adm-theme-toggle-btn span,
  .adm-logout-btn span {
    display: inline;
  }

  .adm-stats-row {
    grid-template-columns: 1fr;
  }
  .adm-detail-item {
    grid-template-columns: 1fr;
    gap: 4px;
  }
  .adm-section-header {
    flex-direction: column;
    align-items: flex-start;
  }
  .adm-page-title {
    font-size: 24px;
  }
}

@media (max-width: 500px) {
  .adm-login-title {
    font-size: 22px;
  }
}
</style>
