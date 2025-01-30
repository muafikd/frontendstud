<template>
    <div class="main-container">

        <div class="content">
            <div class="loading">
                <img src="./../assets/images/image26.png" alt="Loading..." class="loading-image" />
            </div>

            <div></div>
        </div>
        <div class="content">
            <div class="content-wrapper">
                <div class="textblock">
                    <p>Магазин музыки</p>
                    <p>Эксклюзивные диски</p>
                    <p>В нашем магазине есть самые новые и эксклюзивные диски.</p>
                </div>
                <div class="imf">
                    <img src="./../assets/images/image.png" alt="Loading..." />
                </div>
            </div>
        </div>

        <div class="content">
            <div class="content-wrapper">
                <div class="imf">
                    <img src="./../assets/images/image2.png" alt="Loading..." />
                </div>
                <div class="textblock">
                    <p>Почему мы?</p>
                    <p>Мы продаем новые и подержанные виниловые пластинки без жанровых ограничений.</p>
                    <p>У нас можно купить как «классические» рок-альбомы, так и современную электронику. Есть
                        ассортимент классической музыки, джаза, металла, хип-хопа и многое другое. </p>
                </div>
            </div>
        </div>
        <div class="cot">
            <div class="content">
                <img src="./../assets/images/image10.png" alt="Image 1">
            </div>
            <div class="content">
                <img src="./../assets/images/image20.png" alt="Image 2">
            </div>
            <div class="content">
                <img src="./../assets/images/image30.png" alt="Image 3">
            </div>
        </div>



        <div class="container20">
            <img src="./../assets/images/d3.png" alt="Logo" />
            <p>Мы придаем большое значение музыке Казахстанских исполнителей <br> и хотим сохранить и донести до людей
                творчество <br> наших предков. Возможность отправить в любую точку мира.</p>
        </div>

        <div class="content">
            <div class="content-wrapper">
                <div class="textblock">
                    <p>Заходите к нам</p>
                    <p>Открыты каждый день с <br> 11:00 до 22:00</p>
                    <p>Астана,
                        <br>Ул. Аружановы 28.
                    </p>
                </div>
                <div class="imf">
                    <img src="./../assets/images/image45.png" alt="Loading..." />
                </div>
            </div>
        </div>

        <footer class="container30">
            <img src="./../assets/images/d3.png" alt="Logo" />
        </footer>


    </div>
</template>

<!-- 
<button @click="logout">Logout</button>
            <button @click="editProfile" class="edit-profile-button">Edit Profile</button>
            <button @click="$router.push('/products'); " class="edit-profile-button">Products</button> -->
<script>
import axios from 'axios';

export default {
    data() {
        return {
            userEmail: '',
            loading: true,
            errorMessage: '',
        };
    },
    created() {
        this.getUserInfo();
    },
    methods: {
        async getUserInfo() {
            const token = localStorage.getItem('jwt');

            // if (!token) {
            //     this.$router.push('/login'); // Redirect if token is missing
            //     return;
            // }

            try {
                const response = await axios.get('http://localhost:8080/api/users/me', {
                    headers: { Authorization: `Bearer ${token}` },
                    withCredentials: true,
                });

                this.userEmail = response.data.email; // Display logged-in user’s email
            } catch (error) {
                console.error('Failed to fetch user info:', error);
                this.errorMessage = 'Failed to fetch user information. Please login again.';
                // this.$router.push('/login');
            } finally {
                this.loading = false;
            }
        },
        logout() {
            localStorage.removeItem('jwt'); // Remove token on logout
            this.$router.push('/login'); // Redirect to login page
        },
        editProfile() {
            this.$router.push('/edit-profile'); // Navigate to edit profile page
        },
    }

};
</script>


<style scoped>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background-color: #313034;
    color: #313034;
}

.main-container {
    width: 100%;
    height: 100%;
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

.logo img {
    height: 30px;
}

.nav-menu ul {
    list-style: none;
    display: flex;
    gap: 20px;
    margin-right: 50px;
}

.cot {
    display: flex;
    text-align: center;
    justify-content: center;
    margin-top: 20px;
    margin-bottom: 20px;
}

.container20 {
    background-color: #A387A6;
    text-align: center;
    padding-top: 20px;
    padding-bottom: 20px;
    color: white;
    margin-bottom: 20px;
}

.container30 {
    background-color: #9E8D7B;
    text-align: center;
    padding-top: 20px;
    padding-bottom: 20px;
    color: white;
}

.nav-menu ul li a {
    text-decoration: none;
    color: #313034;
    font-size: 1rem;
}

.nav-menu ul li a:hover {
    color: #363636;
}

.profile-section {
    display: flex;
    align-items: center;
    gap: 10px;
}

.profile-btn {
    background-color: transparent;
    border: none;
    color: #313034;
    cursor: pointer;
    margin-right: 10px;
}

.profile-btn svg {
    width: 24px;
    height: 24px;
}

.content {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    color: #333;
    padding: 5px;
    box-sizing: border-box;
    margin-top: 1px;
}

h2 {
    font-size: 2rem;
    margin-bottom: 20px;
}

.loading {
    font-size: 1.2rem;

}

.error {
    color: red;
    margin-top: 10px;
}

.buttons {
    margin-top: 20px;
}

.btn {
    background-color: #4caf50;
    color: #313034;
    border: none;
    padding: 10px 20px;
    margin: 10px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
}

.btn:hover {
    background-color: #45a049;
}

.logout-btn {
    background: transparent;
    border: none;
    color: #313034;
}

.white-icon {
    stroke: white;
}

.edit-profile-btn {
    background-color: #313034;
}

.edit-profile-btn:hover {
    background-color: #313034;
}

.content-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
    max-width: 1160px;

}

.textblock {
    flex: 1;
    max-width: 60%;
    margin-left: 20px;
    margin-right: 30px;
}

.imf img {
    max-width: 100%;
    /* Уменьшение размера картинки */
    height: auto;
}

p {
    margin: 10px 0;
    font-size: 18px;
}
</style>