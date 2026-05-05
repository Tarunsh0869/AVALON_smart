-- Run this in SQL Server Management Studio (SSMS)
-- Database: AvalonDB
-- This inserts all 40 questions directly, bypassing EF migrations

USE AvalonDB;
GO

-- Clear existing questions first to avoid duplicate ID errors
DELETE FROM Questions;
GO

-- Reset identity so IDs start from 1
DBCC CHECKIDENT ('Questions', RESEED, 0);
GO

INSERT INTO Questions (CategoryId, QuestionText, OptionsJson, CorrectOption) VALUES
-- Python (CategoryId = 1)
(1, 'What is the output of print(2 ** 3)?',                         '["6","8","9","12"]',                                                    '8'),
(1, 'Which keyword is used to define a function in Python?',         '["func","def","function","define"]',                                    'def'),
(1, 'What data type is the result of: type(3.14)?',                  '["int","str","float","double"]',                                        'float'),
(1, 'Which of these is used to handle exceptions in Python?',        '["try/catch","try/except","catch/finally","error/handle"]',             'try/except'),
(1, 'What does len([1, 2, 3]) return?',                              '["2","3","4","1"]',                                                     '3'),
(1, 'Which symbol is used for single-line comments in Python?',      '["//","#","--","/*"]',                                                  '#'),
(1, 'What is the correct way to create a list in Python?',           '["list = ()","list = {}","list = []","list = <>"]',                     'list = []'),
(1, 'Which method adds an element to the end of a list?',            '["add()","insert()","append()","push()"]',                             'append()'),
(1, 'What keyword is used to create a class in Python?',             '["class","object","struct","type"]',                                    'class'),
(1, 'What is the output of bool(0)?',                                '["True","False","None","0"]',                                           'False'),

-- SQL (CategoryId = 2)
(2, 'Which SQL statement is used to retrieve data?',                 '["GET","FETCH","SELECT","READ"]',                                       'SELECT'),
(2, 'Which clause filters rows in a SELECT statement?',              '["HAVING","WHERE","FILTER","LIMIT"]',                                   'WHERE'),
(2, 'What does PRIMARY KEY ensure?',                                 '["Unique + Not Null","Only Unique","Only Not Null","Foreign reference"]','Unique + Not Null'),
(2, 'Which JOIN returns all rows from both tables?',                 '["INNER JOIN","LEFT JOIN","RIGHT JOIN","FULL OUTER JOIN"]',             'FULL OUTER JOIN'),
(2, 'Which function counts the number of rows?',                     '["SUM()","COUNT()","TOTAL()","NUM()"]',                                 'COUNT()'),
(2, 'Which SQL keyword removes duplicate rows from results?',        '["UNIQUE","DISTINCT","DIFFERENT","NODUPE"]',                            'DISTINCT'),
(2, 'What does the GROUP BY clause do?',                             '["Sorts rows","Groups rows by column value","Filters groups","Joins tables"]', 'Groups rows by column value'),
(2, 'Which command is used to delete a table permanently?',          '["DELETE","REMOVE","DROP","TRUNCATE"]',                                 'DROP'),
(2, 'Which constraint prevents NULL values in a column?',            '["UNIQUE","NOT NULL","DEFAULT","CHECK"]',                               'NOT NULL'),
(2, 'What does ORDER BY DESC do?',                                   '["Ascending sort","Descending sort","Random sort","Group sort"]',       'Descending sort'),

-- UI/UX (CategoryId = 3)
(3, 'What does UX stand for?',                                       '["User Experience","User Extension","Unified Experience","User Execution"]', 'User Experience'),
(3, 'What is a wireframe?',                                          '["Final design","Low-fidelity layout sketch","Color palette","Font guide"]',  'Low-fidelity layout sketch'),
(3, 'Which principle means keeping similar items visually grouped?', '["Contrast","Proximity","Alignment","Repetition"]',                    'Proximity'),
(3, 'What is the purpose of a prototype?',                           '["Final product","Test interactions before building","Write code","Deploy app"]', 'Test interactions before building'),
(3, 'What does CTA stand for in UI design?',                         '["Click To Action","Call To Action","Create Text Area","Custom Tab Area"]',    'Call To Action'),
(3, 'Which color model is used for screens?',                        '["CMYK","RGB","HSL only","Pantone"]',                                   'RGB'),
(3, 'What is the 60-30-10 rule in UI design?',                       '["Font sizes","Color distribution","Grid columns","Padding ratio"]',    'Color distribution'),
(3, 'What does accessibility in UI mean?',                           '["Fast loading","Usable by people with disabilities","Mobile only","Dark mode"]', 'Usable by people with disabilities'),
(3, 'Which tool is most popular for UI/UX design?',                  '["Photoshop","Figma","MS Paint","Notepad"]',                            'Figma'),
(3, 'What is a user persona?',                                       '["A real user","Fictional user representing target audience","Admin account","Test account"]', 'Fictional user representing target audience'),

-- Data Science (CategoryId = 4)
(4, 'Which Python library is used for data manipulation?',           '["NumPy","Pandas","Matplotlib","Scikit-learn"]',                        'Pandas'),
(4, 'What does CSV stand for?',                                      '["Comma Separated Values","Code Stored Values","Column Set View","Computed String Variable"]', 'Comma Separated Values'),
(4, 'Which chart is best for showing distribution of data?',         '["Pie chart","Line chart","Histogram","Bar chart"]',                    'Histogram'),
(4, 'What is a null value in a dataset?',                            '["Zero","Missing or undefined value","Negative number","Empty string"]', 'Missing or undefined value'),
(4, 'Which algorithm is used for classification problems?',          '["Linear Regression","K-Means","Decision Tree","PCA"]',                 'Decision Tree'),
(4, 'What does overfitting mean in machine learning?',               '["Model too simple","Model memorises training data","Model is fast","Model has no errors"]', 'Model memorises training data'),
(4, 'Which library is used for plotting graphs in Python?',          '["Pandas","NumPy","Matplotlib","Flask"]',                               'Matplotlib'),
(4, 'What is the purpose of train/test split?',                      '["Speed up training","Evaluate model on unseen data","Reduce dataset size","Clean data"]', 'Evaluate model on unseen data'),
(4, 'What does correlation measure?',                                '["Causation","Relationship strength between variables","Data size","Model accuracy"]', 'Relationship strength between variables'),
(4, 'Which of these is an unsupervised learning algorithm?',         '["Linear Regression","Decision Tree","K-Means Clustering","Logistic Regression"]', 'K-Means Clustering');
GO

-- Verify
SELECT CategoryId, COUNT(*) AS QuestionCount FROM Questions GROUP BY CategoryId;
GO
