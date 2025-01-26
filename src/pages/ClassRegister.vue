<template>
    <div class="container">
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

        <div class="right">
            <h1>Сыныпты тіркеу</h1>
            <form @submit.prevent="handleSubmit">
                <div>
                    <input v-model="username" type="text" id="username" placeholder="Аты" required />
                </div>
                <div>
                    <input v-model="password" type="password" id="password" placeholder="Құпиясөз" required />
                </div>
                <div>
                    <button type="submit">Сыныпты тіркеу</button>
                </div>
                <div class="text-link">
                    <router-link to="/class-login">Сыныпқа кіру</router-link>
                </div>
                <div v-if="error" class="error-message">
                    Қолданушы аты немесе құпиясөз дұрыс емес!
                </div>
            </form>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            username: '',
            password: '',
            error: false,
        };
    },
    methods: {
        async handleSubmit() {
            // Implement your registration logic here, for example, sending data to the backend.
            try {
                // Mock API call (replace with real backend call)
                if (this.username === 'correct' && this.password === 'password') {
                    // Redirect to login page or other pages upon success
                    this.$router.push('/login');
                } else {
                    this.error = true;
                }
            } catch (err) {
                this.error = true;
            }
        },
    },
};
</script>

<style scoped>
body {
    margin: 0;
    padding: 0;
    font-family: 'Inika', sans-serif;
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
    font-family: 'Inika', sans-serif;
    text-align: left;
}

.left .overlay-text .logo {
    display: flex;
    align-items: center;
    position: relative;
}

.left .overlay-text .logo .letter-s {
    font-size: 130px;
    font-weight: bold;
    color: white;
    line-height: 1;
    margin-right: 1px;
}

.left .overlay-text .logo .side-text {
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
    margin-bottom: 100px;
    color: #414141;
}

.right label {
    font-size: 18px;
    margin-bottom: 10px;
    display: block;
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

.join-class-link {
    position: absolute;
    top: 20px;
    right: 20px;
    color: gray;
    font-size: 16px;
    cursor: pointer;
    text-decoration: underline;
    padding: 0;
    transition: color 0.3s;
}

.join-class-link:hover {
    color: #5a00d1;
}
</style>