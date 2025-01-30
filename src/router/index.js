import { createRouter, createWebHistory } from 'vue-router';
import Login from '../components/Login.vue';
import Register from '../components/Register.vue';
import Main from '../components/Main.vue';
import EditProfile from '@/components/EditProfile.vue';
import Products from '@/components/Products.vue';
import ProductList from '@/components/ProductList.vue';
import ProductDetail from '../components/ProductDetail.vue';
import CartPage from '@/components/CartPage.vue';
import OrderSuccess from '@/components/OrderSuccess.vue'
import OrdersPage from '@/components/OrdersPage.vue'
import OrderDetails from '@/components/OrderDetails.vue'

const routes = [
    { path: '/', redirect: '/login' },
    { path: '/login', component: Login },
    { path: '/register', component: Register },
    { path: '/main', component: Main },
    { path: '/edit-profile', component: EditProfile},
    { path: '/products', component: Products  },
    { path: '/product-list', component: ProductList  },
    { path: '/product/:productId', component: ProductDetail},
    { path: '/cart', component: CartPage},
    {
        path: '/order-success/:orderId/:totalPrice',
        name: 'OrderSuccess',
        component: OrderSuccess,
        props: true
    },
    { path: '/orders', component: OrdersPage},
    {
        path: '/orders/:orderId',
        name: 'OrderDetails',
        component: OrderDetails,
        props: true
    }
];

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes,
});

export default router;
