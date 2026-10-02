-- Create Users Table
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Student', 'Admin')),
    created_at DATETIME DEFAULT GETDATE()
);

-- Create Events Table
CREATE TABLE Events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT NULL,
    location VARCHAR(100) NOT NULL,
    event_date DATETIME NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    created_at DATETIME DEFAULT GETDATE()
);

-- Create Registrations Table (Resolves Many-to-Many relationship in 3NF)
CREATE TABLE Registrations (
    registration_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    registered_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'Confirmed' CHECK (status IN ('Confirmed', 'Cancelled', 'Waitlisted')),
    CONSTRAINT FK_Registrations_Users FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT FK_Registrations_Events FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Event UNIQUE (user_id, event_id)
);

-- Non-Clustered Performance Indexes on Foreign Keys
CREATE NONCLUSTERED INDEX IX_Registrations_UserId ON Registrations(user_id);
CREATE NONCLUSTERED INDEX IX_Registrations_EventId ON Registrations(event_id);