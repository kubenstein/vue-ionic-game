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
@font-face {
  font-family: "Press Start 2P";
  src: url("../../assets/fonts/PressStart2P-Regular.ttf") format("truetype");
}

html {
  height: 100%;
}

body {
  height: 100%;
  font-family: "Press Start 2P", Tahoma, sans-serif;
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
