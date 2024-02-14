-- CREATE DATABASE 

CREATE TABLE Movies (
    Title VARCHAR(255),
    Release_Year INT,
    Locations VARCHAR(255),
    Fun_Facts TEXT,
    Production_Company VARCHAR(255),
    Distributor VARCHAR(255),
    Director VARCHAR(255),
    Writer VARCHAR(255),
    Actor_1 VARCHAR(255),
    Actor_2 VARCHAR(255),
    Actor_3 VARCHAR(255),
    SF_Find_Neighborhoods VARCHAR(255),
    Analysis_Neighborhoods VARCHAR(255),
    Current_Supervisor_Districts INT
);
SELECT * FROM movies;
-- COUNT
-- Retrieve the number of locations of the films which are directed by Woody Allen.
SELECT director FROM movies WHERE `Director`='Woody Allen';
-- Retrieve the number of films shot at Russian Hill.
-- Retrieve the number of rows having a release year older than 1950 from the “FilmLocations” table


-- DSTINCT
-- Retrieve the name of all unique films released in the 21st century and onwards, along with their release years.
-- Retrieve the names of all the directors and their distinct films shot at City Hall.
-- Retrieve the number of distributors distinctly who distributed films acted by Clint Eastwood as 1st actor.

-- LIMIT
-- Retrieve the name of first 50 films distinctly.
-- Retrieve first 10 film names distinctly released in 2015
-- Retrieve the next 3 film names distinctly after first 5 films released in 2015.