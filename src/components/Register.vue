<template>
    <div class="auth-page">
        <div class="auth-container">
            <div class="form-box register-container">
                <div class="form-content">
                    <h2 class="title">Create Account</h2>
                    <form @submit.prevent="registerUser" class="register-form">
                        <div class="input-group">
                            <input type="email" v-model="email" required />
                            <label>Email</label>
                            <span class="highlight"></span>
                        </div>

                        <div class="input-group">
                            <input type="password" v-model="password" required />
                            <label>Password</label>
                            <span class="highlight"></span>
                        </div>

                        <transition name="fade">
                            <p v-if="successMessage" class="success">{{ successMessage }}</p>
                        </transition>
                        <transition name="fade">
                            <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
                        </transition>

                        <button type="submit" class="submit-btn">
                            <span>Sign Up</span>
                        </button>

                        <p class="switch-auth">
                            Already have an account? 
                            <router-link to="/login" class="switch-link">Login</router-link>
                        </p>
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
            email: '',
            password: '',
            successMessage: '',
            errorMessage: '',
        };
    },
    methods: {
        async registerUser() {
            try {
                await axios.post('http://localhost:8080/api/register', {
                    email: this.email,
                    passwordHash: this.password,
                });

                this.successMessage = 'Registration successful!';
                this.errorMessage = '';
                
                // Добавляем задержку перед редиректом для показа сообщения об успехе
                setTimeout(() => {
                    this.$router.push('/login');
                }, 1500);
                
            } catch (error) {
                if (error.response && error.response.status === 400) {
                    this.errorMessage = 'Email already exists. Please use a different email.';
                } else {
                    this.errorMessage = 'Registration failed. Please try again later.';
                }
                this.successMessage = '';
            }
        },
    },
};
</script>

<style scoped>
.auth-page {
    min-height: 100vh;
    background: linear-gradient(135deg, #1a1a1a 0%, #363636 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.auth-container {
    width: 100%;
    max-width: 480px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
    animation: slideIn 0.6s ease-out;
}

.title {
    color: #fff;
    font-size: 2.5em;
    margin-bottom: 40px;
    text-align: center;
    font-weight: 300;
    letter-spacing: 1px;
}

.input-group {
    position: relative;
    margin-bottom: 35px;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 10px;
    padding: 15px 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.3s ease;
}

.input-group:hover {
    background: rgba(255, 255, 255, 0.12);
}

.input-group input {
    width: 100%;
    padding: 10px 0;
    font-size: 16px;
    color: #fff;
    border: none;
    background: transparent;
    outline: none;
    transition: 0.3s;
}

.input-group label {
    position: absolute;
    top: 25px;
    left: 20px;
    font-size: 15px;
    color: rgba(255, 255, 255, 0.7);
    pointer-events: none;
    transition: all 0.3s ease;
}

.input-group input:focus ~ label,
.input-group input:valid ~ label {
    top: 5px;
    left: 20px;
    font-size: 12px;
    color: #B8860B;
}

.input-group .highlight {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 2px;
    background: #B8860B;
    transform: scaleX(0);
    transition: 0.3s;
}

.input-group input:focus ~ .highlight {
    transform: scaleX(1);
}

/* Стили для автозаполнения */
.input-group input:-webkit-autofill {
    -webkit-text-fill-color: #fff;
    -webkit-box-shadow: 0 0 0px 1000px transparent inset;
    transition: background-color 5000s ease-in-out 0s;
}

.submit-btn {
    position: relative;
    width: 100%;
    padding: 15px;
    margin-top: 20px;
    border: none;
    background: #B8860B;
    color: #fff;
    font-size: 16px;
    cursor: pointer;
    border-radius: 5px;
    overflow: hidden;
    transition: 0.3s;
}

.submit-btn:hover {
    background: #9B7506;
    transform: translateY(-2px);
}

.submit-btn span {
    position: relative;
    z-index: 1;
}

.submit-btn .liquid {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: #B8860B;
    z-index: 0;
}

.submit-btn .liquid::before,
.submit-btn .liquid::after {
    content: '';
    position: absolute;
    width: 200%;
    height: 200%;
    top: -50%;
    left: 50%;
    transform: translate(-50%, -75%);
}

.submit-btn .liquid::before {
    border-radius: 45%;
    background: rgba(255, 255, 255, 0.5);
    animation: rotate 10s linear infinite;
}

.submit-btn .liquid::after {
    border-radius: 40%;
    background: rgba(255, 255, 255, 0.3);
    animation: rotate 15s linear infinite;
}

@keyframes rotate {
    0% {
        transform: translate(-50%, -75%) rotate(0deg);
    }
    100% {
        transform: translate(-50%, -75%) rotate(360deg);
    }
}

.success {
    color: #4CAF50;
    text-align: center;
    margin-top: 10px;
    animation: fadeIn 0.3s ease-out;
}

.error {
    color: #f44336;
    text-align: center;
    margin-top: 10px;
    animation: fadeIn 0.3s ease-out;
}

.switch-auth {
    margin-top: 20px;
    color: #fff;
    text-align: center;
}

.switch-link {
    color: #B8860B;
    text-decoration: none;
    font-weight: 500;
    transition: 0.3s;
}

.switch-link:hover {
    color: #9B7506;
}

/* Анимации */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

.fade-enter-active, .fade-leave-active {
    transition: opacity 0.3s;
}

.fade-enter-from, .fade-leave-to {
    opacity: 0;
}
</style>
