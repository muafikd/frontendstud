<template>
    <div class="cart-page">
        <div class="cart-container">
            <h1 class="title">Your Shopping Cart</h1>
            <div class="cart-content">
                <div v-if="cartItems.length > 0" class="cart-items">
                    <div v-for="item in cartItems" :key="item.cartItemId" class="cart-item">
                        <div class="item-details">
                            <h3 class="product-name">{{ item.productName }}</h3>
                            <div class="quantity-controls">
                                <button @click="decreaseQuantity(item.cartItemId)" 
                                        :disabled="item.quantity <= 1"
                                        class="quantity-btn">
                                    <span>−</span>
                                </button>
                                <span class="quantity">{{ item.quantity }}</span>
                                <button @click="increaseQuantity(item.cartItemId)" 
                                        class="quantity-btn">
                                    <span>+</span>
                                </button>
                            </div>
                            <div class="price">{{ item.totalPrice }} $</div>
                            <button @click="deleteCartItem(item.cartItemId)" class="delete-btn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" 
                                          stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div class="cart-summary">
                        <div class="total">
                            <span>Total:</span>
                            <span class="total-amount">{{ calculateTotal }} $</span>
                        </div>
                        <button @click="proceedToCheckout" class="checkout-btn" :disabled="processing">
                            <span v-if="!processing">Proceed to Checkout</span>
                            <span v-else class="processing">
                                <span class="loader"></span>
                                Processing...
                            </span>
                            <span class="checkout-arrow" v-if="!processing">→</span>
                        </button>
                    </div>
                </div>
                <div v-else class="empty-cart">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M9 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4zM20 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                    </svg>
                    <p>Your cart is empty</p>
                    <router-link to="/products" class="continue-shopping">Continue Shopping</router-link>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
 /* eslint-disable */
import axios from 'axios';

export default {
    name: 'CartPage',
    data() {
        return {
            cartItems: [],
            processing: false
        };
    },
    computed: {
        calculateTotal() {
            return this.cartItems.reduce((sum, item) => {
                const price = item.totalPrice || 0;
                return sum + price;
            }, 0);
        }
    },
    created() {
        this.fetchCartItems();
    },
    methods: {
        async fetchCartItems() {
            try {
                const token = localStorage.getItem('jwt');
                const response = await axios.get('http://localhost:8080/api/cart/view', {
                    headers: { Authorization: `Bearer ${token}` }
                });
                this.cartItems = response.data;
            } catch (error) {
                console.error('Error fetching cart items:', error);
                if (error.response?.status === 401) {
                    this.$router.push('/login');
                }
            }
        },

        async deleteCartItem(cartItemId) {
            try {
                const token = localStorage.getItem('jwt');
                await axios.delete(`http://localhost:8080/api/cart/remove/${cartItemId}`, {
                    headers: { Authorization: `Bearer ${token}` }
                });
                await this.fetchCartItems();
                this.$root.showNotification('Товар удален из корзины', 'success');
            } catch (error) {
                console.error('Error deleting item:', error);
                this.$root.showNotification('Ошибка при удалении товара', 'error');
            }
        },

        async increaseQuantity(cartItemId) {
            try {
                const token = localStorage.getItem('jwt');
                await axios.put(`http://localhost:8080/api/cart/increase/${cartItemId}`, null, {
                    headers: { Authorization: `Bearer ${token}` }
                });
                await this.fetchCartItems();
            } catch (error) {
                console.error('Error increasing quantity:', error);
                this.$root.showNotification('Ошибка при увеличении количества', 'error');
            }
        },

        async decreaseQuantity(cartItemId) {
            try {
                const token = localStorage.getItem('jwt');
                await axios.put(`http://localhost:8080/api/cart/decrease/${cartItemId}`, null, {
                    headers: { Authorization: `Bearer ${token}` }
                });
                await this.fetchCartItems();
            } catch (error) {
                console.error('Error decreasing quantity:', error);
                this.$root.showNotification('Ошибка при уменьшении количества', 'error');
            }
        },

        async proceedToCheckout() {
            this.processing = true;
            try {
                const token = localStorage.getItem('jwt');
                if (!token) {
                    this.$root.showNotification('Пожалуйста, войдите в систему', 'error');
                    this.$router.push('/login');
                    return;
                }

                const orderResponse = await axios.post(
                    'http://localhost:8080/api/orders/create',
                    {},
                    {
                        headers: { 
                            'Authorization': `Bearer ${token}`,
                            'Content-Type': 'application/json'
                        }
                    }
                );

                if (orderResponse.data) {
                    this.$root.showNotification('Заказ успешно оформлен!', 'success');
                    this.cartItems = [];
                    
                    // Сохраняем данные заказа
                    localStorage.setItem('lastOrderId', orderResponse.data.orderId);
                    localStorage.setItem('lastOrderTotal', orderResponse.data.totalPrice);
                    
                    // Перенаправляем на страницу успеха
                    setTimeout(() => {
                        this.$router.push({
                            path: `/order-success/${orderResponse.data.orderId}/${orderResponse.data.totalPrice}`
                        });
                    }, 1500);
                }
            } catch (error) {
                console.error('Checkout error:', error);
                let errorMessage = 'Ошибка при оформлении заказа';
                
                if (error.response?.status === 401) {
                    errorMessage = 'Необходима авторизация';
                    this.$router.push('/login');
                } else if (error.response?.data) {
                    errorMessage = error.response.data;
                }
                
                this.$root.showNotification(errorMessage, 'error');
            } finally {
                this.processing = false;
            }
        }
    }
};
</script>

<style scoped>
.cart-page {
    min-height: 100vh;
    background: #F2F1EC;
    padding: 40px 20px;
}

.cart-container {
    max-width: 1000px;
    margin: 0 auto;
    background: white;
    border-radius: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 30px;
}

.title {
    text-align: center;
    color: #313034;
    font-size: 2em;
    margin-bottom: 30px;
    font-weight: 300;
}

.cart-items {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.cart-item {
    background: #f8f8f8;
    border-radius: 12px;
    padding: 20px;
    transition: all 0.3s ease;
}

.cart-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}

.item-details {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
}

.product-name {
    flex: 1;
    font-size: 1.1em;
    color: #313034;
    margin: 0;
}

.quantity-controls {
    display: flex;
    align-items: center;
    gap: 10px;
    background: white;
    padding: 5px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.quantity-btn {
    background: none;
    border: none;
    width: 30px;
    height: 30px;
    border-radius: 6px;
    cursor: pointer;
    color: #666;
    transition: all 0.2s ease;
}

.quantity-btn:hover:not(:disabled) {
    background: #B8860B;
    color: white;
}

.quantity-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.quantity {
    min-width: 30px;
    text-align: center;
    font-weight: 500;
}

.price {
    font-weight: 500;
    color: #B8860B;
    font-size: 1.1em;
    min-width: 100px;
    text-align: right;
}

.delete-btn {
    background: none;
    border: none;
    padding: 8px;
    cursor: pointer;
    color: #ff4d4d;
    border-radius: 8px;
    transition: all 0.2s ease;
}

.delete-btn:hover {
    background: rgba(255, 77, 77, 0.1);
}

.cart-summary {
    margin-top: 30px;
    padding-top: 20px;
    border-top: 2px solid #eee;
}

.total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    font-size: 1.2em;
}

.total-amount {
    color: #B8860B;
    font-weight: 500;
}

.checkout-btn {
    width: 100%;
    padding: 15px;
    background: #B8860B;
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 1.1em;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.checkout-btn:hover:not(:disabled) {
    background: #9B7506;
    transform: translateY(-2px);
}

.checkout-btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}

.processing {
    display: flex;
    align-items: center;
    gap: 10px;
}

.loader {
    width: 20px;
    height: 20px;
    border: 2px solid #fff;
    border-bottom-color: transparent;
    border-radius: 50%;
    display: inline-block;
    animation: rotation 1s linear infinite;
}

.checkout-arrow {
    transition: transform 0.3s ease;
}

.checkout-btn:hover .checkout-arrow {
    transform: translateX(5px);
}

.empty-cart {
    text-align: center;
    padding: 60px 20px;
    color: #666;
}

.empty-cart svg {
    margin-bottom: 20px;
    color: #B8860B;
}

.empty-cart p {
    font-size: 1.2em;
    margin-bottom: 20px;
}

.continue-shopping {
    display: inline-block;
    padding: 12px 24px;
    background: #B8860B;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.continue-shopping:hover {
    background: #9B7506;
    transform: translateY(-2px);
}

@keyframes rotation {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}

.cart-content {
    animation: fadeIn 0.5s ease-out;
}

@media (max-width: 768px) {
    .item-details {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .price {
        text-align: left;
    }
}
</style>
