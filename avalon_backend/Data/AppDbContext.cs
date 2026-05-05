using Microsoft.EntityFrameworkCore;
using avalon_backend.Entities;

namespace avalon_backend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Question> Questions => Set<Question>();
    public DbSet<QuizAttempt> QuizAttempts => Set<QuizAttempt>();
    public DbSet<Leaderboard> Leaderboards => Set<Leaderboard>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Unique email per user
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        // ONE leaderboard row per user per category — prevents duplicates
        modelBuilder.Entity<Leaderboard>()
            .HasIndex(l => new { l.UserId, l.CategoryId })
            .IsUnique();

        // Index for fast leaderboard queries sorted by score
        modelBuilder.Entity<Leaderboard>()
            .HasIndex(l => l.BestScore);

        // Index for fast question lookup by category
        modelBuilder.Entity<Question>()
            .HasIndex(q => q.CategoryId);

        // Seed categories
        modelBuilder.Entity<Category>().HasData(
            new Category { Id = 1, Name = "Python",       IconName = "code" },
            new Category { Id = 2, Name = "SQL",          IconName = "storage" },
            new Category { Id = 3, Name = "UI/UX",        IconName = "palette" },
            new Category { Id = 4, Name = "Data Science", IconName = "analytics" }
        );

        // Seed questions — CorrectOption matches exact option text for backend comparison
        modelBuilder.Entity<Question>().HasData(

            // ── Python (CategoryId = 1) ───────────────────────────────────────
            new Question { Id = 1,  CategoryId = 1, QuestionText = "What is the output of print(2 ** 3)?",                          OptionsJson = "[\"6\",\"8\",\"9\",\"12\"]",                                                    CorrectOption = "8" },
            new Question { Id = 2,  CategoryId = 1, QuestionText = "Which keyword is used to define a function in Python?",          OptionsJson = "[\"func\",\"def\",\"function\",\"define\"]",                                    CorrectOption = "def" },
            new Question { Id = 3,  CategoryId = 1, QuestionText = "What data type is the result of: type(3.14)?",                   OptionsJson = "[\"int\",\"str\",\"float\",\"double\"]",                                        CorrectOption = "float" },
            new Question { Id = 4,  CategoryId = 1, QuestionText = "Which of these is used to handle exceptions in Python?",         OptionsJson = "[\"try/catch\",\"try/except\",\"catch/finally\",\"error/handle\"]",            CorrectOption = "try/except" },
            new Question { Id = 5,  CategoryId = 1, QuestionText = "What does len([1, 2, 3]) return?",                               OptionsJson = "[\"2\",\"3\",\"4\",\"1\"]",                                                    CorrectOption = "3" },
            new Question { Id = 6,  CategoryId = 1, QuestionText = "Which symbol is used for single-line comments in Python?",       OptionsJson = "[\"//\",\"#\",\"--\",\"/*\"]",                                               CorrectOption = "#" },
            new Question { Id = 7,  CategoryId = 1, QuestionText = "What is the correct way to create a list in Python?",           OptionsJson = "[\"list = ()\",\"list = {}\",\"list = []\",\"list = <>\"]",                    CorrectOption = "list = []" },
            new Question { Id = 8,  CategoryId = 1, QuestionText = "Which method adds an element to the end of a list?",            OptionsJson = "[\"add()\",\"insert()\",\"append()\",\"push()\"]",                              CorrectOption = "append()" },
            new Question { Id = 9,  CategoryId = 1, QuestionText = "What keyword is used to create a class in Python?",             OptionsJson = "[\"class\",\"object\",\"struct\",\"type\"]",                                    CorrectOption = "class" },
            new Question { Id = 10, CategoryId = 1, QuestionText = "What is the output of bool(0)?",                                OptionsJson = "[\"True\",\"False\",\"None\",\"0\"]",                                           CorrectOption = "False" },

            // ── SQL (CategoryId = 2) ──────────────────────────────────────────
            new Question { Id = 11, CategoryId = 2, QuestionText = "Which SQL statement is used to retrieve data?",                  OptionsJson = "[\"GET\",\"FETCH\",\"SELECT\",\"READ\"]",                                     CorrectOption = "SELECT" },
            new Question { Id = 12, CategoryId = 2, QuestionText = "Which clause filters rows in a SELECT statement?",               OptionsJson = "[\"HAVING\",\"WHERE\",\"FILTER\",\"LIMIT\"]",                                  CorrectOption = "WHERE" },
            new Question { Id = 13, CategoryId = 2, QuestionText = "What does PRIMARY KEY ensure?",                                  OptionsJson = "[\"Unique + Not Null\",\"Only Unique\",\"Only Not Null\",\"Foreign reference\"]", CorrectOption = "Unique + Not Null" },
            new Question { Id = 14, CategoryId = 2, QuestionText = "Which JOIN returns all rows from both tables?",                  OptionsJson = "[\"INNER JOIN\",\"LEFT JOIN\",\"RIGHT JOIN\",\"FULL OUTER JOIN\"]",             CorrectOption = "FULL OUTER JOIN" },
            new Question { Id = 15, CategoryId = 2, QuestionText = "Which function counts the number of rows?",                     OptionsJson = "[\"SUM()\",\"COUNT()\",\"TOTAL()\",\"NUM()\"]",                                  CorrectOption = "COUNT()" },
            new Question { Id = 16, CategoryId = 2, QuestionText = "Which SQL keyword removes duplicate rows from results?",         OptionsJson = "[\"UNIQUE\",\"DISTINCT\",\"DIFFERENT\",\"NODUPE\"]",                             CorrectOption = "DISTINCT" },
            new Question { Id = 17, CategoryId = 2, QuestionText = "What does the GROUP BY clause do?",                             OptionsJson = "[\"Sorts rows\",\"Groups rows by column value\",\"Filters groups\",\"Joins tables\"]", CorrectOption = "Groups rows by column value" },
            new Question { Id = 18, CategoryId = 2, QuestionText = "Which command is used to delete a table permanently?",          OptionsJson = "[\"DELETE\",\"REMOVE\",\"DROP\",\"TRUNCATE\"]",                                 CorrectOption = "DROP" },
            new Question { Id = 19, CategoryId = 2, QuestionText = "Which constraint prevents NULL values in a column?",            OptionsJson = "[\"UNIQUE\",\"NOT NULL\",\"DEFAULT\",\"CHECK\"]",                               CorrectOption = "NOT NULL" },
            new Question { Id = 20, CategoryId = 2, QuestionText = "What does ORDER BY DESC do?",                                   OptionsJson = "[\"Ascending sort\",\"Descending sort\",\"Random sort\",\"Group sort\"]",        CorrectOption = "Descending sort" },

            // ── UI/UX (CategoryId = 3) ────────────────────────────────────────
            new Question { Id = 21, CategoryId = 3, QuestionText = "What does UX stand for?",                                       OptionsJson = "[\"User Experience\",\"User Extension\",\"Unified Experience\",\"User Execution\"]", CorrectOption = "User Experience" },
            new Question { Id = 22, CategoryId = 3, QuestionText = "What is a wireframe?",                                          OptionsJson = "[\"Final design\",\"Low-fidelity layout sketch\",\"Color palette\",\"Font guide\"]",  CorrectOption = "Low-fidelity layout sketch" },
            new Question { Id = 23, CategoryId = 3, QuestionText = "Which principle means keeping similar items visually grouped?",  OptionsJson = "[\"Contrast\",\"Proximity\",\"Alignment\",\"Repetition\"]",                     CorrectOption = "Proximity" },
            new Question { Id = 24, CategoryId = 3, QuestionText = "What is the purpose of a prototype?",                          OptionsJson = "[\"Final product\",\"Test interactions before building\",\"Write code\",\"Deploy app\"]", CorrectOption = "Test interactions before building" },
            new Question { Id = 25, CategoryId = 3, QuestionText = "What does CTA stand for in UI design?",                        OptionsJson = "[\"Click To Action\",\"Call To Action\",\"Create Text Area\",\"Custom Tab Area\"]",  CorrectOption = "Call To Action" },
            new Question { Id = 26, CategoryId = 3, QuestionText = "Which color model is used for screens?",                        OptionsJson = "[\"CMYK\",\"RGB\",\"HSL only\",\"Pantone\"]",                                     CorrectOption = "RGB" },
            new Question { Id = 27, CategoryId = 3, QuestionText = "What is the 60-30-10 rule in UI design?",                      OptionsJson = "[\"Font sizes\",\"Color distribution\",\"Grid columns\",\"Padding ratio\"]",       CorrectOption = "Color distribution" },
            new Question { Id = 28, CategoryId = 3, QuestionText = "What does accessibility in UI mean?",                          OptionsJson = "[\"Fast loading\",\"Usable by people with disabilities\",\"Mobile only\",\"Dark mode\"]", CorrectOption = "Usable by people with disabilities" },
            new Question { Id = 29, CategoryId = 3, QuestionText = "Which tool is most popular for UI/UX design?",                 OptionsJson = "[\"Photoshop\",\"Figma\",\"MS Paint\",\"Notepad\"]",                              CorrectOption = "Figma" },
            new Question { Id = 30, CategoryId = 3, QuestionText = "What is a user persona?",                                      OptionsJson = "[\"A real user\",\"Fictional user representing target audience\",\"Admin account\",\"Test account\"]", CorrectOption = "Fictional user representing target audience" },

            // ── Data Science (CategoryId = 4) ─────────────────────────────────
            new Question { Id = 31, CategoryId = 4, QuestionText = "Which Python library is used for data manipulation?",           OptionsJson = "[\"NumPy\",\"Pandas\",\"Matplotlib\",\"Scikit-learn\"]",                        CorrectOption = "Pandas" },
            new Question { Id = 32, CategoryId = 4, QuestionText = "What does CSV stand for?",                                     OptionsJson = "[\"Comma Separated Values\",\"Code Stored Values\",\"Column Set View\",\"Computed String Variable\"]", CorrectOption = "Comma Separated Values" },
            new Question { Id = 33, CategoryId = 4, QuestionText = "Which chart is best for showing distribution of data?",        OptionsJson = "[\"Pie chart\",\"Line chart\",\"Histogram\",\"Bar chart\"]",                      CorrectOption = "Histogram" },
            new Question { Id = 34, CategoryId = 4, QuestionText = "What is a null value in a dataset?",                          OptionsJson = "[\"Zero\",\"Missing or undefined value\",\"Negative number\",\"Empty string\"]",   CorrectOption = "Missing or undefined value" },
            new Question { Id = 35, CategoryId = 4, QuestionText = "Which algorithm is used for classification problems?",         OptionsJson = "[\"Linear Regression\",\"K-Means\",\"Decision Tree\",\"PCA\"]",                   CorrectOption = "Decision Tree" },
            new Question { Id = 36, CategoryId = 4, QuestionText = "What does overfitting mean in machine learning?",              OptionsJson = "[\"Model too simple\",\"Model memorises training data\",\"Model is fast\",\"Model has no errors\"]", CorrectOption = "Model memorises training data" },
            new Question { Id = 37, CategoryId = 4, QuestionText = "Which library is used for plotting graphs in Python?",         OptionsJson = "[\"Pandas\",\"NumPy\",\"Matplotlib\",\"Flask\"]",                                  CorrectOption = "Matplotlib" },
            new Question { Id = 38, CategoryId = 4, QuestionText = "What is the purpose of train/test split?",                    OptionsJson = "[\"Speed up training\",\"Evaluate model on unseen data\",\"Reduce dataset size\",\"Clean data\"]", CorrectOption = "Evaluate model on unseen data" },
            new Question { Id = 39, CategoryId = 4, QuestionText = "What does correlation measure?",                               OptionsJson = "[\"Causation\",\"Relationship strength between variables\",\"Data size\",\"Model accuracy\"]", CorrectOption = "Relationship strength between variables" },
            new Question { Id = 40, CategoryId = 4, QuestionText = "Which of these is an unsupervised learning algorithm?",        OptionsJson = "[\"Linear Regression\",\"Decision Tree\",\"K-Means Clustering\",\"Logistic Regression\"]", CorrectOption = "K-Means Clustering" }
        );
    }
}
