<template>
    <div v-if="loading" class="loading">Loading product details...</div>
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
    <div v-if="product" class="product-detail-container">
        <div class="product-layout">
            <div class="product-image">
                <img :src="product.imageUrl" :alt="product.title" />
            </div>
            <div class="product-info">
                <h1>{{ product.title }}</h1>
                <p class="price">тг{{ product.price }}</p>

                <div class="quantity-selector">
                    <label for="quantity">Quantity:</label>
                    <div class="quantity-controls">
                        <button 
                            class="quantity-btn" 
                            @click="decrementQuantity" 
                            :disabled="quantity <= 1"
                        >-</button>
                        <input 
                            type="number" 
                            id="quantity" 
                            v-model="quantity" 
                            min="1" 
                            :max="product.stockQuantity"
                            class="quantity-input" 
                        />
                        <button 
                            class="quantity-btn" 
                            @click="incrementQuantity" 
                            :disabled="quantity >= product.stockQuantity"
                        >+</button>
                    </div>
                </div>

                <button class="add-to-cart" @click="addToCart($event)">Add to cart</button>

                <div class="content-section">
                    <h2>Информация</h2>
                    <div class="product-details">
                        <p><span>Artist:</span> {{ product.artist }}</p>
                        <p><span>Genre:</span> {{ product.genre }}</p>
                        <p><span>In Stock:</span> {{ product.stockQuantity }}</p>
                        <p class="description">{{ product.description }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script>
/*eslint-disable*/
import axios from 'axios';

export default {
    data() {
        return {
            product: null,
            quantity: 1,
            loading: true,
            errorMessage: ''
        };
    },
    created() {
        this.fetchProductDetails();
    },
    methods: {
        async fetchProductDetails() {
            const productId = this.$route.params.productId;
            try {
                const response = await axios.get(`http://localhost:8080/api/products/${productId}`);
                this.product = response.data;
            } catch (error) {
                this.errorMessage = 'Failed to load product details. Please try again later.';
                console.error(error);
            } finally {
                this.loading = false;
            }
        },
        async addToCart(event) {
            const productId = this.product.productId;
            try {
                const token = localStorage.getItem('jwt');
                // Убедимся, что токен существует
                if (!token) {
                    this.$root.showNotification('Пожалуйста, войдите в систему', 'error');
                    this.$router.push('/login');
                    return;
                }

                const rect = event.target.getBoundingClientRect();
                const startX = rect.left + rect.width/2;
                const startY = rect.top + rect.height/2;
                
                this.$root.animateToCart(startX, startY);

                const response = await axios.post(
                    `http://localhost:8080/api/cart/add?productId=${productId}&quantity=${this.quantity}`,
                    {},
                    { 
                        headers: { 
                            'Authorization': `Bearer ${token}`,
                            'Content-Type': 'application/json'
                        } 
                    }
                );
                
                this.$root.showNotification('Товар успешно добавлен в корзину', 'success');
            } catch (error) {
                console.error('Error details:', error.response?.data);
                let errorMessage = 'Ошибка при добавлении товара в корзину';
                
                // Проверяем различные случаи ошибок
                if (error.response?.status === 401) {
                    errorMessage = 'Необходима авторизация';
                    this.$router.push('/login');
                } else if (error.response?.data) {
                    errorMessage = error.response.data;
                }
                
                this.$root.showNotification(errorMessage, 'error');
            }
        },
        incrementQuantity() {
            if (this.quantity < this.product.stockQuantity) {
                this.quantity++;
            }
        },
        decrementQuantity() {
            if (this.quantity > 1) {
                this.quantity--;
            }
        }
    }
};
</script>

<style scoped>
.product-detail-container {
    max-width: 1200px;
    margin: 40px auto;
    padding: 0 20px;
}

.product-layout {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 40px;
}

.product-image img {
    width: 100%;
    max-width: 500px;
    height: auto;
    border-radius: 4px;
}

.product-info {
    padding: 20px;
}

h1 {
    font-size: 28px;
    margin-bottom: 20px;
    color: #333;
}

.price {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 30px;
}

.add-to-cart {
    width: 100%;
    padding: 15px;
    background-color: #B8860B;
    /* Золотисто-коричневый цвет как на изображении */
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    margin-bottom: 40px;
}

.add-to-cart:hover {
    background-color: #9B7506;
}

.content-section {
    margin-top: 30px;
}

h2 {
    font-size: 20px;
    margin-bottom: 20px;
    color: #333;
}

.track-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.track-item {
    display: flex;
    gap: 15px;
    font-size: 16px;
    line-height: 1.6;
}

.track-number {
    min-width: 30px;
    color: #666;
}

.track-name {
    color: #333;
}

@media (max-width: 768px) {
    .product-layout {
        grid-template-columns: 1fr;
    }

    .product-image img {
        max-width: 100%;
    }
}

.quantity-selector {
    margin: 30px 0;
    padding: 15px 0;
    border-top: 1px solid #eee;
    border-bottom: 1px solid #eee;
}

.quantity-selector label {
    display: block;
    margin-bottom: 12px;
    font-size: 16px;
    color: #333;
    font-weight: 500;
}

.quantity-controls {
    display: flex;
    align-items: center;
    gap: 8px;
    max-width: 200px;
}

.quantity-input {
    width: 60px;
    height: 40px;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
    padding: 0 8px;
}

.quantity-input::-webkit-inner-spin-button,
.quantity-input::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

.quantity-btn {
    width: 40px;
    height: 40px;
    border: 1px solid #ddd;
    background: #f5f5f5;
    border-radius: 4px;
    cursor: pointer;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

.quantity-btn:hover:not(:disabled) {
    background: #e5e5e5;
}

.quantity-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
</style>
