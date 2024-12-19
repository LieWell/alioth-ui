import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    name: "index",
    meta: { title: "首页" },
    component: () => import("../views/index.vue"),
  },
  {
    path: "/about",
    name: "about",
    meta: { title: "关于" },
    component: () => import("../views/about.vue"),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: routes,
});

router.beforeEach((to, from, next) => {
  // 如果路由设置了标题,则使用该标题
  if (to.meta.title) {
    document.title = to.meta.title;
  }
  // 确保要调用 next() 方法, 否则钩子就不会被 resolved
  next();
});

export default router;
