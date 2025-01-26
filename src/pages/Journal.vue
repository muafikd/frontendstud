<template>
    <div class="container">
        <h1>Class and Student Management</h1>

        <!-- Register Student Form -->
        <form @submit.prevent="registerStudent">
            <h2>Register Student</h2>
            <div>
                <input type="text" v-model="studentName" placeholder="Enter student name" required />
            </div>
            <div>
                <input type="text" v-model="studentUsername" placeholder="Enter student username" required />
            </div>
            <div>
                <input type="password" v-model="studentPassword" placeholder="Enter student password" required />
            </div>
            <div>
                <button type="submit">Register Student</button>
            </div>
            <p v-if="studentSuccessMessage" class="success">{{ studentSuccessMessage }}</p>
            <p v-if="studentErrorMessage" class="error">{{ studentErrorMessage }}</p>
        </form>

        <hr />

        <!-- Classes and Students -->
        <h2>Classes and Students</h2>
        <div v-for="schoolClass in classes" :key="schoolClass.id" class="class-container">
            <h3>{{ schoolClass.name }}</h3>
            <<table border="1" class="student-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Username</th>
                        <th>Grades</th>
                        <th>Add Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="student in schoolClass.students" :key="student.id">
                        <td>{{ student.name }}</td>
                        <td>{{ student.username }}</td>
                        <td>
                            <div v-if="studentGrades[student.id]?.length > 0">
                                <div v-for="grade in studentGrades[student.id]" :key="grade.testId">
                                    Test: {{ grade.testName }} - Grade: {{ grade.grade }}
                                </div>
                            </div>
                            <div v-else>-</div>
                        </td>
                        <td>
                            <button @click="showGradeForm(student, schoolClass.id)">Add Grade</button>
                        </td>
                    </tr>

                    <!-- Add Grade Form (appear below the selected student's row) -->
                    <tr
                        v-if="isGradeFormVisible && selectedStudent.classId === schoolClass.id && selectedStudent.id === selectedStudentId">
                        <td colspan="4">
                            <div class="grade-form">
                                <h3>Add Grade for {{ selectedStudent.name }}</h3>
                                <form @submit.prevent="submitGrade">
                                    <div>
                                        <label for="test">Test</label>
                                        <select v-model="selectedTest" required>
                                            <option v-for="test in tests" :key="test.id" :value="test.id">{{ test.name
                                                }}</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label for="grade">Grade</label>
                                        <input type="text" v-model="grade" placeholder="Enter grade" required />
                                    </div>
                                    <div>
                                        <button type="submit">Submit Grade</button>
                                        <button @click="closeGradeForm" type="button">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </td>
                    </tr>
                </tbody>
                </table>

        </div>
    </div>
</template>




<script>
import axios from "axios";
export default {
    data() {
        return {
            studentName: "",
            studentUsername: "",
            studentPassword: "",
            selectedStudent: null, // Selected student for adding grades
            selectedStudentId: null, // Store the selected student's ID
            selectedTest: "", // Selected test for grade
            grade: "", // The grade to be assigned
            classes: [], // List of classes with students
            studentSuccessMessage: "",
            studentErrorMessage: "",
            studentGrades: {}, // Store grades by student ID
            tests: [], // List of available tests for grading
            isGradeFormVisible: false, // To show/hide the grade form
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
                this.fetchStudentGrades(); // Fetch grades once classes are loaded
            } catch (error) {
                console.error("Failed to load classes.");
            }
        },

        async fetchStudentGrades() {
            try {
                const studentIds = this.classes.flatMap(schoolClass => schoolClass.students.map(student => student.id));
                for (const studentId of studentIds) {
                    const response = await axios.get(
                        `http://localhost:8080/api/grades/student/${studentId}`,
                        { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                    );
                    const grades = response.data;

                    // Fetch test names for each grade
                    const detailedGrades = await Promise.all(
                        grades.map(async grade => {
                            const testResponse = await axios.get(
                                `http://localhost:8080/api/tests/${grade.testId}`,
                                { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                            );
                            return {
                                grade: grade.grade,
                                testName: testResponse.data.name, // Assuming TestResponse contains `name`
                            };
                        })
                    );

                    // Store detailed grades in studentGrades
                    this.studentGrades[studentId] = detailedGrades;
                }
            } catch (error) {
                console.error("Failed to load student grades with test names:", error);
            }
        },

        getStudentGrade(studentId) {
            const grades = this.studentGrades[studentId] || [];
            return grades.length > 0 ? grades.map(grade => grade.grade).join(", ") : "-";
        },

        async fetchTests(classId) {
            try {
                const response = await axios.get(
                    `http://localhost:8080/api/tests/class/${classId}`,
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                this.tests = response.data; // Populate the `tests` array with the fetched tests
            } catch (error) {
                console.error("Failed to load tests for the class.", error);
            }
        },


        showGradeForm(student, classId) {
            this.selectedStudent = student;
            this.selectedStudentId = student.id;
            this.isGradeFormVisible = true;
            this.selectedStudent.classId = classId; // Add classId to track the row
            this.fetchTests(classId);
        },

        closeGradeForm() {
            this.isGradeFormVisible = false;
            this.selectedStudent = null;
            this.selectedStudentId = null;
            this.selectedTest = null;
            this.grade = "";
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

        async submitGrade() {
            try {
                const response = await axios.post(
                    `http://localhost:8080/api/grades/add?studentId=${this.selectedStudent.id}&testId=${this.selectedTest}&gradeValue=${this.grade}`,
                    {},
                    { headers: { Authorization: `${localStorage.getItem("jwtToken")}` } }
                );
                console.log("Grade added successfully:", response.data);
                this.fetchStudentGrades();
                this.closeGradeForm(); // Close the form after submitting
            } catch (error) {
                console.error("Failed to add grade:", error);
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
                console.log(error)
                this.studentErrorMessage = error.response?.data || "Error registering the student.";
            }
        },
    },

    mounted() {
        this.fetchClasses();
        this.fetchStudentGrades();
    },
};

</script>


<style scoped>
.container {
    max-width: 800px;
    margin: 0 auto;
}

.student-table {
    width: 100%;
    margin-bottom: 20px;
    border-collapse: collapse;
}

.student-table th,
.student-table td {
    padding: 10px;
    text-align: left;
}

.add-student-section {
    margin-top: 10px;
}

.success {
    color: green;
}

.error {
    color: red;
}
</style>