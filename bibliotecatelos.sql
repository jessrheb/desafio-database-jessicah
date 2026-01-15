CREATE TABLE Books (
book_id SERIAL PRIMARY KEY,
title VARCHAR(100) NOT NULL,
author VARCHAR(100) NOT NULL,
genre VARCHAR(50) NOT NULL,
published_year INT NOT NULL
);

CREATE TABLE Users (
user_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Loans (
loan_id SERIAL PRIMARY KEY,
book_id INTEGER UNIQUE REFERENCES
Books(book_id),
user_id INTEGER REFERENCES
Users(user_id),
loan_date DATE,
return_date DATE
);

-- Adicionar novos livros ao catálogo:
INSERT INTO Books (title, author, genre, published_year) VALUES
('Don Quixote', 'Miguel de Cervantes', 'Novel', '1605'),
('Pride and Prejudice', 'Jane Austen', 'Romance', '1813'),
('Moby Dick', 'Herman Melville', 'Adventure', '1851'),
('Crime and Punishment', 'Fyodor Dostoyevsky', 'Psychological Fiction', '1866'),
('The Adventures of Huckleberry Finn', 'Mark Twain', 'Adventure', '1884'),
('The Picture of Dorian Gray', 'Oscar Wilde', 'Gothic Fiction', '1890'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Tragedy', '1925'),
('All Quiet on the Western Front', 'Erich Maria Remarque', 'War Novel', '1929'),
('And Then There Were None', 'Agatha Christie', 'Mystery', '1939'),
('The Little Prince', 'Antoine de Saint-Exupéry', 'Fantasy', '1943'),
('The Catcher in the Rye', 'J.D. Salinger', 'Coming-of-age', '1951'),
('The Fellowship of the Ring', 'J.R.R. Tolkien', 'Fantasy', '1954'),
('One Hundred Years of Solitude', 'Gabriel García Márquez', 'Magic Realism', '1967'),
('Frankenstein', 'Mary Shelley', 'Gothic Fiction', '1818'),
('The Da Vinci Code', 'Dan Brown', 'Mystery Thriller', '2003'),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', '1937'),
('1984', 'George Orwell', 'Dystopian Fiction', '1949'),
('The Alchemist', 'Paulo Coelho', 'Fantasy', '1988'),
('To Kill a Mockingbird', 'Harper Lee', 'Southern Gothic', '1960'),
('Dream of the Red Chamber', 'Cao Xueqin', 'Family Saga', '1791');

-- Atualizar informações de livros existentes:
UPDATE Books
SET genre = 'Satire' WHERE title = 'Don Quixote';

-- Excluir livros do catálogo:
DELETE FROM Books WHERE published_year < 1800;

-- Buscar livros no catálogo por título, autor, gênero, etc.:
SELECT * FROM Books WHERE title = 'One Hundred Years of Solitude';
SELECT * FROM Books WHERE author = 'J.R.R. Tolkien';
SELECT * FROM Books WHERE genre = 'Fantasy';
SELECT * FROM Books WHERE published_year > 1900;

-- Adicionar novos usuários:
INSERT INTO Users (name, email) VALUES
('Matthew Wilson', 'matthew.wilson@example.com'),
('Isabella Taylor', 'isabella.taylor@example.com'),
('Christopher Lee', 'christopher.lee@example.com'),
('Ava Martin', 'ava.martin@example.com'),
('Andrew Clark', 'andrew.clark@example.com'),
('Mia Rodriguez', 'mia.rodriguez@example.com'),
('Joshua Lewis', 'joshua.lewis@example.com'),
('Charlotte Walker', 'charlotte.walker@example.com'),
('Ryan Hall', 'ryan.hall@example.com'),
('Amelia Allen', 'amelia.allen@example.com');

-- Atualizar informações de usuários existentes:
UPDATE Users
SET email = 'chris.lee@example.com' WHERE name = 'Christopher Lee';

-- Excluir usuários:
DELETE FROM Users WHERE user_id = 4;

-- Buscar usuários por nome, email, etc.:
SELECT * FROM Users WHERE name = 'Charlotte Walker';
SELECT * FROM Users WHERE email = 'amelia.allen@example.com';

-- Registrar empréstimos de livros:
INSERT INTO Loans (book_id, user_id, loan_date, return_date) VALUES
(5, 8, '12/01/2026', NULL),
(2, 9, '12/01/2026', NULL),
(18, 5, '09/01/2026', NULL),
(7, 3, '08/01/2026', NULL),
(10, 2, '07/01/2026', NULL),
(13, 2, '06/01/2026', NULL),
(6, 7, '06/01/2026', NULL),
(4, 10, '05/01/2026', NULL);

-- Registrar devoluções de livros:
UPDATE Loans
SET return_date = CAST(data.return_date AS DATE)
FROM (
    VALUES 
        (1, '13/01/2026'), 
        (4, '13/01/2026'), 
        (8, '13/01/2026')
) AS data(loan_id, return_date)
WHERE Loans.loan_id = data.loan_id;

-- Verificar a disponibilidade de um livro antes de realizar um empréstimo:
SELECT Books.title, Books.author FROM Books
FULL JOIN Loans ON Books.book_id = Loans.book_id WHERE Loans.loan_id IS NULL OR Loans.return_date IS NOT NULL;

-- Gerar relatórios de livros emprestados e devolvidos:
SELECT Books.title, Books.author, Loans.loan_date, Loans.return_date FROM Books
INNER JOIN Loans ON Books.book_id = Loans.book_id WHERE Loans.loan_date IS NOT NULL AND Loans.return_date IS NOT NULL;

-- Gerar relatórios de livros atualmente emprestados:
SELECT Books.title, Books.author, Users.name, Loans.loan_date FROM Books
INNER JOIN Loans ON Books.book_id = Loans.book_id
INNER JOIN Users ON Users.user_id = Loans.user_id
WHERE Loans.loan_date IS NOT NULL AND Loans.return_date IS NULL;

-- Gerar relatórios de usuários com mais empréstimos:
SELECT Users.name, COUNT(Loans.user_id) AS total_loans FROM Loans
JOIN Users ON Loans.user_id = Users.user_id
GROUP BY Users.name ORDER BY total_loans DESC LIMIT 1;