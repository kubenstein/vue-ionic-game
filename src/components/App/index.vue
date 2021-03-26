<template>
  <router-view></router-view>
</template>

<script>
export default {
  mounted() {
    window.screen.orientation.lock("portrait");
  },
};
</script>

<style lang="scss">
html {
  height: 100%;
}

body {
  height: 100%;
  font-family: Tahoma, sans-serif;
}

html,
body,
h1,
p {
  margin: 0;
  padding: 0;
}

* {
  box-sizing: border-box;
  outline: none;
  user-select: none;
}
</style>
