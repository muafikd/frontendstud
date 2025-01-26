<template>
    <div class="navbar">
        <h1>StudyStep</h1>
        <div class="nav-links">
            <router-link to="/" class="nav-link" :class="{ active: isActive('/main') }">Басты бет</router-link>
            <router-link to="/journal" class="nav-link" :class="{ active: isActive('/journal') }">Журнал</router-link>
            <router-link to="/test" class="nav-link" :class="{ active: isActive('/test') }">Тесттер</router-link>
            <router-link to="/school-classes" class="nav-link" :class="{ active: isActive('/school-classes') }">Сыныптар</router-link>
            <div class="search-wrapper">
                <input type="text" placeholder="Іздеу" class="search" v-model="searchQuery" />
                <button class="clear-btn" @click="clearSearch">&times;</button>
            </div>
            <div class="notification">
                <button style="background: none; border: none; padding: 0;">
                    <img src="https://d3t0tbmlie281e.cloudfront.net/igi/aeroqual/R3NxMElH2PkT1Amk.full" />
                </button>
            </div>
            <button class="logout-btn" @click="logout">Шығу</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
export default {
    data() {
        return {
            searchQuery: "", // Bind this to the search input
        };
    },
    methods: {
        clearSearch() {
            this.searchQuery = ""; // Clear the search input
        },
        isActive(route) {
            return this.$route.path === route; // Check if the current route matches
        },
        async logout() {
            console.log(`TOKEN: ${localStorage.getItem("jwtToken")}`)
            const response = await axios
                .post("http://localhost:8080/api/auth/logout", null, {
                    headers: {
                        Authorization: `${localStorage.getItem("jwtToken")}`, // Add JWT token if needed
                    },
                })
                .then(() => {
                    localStorage.removeItem("jwtToken");
                    localStorage.removeItem("teacherUsername");
                    console.log(`TOKEN: ${localStorage.getItem("jwtToken")}`)

                    console.log("User logged out successfully");

                    this.$router.push("/login");
                })
                .catch((error) => {
                    console.log(`TOKEN: ${localStorage.getItem("jwtToken")}`)

                    console.error("Error during logout:", error);
                });
        }

    },
};
</script>

<style scoped>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: white;
    color: #6200ea;
    padding: 15px 20px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.nav-links {
    display: flex;
    align-items: center;
}

.nav-links a {
    color: #6200ea;
    text-decoration: none;
    margin: 0 30px;
    font-weight: 300;
    position: relative;
}

.nav-links a.active {
    font-weight: bold;
}

.nav-links a.active::after {
    content: "";
    display: block;
    width: 100%;
    height: 2px;
    background-color: #6200ea;
    position: absolute;
    left: 0;
    bottom: -5px;
}

.search-wrapper {
    position: relative;
    display: flex;
    align-items: center;
}

.search {
    padding: 5px;
    border-radius: 20px;
    border: 1px solid #ccc;
    padding-right: 30px;
}

.clear-btn {
    position: absolute;
    right: 10px;
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    color: #ccc;
}

.notification {
    font-size: 24px;
    margin-left: 15px;
    color: #6200ea;
}

.notification img {
    width: 45px;
    height: 40px;
    margin-top: 10px;
}

.logout-btn {
    background: none;
    border: none;
    color: #6200ea;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    margin-left: 20px;
}
</style>
