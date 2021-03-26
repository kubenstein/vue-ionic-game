<template>
  <div ref="screen" class="game" @click="click">
    <p class="points">Record: {{ maxPoints }}<br />Points: {{ points }}</p>
    <img class="player" :src="dinoPng" :style="{ left: `${playerX}px`, top: `${playerY}px` }" />
    <img
      v-for="obstacle in obstacles"
      :key="obstacle.id"
      class="obstacle"
      :src="obstaclePng"
      :style="{ left: `${obstacle.x}px`, top: `${obstacle.y}px` }"
    />
    <p v-if="state === STATE.gameOver" class="gameOver">Game Over!</p>
  </div>
</template>

<script>
import { HapticsImpactStyle, Plugins } from "@capacitor/core";
import { randomNumberBetween } from "../../../lib/utils";
import dinoPng from "../../../assets/images/dino.png";
import obstaclePng from "../../../assets/images/obstacle.png";

const { Haptics, Storage } = Plugins;

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
      STATE,

      state: STATE.idle,
      maxPoints: 0,
      playerY: 350,
      playerX: 50,
      playerVelocityY: 0,
      force: -0.5,
      jumpForce: 6,
      totalObstacleCount: 0,
      maxObstacleCount: 5,
      obstacleGap: 200,
      obstacles: [],
      obstacleVelocityX: 3,
      gameInterval: null,
    };
  },

  computed: {
    points() {
      return this.totalObstacleCount - this.obstacles.length;
    },
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
        this.playerVelocityY = this.jumpForce;
      }
      if (this.state === STATE.gameOver) {
        this.$router.push({ path: "/" });
      }
    },

    startGame() {
      this.totalObstacleCount = 0;
      this.playerX = 50;
      this.playerVelocityY = 0;
      this.obstacles = [];
      this.gameInterval = setInterval(() => this.gameLoop(), 1000 / 30);
      Storage.get({ key: "maxPoints" }).then(({ value }) => (this.maxPoints = parseInt(value || "0")));
    },

    gameOver() {
      clearInterval(this.gameInterval);
      Storage.set({ key: "maxPoints", value: `${this.points}` });
    },

    gameLoop() {
      this.movePlayer();
      this.moveAndRemoveObstacles();
      this.detectCollisionWithObstacles();
      this.detectCollisionWithGround();
      this.addObstaclesIfNeeded();
    },

    movePlayer() {
      this.playerVelocityY += this.force;
      this.playerY -= this.playerVelocityY;
    },

    moveAndRemoveObstacles() {
      this.obstacles = this.obstacles
        .map((obstacle) => ({
          ...obstacle,
          x: obstacle.x - this.obstacleVelocityX,
        }))
        .filter((obstacle) => obstacle.x > -60);
    },

    detectCollisionWithObstacles() {
      const possibleCollision = this.obstacles.filter(
        (obstacle) => this.playerX + 60 > obstacle.x && this.playerX < obstacle.x + 60
      )[0];
      if (!possibleCollision) return;
      const collision =
        this.playerY < possibleCollision.gapStarts + possibleCollision.y ||
        this.playerY + 60 > possibleCollision.gapEnds + possibleCollision.y;

      if (collision) this.state = STATE.gameOver;
    },

    detectCollisionWithGround() {
      const screenHeight = this.$refs.screen.getBoundingClientRect().height;
      const collision = this.playerY + 60 > screenHeight;

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
      this.totalObstacleCount += 1;
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

.gameOver {
  position: absolute;
  top: 50%;
  right: 0;
  left: 0;
  color: #45584d;
  font-size: 0.8rem;
  text-align: center;
  text-shadow: 2px 2px #718f78;
}

.points {
  position: absolute;
  top: 50px;
  left: 10px;
  z-index: 10;
  color: #45584d;
  font-size: 0.8rem;
}
</style>
