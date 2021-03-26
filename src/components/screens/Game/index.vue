<template>
  <div class="game" @click="click">
    <img class="player" :src="dinoPng" :style="{ top: `${dinoY}px` }" />
    <img
      v-for="obstacle in obstacles"
      :key="obstacle.id"
      class="obstacle"
      :src="obstaclePng"
      :style="{ left: `${obstacle.x}px`, top: `${obstacle.y}px` }"
    />
  </div>
</template>

<script>
import { HapticsImpactStyle, Plugins } from "@capacitor/core";
import dinoPng from "../../../assets/images/dino.png";
import obstaclePng from "../../../assets/images/obstacle.png";

const { Haptics } = Plugins;
export default {
  data() {
    return {
      dinoPng,
      obstaclePng,
      dinoY: 350,
      dinoYVelocity: 0,
      force: -0.5,
      jumpForce: 6,
      obstacles: [
        { id: 1, x: 414, y: -250 },
        { id: 2, x: 2 * 300, y: -250 },
        { id: 3, x: 3 * 300, y: -0 },
        { id: 4, x: 4 * 300, y: -150 },
      ],
      obstacleYVelocity: 3,
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
    click() {
      Haptics.impact({ style: HapticsImpactStyle.Heavy });
      this.dinoYVelocity = this.jumpForce;
    },

    gameLoop() {
      this.adjustDinoVelocity();
      this.moveAndRemoveObstacles();
    },

    adjustDinoVelocity() {
      this.dinoYVelocity += this.force;
      this.dinoY -= this.dinoYVelocity;
    },

    moveAndRemoveObstacles() {
      this.obstacles = this.obstacles
        .map((obstacle) => ({
          ...obstacle,
          x: obstacle.x - this.obstacleYVelocity,
        }))
        .filter((obstacle) => obstacle.x > -60);
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

.obstacle {
  position: absolute;
  width: 60px;
}
</style>
