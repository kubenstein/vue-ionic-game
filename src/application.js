import Vue from "vue";
import VueRouter from "vue-router";
import App from "./components/App/index.vue";
import routes from "./components/App/routes.js";

Vue.use(VueRouter);

const router = new VueRouter({
  routes,
  mode: "hash",
});

new Vue({
  el: "#app",
  router,
  render: (h) => h(App),
});
