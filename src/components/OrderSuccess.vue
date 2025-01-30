<template>
    <div class="order-success">
        <div class="success-container">
            <div class="success-icon">
                <svg viewBox="0 0 24 24" width="100" height="100">
                    <path fill="none" stroke="#4CAF50" stroke-width="2" 
                          d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <path fill="none" stroke="#4CAF50" stroke-width="2" 
                          d="M22 4L12 14.01l-3-3"/>
                </svg>
            </div>
            <h1>Заказ успешно оформлен!</h1>
            <div class="order-details">
                <p class="order-number">Номер заказа: #{{ orderDetails.orderId }}</p>
                <p class="order-total">Сумма заказа: {{ orderDetails.totalPrice }} $</p>
            </div>
            <p class="thank-you">Спасибо за покупку! Мы отправим вам уведомление о статусе заказа.</p>
            <div class="buttons">
                <router-link to="/products" class="continue-shopping">
                    Продолжить покупки
                </router-link>
                <router-link :to="`/orders/${orderDetails.orderId}`" class="view-order">
                    Просмотреть заказ
                </router-link>
            </div>
        </div>
    </div>
</template>

<script>
/* eslint-disable */
export default {
    name: 'OrderSuccess',
    data() {
        return {
            orderDetails: {
                orderId: '',
                totalPrice: 0
            }
        };
    },
    created() {
        // Получаем данные из route params
        const { orderId, totalPrice } = this.$route.params;
        if (orderId && totalPrice) {
            this.orderDetails.orderId = orderId;
            this.orderDetails.totalPrice = totalPrice;
        } else {
            // Если данных нет в params, проверяем localStorage
            const savedOrderId = localStorage.getItem('lastOrderId');
            const savedTotalPrice = localStorage.getItem('lastOrderTotal');
            if (savedOrderId && savedTotalPrice) {
                this.orderDetails.orderId = savedOrderId;
                this.orderDetails.totalPrice = savedTotalPrice;
                // Очищаем после использования
                localStorage.removeItem('lastOrderId');
                localStorage.removeItem('lastOrderTotal');
            }
        }
    }
};
</script>

<style scoped>
.order-success {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #F2F1EC;
    padding: 20px;
}

.success-container {
    background: white;
    padding: 40px;
    border-radius: 20px;
    text-align: center;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    max-width: 500px;
    width: 100%;
}

.success-icon {
    margin-bottom: 20px;
    animation: scaleIn 0.5s ease-out;
}

.success-icon svg path {
    stroke-dasharray: 100;
    stroke-dashoffset: 100;
    animation: checkmark 1s ease-in-out forwards;
}

h1 {
    color: #4CAF50;
    margin-bottom: 20px;
    font-size: 2em;
}

.order-details {
    margin: 20px 0;
    padding: 20px;
    background: #f8f8f8;
    border-radius: 10px;
}

.order-number, .order-total {
    font-size: 1.2em;
    margin: 10px 0;
    color: #333;
}

.thank-you {
    color: #666;
    margin: 20px 0;
}

.buttons {
    display: flex;
    gap: 15px;
    justify-content: center;
    margin-top: 30px;
}

.continue-shopping, .view-order {
    padding: 12px 24px;
    border-radius: 8px;
    text-decoration: none;
    transition: all 0.3s ease;
}

.continue-shopping {
    background: #B8860B;
    color: white;
}

.view-order {
    background: #f8f8f8;
    color: #333;
}

.continue-shopping:hover, .view-order:hover {
    transform: translateY(-2px);
}

@keyframes scaleIn {
    0% { transform: scale(0); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
}

@keyframes checkmark {
    0% { stroke-dashoffset: 100; }
    100% { stroke-dashoffset: 0; }
}

@media (max-width: 480px) {
    .buttons {
        flex-direction: column;
    }
}
</style> 