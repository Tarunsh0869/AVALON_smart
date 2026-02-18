const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); //

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const questionBank = [
    // --- PYTHON (10 Questions) ---
    { category: "Python", q: "What is the correct file extension for Python files?", a: [".pyt", ".py", ".pyth", ".pt"], c: 1 },
    { category: "Python", q: "Which keyword is used to create a function in Python?", a: ["function", "void", "def", "func"], c: 2 },
    { category: "Python", q: "How do you insert COMMENTS in Python code?", a: ["//", "#", "/* */", ""], c: 1 },
    { category: "Python", q: "Which data type is used to store multiple items in a single variable?", a: ["String", "Integer", "List", "Float"], c: 2 },
    { category: "Python", q: "What is the output of print(2**3)?", a: ["6", "8", "9", "5"], c: 1 },
    { category: "Python", q: "Which method can be used to remove any whitespace from both the beginning and the end of a string?", a: ["strip()", "trim()", "len()", "cut()"], c: 0 },
    { category: "Python", q: "How do you create a variable with the numeric value 5?", a: ["x = 5", "x = int(5)", "Both are correct", "x == 5"], c: 2 },
    { category: "Python", q: "Which statement is used to stop a loop?", a: ["stop", "exit", "break", "return"], c: 2 },
    { category: "Python", q: "What is the correct syntax to output the type of a variable or object in Python?", a: ["print(typeof(x))", "print(type(x))", "print(typeOf(x))", "print(class(x))"], c: 1 },
    { category: "Python", q: "Which collection is ordered, changeable, and allows duplicate members?", a: ["Set", "Dictionary", "Tuple", "List"], c: 3 },
    // --- SQL (10 Questions) ---
    { category: "SQL", q: "Which SQL statement is used to extract data from a database?", a: ["EXTRACT", "GET", "SELECT", "OPEN"], c: 2 },
    { category: "SQL", q: "Which clause is used to filter records?", a: ["ORDER BY", "WHERE", "GROUP BY", "FILTER"], c: 1 },
    { category: "SQL", q: "Which SQL keyword is used to sort the result-set?", a: ["SORT", "ORDER", "ORDER BY", "SORT BY"], c: 2 },
    { category: "SQL", q: "How do you select all columns from a table named 'Users'?", a: ["SELECT all FROM Users", "SELECT * FROM Users", "SELECT [all] FROM Users", "GET * FROM Users"], c: 1 },
    { category: "SQL", q: "Which operator is used to search for a specified pattern in a column?", a: ["GET", "LIKE", "SEARCH", "PATTERN"], c: 1 },
    { category: "SQL", q: "How can you return all records from Persons sorted descending by 'FirstName'?", a: ["SELECT * FROM Persons ORDER FirstName DESC", "SELECT * FROM Persons SORT 'FirstName' DESC", "SELECT * FROM Persons ORDER BY FirstName DESC", "SELECT * FROM Persons SORT BY 'FirstName' DESC"], c: 2 },
    { category: "SQL", q: "Which SQL statement is used to insert new data in a database?", a: ["ADD NEW", "INSERT INTO", "ADD RECORD", "INSERT NEW"], c: 1 },
    { category: "SQL", q: "How can you change 'Hansen' into 'Nilsen' in the 'LastName' column?", a: ["UPDATE Persons SET LastName='Nilsen' WHERE LastName='Hansen'", "MODIFY Persons SET LastName='Nilsen' WHERE LastName='Hansen'", "UPDATE Persons SET LastName='Hansen' INTO LastName='Nilsen'", "SAVE Persons SET LastName='Nilsen' WHERE LastName='Hansen'"], c: 0 },
    { category: "SQL", q: "Which SQL statement is used to delete data from a database?", a: ["REMOVE", "COLLAPSE", "DELETE", "TRUNCATE"], c: 2 },
    { category: "SQL", q: "The OR operator displays a record if:", a: ["Only the first condition is true", "All conditions are true", "Any condition is true", "No conditions are true"], c: 2 },

    // --- UI/UX (10 Questions) ---
    { category: "UI/UX", q: "What does 'UX' stand for in design?", a: ["User Experience", "User Example", "Universal Experience", "User Execution"], c: 0 },
    { category: "UI/UX", q: "Which of these is a popular wireframing and prototyping tool?", a: ["Docker", "Figma", "Postman", "Jenkins"], c: 1 },
    { category: "UI/UX", q: "What is the main goal of a 'User Persona'?", a: ["To list all technical features", "To represent the target user needs", "To design the logo", "To code the backend"], c: 1 },
    { category: "UI/UX", q: "What does UI stand for?", a: ["User Interface", "User Interaction", "Universal Icon", "Unique Interface"], c: 0 },
    { category: "UI/UX", q: "Which color scheme uses colors opposite each other on the color wheel?", a: ["Monochromatic", "Analogous", "Complementary", "Triadic"], c: 2 },
    { category: "UI/UX", q: "What is a 'Wireframe' in UX?", a: ["A final design", "A skeletal framework of a website", "A CSS framework", "An interview technique"], c: 1 },
    { category: "UI/UX", q: "What is the purpose of 'White Space'?", a: ["To save on ink", "To make it look empty", "To improve readability and focus", "To hide errors"], c: 2 },
    { category: "UI/UX", q: "What is 'A/B Testing'?", a: ["Alphabetical testing", "Comparing two versions of a webpage", "Testing buttons", "Backend testing"], c: 1 },
    { category: "UI/UX", q: "What does the term 'Affordance' refer to?", a: ["Design cost", "Properties that suggest how to use an object", "App speed", "Font size"], c: 1 },
    { category: "UI/UX", q: "In UX, what is a 'User Journey Map'?", a: ["A GPS route", "A visual representation of the user's process", "Coding requirements", "Marketing budget"], c: 1 },

    // --- JAVA (10 Questions) ---
    { category: "Java", q: "Which method is the entry point for any Java program?", a: ["start()", "init()", "main()", "run()"], c: 2 },
    { category: "Java", q: "Which keyword is used to create a subclass in Java?", a: ["super", "extends", "implements", "class"], c: 1 },
    { category: "Java", q: "What is the size of 'int' data type in Java?", a: ["8-bit", "16-bit", "32-bit", "64-bit"], c: 2 },
    { category: "Java", q: "Which of these is NOT a Java feature?", a: ["Object Oriented", "Use of pointers", "Platform independent", "Robust"], c: 1 },
    { category: "Java", q: "What is the extension of Java code files?", a: [".js", ".txt", ".class", ".java"], c: 3 },
    { category: "Java", q: "Which of these is used to compile Java code?", a: ["jvm", "jre", "javac", "jdk"], c: 2 },
    { category: "Java", q: "What is the default value of a boolean variable in Java?", a: ["true", "false", "null", "0"], c: 1 },
    { category: "Java", q: "Which keyword prevents any method from overriding?", a: ["static", "final", "abstract", "private"], c: 1 },
    { category: "Java", q: "Which of these is a reserved keyword in Java?", a: ["object", "main", "system", "strictfp"], c: 3 },
    { category: "Java", q: "Which package contains the Random class?", a: ["java.lang", "java.io", "java.util", "java.awt"], c: 2 },

    // --- TRIGONOMETRY (10 Questions) ---
    { category: "Trigonometry", q: "What is the value of sin(90°)?", a: ["0", "0.5", "1", "Infinity"], c: 2 },
    { category: "Trigonometry", q: "Which of the following is equal to tan(x)?", a: ["cos(x)/sin(x)", "1/cos(x)", "sin(x)/cos(x)", "sin(x)*cos(x)"], c: 2 },
    { category: "Trigonometry", q: "In a right-angled triangle, what is sin(θ) equal to?", a: ["Adj/Hyp", "Opp/Adj", "Opp/Hyp", "Hyp/Opp"], c: 2 },
    { category: "Trigonometry", q: "What is the value of cos(0°)?", a: ["0", "1", "0.5", "Undefined"], c: 1 },
    { category: "Trigonometry", q: "What is sec(x) equal to?", a: ["1/sin(x)", "1/tan(x)", "1/cos(x)", "sin(x)/cos(x)"], c: 2 },
    { category: "Trigonometry", q: "sin²(x) + cos²(x) = ?", a: ["0", "2", "1", "tan²(x)"], c: 2 },
    { category: "Trigonometry", q: "What is the value of tan(45°)?", a: ["0", "√3", "1", "1/√3"], c: 2 },
    { category: "Trigonometry", q: "The period of a basic sine function y = sin(x) is:", a: ["π", "2π", "π/2", "3π/2"], c: 1 },
    { category: "Trigonometry", q: "What is the value of sin(30°)?", a: ["√3/2", "1/√2", "1/2", "1"], c: 2 },
    { category: "Trigonometry", q: "Which formula represents the Law of Cosines?", a: ["a/sinA = b/sinB", "c² = a² + b² - 2ab cos(C)", "sin²x + cos²x = 1", "tan x = sin x / cos x"], c: 1 }
];

async function seedDatabase() {
    console.log("Strict Data Reset Initiated...");
    const snapshot = await db.collection("question_bank").get();
    const deleteBatch = db.batch();
    snapshot.docs.forEach(doc => deleteBatch.delete(doc.ref));
    await deleteBatch.commit();
    
    const uploadBatch = db.batch();
    questionBank.forEach(q => {
        const ref = db.collection("question_bank").doc();
        uploadBatch.set(ref, q);
    });
    
    await uploadBatch.commit();
    console.log("✅ Success: 50 Questions Live (10 per topic).");
    process.exit();
}

seedDatabase();