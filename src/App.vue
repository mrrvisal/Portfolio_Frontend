<template>
  <div>
    <RouterView />
    <ToastContainer />  <!-- ← add this -->
  </div>
</template>

<script setup>
import ToastContainer from "@/components/base/ToastContainer.vue";
</script>