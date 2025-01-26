<div class="container">
    <h1>Register Student</h1>
    <form @submit.prevent="registerStudent">
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
</div>

<!-- Create Class Section -->
<h1>Create School Class</h1>
<form @submit.prevent="createClass">
    <div>
        <input type="text" v-model="className" placeholder="Enter class name" required />
    </div>
    <div>
        <button type="submit">Create Class</button>
    </div>
    <p v-if="classSuccessMessage" class="success">{{ classSuccessMessage }}</p>
    <p v-if="classErrorMessage" class="error">{{ classErrorMessage }}</p>
</form>

<h1>Create Test</h1>
<form @submit.prevent="createTest">
    <div>
        <input type="text" v-model="testName" placeholder="Enter test name" required />
    </div>
    <div>
        <input type="number" v-model="testDuration" placeholder="Enter test duration (minutes)" required />
    </div>
    <div>
        <select v-model="selectedClassId" required>
            <option disabled value="">Select a class</option>
            <option v-for="schoolClass in classes" :value="schoolClass.id" :key="schoolClass.id">
                {{ schoolClass.name }}
            </option>
        </select>
    </div>
    <div>
        <button type="submit">Create Test</button>
    </div>
    <p v-if="successMessage" class="success">{{ successMessage }}</p>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
</form>

<div v-if="tests.length">
    <h2>Existing Tests</h2>
    <ul>
        <li v-for="test in tests" :key="test.id" @click="onTestSelected(test.id)">
            <strong>{{ test.name }}</strong> - {{ test.duration }} mins
        </li>
    </ul>
    <div v-if="questions.length">
        <h2>Questions for Selected Test</h2>
        <ul>
            <li v-for="question in questions" :key="question.id">
                <strong>{{ question.text }}</strong>
                <strong>Answer: {{ question.correctAnswer }}</strong>
                <ul>
                    <li v-for="option in question.options" :key="option.id">
                        {{ option }}
                    </li>
                </ul>
            </li>
        </ul>
    </div>

</div>

<div v-if="classes.length">
            <h2>Existing Classes</h2>
            <ul>
                <li v-for="schoolClass in classes" :key="schoolClass.id">
                    <div>
                        <strong>{{ schoolClass.name }}</strong> -
                        Teacher: {{ schoolClass.teacher.name }}
                        <button @click="toggleStudentList(schoolClass.id)">
                            {{ expandedClasses.includes(schoolClass.id) ? 'Hide' : 'Show' }} Students
                        </button>
                    </div>

                    <ul v-if="expandedClasses.includes(schoolClass.id)">
                        <li v-for="student in schoolClass.students" :key="student.id">
                            {{ student.name }} ({{ student.username }})
                        </li>
                        <li>
                            <select v-model="selectedStudent" :disabled="!availableStudents.length">
                                <option disabled value="">Select a student</option>
                                <option v-for="student in availableStudents" :value="student.id" :key="student.id">
                                    {{ student.name }}
                                </option>
                            </select>
                            <button @click="addStudentToClass(schoolClass.id)" :disabled="!selectedStudent">
                                Add Student
                            </button>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>