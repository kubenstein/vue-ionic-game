<template>
  <div ref="screen" class="welcome" @click="startGame">
    <img class="player" :src="dinoPng" :style="{ left: `${playerX}px`, top: `${playerY}px` }" />
    <h1 class="title">
      Welcome to:
      <br />
      <strong>FLAPPY KOMOJU</strong>
    </h1>
    <p class="info">Tap to start!</p>
  </div>
</template>

<script>
import dinoPng from "../../../assets/images/dino.png";

export default {
  data() {
    return {
      dinoPng,
      playerY: 350,
      playerX: 170,
      playerYVelocity: 0,
      force: -0.5,
      jumpForce: 6,
      autoJumpInterval: null,
    };
  },

  mounted() {
    this.gameInterval = setInterval(() => this.gameLoop(), 1000 / 30);
    this.autoJumpInterval = setInterval(() => this.autoJump(), 600);
  },

  beforeDestroy() {
    clearInterval(this.gameInterval);
    clearInterval(this.autoJumpInterval);
  },

  methods: {
    startGame() {
      this.$router.push({ path: "/game" });
    },

    autoJump() {
      const screenHeight = this.$refs.screen.getBoundingClientRect().height;

      if (this.playerY > screenHeight / 3) {
        this.playerYVelocity = this.jumpForce;
      }
    },

    gameLoop() {
      this.movePlayer();
    },

    movePlayer() {
      this.playerYVelocity += this.force;
      this.playerY -= this.playerYVelocity;
    },
  },
};
</script>

<style lang="scss" scoped>
.welcome {
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

.title {
  position: absolute;
  top: 90px;
  right: 0;
  left: 0;
  color: white;
  font-size: 0.6rem;
  text-align: center;

  strong {
    display: inline-block;
    margin-top: 20px;
    color: #45584d;
    font-size: 0.7rem;
    text-shadow: 2px 2px #718f78;
  }
}

.info {
  position: absolute;
  right: 0;
  bottom: 25px;
  left: 0;
  color: #4a313e;
  font-size: 0.8rem;
  text-align: center;
}
</style>
