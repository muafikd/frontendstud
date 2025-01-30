<template>
    <div class="orders-page">
        <div class="orders-container">
            <h1>My Orders</h1>
            <div class="orders-list" v-if="orders.length > 0">
                <div v-for="order in orders" :key="order.orderId" class="order-card">
                    <div class="order-header">
                        <span class="order-number">Order #{{ order.orderId }}</span>
                        <span class="order-date">{{ formatDate(order.placedAt) }}</span>
                    </div>
                    <div class="order-status" :class="getStatusClass(order.orderStatus)">
                        {{ order.orderStatus || 'PENDING' }}
                    </div>
                    <div class="order-total">
                        Total: {{ order.totalPrice }} тг
                    </div>
                    <button @click="viewOrderDetails(order.orderId)" class="view-details-btn">
                        View Details
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path d="M9 18l6-6-6-6"/>
                        </svg>
                    </button>
                </div>
            </div>
            <div v-else class="no-orders">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
                <p>You haven't placed any orders yet</p>
                <router-link to="/products" class="start-shopping-btn">
                    Start Shopping
                </router-link>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'OrdersPage',
    data() {
        return {
            orders: []
        };
    },
    methods: {
        async fetchOrders() {
            try {
                const token = localStorage.getItem('jwt');
                const response = await axios.get('http://localhost:8080/api/orders/my-orders', {
                    headers: { Authorization: `Bearer ${token}` }
                });
                this.orders = response.data;
            } catch (error) {
                console.error('Error fetching orders:', error);
                if (error.response?.status === 401) {
                    this.$router.push('/login');
                }
            }
        },
        formatDate(dateString) {
            return new Date(dateString).toLocaleDateString('ru-RU', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        },
        viewOrderDetails(orderId) {
            console.log('Navigating to order:', orderId);
            this.$router.push(`/orders/${orderId}`);
        },
        getStatusClass(status) {
            if (!status) return 'pending';
            return status.toLowerCase();
        }
    },
    created() {
        this.fetchOrders();
    }
};
</script>

<style scoped>
.orders-page {
    min-height: 100vh;
    background: #F2F1EC;
    padding: 40px 20px;
}

.orders-container {
    max-width: 1000px;
    margin: 0 auto;
}

h1 {
    color: #313034;
    font-size: 2em;
    margin-bottom: 30px;
    font-weight: 300;
    text-align: center;
}

.orders-list {
    display: grid;
    gap: 20px;
}

.order-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
}

.order-card:hover {
    transform: translateY(-2px);
}

.order-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
}

.order-number {
    font-weight: 500;
    color: #B8860B;
}

.order-date {
    color: #666;
}

.order-status {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.9em;
    margin-bottom: 15px;
}

.order-status.pending {
    background: #FFF3CD;
    color: #856404;
}

.order-status.completed {
    background: #D4EDDA;
    color: #155724;
}

.order-total {
    font-size: 1.1em;
    color: #313034;
    margin-bottom: 15px;
}

.view-details-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: none;
    border: none;
    color: #B8860B;
    cursor: pointer;
    padding: 8px 0;
    transition: all 0.3s ease;
}

.view-details-btn:hover {
    color: #9B7506;
}

.view-details-btn svg {
    transition: transform 0.3s ease;
}

.view-details-btn:hover svg {
    transform: translateX(4px);
}

.no-orders {
    text-align: center;
    padding: 60px 20px;
}

.no-orders svg {
    stroke: #B8860B;
    margin-bottom: 20px;
}

.no-orders p {
    color: #666;
    margin-bottom: 20px;
}

.start-shopping-btn {
    display: inline-block;
    padding: 12px 24px;
    background: #B8860B;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.start-shopping-btn:hover {
    background: #9B7506;
    transform: translateY(-2px);
}

@media (max-width: 768px) {
    .order-header {
        flex-direction: column;
        gap: 10px;
    }
}
</style> 