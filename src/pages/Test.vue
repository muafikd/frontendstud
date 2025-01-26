<template>
    <div class="container">
        <h1>Create Test</h1>
        <form @submit.prevent="createTest" class="form">
            <div>
                <input type="text" v-model="testName" placeholder="Enter test name" required class="input" />
            </div>
            <div>
                <input type="number" v-model="testDuration" placeholder="Enter test duration (minutes)" required
                    class="input" />
            </div>
            <div>
                <select v-model="selectedClassId" required class="select">
                    <option disabled value="">Select a class</option>
                    <option v-for="schoolClass in classes" :value="schoolClass.id" :key="schoolClass.id">
                        {{ schoolClass.name }}
                    </option>
                </select>
            </div>
            <button type="submit" class="button">Create Test</button>
            <p v-if="successMessage" class="success">{{ successMessage }}</p>
            <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
        </form>

        <h1>Create Question</h1>
        <form @submit.prevent="submitQuestion" class="form">
            <div>
                <label for="text">Question Text:</label>
                <input type="text" id="text" v-model="question.text" required class="input" />
            </div>
            <div>
                <label for="testId">Test:</label>
                <select id="testId" v-model="question.testId" required class="select">
                    <option v-for="test in tests" :key="test.id" :value="test.id">
                        {{ test.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="options">Options (comma-separated):</label>
                <input type="text" id="options" v-model="question.options" required class="input" />
            </div>
            <div>
                <label for="correctAnswer">Correct Answer:</label>
                <input type="text" id="correctAnswer" v-model="question.correctAnswer" required class="input" />
            </div>
            <button type="submit" class="button">Create Question</button>
            <p v-if="message" class="message">{{ message }}</p>
        </form>

        <div v-if="tests.length" class="tests">
            <h2>Existing Tests</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Test Name</th>
                        <th>Duration (mins)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="test in tests" :key="test.id">
                        <td>{{ test.name }}</td>
                        <td>{{ test.duration }}</td>
                        <td>
                            <button @click="fetchQuestions(test.id)" class="button">
                                View Questions
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div v-if="questions.length" class="questions">
            <h2>Questions for Selected Test</h2>
            <ul>
                <li v-for="question in questions" :key="question.id" class="question-item">
                    <div class="question-header" @click="question.show = !question.show">
                        <strong>{{ question.text }}</strong>
                    </div>
                    <div v-if="question.show" class="question-body">
                        <p><strong>Answer:</strong> {{ question.correctAnswer }}</p>
                        <ul>
                            <li v-for="option in question.options" :key="option">
                                {{ option }}
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
            testName: "",
            testDuration: "",
            selectedClassId: "",
            successMessage: "",
            errorMessage: "",
            tests: [],
            questions: [],
            classes: [],
            question: {
                text: "",
                testId: null,
                options: "",
                correctAnswer: "",
            },
            tests: [], // This will hold the list of tests for the dropdown
            message: "",
        };
    },
    methods: {
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
        async fetchTests() {
            try {
                const teacherUsername = localStorage.getItem("teacherUsername");
                if (!teacherUsername) {
                    throw new Error("Teacher username not found in localStorage.");
                }
                const response = await axios.get(`http://localhost:8080/api/tests/teacher/${teacherUsername}`, {
                    headers: {
                        Authorization: `${localStorage.getItem("jwtToken")}`
                    }
                });
                this.tests = response.data;
            } catch (error) {
                this.errorMessage = error.response?.data || "Failed to load tests.";
            }
        },

        async createTest() {
            try {
                const requestData = {
                    name: this.testName,
                    duration: this.testDuration,
                    classId: this.selectedClassId
                };
                const response = await axios.post("http://localhost:8080/api/tests/create", requestData, {
                    headers: {
                        Authorization: `${localStorage.getItem("jwtToken")}`
                    }
                });
                this.successMessage = "Test created successfully!";
                this.tests.push(response.data); // Add the new test to the list
                this.resetForm();
            } catch (error) {
                this.errorMessage = error.response?.data || "Failed to create test.";
            }
        },
        async fetchQuestions(testId) {
            try {
                const response = await axios.get(`http://localhost:8080/api/questions/test/${testId}`, {
                    headers: { Authorization: `${localStorage.getItem("jwtToken")}` }
                });
                this.questions = response.data;
                console.log(this.questions); // Debug log
            } catch (error) {
                this.errorMessage = "Failed to load questions for the selected test.";
                console.error(error);
            }
        },
        async fetchTeacherTests() {
            const teacherUsername = localStorage.getItem("teacherUsername");
            try {
                const response = await axios.get(
                    `http://localhost:8080/api/tests/teacher/${teacherUsername}`,
                    {
                        headers: {
                            Authorization: `${localStorage.getItem("jwtToken")}`,
                        },
                    }
                );

                this.tests = response.data; // Populate the tests for the teacher
            } catch (error) {
                console.error(error);
                this.errorMessage = "Failed to load tests.";
            }
        },
        async submitQuestion() {
            try {
                const payload = {
                    text: this.question.text,
                    testId: this.question.testId,
                    correctAnswer: this.question.correctAnswer,
                    options: this.question.options.split(",").map((opt) => opt.trim()), // Convert to array
                };
                const response = await axios.post("http://localhost:8080/api/questions/create", payload,
                    {
                        headers: {
                            Authorization: `${localStorage.getItem("jwtToken")}`,
                        },
                    }); // Replace with your actual endpoint
                this.message = "Question created successfully!";
                this.clearForm();
            } catch (error) {
                console.error("Error creating question:", error);
                this.message = "Failed to create question. Please try again.";
            }
        },
        resetForm() {
            this.testName = "";
            this.testDuration = "";
            this.selectedClassId = "";
        },
        clearForm() {
            this.question = {
                text: "",
                testId: null,
                options: "",
                correctAnswer: "",
            };
        },
    },
    mounted() {
        this.fetchClasses();
        this.fetchTeacherTests();
        this.fetchTests();
    },
    created() {
        const token = localStorage.getItem("jwtToken");

        if (!token) {
            this.$router.push("/login"); // Redirect if token is missing
            return;
        }
    }
};
</script>


<style scoped>
.container {
    padding: 20px;
    font-family: Arial, sans-serif;
}

h1,
h2 {
    margin-bottom: 20px;
}

.form {
    margin-bottom: 30px;
    background-color: #f9f9f9;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.input,
.select {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.button {
    background-color: #4caf50;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
}

.button:hover {
    background-color: #45a049;
}

.table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

.table th,
.table td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}

.table th {
    background-color: #f4f4f4;
}

.question-item {
    margin: 10px 0;
}

.question-header {
    background-color: #e0e0e0;
    padding: 10px;
    border-radius: 4px;
    cursor: pointer;
}

.question-body {
    padding: 10px;
    border-left: 3px solid #4caf50;
    margin-top: 10px;
}

.success {
    color: green;
}

.error {
    color: red;
}

.message {
    margin-top: 10px;
    color: blue;
}
</style>