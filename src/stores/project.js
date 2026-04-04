import { ref } from "vue";
import { defineStore } from "pinia";
const API_URL = import.meta.env.VITE_API_URL;


export const useProjectStore = defineStore("project", () => {
  // state
  const project = ref([]);
  const loading = ref(false);
  const error = ref(null);

  const getProjects = async (formData) => {
    loading.value = true;
    error.value = null;

    try {
      const res = await fetch(`${API_URL}/api/projects`);

      // check response
      if (!res.ok) {
        throw new Error("API error: " + res.status);
      }

      const response = await res.json();
      const data = response.data
      // console.log("GET result:", data);
      return data;
    } catch (err) {
      error.value = err.message || "Failed to create projects";
      console.error(err);
      project.value = [];
    } finally {
      loading.value = false;
    }
  };
  return {
    project,
    loading,
    error,
    getProjects,
  };
});
