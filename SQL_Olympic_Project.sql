-- Creating table athlete_events and checking if already exits then drop it.
drop table if exists athlete_events;
create table athlete_events (id integer, Name varchar, Sex varchar(1), 
Age varchar, Height varchar, Weight varchar, Team varchar, NOC varchar(3),
Games varchar, Year int, Season varchar, City varchar, Sport varchar,
Event varchar, Medal varchar);

-- Importing athelete_events talble data
copy athlete_events from 'D:\SQL\athlete_events.csv' with CSV header;

select * from athlete_events;

-- Creating table noc_regions and checking if already exits then drop it.
drop table if exists noc_regions;
create table noc_regions(NOC varchar(3), Region varchar);

-- Importing athelete_events talble data
copy noc_regions from 'D:\SQL\noc_regions.csv' with CSV header;

select * from noc_regions;

-- Undestanding and Analyzing the Data

select * from athlete_events where weight = 'NA' and Age = 'NA' and 
height= 'NA' and medal = 'NA';

select count (distinct games) from athlete_events;

select distinct (sport) from athlete_events;

select distinct (year) from athlete_events; 

-- The data is of 35 distinct years between 1896 to 2016 with 765 events and total 66 sports.

-- Here are some question to understand the data better.

-- Q1 : How many olympics games have been held?
select count (distinct games) Total_Olympic_Games from athlete_events;

-- Q2 : List down all Olympics games held so far.
select distinct games Total_Games from athlete_events;

-- Q3 : Mention the total no of nations who participated in each olympics game?
select count(distinct noc) Total_Counties from athlete_events;

-- Q4 : Which year saw the highest and lowest no of countries participating in olympics?
with tab as (select year, count(distinct noc) Countries 
from athlete_events group by year) select * from tab where 
Countries=(select min(Countries) from tab) or 
Countries=(select max(Countries) from tab);
											 											 
-- Q5 : Which nation has participated in all of the olympic games?
select u.region, count(games) from
(select distinct noc countries, games from athlete_events) 
as t inner join noc_regions as u on u.noc = t.countries
group by region having count(games) = (select count (distinct games) from athlete_events);

-- Q6 : Identify the sport which was played in all summer olympics.
select sport, count (games) total_games from (select distinct sport, games from athlete_events 
where season='Summer') as t group by sport having count(games) = (select count (distinct games) 
from athlete_events where season = 'Summer');

-- Q7 : Which Sports were just played only once in the olympics?
select sport, count (sport) No_of_games from (select distinct sport, games 
from athlete_events where season='Summer') as t
group by sport having count(sport) =1;

-- Q8 :Fetch the total no of sports played in each olympic games.
select count (distinct sport) no_of_sports_played, games from athlete_events group by
games order by count(distinct sport) desc;

-- Q9 : Fetch details of the oldest athletes to win a gold medal.
select * from athlete_events where age!= 'NA' and medal = 'Gold' order by age desc limit 2;

-- Q10 : Fetch the top 5 athletes who have won the most gold medals.
select distinct name, team, noc, count(medal) over(partition by name) total_no_of_gold_medals
from athlete_events where medal = 'Gold' order by total_no_of_medals desc limit 5;

-- Q11 : Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
select distinct name, team, noc, count(medal) over(partition by name) total_no_of_medals
from athlete_events where medal !='NA' order by total_no_of_medals desc limit 5;

-- Q12 : Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
select distinct region, count(medal) total_no_of_medals from athlete_events ae inner join noc_regions nr
on ae.noc = nr.noc where medal!='NA' group by region order by total_no_of_medals desc limit 5;

-- Q13 : List down total gold, silver and broze medals won by each country.
select region, 
sum(case when medal='Gold' then 1 else 0 end) Gold,
sum(case when medal='Silver' then 1 else 0 end) Silver,
sum(case when medal='Bronze' then 1 else 0 end) Bronze
from athlete_events ae inner join noc_regions nr on ae.noc=nr.noc
group by region order by Gold desc, Silver desc, Bronze desc; 

-- Q14 : List down total gold, silver and broze medals won by each country corresponding to each olympic games.
select region, games,
sum(case when medal='Gold' then 1 else 0 end) Gold,
sum(case when medal='Silver' then 1 else 0 end) Silver,
sum(case when medal='Bronze' then 1 else 0 end) Bronze
from athlete_events ae inner join noc_regions nr on ae.noc=nr.noc
group by region,games order by Gold desc, Silver desc, Bronze desc; 

-- Q15 : In which Sport/event, India has won highest medals.
select sport,count(medal) total_medals from athlete_events where medal!='NA' and noc = 'IND' 
group by sport order by total_medals desc limit 1;
