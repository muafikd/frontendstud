<template>
    <div class="order-details-page">
        <div class="order-details-container">
            <div class="order-header">
                <h1>Заказ #{{ orderId }}</h1>
                <div class="order-status" :class="getStatusClass(orderDetails.orderStatus)">
                    {{ orderDetails.orderStatus || 'PENDING' }}
                </div>
            </div>

            <div class="order-info">
                <div class="info-block">
                    <p class="info-label">Дата заказа:</p>
                    <p class="info-value">{{ formatDate(orderDetails.placedAt) }}</p>
                </div>
                <div class="info-block">
                    <p class="info-label">Общая сумма:</p>
                    <p class="info-value">{{ orderDetails.totalPrice }} $</p>
                </div>
            </div>

            <div class="order-items">
                <h2>Товары в заказе</h2>
                <div class="items-list">
                    <div v-for="item in orderDetails.items" :key="item.productId" class="item-card">
                        <div class="item-info">
                            <h3>{{ item.productName }}</h3>
                            <p class="item-quantity">Количество: {{ item.quantity }}</p>
                            <p class="item-price">Цена: {{ item.price }} $</p>
                            <p class="item-total">Итого: {{ item.price * item.quantity }} $</p>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="isAdmin" class="admin-controls">
                <h3>Управление заказом</h3>
                <div class="status-controls">
                    <select v-model="orderDetails.orderStatus" @change="updateOrderStatus">
                        <option value="PENDING">В обработке</option>
                        <option value="CONFIRMED">Подтвержден</option>
                        <option value="SHIPPED">Отправлен</option>
                        <option value="DELIVERED">Доставлен</option>
                        <option value="CANCELLED">Отменен</option>
                    </select>
                    <button @click="updateOrderStatus" class="update-status-btn">
                        Обновить статус
                    </button>
                </div>
            </div>

            <div class="order-actions">
                <router-link to="/orders" class="back-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M15 18l-6-6 6-6"/>
                    </svg>
                    Назад к заказам
                </router-link>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'OrderDetails',
    data() {
        return {
            orderId: this.$route.params.orderId,
            orderDetails: {
                orderStatus: '',
                placedAt: '',
                totalPrice: 0,
                items: []
            },
            isAdmin: false
        };
    },
    methods: {
        checkAdminRole() {
            const token = localStorage.getItem('jwt');
            if (token) {
                try {
                    const decoded = JSON.parse(atob(token.split('.')[1]));
                    this.isAdmin = decoded.roles && decoded.roles.includes("ROLE_ADMIN");
                } catch (error) {
                    console.error('Error checking admin role:', error);
                }
            }
        },
        async fetchOrderDetails() {
            try {
                const token = localStorage.getItem('jwt');
                const response = await axios.get(
                    `http://localhost:8080/api/orders/${this.orderId}`,
                    {
                        headers: { Authorization: `Bearer ${token}` }
                    }
                );
                this.orderDetails = response.data;
            } catch (error) {
                console.error('Error fetching order details:', error);
                if (error.response?.status === 401) {
                    this.$router.push('/login');
                }
            }
        },
        formatDate(dateString) {
            if (!dateString) return '';
            return new Date(dateString).toLocaleDateString('ru-RU', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        },
        getStatusClass(status) {
            if (!status) return 'pending';
            return status.toLowerCase();
        },
        updateOrderStatus() {
            // Implementation of updateOrderStatus method
        }
    },
    created() {
        this.checkAdminRole();
        this.fetchOrderDetails();
    }
};
</script>

<style scoped>
.order-details-page {
    min-height: 100vh;
    background: #F2F1EC;
    padding: 40px 20px;
}

.order-details-container {
    max-width: 800px;
    margin: 0 auto;
    background: white;
    border-radius: 12px;
    padding: 30px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

h1 {
    color: #313034;
    font-size: 1.8em;
    margin: 0;
}

.order-status {
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 0.9em;
}

.order-status.pending {
    background: #FFF3CD;
    color: #856404;
}

.order-status.completed {
    background: #D4EDDA;
    color: #155724;
}

.order-info {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
}

.info-block {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.info-label {
    color: #666;
    font-size: 0.9em;
    margin: 0;
}

.info-value {
    color: #313034;
    font-size: 1.1em;
    margin: 0;
}

.order-items {
    margin-bottom: 30px;
}

h2 {
    color: #313034;
    font-size: 1.4em;
    margin-bottom: 20px;
}

.items-list {
    display: grid;
    gap: 15px;
}

.item-card {
    padding: 20px;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    transition: transform 0.3s ease;
}

.item-card:hover {
    transform: translateY(-2px);
}

.item-info h3 {
    color: #313034;
    margin: 0 0 10px 0;
    font-size: 1.2em;
}

.item-quantity, .item-price, .item-total {
    color: #666;
    margin: 5px 0;
}

.item-total {
    color: #B8860B;
    font-weight: 500;
}

.order-actions {
    display: flex;
    justify-content: flex-start;
    margin-top: 30px;
}

.back-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background: none;
    border: 1px solid #B8860B;
    color: #B8860B;
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.back-btn:hover {
    background: #B8860B;
    color: white;
}

.back-btn svg {
    transition: transform 0.3s ease;
}

.back-btn:hover svg {
    transform: translateX(-4px);
}

.admin-controls {
    margin-top: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
}

.admin-controls h3 {
    color: #313034;
    margin-bottom: 15px;
}

.status-controls {
    display: flex;
    gap: 15px;
}

.status-controls select {
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background: white;
}

.update-status-btn {
    padding: 8px 16px;
    background: #B8860B;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.update-status-btn:hover {
    background: #9B7506;
}

@media (max-width: 768px) {
    .order-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .order-info {
        grid-template-columns: 1fr;
    }
}
</style> 