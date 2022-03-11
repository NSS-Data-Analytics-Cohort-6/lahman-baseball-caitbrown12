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

-- SELECT ROUND(AVG(so / g), 2) AS avg_strikeouts,
-- 	ROUND(AVG(hr / g), 2) AS avg_homeruns,
-- 	CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
-- 	WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
-- 	WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
-- 	WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
-- 	WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
-- 	WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
-- 	WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
-- 	WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
-- 	WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
-- 	WHEN yearid BETWEEN 2000 AND 2019 THEN '2010s' END AS decade
-- FROM teams
-- WHERE yearid >= 1920
-- GROUP BY decade
-- ORDER BY decade;

-- Answer The number of strikeouts per game has steadily increased each game. While the average number of homeruns per game has increased in total over the period, it has not been a steady increase. Significant increases were observed in the 1950's, 1990's, and 2000's which large decreases were observed in the 1970's and 2010's.

-- Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.

-- SELECT p.namelast,
-- 	p.namefirst,
-- 	ROUND(SUM(b.sb) * 100.0 / NULLIF(SUM(b.sb + b.cs),0), 2) AS sb_success
-- FROM batting AS b
-- INNER JOIN people AS p
-- ON p.playerid = b.playerid
-- WHERE b.yearid = 2016
-- 	AND (sb+cs) >=20
-- GROUP BY namelast, namefirst
-- ORDER BY sb_success DESC;

-- SELECT p.namelast,
-- 	p.namefirst,
-- 	(100*SUM(sb)/(SUM(sb+cs))) AS success_perc
-- FROM batting AS b
-- INNER JOIN people AS p
-- ON p.playerid = b.playerid
-- WHERE b.yearid = 2016
-- 	AND (sb+cs) >=20
-- 	AND sb IS NOT NULL
-- 	AND cs IS NOT NULL
-- GROUP BY namelast, namefirst
-- ORDER BY success_perc DESC;

-- 	ROUND(((b.sb/(b.sb+b.cs))*100), 2) AS success_percentage - ask why this would not work. NULLIF in the demoninator replaces additional WHERE statements to clarify when SB and CS are NOT NULL. Not sure why it is successful only when * 100 is in the numerator of the statement though. Order of operations? Also, why does the second approach result in whole numbers automatically?
		  

-- Answer Chris Owings had the best success stealing bases in 2016 with a 91.30% success percentage.

--  7 From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

-- SELECT name,
-- 	yearid,
-- 	MAX(w) AS most_wins
-- FROM teams
-- WHERE yearid BETWEEN 1970 AND 2016
-- 	AND wswin = 'N'
-- GROUP BY name, yearid
-- ORDER BY most_wins DESC;

-- Answer pt 1 The 2001 Seattle Mariners won 116 games but did not win the World Series.

-- SELECT name,
-- 	yearid,
-- 	MIN(w) AS most_wins
-- FROM teams
-- WHERE yearid BETWEEN 1970 AND 2016
-- 	AND wswin = 'Y'
-- 	AND yearid <> 1981
-- GROUP BY name, yearid
-- ORDER BY most_wins;

-- Answer pt 2 The 1981 Los Angeles Dodgers won the World Series despite only having 63 wins. This number is significantly lower than all other seasons due to the mid-season players strike in June-July. The MLB decided to split the season into halves and the teams that won their division in each half advanced to the post season. Excluding the 1981 Dodgers, the 2006 St. Louis Cardinals won the World Series with the lowest number of total wins at just 83.

-- SELECT name,
-- 	yearid,
-- 	MAX(w) AS most_wins,
-- 	wswin
-- FROM teams
-- WHERE yearid BETWEEN 1970 AND 2016
-- GROUP BY name, yearid, wswin
-- ORDER BY yearid;

-- SELECT COUNT(SELECT name,
-- 	MAX(w) AS most_wins
-- FROM teams) AS team_most_wins
-- WHERE yearid BETWEEN 1970 AND 2016
-- 	AND wswin = 'Y'
-- GROUP BY name, yearid
-- ORDER BY yearid;

-- SELECT year,
-- 	COUNT(SELECT name,
-- 	MAX(w) AS most_wins
-- FROM teams
-- WHERE wswin = 'Y'
-- GROUP BY name, yearid
-- ORDER BY yearid;)
-- FROM teams
-- GROUP BY year;

-- SELECT yearid,
-- 	COUNT(CASE WHEN max(W) AND wswin = 'Y' THEN teamid END) AS max_wins_wschamp
-- FROM teams
-- GROUP BY yearid;

--Needs work to answer final 2 parts. Case statement to help isolate team with most wins and a WS win?

-- 8 Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

-- SELECT park_name,
-- 	h.team,
-- 	(h.attendance/h.games) AS avg_attendance
-- FROM homegames AS h
-- INNER JOIN parks AS p
-- ON h.park = p.park
-- WHERE h.year = '2016'
-- 	AND h.games >= '10'
-- ORDER BY avg_attendance DESC
-- LIMIT 5;

-- The 5 teams with the highest average home game attendance in 2016 were Los Angeles Dodgers at Dodger Stadium (45,719), St. Louis Cardinals at Busch Stadium III (42,524), Toronto Blue Jays at Rogers Centre (41,877), San Francisco Giants at AT&T Park  (41,546), and Chicago Cubs at Wrigley Field (39,906).

-- SELECT p.park_name,
-- 	h.team,
-- 	(h.attendance/h.games) AS avg_attendance
-- FROM homegames AS h
-- INNER JOIN parks AS p
-- ON h.park = p.park
-- WHERE h.year = 2016
-- 	AND h.games >= 10
-- ORDER BY avg_attendance
-- LIMIT 5;

-- The 5 teams with the lowest average home game attendance in 2016 were the Tampa Bay Rays at Tropicana Field (15,878), Oakland Athletics at Oakland-Alameda County Coliseum (18,784), Cleveland Indians at Progressive Field (19,650), Miami Marlins at Marlins Park (21,405), and the Chicago White Sox at U.S. Cellular Field.

-- 9 Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

-- SELECT COUNT(a.playerid),
-- 	p.namefirst,
-- 	p.namelast,
-- 	a.lgid,
-- 	a.yearid,
-- 	m.playerid,
-- 	t.name
-- FROM awardsmanagers AS a
-- INNER JOIN people AS p
-- ON a.playerid = p.playerid
-- INNER JOIN managershalf AS m
-- ON p.playerid = m.playerid
-- INNER JOIN teams as t
-- ON m.teamid = t.teamid
-- WHERE a.awardid = 'TSN Manager of the Year'
-- 	AND a.lgid <> 'ML'
-- GROUP BY p.namelast, p.namefirst, t.name, a.lgid, a.yearid, m.playerid
-- ORDER BY p.namelast DESC, p.namefirst;

-- SELECT a.playerid,
-- 	p.namefirst,
-- 	p.namelast,
-- 	a.lgid,
-- 	a.yearid,
-- 	t.name
-- FROM awardsmanagers AS a
-- INNER JOIN people AS p
-- ON a.playerid = p.playerid
-- INNER JOIN managershalf AS m
-- ON p.playerid = m.playerid
-- INNER JOIN teams as t
-- ON m.teamid = t.teamid
-- WHERE a.awardid = 'TSN Manager of the Year'
-- 	AND a.lgid <> 'ML'
-- GROUP BY p.namelast, p.namefirst, t.name, a.lgid, a.yearid, a.playerid
-- ORDER BY p.namelast DESC, p.namefirst;

-- 9 Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

--Shows count of awards and league, but does not provide team when managing.
-- SELECT COUNT(a.awardid),
-- 	p.namefirst,
-- 	p.namelast,
-- 	a.lgid
-- FROM awardsmanagers AS a
-- INNER JOIN people AS p
-- ON a.playerid = p.playerid
-- WHERE a.awardid = 'TSN Manager of the Year'
-- 	AND a.lgid <> 'ML'
-- GROUP BY p.namelast, p.namefirst, a.lgid
-- ORDER BY p.namelast DESC, p.namefirst;

-- Answer Jim Leyland (leylaji99 - 1 AL{2006, COL}, 3NL{1988,1990,1992}) and Davey Johnson (johnsda02 - 1 AL{1997}, 1 NL{2012})

--Changed joins to left and using (with two matching criteria for the second join) still includes managers that don't fit the criteria and does not have team name.
SELECT COUNT(a.playerid),
	p.namefirst,
	p.namelast,
	a.lgid, 
	m.yearid,
	m.teamid
FROM awardsmanagers AS a
LEFT JOIN people AS p
USING(playerid)
LEFT JOIN managers AS m
USING (yearid, playerid)
WHERE a.awardid = 'TSN Manager of the Year'
	AND a.lgid <> 'ML'
GROUP BY p.namelast, p.namefirst, a.lgid, m.yearid, m.teamid
ORDER BY p.namelast DESC, p.namefirst;

-- SELECT COUNT(a.awardid),
-- 	p.namefirst,
-- 	p.namelast,
-- 	a.lgid,
-- 	a.yearid
-- FROM awardsmanagers AS a
-- INNER JOIN people AS p
-- ON a.playerid = p.playerid
-- WHERE a.awardid = 'TSN Manager of the Year'
-- 	AND a.lgid <> 'ML'
-- GROUP BY p.namelast, p.namefirst, a.lgid, a.yearid
-- ORDER BY p.namelast DESC, p.namefirst;

-- SELECT teamid,
-- 	playerid
-- FROM managers
-- WHERE playerid IN ('leylaji99', 'johnsda02');

WITH n AS (
	SELECT a.awardid,
	p.namefirst,
	p.namelast,
	a.yearid,
	a.playerid,
	a.lgid
FROM awardsmanagers AS a
INNER JOIN people AS p
ON a.playerid = p.playerid
WHERE awardid = 'TSN Manager of the Year'
	AND a.lgid = 'NL'),
	
	a AS (
	SELECT a.awardid,
	p.namefirst,
	p.namelast,
	a.yearid,
	a.playerid,
	a.lgid
FROM awardsmanagers AS a
INNER JOIN people AS p
ON a.playerid = p.playerid
WHERE awardid = 'TSN Manager of the Year'
	AND a.lgid = 'AL')
	
SELECT n.namelast,
	n.namefirst,
	n.lgid,
	a.lgid,
	n.yearid AS NL_year,
	a.yearid AS AL_year,
	m.teamid
FROM n
LEFT JOIN a
USING (playerid, yearid)
LEFT JOIN managers AS m
USING (playerid);

-- Use original 2 CTEs 

WITH n AS (
	SELECT a.awardid,
	p.namefirst,
	p.namelast,
	a.yearid,
	a.playerid,
	a.lgid
FROM awardsmanagers AS a
INNER JOIN people AS p
ON a.playerid = p.playerid
WHERE awardid = 'TSN Manager of the Year'
	AND a.lgid = 'NL'),
	
	a AS (
	SELECT a.awardid,
	p.namefirst,
	p.namelast,
	a.yearid,
	a.playerid,
	a.lgid
FROM awardsmanagers AS a
INNER JOIN people AS p
ON a.playerid = p.playerid
WHERE awardid = 'TSN Manager of the Year'
	AND a.lgid = 'AL')
	
SELECT n.namelast,
	n.namefirst,
	n.lgid AS nl_win,
	n.yearid,
	a.lgid AS al_win,
	a.yearid
FROM n
LEFT JOIN a
ON a.playerid = n.playerid
WHERE n.lgid IS NOT NULL
	AND a.lgid IS NOT NULL;

--union is needed to create a table that has one column for year and one for leagueid. Struggling to union since they're from the same table
-- SELECT yearid AS year
-- FROM awardsmanagers
-- UNION ALL
-- SELECT lgid AS league
-- FROM awardsmanagers
-- ORDER BY yearid;

-- SELECT *
-- FROM managers
-- ORDER BY playerid

-- SELECT teamid, yearid, playerid --Amanda's query to double check
-- FROM managers
-- WHERE yearid IN (1988, 1990, 1992, 1997, 2006, 2012)
-- 	AND playerid IN ('leylaji99', 'johnsda02')
-- ORDER BY playerid



-- 10 Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

SELECT p.namelast, --move forward with current query but look into window function to isolate numbers for 2016. Still need to filter for players with more than 10 seasons played
	p.namefirst,
	MAX(b.hr),
	COUNT(b.yearid) AS seasons_played
FROM people AS p
LEFT JOIN batting AS b
USING (playerid)
WHERE b.yearid = 2016 --window
	AND b.hr >= 1
GROUP BY p.namelast, p.namefirst
-- ORDER BY p.namelast, p.namefirst;
ORDER BY seasons_played DESC;

-- SELECT EXTRACT(YEAR FROM debut)
-- FROM people
-- WHERE namelast = 'Price'

-- SELECT namelast,
-- 	CAST(finalgame AS date) AS final_game,
-- 	CAST (debut AS date) AS first_game
-- FROM people
-- WHERE (CAST(finalgame AS date)-(CAST(debut AS date))) >= 3650


-- SELECT p.namelast, --creating duplicates, needs more refining
-- 	p.namefirst,
-- 	p.namegiven,
-- 	COUNT(b.yearid) AS seasons_played
-- FROM people AS p
-- LEFT JOIN batting AS b
-- USING (playerid)
-- GROUP BY p.namelast, p.namefirst, p.namegiven
-- ORDER by seasons_played DESC;

