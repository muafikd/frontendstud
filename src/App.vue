<template>
  <div id="app">
    <Navbar v-if="!hideNavbar" />
    <router-view />
  </div>
</template>

<script>
import Navbar from "./components/Navbar.vue";

export default {
  components: {
    Navbar,
  },
  computed: {
    hideNavbar() {
      // Specify the routes where the navbar should be hidden
      const routesWithoutNavbar = ["/login", "/register", "/class-login", "/class-register"];
      return routesWithoutNavbar.includes(this.$route.path);
    },
  },
};
</script>

<style>
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  /* background-color: #f4f4f4; */
}
</style>
