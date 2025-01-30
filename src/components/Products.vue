<template>
    <div class="products-container">
        <div class="header-section">
            <h2>Vinyl Collection</h2>
            <p class="subtitle">Discover Rare and Classic Albums</p>
            <button class="filter-toggle" @click="toggleFilters">
                {{ isFiltersVisible ? 'Hide Filters' : 'Show Filters' }}
                <i class="arrow" :class="{ up: isFiltersVisible }"></i>
            </button>
        </div>

        <transition name="slide-fade">
            <div v-if="isFiltersVisible" class="filters-section">
                <div class="filters-content">
                    <div class="price-filter">
                        <h3>Price Range</h3>
                        <div class="price-inputs">
                            <div class="price-input">
                                <label>Min (тг)</label>
                                <input 
                                    type="number" 
                                    v-model="priceRange.min" 
                                    :min="0" 
                                    :max="priceRange.max"
                                >
                            </div>
                            <div class="price-input">
                                <label>Max (тг)</label>
                                <input 
                                    type="number" 
                                    v-model="priceRange.max" 
                                    :min="priceRange.min"
                                >
                            </div>
                        </div>
                        <div class="range-slider">
                            <input 
                                type="range" 
                                v-model="priceRange.min" 
                                :min="minPrice" 
                                :max="maxPrice"
                                class="slider"
                            >
                            <input 
                                type="range" 
                                v-model="priceRange.max" 
                                :min="minPrice" 
                                :max="maxPrice"
                                class="slider"
                            >
                        </div>
                    </div>

                    <div class="genre-filter">
                        <h3>Genres</h3>
                        <div class="genre-options">
                            <label v-for="genre in genres" :key="genre" class="genre-checkbox">
                                <input 
                                    type="checkbox" 
                                    v-model="selectedGenres" 
                                    :value="genre"
                                >
                                {{ genre }}
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </transition>

        <div class="category-tags">
            <button 
                class="tag" 
                :class="{ active: selectedGenres.length === 0 }"
                @click="clearGenreFilters"
            >
                All
            </button>
            <button 
                v-for="genre in genres" 
                :key="genre"
                class="tag"
                :class="{ active: selectedGenres.includes(genre) }"
                @click="toggleGenre(genre)"
            >
                {{ genre }}
            </button>
        </div>

        <div v-if="loading" class="loading-spinner">Loading products...</div>
        <div v-if="errorMessage" class="error">{{ errorMessage }}</div>

        <transition-group 
            v-if="filteredProducts.length > 0" 
            name="fade-move" 
            tag="div" 
            class="de"
        >
            <router-link 
                v-for="product in filteredProducts" 
                :key="product.productId" 
                :to="'/product/' + product.productId"
                class="pr"
            >
                <div class="image-container">
                    <img :src="product.imageUrl" alt="Product Image" class="product-image" />
                    <div class="hover-overlay">
                        <span>View Details</span>
                    </div>
                </div>
                <h3>{{ product.title }}</h3>
                <p class="price">{{ product.price }} тг</p>
            </router-link>
        </transition-group>
        <div v-else-if="!loading" class="no-results">
            No products found matching your criteria
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            products: [],
            loading: true,
            errorMessage: '',
            genres: ['Rock', 'Jazz', 'Classical', 'Folk', 'Pop', 'Electronic'],
            selectedGenres: [],
            priceRange: {
                min: 0,
                max: 5000
            },
            minPrice: 0,
            maxPrice: 5000,
            isFiltersVisible: false
        };
    },
    computed: {
        filteredProducts() {
            return this.products.filter(product => {
                // Фильтр по цене
                const priceMatch = product.price >= this.priceRange.min && 
                                 product.price <= this.priceRange.max;
                
                // Фильтр по жанрам
                const genreMatch = this.selectedGenres.length === 0 || 
                                 this.selectedGenres.includes(product.genre);
                
                return priceMatch && genreMatch;
            });
        }
    },
    created() {
        this.fetchProducts();
    },
    methods: {
        async fetchProducts() {
            try {
                const response = await axios.get('http://localhost:8080/api/products');
                this.products = response.data;
                
                // Установка минимальной и максимальной цены на основе данных
                if (this.products.length > 0) {
                    this.minPrice = Math.min(...this.products.map(p => p.price));
                    this.maxPrice = Math.max(...this.products.map(p => p.price));
                    this.priceRange.min = this.minPrice;
                    this.priceRange.max = this.maxPrice;
                }
            } catch (error) {
                this.errorMessage = 'Failed to load products. Please try again later.';
                console.error(error);
            } finally {
                this.loading = false;
            }
        },
        toggleGenre(genre) {
            const index = this.selectedGenres.indexOf(genre);
            if (index === -1) {
                this.selectedGenres.push(genre);
            } else {
                this.selectedGenres.splice(index, 1);
            }
        },
        clearGenreFilters() {
            this.selectedGenres = [];
        },
        toggleFilters() {
            this.isFiltersVisible = !this.isFiltersVisible;
        }
    }
};
</script>

<style scoped>
.products-container {
    padding: 40px 20px;
}

.header-section {
    text-align: center;
    margin-bottom: 40px;
}

.header-section h2 {
    font-size: 2.5em;
    color: #2c3e50;
    margin-bottom: 10px;
}

.subtitle {
    color: #666;
    font-size: 1.1em;
}

.filters-section {
    max-width: 800px;
    margin: 0 auto 30px;
    overflow: hidden;
}

.filters-content {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 30px;
}

.price-filter, .genre-filter {
    padding: 15px;
}

.price-filter h3, .genre-filter h3 {
    margin-bottom: 15px;
    color: #2c3e50;
    font-size: 1.2em;
}

.price-inputs {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

.price-input {
    flex: 1;
}

.price-input label {
    display: block;
    margin-bottom: 5px;
    color: #666;
}

.price-input input {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.range-slider {
    position: relative;
    height: 40px;
}

.slider {
    position: absolute;
    width: 100%;
    height: 5px;
    background: #ddd;
    border-radius: 5px;
    outline: none;
    pointer-events: none;
}

.slider::-webkit-slider-thumb {
    pointer-events: auto;
    -webkit-appearance: none;
    width: 18px;
    height: 18px;
    background: #2c3e50;
    border-radius: 50%;
    cursor: pointer;
}

.genre-options {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
    gap: 10px;
}

.genre-checkbox {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
}

.genre-checkbox input {
    cursor: pointer;
}

.category-tags {
    display: flex;
    justify-content: center;
    gap: 15px;
    margin-bottom: 40px;
    flex-wrap: wrap;
}

.tag {
    padding: 8px 20px;
    border: 2px solid #ddd;
    border-radius: 25px;
    background: transparent;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.9em;
}

.tag:hover, .tag.active {
    background: #2c3e50;
    color: white;
    border-color: #2c3e50;
}

.de {
    position: relative;
    display: flex;
    flex-wrap: wrap;
    gap: 30px;
    justify-content: center;
    padding: 20px;
    min-height: 200px;
}

.pr {
    width: 250px;
    padding: 15px;
    border-radius: 12px;
    background: white;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    text-align: center;
    text-decoration: none;
    color: inherit;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    position: relative;
}

.pr:hover {
    transform: translateY(-8px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.image-container {
    position: relative;
    overflow: hidden;
    border-radius: 8px;
    margin-bottom: 15px;
}

.product-image {
    width: 220px;
    height: 220px;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.hover-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.hover-overlay span {
    color: white;
    font-weight: 500;
    padding: 8px 16px;
    border: 2px solid white;
    border-radius: 20px;
}

.pr:hover .hover-overlay {
    opacity: 1;
}

.pr:hover .product-image {
    transform: scale(1.05);
}

h3 {
    margin: 15px 0 10px;
    font-size: 1.1em;
    color: #2c3e50;
}

.price {
    font-size: 1.2em;
    font-weight: 600;
    color: #2c3e50;
}

.loading-spinner {
    text-align: center;
    padding: 40px;
    color: #666;
}

.error {
    text-align: center;
    color: #e74c3c;
    padding: 20px;
}

.no-results {
    text-align: center;
    padding: 40px;
    color: #666;
    font-size: 1.1em;
}

.filter-toggle {
    margin-top: 20px;
    padding: 10px 20px;
    background: #2c3e50;
    color: white;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 20px auto;
    transition: all 0.3s ease;
}

.filter-toggle:hover {
    background: #34495e;
    transform: translateY(-2px);
}

.arrow {
    width: 0;
    height: 0;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 5px solid white;
    transition: transform 0.3s ease;
}

.arrow.up {
    transform: rotate(180deg);
}

.slide-fade-enter-active {
    transition: all 0.3s ease-out;
}

.slide-fade-leave-active {
    transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from,
.slide-fade-leave-to {
    transform: translateY(-20px);
    opacity: 0;
}

.de {
    perspective: 1000px;
}

.pr {
    animation: fadeIn 0.6s ease-out;
    backface-visibility: hidden;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px) rotateX(-10deg);
    }
    to {
        opacity: 1;
        transform: translateY(0) rotateX(0);
    }
}

.slider::-webkit-slider-thumb {
    transition: transform 0.2s ease;
}

.slider::-webkit-slider-thumb:hover {
    transform: scale(1.2);
}

.genre-checkbox input:checked + span {
    animation: pulse 0.3s ease-in-out;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

@media (max-width: 850px) {
    .filters-content {
        grid-template-columns: 1fr;
        max-width: 500px;
        margin: 0 auto;
    }
}

@media (max-width: 480px) {
    .filters-section {
        margin: 0 15px 30px;
    }
    
    .filters-content {
        padding: 15px;
    }
}

/* Анимации для transition-group */
.fade-move-enter-active,
.fade-move-leave-active {
    transition: all 0.5s cubic-bezier(0.55, 0, 0.1, 1);
}

.fade-move-enter-from {
    opacity: 0;
    transform: scale(0.9) translateY(30px);
}

.fade-move-leave-to {
    opacity: 0;
    transform: scale(0.9) translateY(-30px);
    position: absolute;
}

.fade-move-move {
    transition: transform 0.5s ease;
}
</style>