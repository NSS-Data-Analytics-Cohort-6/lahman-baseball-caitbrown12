-- 1 What range of years for baseball games played does the provided database cover?
-- SELECT MIN(debut), 
-- 	MAX(finalGame)
-- FROM people;
-- Answer: 1871-2017

-- 2 Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

-- SELECT a.g_all,
-- 	p.namegiven,
-- 	p.namelast,
-- 	p.height,
-- 	t.name
-- FROM appearances AS a
-- INNER JOIN people AS p
-- ON a.playerid = p.playerid
-- INNER JOIN teams AS t
-- ON a.teamid = t.teamid
-- ORDER BY height
-- LIMIT 1;

-- Answer: Edward Carl Gaedel is the shortest player in the database. He played 1 game with the St. Louis Browns.

-- 3 Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

-- SELECT p.namelast,
-- 	p.namefirst,
-- 	SUM(s.salary)
-- FROM people AS p
-- INNER JOIN collegeplaying AS c
-- ON p.playerid = c.playerid
-- INNER JOIN salaries AS s
-- ON p.playerid = s.playerid
-- WHERE c.schoolid = 'vandy'
-- GROUP BY p.namelast, p.namefirst
-- ORDER BY SUM(s.salary) DESC;

-- Answer David Price has earned the most money in the majors with a total sum of $245,553,888 for the period included in this database.

-- 4 Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

-- SELECT SUM(po)
-- 	pos,
-- 		CASE WHEN pos = 'OF' THEN 'Outfield'
-- 		WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
-- 		ELSE 'Battery'
-- 	END AS Position
-- FROM fielding
-- WHERE yearid = '2016'
-- GROUP BY Position
-- ORDER BY Position;

-- Answer Battery players were responsible for 41,424 putouts in 2016, infielders generated 58,934, and outfielders had 29,560 putouts.

-- 5 Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?