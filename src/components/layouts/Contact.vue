<template>
  <section id="contact" ref="sectionRef" class="contact-section">
    <div class="section-header reveal">
      <span class="section-eyebrow">06 / Contact</span>
      <h2 class="section-title">
        Let's <span class="highlight">Connect</span>
      </h2>
      <div class="section-rule"></div>
    </div>
    <div class="contact-grid reveal">
      <div>
        <h2 class="contact-big">
          Let's build<br />something<br /><span class="acc">great.</span>
        </h2>
        <p class="contact-sub">
          Have a project in mind? Looking for a developer who cares about
          quality and detail? I'd love to hear from you — whether it's a full
          website, a landing page, or just a question.
        </p>
        <div class="social-row">
          <a href="https://t.me/Sal_4u" target="_blank" class="soc-link"
            ><span>Telegram</span><span>→</span></a
          >
          <a href="https://github.com/mrrvisal" target="_blank" class="soc-link"
            ><span>GitHub</span><span>→</span></a
          >
          <a href="mailto:mrrvisal617@gmail.com" class="soc-link"
            ><span>mrrvisal617@gmail.com</span><span>→</span></a
          >
          <a href="tel:+85510584267" class="soc-link"
            ><span>+855 10 58 42 67</span><span>→</span></a
          >
        </div>
      </div>
      <form @submit.prevent="handleSubmit" class="form">
        <div class="form-row">
          <div class="fg">
            <label class="fl">Name</label>
            <input
              type="text"
              class="fi"
              placeholder="Your full name"
              v-model="contactForm.name"
              :class="{ error: errors.name }"
              @input="validateForm"
            />
            <small class="error">{{ errors.name }}</small>
          </div>
          <div class="fg">
            <label class="fl">Email</label>
            <input
              type="email"
              class="fi"
              placeholder="your@email.com"
              v-model="contactForm.email"
              :class="{ error: errors.email }"
              @input="validateForm"
            />
            <small class="error">{{ errors.email }}</small>
          </div>
        </div>
        <div class="fg">
          <label class="fl">Subject</label>
          <input
            type="text"
            class="fi"
            placeholder="Project inquiry, collaboration..."
            v-model="contactForm.subject"
            :class="{ error: errors.subject }"
            @input="validateForm"
          />
          <small class="error">{{ errors.subject }}</small>
        </div>
        <div class="fg">
          <label class="fl">Message</label>
          <textarea
            class="fi"
            placeholder="Tell me about your project or idea..."
            v-model="contactForm.message"
            @input="validateForm"
            :class="{ error: errors.message }"
          ></textarea>
          <small class="error">{{ errors.message }}</small>
        </div>
        <button type="submit" class="fsub" :disabled="loading">
          <span v-if="!loading">Send Message →</span>
          <span v-else>
            <span
              class="spinner-border spinner-border-sm"
              role="status"
              aria-hidden="true"
            ></span>
            Sending...
          </span>
        </button>
      </form>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive } from "vue";
import { useContactStore } from "@/stores/contact";
import { useToast } from "@/composables/useToast";
const { show } = useToast();

const loading = ref(false);
const contactStore = useContactStore();
const errors = reactive({ name: "", email: "", subject: "", message: "" });
const contactForm = reactive({ name: "", email: "", subject: "", message: "" });
const sectionRef = ref(null);

const validateForm = () => {
  let isValid = true;

  // reset errors
  Object.keys(errors).forEach((key) => (errors[key] = ""));

  if (!contactForm.name.trim()) {
    errors.name = "Name is required";
    isValid = false;
  }

  if (!contactForm.email.trim()) {
    errors.email = "Email is required";
    isValid = false;
  } else if (!/\S+@\S+\.\S+/.test(contactForm.email.trim())) {
    errors.email = "Invalid email format";
    isValid = false;
  }

  if (!contactForm.subject.trim()) {
    errors.subject = "Subject is required";
    isValid = false;
  }

  if (!contactForm.message.trim()) {
    errors.message = "Message is required";
    isValid = false;
  } else if (contactForm.message.trim().length < 10) {
    errors.message = "Message must be at least 10 characters";
    isValid = false;
  } else {
    errors.message = "";
  }

  return isValid;
};
const handleSubmit = async () => {
  try {
    if (!validateForm()) return;
    loading.value = true;

    const result = await contactStore.createContact(contactForm);

    if (result) {
      Object.assign(contactForm, { name: "", email: "", subject: "", message: "" });
      show({ message: "Message sent! I'll get back to you soon.", type: "success" });
    } else {
      show({ message: "Something went wrong. Please try again.", type: "error" });
    }
  } catch (error) {
    console.error(error);
    show({ message: "Failed to send message. Please try again.", type: "error" });
  } finally {
    loading.value = false;
  }
};

const scrollToSection = () => {
  sectionRef.value.scrollIntoView({
    behavior: "smooth",
  });
};

//  IMPORTANT (Vue 3)
defineExpose({
  scrollToSection,
});
</script>