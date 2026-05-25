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
