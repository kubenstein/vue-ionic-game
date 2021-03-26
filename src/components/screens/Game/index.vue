<template>
  <div ref="screen" class="game" @click="click">
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
import { randomNumberBetween } from "../../../lib/utils";
import dinoPng from "../../../assets/images/dino.png";
import obstaclePng from "../../../assets/images/obstacle.png";

const { Haptics } = Plugins;

const STATE = {
  idle: "idle",
  play: "play",
  gameOver: "gameOver",
};

export default {
  data() {
    return {
      dinoPng,
      obstaclePng,

      state: STATE.idle,
      dinoY: 350,
      dinoX: 50,
      dinoYVelocity: 0,
      force: -0.5,
      jumpForce: 6,
      maxObstacleCount: 5,
      obstacleGap: 200,
      obstacles: [],
      obstacleYVelocity: 3,
      gameInterval: null,
    };
  },

  watch: {
    state(newValue) {
      if (newValue === STATE.play) this.startGame();
      if (newValue === STATE.gameOver) this.gameOver();
    },
  },

  mounted() {
    this.state = STATE.play;
  },

  beforeDestroy() {
    clearInterval(this.gameInterval);
  },

  methods: {
    click() {
      Haptics.impact({ style: HapticsImpactStyle.Heavy });

      if (this.state === STATE.play) {
        this.dinoYVelocity = this.jumpForce;
      }
      if (this.state === STATE.gameOver) {
        this.$router.push({ path: "/" });
      }
    },

    startGame() {
      this.dinoX = 50;
      this.dinoYVelocity = 0;
      this.obstacles = [];
      this.gameInterval = setInterval(() => this.gameLoop(), 1000 / 30);
    },

    gameOver() {
      clearInterval(this.gameInterval);
    },

    gameLoop() {
      this.moveDino();
      this.moveAndRemoveObstacles();
      this.detectCollisionWithObstacles();
      this.detectCollisionWithGround();
      this.addObstaclesIfNeeded();
    },

    moveDino() {
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

    detectCollisionWithObstacles() {
      const possibleCollision = this.obstacles.filter(
        (obstacle) => obstacle.x < this.dinoX + 60 && obstacle.x >= this.dinoX
      )[0];
      if (!possibleCollision) return;
      const collision =
        this.dinoY < possibleCollision.gapStarts + possibleCollision.y ||
        this.dinoY + 60 > possibleCollision.gapEnds + possibleCollision.y;

      if (collision) this.state = STATE.gameOver;
    },

    detectCollisionWithGround() {
      const screenHeight = this.$refs.screen.getBoundingClientRect().height;
      const collision = this.dinoY + 60 > screenHeight;

      if (collision) this.state = STATE.gameOver;
    },

    addObstaclesIfNeeded() {
      const screenWidth = this.$refs.screen.getBoundingClientRect().width;

      if (this.obstacles.length === 0) {
        for (let i = 0; i < this.maxObstacleCount; i++) {
          this.spawnObstacle(screenWidth + this.obstacleGap * i);
        }
      }

      if (this.obstacles.length < this.maxObstacleCount) {
        const lastObstacle = this.obstacles[this.obstacles.length - 1];
        this.spawnObstacle(lastObstacle.x + this.obstacleGap);
      }
    },

    spawnObstacle(x) {
      const obstacle = {
        id: `${Math.random()}`,
        x: x,
        y: -randomNumberBetween(0, 250),
        gapStarts: 474,
        gapEnds: 628,
      };
      this.obstacles.push(obstacle);
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
