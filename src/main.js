import 'bootstrap/dist/css/bootstrap.min.css';
import "/src/assets/css/main.css";
import Lew from "lew-ui";
import "lew-ui/style";

import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

const app = createApp(App);
app.use(router);
app.use(Lew);
app.mount("#app");

