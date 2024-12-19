import "/src/assets/css/main.css";
import "/src/assets/css/bootstrap.min.css";
import 'lew-ui/style'

import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

const app = createApp(App);
app.use(router);
app.mount("#app");

