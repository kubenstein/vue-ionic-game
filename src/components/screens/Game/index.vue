<template>
  <div class="game" @click="click">
    <img class="player" :src="dinoPng" :style="{ left: `${dinoX}px`, top: `${dinoY}px` }" />
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
      dinoX: 50,
      dinoYVelocity: 0,
      force: -0.5,
      jumpForce: 6,
      obstacles: [
        { id: 1, x: 414, y: -250, gapStarts: 474, gapEnds: 628 },
        { id: 2, x: 2 * 300, y: -250, gapStarts: 474, gapEnds: 628 },
        { id: 3, x: 3 * 300, y: -0, gapStarts: 474, gapEnds: 628 },
        { id: 4, x: 4 * 300, y: -150, gapStarts: 474, gapEnds: 628 },
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
      this.detectCollision();
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

    detectCollision() {
      const possibleCollision = this.obstacles.filter(
        (obstacle) => obstacle.x < this.dinoX + 60 && obstacle.x >= this.dinoX
      )[0];
      if (!possibleCollision) return;
      const collision =
        this.dinoY < possibleCollision.gapStarts + possibleCollision.y ||
        this.dinoY + 60 > possibleCollision.gapEnds + possibleCollision.y;

      if (collision) alert("hit");
    },
  },
};
</script>

<style lang="scss" scoped>
.game {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: #70c5ce url("../../../assets/images/background.png") 0 100% no-repeat;
}

.player {
  position: absolute;
  width: 60px;
  height: 60px;
}

.obstacle {
  position: absolute;
  width: 60px;
}
</style>
