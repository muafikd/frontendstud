<template>
    
</template>

<script>
import axios from "axios";

export default {
    data() {
        return {
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
        this.fetchTeacherTests(); // Fetch the list of tests when the component mounts
    },
};
</script>

<style>
.question-form {
    max-width: 500px;
    margin: 0 auto;
}

form div {
    margin-bottom: 15px;
}

label {
    display: block;
    font-weight: bold;
}

input,
select,
button {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
}

.message {
    margin-top: 20px;
    color: green;
    font-weight: bold;
}
</style>