<template>
  <div class="game" @click="click">
    <img class="player" :src="dinoPng" :style="{ top: `${dinoY}px` }" />
  </div>
</template>

<script>
import { HapticsImpactStyle, Plugins } from "@capacitor/core";
import dinoPng from "../../../assets/images/dino.png";

const { Haptics } = Plugins;
export default {
  data() {
    return {
      dinoPng,
      dinoY: 350,
      dinoYVelocity: 0,
      force: -0.3,
      jumpForce: 6,
      gameInterval: null,
    };
  },

  mounted() {
    this.gameInterval = setInterval(() => this.gameLoop(), 1000 / 30);
  },

  beforeDestroy() {
    clearInterval(this.gameInterval);
  },

  methods: {
    gameLoop() {
      this.dinoYVelocity += this.force;
      this.dinoY -= this.dinoYVelocity;
    },

    click() {
      Haptics.impact({ style: HapticsImpactStyle.Heavy });
      this.dinoYVelocity = this.jumpForce;
    },
  },
};
</script>

<style lang="scss" scoped>
.game {
  position: relative;
  height: 100%;
  background: #70c5ce url("../../../assets/images/background.png") 0 100% no-repeat;
}

.player {
  position: absolute;
  left: 50%;
  width: 60px;
  transform: translate(-50%, -50%);
}
</style>
