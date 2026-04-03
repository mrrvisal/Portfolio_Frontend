import { ref } from "vue";
import { defineStore } from "pinia";

export const useEducationStore = defineStore("education", () => {
  // state
  const education = ref([]);
  const loading = ref(false);
  const error = ref(null);

  const getEducations = async (formData) => {
    loading.value = true;
    error.value = null;

    try {
      const res = await fetch("http://localhost:3000/api/educations");

      // check response
      if (!res.ok) {
        throw new Error("API error: " + res.status);
      }

      const response = await res.json();
      const data = response.data;
      // console.log("GET result:", data);
      return data;
    } catch (err) {
      error.value = err.message || "Failed to create Educations";
      console.error(err);
    } finally {
      loading.value = false;
    }
  };
  return {
    education,
    loading,
    error,
    getEducations,
  };
});
