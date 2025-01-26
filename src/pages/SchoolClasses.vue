<template>
    <div class="page-container">
        <h1 class="page-title">Manage School Classes</h1>

        <!-- Classes List -->
        <div class="class-container">
            <h2>Classes</h2>
            <div class="class-list">
                <div v-for="schoolClass in classes" :key="schoolClass.id" class="class-card">
                    <div class="class-header">
                        <span class="class-name">{{ schoolClass.name }}</span>
                    </div>
                    <ul class="student-list">
                        <li v-for="student in schoolClass.students" :key="student.id" class="student-item">
                            <span class="star">&#9733;</span>
                            {{ student.name }} <span class="student-grade">A</span>
                        </li>
                    </ul>
                    <div class="class-actions">
                        <button @click="toggleStudentList(schoolClass.id)" class="btn btn-secondary">
                            Add Students
                        </button>

                        <!-- Only show add student option when the class is expanded -->
                        <div v-if="expandedClasses.includes(schoolClass.id)" class="add-student-container">
                            <select v-model="selectedStudent" :disabled="!availableStudents.length">
                                <option disabled value="">Select a student</option>
                                <option v-for="student in availableStudents" :value="student.id" :key="student.id">
                                    {{ student.name }}
                                </option>
                            </select>
                            <button @click="addStudentToClass(schoolClass.id)" :disabled="!selectedStudent">
                                Add Student
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Floating Action Button for creating new class -->
        <div class="fab-container">
            <button class="fab" @click="showCreateClassModal">
                <span class="fab-icon">+</span>
            </button>
        </div>

        <!-- Create Class Modal (hidden by default) -->
        <div v-if="isCreateClassModalVisible" class="modal-overlay" @click="closeCreateClassModal">
            <div class="modal-content" @click.stop>
                <h3>Create New Class</h3>
                <input type="text" v-model="className" placeholder="Enter class name" class="input-field" required />
                <button @click="createClass" class="btn btn-primary">Create Class</button>
                <button @click="closeCreateClassModal" class="btn btn-secondary">Cancel</button>
            </div>
        </div>
    </div>
</template>



<script>
import axios from "axios";

export default {
    data() {
        return {
            className: "",
            studentName: "",
            studentUsername: "",
            studentPassword: "",
            selectedStudent: "",
            classes: [],
            availableStudents: [],
            expandedClasses: [],
            classSuccessMessage: "",
            classErrorMessage: "",
            studentSuccessMessage: "",
            studentErrorMessage: "",
            isCreateClassModalVisible: false, // controls modal visibility
            newClassName: "", // stores the class name input
        };
    },
    methods: {
        async createClass() {
            try {
                const response = await axios.post(
                    "http://localhost:8080/api/school-classes/create",
                    { name: this.className },
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                this.classSuccessMessage = "Class created successfully!";
                this.classErrorMessage = "";
                this.className = "";
                this.classes.push(response.data);
            } catch (error) {
                this.classErrorMessage = error.response?.data || "Error creating the class.";
            }
        },
        async registerStudent() {
            try {
                const response = await axios.post(
                    "http://localhost:8080/api/teacher/register-student",
                    {
                        name: this.studentName,
                        username: this.studentUsername,
                        password: this.studentPassword,
                    },
                    {
                        headers: { Authorization: `${localStorage.getItem("jwtToken")}` },
                    }
                );
                this.studentSuccessMessage = "Student registered successfully!";
                this.studentErrorMessage = "";
                this.studentName = "";
                this.studentUsername = "";
                this.studentPassword = "";
                this.fetchAvailableStudents();
            } catch (error) {
                this.studentErrorMessage = error.response?.data || "Error registering the student.";
            }
        },
        async fetchClasses() {
            try {
                const response = await axios.get(
                    "http://localhost:8080/api/school-classes",
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                this.classes = response.data;
            } catch (error) {
                console.error("Failed to load classes.");
            }
        },
        async fetchAvailableStudents() {
            try {
                const response = await axios.get(
                    "http://localhost:8080/api/students/available-students",
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                this.availableStudents = response.data;
            } catch (error) {
                console.error("Failed to load students.");
            }
        },
        toggleStudentList(classId) {
            if (this.expandedClasses.includes(classId)) {
                this.expandedClasses = this.expandedClasses.filter(id => id !== classId);
            } else {
                this.expandedClasses.push(classId);
            }
        },
        async addStudentToClass(classId) {
            try {
                const response = await axios.post(
                    `http://localhost:8080/api/school-classes/${classId}/add-student/${this.selectedStudent}`,
                    {},
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                const updatedClass = response.data;
                this.classes = this.classes.map(schoolClass =>
                    schoolClass.id === updatedClass.id ? updatedClass : schoolClass
                );
                this.selectedStudent = "";
                this.fetchClasses();
            } catch (error) {
                console.error("Error adding student to class.");
            }
        },
        showCreateClassModal() {
            this.isCreateClassModalVisible = true; // Show the modal
        },
        closeCreateClassModal() {
            this.isCreateClassModalVisible = false; // Close the modal
        },
    },
    mounted() {
        this.fetchClasses();
        this.fetchAvailableStudents();
    },
    created() {
        const token = localStorage.getItem('jwtToken');

        if (!token) {
            this.$router.push('/login'); // Redirect if token is missing
            return;
        }
    }
};
</script>
<style scoped>
.page-container {
    padding: 30px;
    background-color: #f9f9f9;
    font-family: Arial, sans-serif;
}

.page-title {
    text-align: center;
    font-size: 2em;
    margin-bottom: 30px;
}

.card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
    padding: 20px;
}

.card-header {
    font-size: 1.5em;
    margin-bottom: 20px;
}

.card-body {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.input-group {
    display: flex;
    gap: 10px;
}

.input-field {
    padding: 10px;
    font-size: 1em;
    width: 100%;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.btn {
    padding: 10px 20px;
    border-radius: 5px;
    color: #fff;
    border: none;
    cursor: pointer;
}

.btn-primary {
    background-color: #007bff;
}

.btn-secondary {
    background-color: #6c757d;
}

.btn:hover {
    opacity: 0.8;
}

.success {
    color: green;
}

.error {
    color: red;
}

.class-container {
    margin-top: 30px;
}

.class-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.class-card {
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    width: 280px;
    padding: 15px;
    transition: transform 0.3s;
}

.class-card:hover {
    transform: scale(1.05);
}

.class-header {
    font-size: 1.2em;
    font-weight: bold;
    text-align: center;
    margin-bottom: 15px;
}

.student-list {
    list-style-type: none;
    padding: 0;
}

.student-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #ddd;
}

.star {
    color: gold;
}

.student-grade {
    font-size: 0.9em;
    color: #777;
}

.class-actions {
    margin-top: 10px;
}

.add-student-container {
    margin-top: 10px;
    padding: 10px;
    background-color: #f9f9f9;
    border-radius: 5px;
}

.add-student-container select {
    width: 100%;
    padding: 8px;
    margin-bottom: 10px;
    border-radius: 5px;
}

.add-student-container button {
    width: 100%;
    padding: 8px;
    background-color: #28a745;
    border-radius: 5px;
    color: white;
}

.add-student-container button:hover {
    background-color: #218838;
}

.fab-container {
    position: fixed;
    bottom: 30px;
    right: 30px;
}

.fab {
    background-color: #007bff;
    color: white;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    font-size: 30px;
    display: flex;
    justify-content: center;
    align-items: center;
    border: none;
    cursor: pointer;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: background-color 0.3s ease;
}

.fab:hover {
    background-color: #0056b3;
}

.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 300px;
}

.modal-content input {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.modal-content button {
    width: 100%;
    padding: 10px;
    margin-top: 10px;
    border-radius: 5px;
    color: white;
    border: none;
}

.modal-content .btn-primary {
    background-color: #007bff;
}

.modal-content .btn-secondary {
    background-color: #6c757d;
}
</style>
