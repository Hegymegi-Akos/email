CREATE DATABASE IF NOT EXISTS EmailDb;
USE EmailDb;

CREATE TABLE AspNetRoles (
    Id VARCHAR(450) NOT NULL PRIMARY KEY,
    Name VARCHAR(256) NULL,
    NormalizedName VARCHAR(256) NULL,
    ConcurrencyStamp TEXT NULL
);

CREATE TABLE AspNetUsers (
    Id VARCHAR(450) NOT NULL PRIMARY KEY,
    UserName VARCHAR(256) NULL,
    NormalizedUserName VARCHAR(256) NULL,
    Email VARCHAR(256) NULL,
    NormalizedEmail VARCHAR(256) NULL,
    EmailConfirmed TINYINT(1) NOT NULL DEFAULT 0,
    PasswordHash TEXT NULL,
    SecurityStamp TEXT NULL,
    ConcurrencyStamp TEXT NULL,
    PhoneNumber TEXT NULL,
    PhoneNumberConfirmed TINYINT(1) NOT NULL DEFAULT 0,
    TwoFactorEnabled TINYINT(1) NOT NULL DEFAULT 0,
    LockoutEnd DATETIME NULL,
    LockoutEnabled TINYINT(1) NOT NULL DEFAULT 0,
    AccessFailedCount INT NOT NULL DEFAULT 0
);

CREATE TABLE SentEmails (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Sender VARCHAR(500) NOT NULL,
    Subject VARCHAR(500) NOT NULL,
    Body TEXT NOT NULL,
    Recipient VARCHAR(500) NOT NULL,
    SentAt DATETIME NOT NULL
);

CREATE TABLE AspNetRoleClaims (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    RoleId VARCHAR(450) NOT NULL,
    ClaimType TEXT NULL,
    ClaimValue TEXT NULL,
    FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserClaims (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    UserId VARCHAR(450) NOT NULL,
    ClaimType TEXT NULL,
    ClaimValue TEXT NULL,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserLogins (
    LoginProvider VARCHAR(450) NOT NULL,
    ProviderKey VARCHAR(450) NOT NULL,
    ProviderDisplayName TEXT NULL,
    UserId VARCHAR(450) NOT NULL,
    PRIMARY KEY (LoginProvider, ProviderKey),
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserRoles (
    UserId VARCHAR(450) NOT NULL,
    RoleId VARCHAR(450) NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserTokens (
    UserId VARCHAR(450) NOT NULL,
    LoginProvider VARCHAR(450) NOT NULL,
    Name VARCHAR(450) NOT NULL,
    Value TEXT NULL,
    PRIMARY KEY (UserId, LoginProvider, Name),
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX RoleNameIndex ON AspNetRoles(NormalizedName);
CREATE UNIQUE INDEX UserNameIndex ON AspNetUsers(NormalizedUserName);
CREATE INDEX EmailIndex ON AspNetUsers(NormalizedEmail);
