<template>
    <div class="edit-profile-page">
        <div class="edit-profile-container">
            <div class="form-box">
                <div class="form-content">
                    <h2 class="title">Edit Profile</h2>
                    <div class="subtitle">Update your personal information</div>

                    <div v-if="loading" class="loading">Loading user information...</div>
                    
                    <form v-else @submit.prevent="updateUserInfo" class="edit-form">
                        <div class="input-group">
                            <input type="text" v-model="name" required />
                            <label>Name</label>
                            <span class="highlight"></span>
                        </div>

                        <div class="input-group">
                            <input type="email" v-model="email" required />
                            <label>Email</label>
                            <span class="highlight"></span>
                        </div>

                        <div class="input-group">
                            <input type="password" v-model="password" />
                            <label>New Password</label>
                            <span class="highlight"></span>
                        </div>

                        <div class="input-group">
                            <input type="text" v-model="phone" required />
                            <label>Phone</label>
                            <span class="highlight"></span>
                        </div>

                        <div class="input-group">
                            <input type="text" v-model="address" required />
                            <label>Address</label>
                            <span class="highlight"></span>
                        </div>

                        <transition name="fade">
                            <p v-if="successMessage" class="success">{{ successMessage }}</p>
                        </transition>
                        <transition name="fade">
                            <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
                        </transition>

                        <button type="submit" class="submit-btn">
                            <span>Save Changes</span>
                            <div class="liquid"></div>
                        </button>
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
            name: '',
            email: '',
            password: '',
            phone: '',
            address: '',
            loading: true,
            successMessage: '',
            errorMessage: ''
        };
    },
    created() {
        this.getUserInfo();
    },
    methods: {
        async getUserInfo() {
            const token = localStorage.getItem('jwt');
            // if (!token) {
            //     this.$router.push('/login');
            //     return;
            // }

            try {
                const response = await axios.get('http://localhost:8080/api/users/me', {
                    headers: { Authorization: `Bearer ${token}` }
                });
                const userData = response.data;

                this.name = userData.name;
                this.email = userData.email;
                this.phone = userData.phone;
                this.address = userData.address;
            } catch (error) {
                console.error('Failed to fetch user info:', error);
                this.errorMessage = 'Failed to load user information.';
            } finally {
                this.loading = false;
            }
        },
        async updateUserInfo() {
            const token = localStorage.getItem('jwt');
            try {
                await axios.put(
                    'http://localhost:8080/api/users/me',
                    {
                        name: this.name,
                        email: this.email,
                        passwordHash: this.password ? this.password : null,
                        phone: this.phone,
                        address: this.address,
                    },
                    { headers: { Authorization: `Bearer ${token}` } }
                );

                this.successMessage = 'Profile updated successfully!';
                this.errorMessage = '';
            } catch (error) {
                console.error('Failed to update user info:', error);
                this.errorMessage = 'Failed to update user information.';
            }
        }
    }
};
</script>

<style scoped>
.edit-profile-page {
    min-height: 100vh;
    background: #F2F1EC; /* Кремовый фон как на основном сайте */
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    position: relative;
}

.edit-profile-container {
    width: 100%;
    max-width: 600px;
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    position: relative;
    z-index: 2;
}

.title {
    color: #313034;
    font-size: 2.5em;
    margin-bottom: 10px;
    text-align: center;
    font-weight: 300;
    letter-spacing: 2px;
}

.subtitle {
    color: #666;
    text-align: center;
    margin-bottom: 40px;
    font-size: 0.9em;
    letter-spacing: 1px;
}

.input-group {
    position: relative;
    margin-bottom: 35px;
    background: #f8f8f8;
    border-radius: 10px;
    padding: 15px 20px;
    border: 1px solid #eee;
    transition: all 0.3s ease;
}

.input-group:hover {
    background: #fff;
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

.input-group input {
    width: 100%;
    padding: 10px 0;
    font-size: 16px;
    color: #313034;
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
    color: #666;
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
    box-shadow: 0 4px 15px rgba(184, 134, 11, 0.3);
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

.success {
    color: #4CAF50;
    text-align: center;
    margin-top: 10px;
}

.error {
    color: #f44336;
    text-align: center;
    margin-top: 10px;
}

.loading {
    color: #313034;
    text-align: center;
    font-size: 1.2em;
    margin: 20px 0;
}

@keyframes container-glow {
    from {
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
    }
    to {
        box-shadow: 0 8px 32px 0 rgba(184, 134, 11, 0.37);
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
