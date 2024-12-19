<script setup>
import GithubCorner from '@/components/GithubCorner.vue'
</script>

<template>
  <GithubCorner />

  <body class="d-flex flex-column min-vh-100">
    <div class="flex-fill">
      <div class="canvas-panel justify-content-center">
        <div v-for="(pixel, index) in pixels" :key="index" class="pixel" :style="{
          backgroundColor: pixel.color,
          transform: `rotate(${pixel.rotation}deg)`,
          transition: 'transform 0.5s ease'
        }" @click="updatePixel(index)">
        </div>
      </div>
      <div class="link-wrapper">
        <ul class="nav justify-content-center">
          <li class="nav-item"><a href="https://blog.liewell.fun" target="_blank" class="nav-link px-4">Blog</a></li>
          <li class="nav-item"><a href="https://v2ex.liewell.fun" target="_blank" class="nav-link px-4">V2ex</a></li>
          <li class="nav-item"><a href="https://www.reddit.com/r/place/" target="_blank" class="nav-link px-4">what's
              this?</a></li>
        </ul>
      </div>
    </div>
    <footer class="footer-text text-center py-3">
      <span>
        备案号：<a href="https://beian.miit.gov.cn/" target="_blank">鲁ICP备2023048137号</a>
      </span>
    </footer>
  </body>
</template>

<script>
export default {
  data() {
    return {
      colorWhite: "#FFFFFF",
      colorBlack: "#404040",
      width: 32,
      height: 16,
      pixels: Array(512).fill(null).map(() => ({ color: this.colorWhite, rotation: 0 })),
      socket: null,
    }
  },
  created() {
    this.socket = new WebSocket("ws://127.0.0.1:12321/rplace");
    // 接收到数据时的处理
    this.socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      // 建立链接后,将推送全部数据,此时初始化整个画布
      if (Array.isArray(data)) {
        data.forEach((line, y) => {
          line.forEach((color, x) => {
            const index = y * this.width + x;
            if (this.pixels[index]) {
              this.pixels[index].color = color;
            }
          });
        });
      } else {
        // 后续仅推送更新的单个像素
        const { x, y, color } = data;
        const index = y * this.width + x;
        if (this.pixels[index]) {
          this.pixels[index].color = color;
        }
      }
    };
    // 连接建立时的处理
    this.socket.onopen = (res) => {
      console.log("ws connection established");
    };
  },
  methods: {
    updatePixel(index) {
      const x = index % this.width;
      const y = Math.floor(index / this.width);
      // 点击反转颜色
      const newColor = this.pixels[index].color === this.colorBlack ? this.colorWhite : this.colorBlack;
      this.pixels[index].color = newColor;

      // 点击添加旋转效果
      const rotation = this.pixels[index].rotation === 90 ? 0 : 90;
      this.pixels[index].rotation = rotation;

      // 发送像素更新到后端
      this.socket.send(
        JSON.stringify({
          x: x,
          y: y,
          color: newColor,
        }));
    },
  },
};
</script>

<style scoped>
.canvas-panel {
  width: auto;
  display: grid;
  grid-gap: 3px;
  grid-template-columns: repeat(32, 20px);
}

.pixel {
  width: 20px;
  height: 20px;
}

@keyframes rotateAnimation {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(180deg);
  }
}

.rotate {
  animation: rotateAnimation 0.5s linear forwards;
}

.link-wrapper {
  margin-top: 20px;
}

.footer-text {
  font-size: 12px;
  border-top: 1px solid #DDD;
  /*不皂*/
}

.footer-text a,
.footer-text span {
  color: #999;
}
</style>