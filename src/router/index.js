import { createRouter, createWebHistory } from 'vue-router';
import Login from '@/pages/Login.vue'
import Register from '@/pages/Register.vue';
import ClassLogin from '@/pages/ClassLogin.vue';
import ClassRegister from '@/pages/ClassRegister.vue';
import Main from "@/pages/Main.vue"
import SchoolClasses from '@/pages/SchoolClasses.vue';
import Journal from '@/pages/Journal.vue';
import Test from "@/pages/Test.vue"
const routes = [
    { path: '/login', component: Login },
    { path: '/register', component: Register },
    { path: '/class-login', component: ClassLogin },
    { path: '/class-register', component: ClassRegister },
    { path: '/', component: Main },
    { path: '/school-classes', component: SchoolClasses },
    { path: '/journal', component: Journal},
    { path: '/test', component: Test},
    

];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
