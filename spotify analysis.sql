-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
---------------------------------------------------------------
SELECT  COUNT(*) FROM SPOTIFY;
SELECT DISTINCT ALBUM_TYPE FROM SPOTIFY;
SELECT MAX(DURATION_MIN) , MIN(DURATION_MIN) FROM SPOTIFY;


SELECT * FROM SPOTIFY 
WHERE DURATION_MIN=0;

DELETE FROM SPOTIFY
WHERE DURATION_MIN=0;
---------------------------------------

------------------------------------------DATA ANALYSIS --------------------------------------------------------------




--Q1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM SPOTIFY
WHERE STREAM > 1000000000;


--Q2.List all albums along with their respective artists.
SELECT distinct album,artist 
from spotify                        // we have 14178 distinct album
order by artist;

select distinct artist 
from spotify;                   // we have 2074 artists

--q3 Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) as total_number_of_comments
from spotify
where licensed=true;

--q4 Find all tracks that belong to the album type single.

select  track
  from spotify 
  where album_type = 'single';
  
--q5 Count the total number of tracks by each artist.

 select  distinct artist ,count(track) as track_count
 from spotify
 group by artist ;
 


--q6:Calculate the average danceability of tracks in each album.

select album,avg(danceability) as Avg_danceability
from spotify
group by album
order by Avg_danceability desc;


 -- q7:Find the top 5 tracks with the highest energy values
 
 select track , round(energy_liveness) as top_05_energyvalues
 from spotify
 order by energy_liveness desc
 limit 5;

 --q8 List all tracks along with their views and likes where official_video = TRUE.

  select track , views, likes
  from spotify
  where official_video = true;

-- q9 For each album, calculate the total views of all associated tracks.
 select album,track, sum(views) as views
 from spotify 
 group by album,track
 order by  sum(views) desc;

 -- q10. Retrieve the track names that have been streamed on Spotify more than YouTube 
 
SELECT * FROM
( SELECT TRACK,
COALESCE(sum(case when lower(trim(most_played_on ))='youtube' then stream end),0) as str_you,
coalesce (sum (case when lower (trim(most_played_on)) = 'spotify' then stream end),0 ) as str_spo
from spotify
group by 1) as t1
where
str_spo > str_you
and
str_you <>0;

q11.Find the top 3 most-viewed tracks for each artist using window functions.

SELECT * FROM (
SELECT 
    artist,
    track,
    views,
    ROW_NUMBER() OVER (PARTITION BY ARTIST ORDER BY views DESC) AS RANKS
FROM spotify) AS T
WHERE RANKS BETWEEN 1 AND 3;

Q12-Write a query to find tracks where the liveness score is above the average.

	select track ,liveness
		from spotify
		where liveness >(
		SELECT  avg(liveness) as avg_liveness
		from spotify)
q13:Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
WITH energy_values
	AS
	(SELECT 
		album,
		MAX(energy) as highest_energy,
		MIN(energy) as lowest_energery
	FROM spotify
	GROUP BY album
	)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM energy_values
ORDER BY energy_diff DESC;


q14:Find tracks where the energy-to-liveness ratio is greater than 1.2.

   select  track ,energy_liveness
    from spotify
	where energy_liveness > 1.2;

q15: Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
   
SELECT 
    track,
    views,
    likes,
    sum(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify
ORDER BY views desc;

