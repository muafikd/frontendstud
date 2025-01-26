<template>
    <div class="container">
        <!-- Left Section -->
        <div class="left">
            <img src="https://uploads-ssl.webflow.com/628098d9ac3825d23c47c9ac/62991b11aee8abd70d8dbf51_Saly-10%20(2)-p-2000.png"
                alt="Image Illustration" />
            <div class="overlay-text">
                <div class="logo">
                    <span class="letter-s">S</span>
                    <div class="right-container">
                        <span class="side-text">tudy<br />tep</span>
                    </div>
                </div>
                <p>Білім беру порталы</p>
            </div>
        </div>

        <!-- Right Section -->
        <div class="right">
            <h1>Тіркелу</h1>
            <form @submit.prevent="submitForm">
                <div>
                    <input type="text" v-model="user.username" placeholder="Логин" required />
                </div>
                <div>
                    <input type="password" v-model="user.password" placeholder="Құпиясөз" required />
                </div>
                <div>
                    <input type="text" v-model="user.name" placeholder="Аты-жөніңіз" required />
                </div>
                <div>
                    <p v-if="successMessage" class="success">{{ successMessage }}</p>
                    <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
                    <button type="submit">Тіркелу</button>
                </div>
                <div class="text-link">
                    <router-link to="/login">Парақшаңыз бар ма?</router-link>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            user: {
                username: "",
                password: "",
                name: "",
            },
            successMessage: "", // Message for successful registration
            errorMessage: "", // Message for errors
        };
    },
    methods: {
        async submitForm() {
            this.successMessage = "";
            this.errorMessage = "";

            try {
                const response = await axios.post("http://localhost:8080/api/auth/register", this.user);

                this.successMessage = "Тіркелу сәтті аяқталды! Қазір логин жасаңыз.";
                this.errorMessage = "";
                this.user.username = "";
                this.user.password = "";
                this.user.name = "";

                setTimeout(() => {
                    this.$router.push("/login");
                }, 2000);
            } catch (error) {
                if (error.response && error.response.data && error.response.data.message) {
                    this.errorMessage = error.response.data.message;
                } else {
                    this.errorMessage = "Тіркелу кезінде қате орын алды. Қайта көріңіз.";
                }
            }
        },
    },
};
</script>


<style scoped>
body {
    margin: 0;
    padding: 0;
    font-family: "Inika", sans-serif;
    background-color: #977dff;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    display: flex;
    width: 100vw;
    height: 100vh;
}

.left {
    flex: 1;
    background-color: #977dff;
    display: flex;
    justify-content: center;
    align-items: flex-end;
    position: relative;
}

.left img {
    max-width: 80%;
    max-height: 80%;
    height: auto;
    margin-bottom: 30px;
}

.left .overlay-text {
    position: absolute;
    top: 10px;
    left: 20px;
    color: white;
    font-family: "Inika", sans-serif;
    text-align: left;
}

.overlay-text .logo {
    display: flex;
    align-items: center;
    position: relative;
}

.overlay-text .logo .letter-s {
    font-size: 130px;
    font-weight: bold;
    color: white;
    line-height: 1;
    margin-right: 1px;
}

.overlay-text .logo .side-text {
    font-size: 48px;
    color: white;
    line-height: 1;
    margin-left: 1px;
}

.right {
    flex: 1;
    padding: 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    background-color: #ffffff;
    box-shadow: -4px 0 15px rgba(0, 0, 0, 0.1);
    border-top-left-radius: 50px;
    border-bottom-left-radius: 50px;
    position: relative;
}

.right h1 {
    font-size: 50px;
    margin-bottom: 100;
    color: #414141;
}

.right input {
    width: 100%;
    padding: 10px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 16px;
}

.right button {
    padding: 10px;
    background-color: #787878;
    color: #fff;
    border: none;
    border-radius: 5px;
    font-size: 18px;
    cursor: pointer;
}

.right button:hover {
    background-color: #333;
}

.text-link {
    margin-top: 20px;
}

.text-link a {
    color: #787878;
    text-decoration: none;
}

.text-link a:hover {
    text-decoration: underline;
}

.error-message {
    color: red;
}

.overlay-text p {
    margin-left: 10px;
    font-size: 20px;
    margin-top: 10px;
}
</style>