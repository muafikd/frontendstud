<template>
    <div class="product-list-page">
        <div class="admin-container">
            <div class="header-section">
                <h1>Управление товарами</h1>
                <div class="stats">
                    <div class="stat-item">
                        <span class="stat-value">{{ products.length }}</span>
                        <span class="stat-label">Всего товаров</span>
                    </div>
                </div>
            </div>

            <div v-if="errorMessage" class="error-message">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor">
                    <circle cx="12" cy="12" r="10" />
                    <line x1="12" y1="8" x2="12" y2="12" />
                    <line x1="12" y1="16" x2="12" y2="16" />
                </svg>
                {{ errorMessage }}
            </div>

            <div class="content-grid">
                <div class="products-section">
                    <h2>Список товаров</h2>
                    <div class="products-grid">
                        <div v-for="product in products" :key="product.productId" class="product-card">
                            <img :src="product.imageUrl || '/default-album.jpg'" :alt="product.title"
                                class="product-image">
                            <div class="product-info">
                                <h3>{{ product.title }}</h3>
                                <p class="artist">{{ product.artist }}</p>
                                <p class="price">{{ product.price }} тг</p>
                                <p class="stock">В наличии: {{ product.stockQuantity }}</p>
                            </div>
                            <div class="product-actions">
                                <button @click="editProduct(product)" class="edit-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor">
                                        <path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34" />
                                        <polygon points="18 2 22 6 12 16 8 16 8 12 18 2" />
                                    </svg>
                                </button>
                                <button @click="deleteProduct(product.productId)" class="delete-btn">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor">
                                        <path d="M3 6h18" />
                                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6" />
                                        <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h2>{{ form.productId ? 'Редактировать товар' : 'Добавить товар' }}</h2>
                    <form @submit.prevent="saveProduct" class="product-form">
                        <div class="form-group">
                            <label>Название</label>
                            <input v-model="form.title" required />
                        </div>
                        <div class="form-group">
                            <label>Исполнитель</label>
                            <input v-model="form.artist" required />
                        </div>
                        <div class="form-group">
                            <label>Жанр</label>
                            <input v-model="form.genre" required />
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Год выпуска</label>
                                <input type="number" v-model.number="form.releaseYear" required />
                            </div>
                            <div class="form-group">
                                <label>Цена</label>
                                <input type="number" v-model.number="form.price" required />
                            </div>
                            <div class="form-group">
                                <label>Количество</label>
                                <input type="number" v-model.number="form.stockQuantity" required />
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Описание</label>
                            <textarea v-model="form.description" required></textarea>
                        </div>
                        <div class="form-group">
                            <label>URL изображения</label>
                            <input v-model="form.imageUrl" />
                        </div>
                        <div class="form-actions">
                            <button type="button" @click="resetForm" class="cancel-btn">Отмена</button>
                            <button type="submit" class="save-btn">
                                {{ form.productId ? 'Сохранить изменения' : 'Добавить товар' }}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            products: [],
            errorMessage: '',
            form: {
                productId: null,
                title: '',
                artist: '',
                genre: '',
                releaseYear: '',
                price: '',
                stockQuantity: '',
                description: '',
                imageUrl: ''
            }
        };
    },
    created() {
        this.checkAdminRole();  // Check the user's role when the component is created
        this.fetchProducts();
    },
    methods: {
        getAuthHeader() {
            const token = localStorage.getItem('jwt');
            return { Authorization: `Bearer ${token}` };
        },
        async fetchProducts() {
            try {
                const response = await axios.get('http://localhost:8080/api/products', {
                    headers: this.getAuthHeader()
                });
                this.products = response.data;
            } catch (error) {
                this.errorMessage = 'Failed to load products.';
            }
        },
        async saveProduct() {
            try {
                const productData = { ...this.form };

                // Удаляем productId при создании нового продукта
                if (!this.form.productId) {
                    delete productData.productId;
                }

                if (this.form.productId) {
                    await axios.put(`http://localhost:8080/api/products/${this.form.productId}`, productData, {
                        headers: this.getAuthHeader()
                    });
                } else {
                    await axios.post('http://localhost:8080/api/products', productData, {
                        headers: this.getAuthHeader()
                    });
                }
                this.fetchProducts();
                this.resetForm();
            } catch (error) {
                this.errorMessage = 'Failed to save product.';
            }
        },
        editProduct(product) {
            this.form = { ...product };
        },
        resetForm() {
            this.form = {
                productId: null,
                title: '',
                artist: '',
                genre: '',
                releaseYear: '',
                price: '',
                stockQuantity: '',
                description: '',
                imageUrl: ''
            };
        },
        async deleteProduct(id) {
            try {
                await axios.delete(`http://localhost:8080/api/products/${id}`, {
                    headers: this.getAuthHeader()
                });
                this.fetchProducts();
            } catch (error) {
                this.errorMessage = 'Failed to delete product.';
            }
        },
        checkAdminRole() {
            const token = localStorage.getItem('jwt');
            if (token) {
                try {
                    const decoded = JSON.parse(atob(token.split('.')[1]));  // Decode the JWT token
                    // Check if the decoded object has roles and if 'ADMIN' is included in the roles
                    if (decoded && decoded.roles && decoded.roles.includes("ROLE_ADMIN")) {
                        // User is an admin, proceed to load the product list
                        return;
                    }
                } catch (error) {
                    console.error('Error decoding token:', error);  // Log any errors during decoding
                }
            }
            // If the token is not present, or the user is not an admin, redirect to the main page
            this.$router.push("/main");
        }
    }
};
</script>

<style scoped>
.product-list-page {
    min-height: 100vh;
    background: #F2F1EC;
    padding: 40px 20px;
}

.admin-container {
    max-width: 1200px;
    margin: 0 auto;
}

.header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

.header-section h1 {
    color: #313034;
    font-size: 2em;
    margin: 0;
}

.stats {
    display: flex;
    gap: 20px;
}

.stat-item {
    background: white;
    padding: 15px 25px;
    border-radius: 8px;
    text-align: center;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-value {
    display: block;
    font-size: 1.5em;
    font-weight: bold;
    color: #B8860B;
}

.stat-label {
    color: #666;
    font-size: 0.9em;
}

.error-message {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #FEE2E2;
    color: #DC2626;
    padding: 12px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.content-grid {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 30px;
}

.products-section,
.form-section {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.product-card {
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.3s ease;
}

.product-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.product-image {
    width: 100%;
    height: 200px;
    object-fit: cover;
}

.product-info {
    padding: 15px;
}

.product-info h3 {
    margin: 0;
    font-size: 1.1em;
    color: #313034;
}

.artist {
    color: #666;
    margin: 5px 0;
}

.price {
    color: #B8860B;
    font-weight: 500;
    margin: 5px 0;
}

.stock {
    color: #666;
    font-size: 0.9em;
    margin: 5px 0;
}

.product-actions {
    display: flex;
    justify-content: flex-end;
    padding: 10px;
    gap: 10px;
    border-top: 1px solid #e5e7eb;
}

.edit-btn,
.delete-btn {
    padding: 8px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.edit-btn {
    background: #E5E7EB;
    color: #374151;
}

.delete-btn {
    background: #FEE2E2;
    color: #DC2626;
}

.edit-btn:hover {
    background: #D1D5DB;
}

.delete-btn:hover {
    background: #FCA5A5;
}

.product-form {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
}

label {
    color: #374151;
    font-size: 0.9em;
}

input,
textarea {
    padding: 8px 12px;
    border: 1px solid #D1D5DB;
    border-radius: 4px;
    font-size: 1em;
}

textarea {
    min-height: 100px;
    resize: vertical;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}

.cancel-btn,
.save-btn {
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.3s ease;
}

.cancel-btn {
    background: #E5E7EB;
    color: #374151;
}

.save-btn {
    background: #B8860B;
    color: white;
}

.cancel-btn:hover {
    background: #D1D5DB;
}

.save-btn:hover {
    background: #9B7506;
}

@media (max-width: 1024px) {
    .content-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .form-row {
        grid-template-columns: 1fr;
    }
}
</style>