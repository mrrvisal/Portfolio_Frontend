import { ref } from "vue";
import { defineStore } from "pinia";

const API_URL = import.meta.env.VITE_API_URL;

export const useContactStore = defineStore("contact", () => {
  // state
  const contact = ref([]);
  const loading = ref(false);
  const error = ref(null);

  const createContact = async (formData) => {
    loading.value = true;
    error.value = null;

    try {
      const res = await fetch(`${API_URL}/api/contact`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      // check response
      if (!res.ok) {
        throw new Error("API error: " + res.status);
      }

      const data = await res.json();
      // console.log("POST result:", data);

      // optional: push new contact into list
      contact.value.push(data);

      return data;
    } catch (err) {
      error.value = err.message || "Failed to create contact";
      console.error(err);
    } finally {
      loading.value = false;
    }
  };
  const getContacts = async () => {
    loading.value = true;
    error.value = null;

    try {
      const res = await fetch(`${API_URL}/api/contacts`);

      // check response
      if (!res.ok) {
        throw new Error("API error: " + res.status);
      }

      const response = await res.json();
      const data = response.data;
      // console.log("GET result:", data);
      return data;
    } catch (err) {
      error.value = err.message || "Failed to fetch contacts";
      console.error(err);
    } finally {
      loading.value = false;
    }
  };

  return {
    contact,
    loading,
    error,
    createContact,
    getContacts,
  };
});