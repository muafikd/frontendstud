<template>
  <div id="app">
    <template v-if="!isAuthPage">
      <div class="promo-banner">
        <p>Получите скидку по промокоду "START"</p>
      </div>
      <header class="header">
        <div class="logo">
          <router-link to="/main">
            <img src="./assets/images/logoo.png" alt="Logo" />
          </router-link>
        </div>
        <div class="profile-section">
          <nav class="nav-menu">
            <ul>
              <li>
                <router-link to="/products">Каталог</router-link>
              </li>
            </ul>
          </nav>
          <!-- Кнопка добавления продуктов (только для админа) -->
          <button v-if="isAdmin" @click="goToProductList" class="admin-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M12 5v14M5 12h14"/>
            </svg>
          </button>
          <button @click="goToCart" class="cart-btn">
            <svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" 
              stroke-width="2" viewBox="0 0 24 24" class="feather feather-shopping-cart">
              <path d="M9 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4zM20 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4z" />
              <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
            </svg>
          </button>
          <button @click="goToOrders" class="orders-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
            </svg>
          </button>
          <button @click="editProfile" class="profile-btn">
            <svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor"
              stroke-width="2" viewBox="0 0 24 24" class="feather feather-user">
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zM12 14c-3.31 0-6 2.69-6 6v2h12v-2c0-3.31-2.69-6-6-6z" />
            </svg>
          </button>
          <button @click="logout" class="logout-btn">
            <svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="#000" stroke-width="2"
              viewBox="0 0 24 24" class="feather feather-log-out black-icon">
              <path d="M17 11l4-4m0 0l-4-4m4 4H3m14 4H7a2 2 0 0 0-2 2v3a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2z" />
            </svg>
          </button>
        </div>
      </header>
    </template>

    <!-- Добавляем элемент для анимации -->
    <div v-if="showCartAnimation" 
         class="cart-animation" 
         :style="cartAnimationStyles">
      <div class="cart-animation-item"></div>
    </div>

    <!-- Добавляем контейнер для уведомлений -->
    <div class="notifications-container">
      <transition-group name="notification">
        <div v-for="notification in notifications" 
             :key="notification.id"
             class="notification"
             :class="notification.type">
          <div class="notification-content">
            <span class="notification-message">{{ notification.message }}</span>
          </div>
          <button @click="removeNotification(notification.id)" class="notification-close">
            ×
          </button>
        </div>
      </transition-group>
    </div>

    <transition name="page" mode="out-in">
      <router-view />
    </transition>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'App',
  computed: {
    isAuthPage() {
      return ['/login', '/register'].includes(this.$route.path);
    }
  },
  data() {
    return {
      showCartAnimation: false,
      cartAnimationStyles: {
        left: '0px',
        top: '0px'
      },
      notifications: [],
      notificationId: 0,
      isAdmin: false
    }
  },
  created() {
    this.checkAdminRole();
    // Добавляем слушатели событий
    window.addEventListener('storage', this.checkAdminRole);
    window.addEventListener('login', this.checkAdminRole);
    window.addEventListener('logout', this.checkAdminRole);
  },
  watch: {
    // Следим за изменениями маршрута
    '$route'() {
      this.checkAdminRole();
    }
  },
  beforeUnmount() {
    // Удаляем слушатели
    window.removeEventListener('storage', this.checkAdminRole);
    window.removeEventListener('login', this.checkAdminRole);
    window.removeEventListener('logout', this.checkAdminRole);
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
          this.isAdmin = false;
        }
      } else {
        this.isAdmin = false;
      }
    },
    goToProductList() {
      this.$router.push('/product-list');
    },
    goToCart() {
      this.$router.push('/cart');
    },
    goToOrders() {
      this.$router.push('/orders');
    },
    editProfile() {
      this.$router.push('/edit-profile');
    },
    async logout() {
      try {
        const token = localStorage.getItem('jwt');
        await axios.post('http://localhost:8080/api/logout', {}, {
          headers: {
            Authorization: `${token}`
          }
        });

        localStorage.removeItem('jwt');
        // Вызываем событие logout
        window.dispatchEvent(new Event('logout'));
        this.$router.push('/login');
      } catch (error) {
        console.error('Logout failed:', error);
        localStorage.removeItem('jwt');
        window.dispatchEvent(new Event('logout'));
        this.$router.push('/login');
      }
    },
    // Метод для запуска анимации
    animateToCart(startX, startY) {
      // Получаем позицию кнопки корзины
      const cartButton = document.querySelector('.cart-btn');
      const cartRect = cartButton.getBoundingClientRect();
      
      // Устанавливаем начальную позицию
      this.cartAnimationStyles = {
        left: `${startX}px`,
        top: `${startY}px`
      }
      
      // Показываем элемент анимации
      this.showCartAnimation = true;
      
      // Добавляем небольшую задержку перед началом анимации
      setTimeout(() => {
        this.cartAnimationStyles = {
          left: `${cartRect.left + cartRect.width/2}px`,
          top: `${cartRect.top + cartRect.height/2}px`
        }
      }, 50);
      
      // Скрываем элемент после завершения анимации
      setTimeout(() => {
        this.showCartAnimation = false;
      }, 1000);
    },
    // Метод для показа уведомления
    showNotification(message, type = 'success') {
      const id = this.notificationId++;
      this.notifications.push({
        id,
        message,
        type
      });
      
      // Автоматически удаляем уведомление через 3 секунды
      setTimeout(() => {
        this.removeNotification(id);
      }, 3000);
    },
    
    // Метод для удаления уведомления
    removeNotification(id) {
      this.notifications = this.notifications.filter(n => n.id !== id);
    }
  }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@100;400;700;900&display=swap');

body {
  font-family: 'Montserrat', sans-serif;
  margin: 0;
  padding: 0;
  background-color: #F2F1EC;
}

.promo-banner {
  background-color: #333;
  color: #ffffff;
  text-align: center;
  padding: 10px 0;
  font-size: 15px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background-color: #f2f1ec;
  margin-left: 80px;
  margin-right: 80px;
}

.logo {
  cursor: pointer;
}

.logo a {
  display: inline-block;
  text-decoration: none;
}

.logo img {
  height: 30px;
  transition: transform 0.2s ease;
}

.logo img:hover {
  transform: scale(1.05);
}

.nav-menu ul {
  list-style: none;
  display: flex;
  gap: 20px;
  margin-right: 50px;
}

.nav-menu ul li a,
.nav-menu ul li router-link {
  text-decoration: none;
  color: #313034;
  font-size: 1rem;
  transition: color 0.2s ease;
}

.nav-menu ul li a:hover,
.nav-menu ul li router-link:hover {
  color: #363636;
}

/* Убираем стандартное подчеркивание у router-link */
.router-link-active {
  color: #B8860B;
  font-weight: 500;
}

.profile-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.cart-btn, .profile-btn, .logout-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
    margin: 0 5px;
    border-radius: 50%;
    transition: all 0.3s ease;
}

.cart-btn:hover, .profile-btn:hover, .logout-btn:hover {
    background: rgba(184, 134, 11, 0.1);
    transform: translateY(-2px);
}

.cart-btn svg, .profile-btn svg, .logout-btn svg {
    transition: all 0.3s ease;
}

.cart-btn:hover svg, .profile-btn:hover svg, .logout-btn:hover svg {
    stroke: #B8860B;
}

/* Анимации перехода страниц */
.page-enter-active,
.page-leave-active {
  transition: all 0.4s ease;
}

.page-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.page-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}

/* Предотвращаем скролл во время анимации */
.page-enter-active,
.page-leave-active {
  position: absolute;
  width: 100%;
}

/* Обеспечиваем правильное позиционирование контента */
#app {
  position: relative;
  min-height: 100vh;
}

.cart-animation {
  position: fixed;
  z-index: 9999;
  pointer-events: none;
  transition: all 0.8s cubic-bezier(0.215, 0.61, 0.355, 1);
}

.cart-animation-item {
  width: 20px;
  height: 20px;
  background: #B8860B;
  border-radius: 50%;
  opacity: 0.8;
  animation: scaleDown 0.8s forwards;
}

@keyframes scaleDown {
  0% {
    transform: scale(1);
    opacity: 0.8;
  }
  100% {
    transform: scale(0.2);
    opacity: 0;
  }
}

/* Добавляем анимацию подпрыгивания для иконки корзины */
@keyframes cartBounce {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.2); }
}

.cart-btn.animate {
  animation: cartBounce 0.5s ease;
}

.notifications-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notification {
  display: flex;
  align-items: center;
  min-width: 300px;
  padding: 15px 20px;
  border-radius: 8px;
  background: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  animation: slideIn 0.3s ease-out;
}

.notification.success {
  border-left: 4px solid #4CAF50;
}

.notification.error {
  border-left: 4px solid #f44336;
}

.notification.info {
  border-left: 4px solid #2196F3;
}

.notification-content {
  flex: 1;
  margin-right: 10px;
}

.notification-message {
  color: #333;
  font-size: 0.95em;
}

.notification-close {
  background: none;
  border: none;
  color: #999;
  font-size: 20px;
  cursor: pointer;
  padding: 0 5px;
  transition: color 0.2s;
}

.notification-close:hover {
  color: #333;
}

/* Анимации для уведомлений */
.notification-enter-active,
.notification-leave-active {
  transition: all 0.3s ease;
}

.notification-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.notification-leave-to {
  opacity: 0;
  transform: translateX(100%);
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.orders-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
    margin: 0 5px;
    border-radius: 50%;
    transition: all 0.3s ease;
}

.orders-btn:hover {
    background: rgba(184, 134, 11, 0.1);
    transform: translateY(-2px);
}

.orders-btn svg {
    transition: all 0.3s ease;
}

.orders-btn:hover svg {
    stroke: #B8860B;
}

.admin-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
    margin: 0 5px;
    border-radius: 50%;
    transition: all 0.3s ease;
}

.admin-btn:hover {
    background: rgba(184, 134, 11, 0.1);
    transform: translateY(-2px);
}

.admin-btn svg {
    stroke: #B8860B;
    transition: all 0.3s ease;
}

.admin-btn:hover svg {
    stroke: #9B7506;
}
</style>
