
----------------------------------------------------------------------------------------------------------------------------------
/*We want to reward our users who have been around the longest.*/
-- TODO: Find the 5 oldest users.
----------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM users
ORDER BY created_at DESC
LIMIT 5;

----------------------------------------------------------------------------------------------------------------------------------
/*We need to figure out when to schedule an ad campgain*/
-- TODO: What day of the week do most users register on?
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
	DAYNAME(created_at) AS 'day_of_week', 
    COUNT(*) AS 'total_registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- 2nd Method:
SELECT 
	date_format(created_at,'%W') AS 'day of the week', 
    COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

----------------------------------------------------------------------------------------------------------------------------------
/*We want to target our inactive users with an email campaign.*/
-- TODO: Find the users who have never posted a photo.
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
	username
FROM users
LEFT JOIN photos 
	ON users.id = photos.user_id
WHERE photos.id IS NULL;

----------------------------------------------------------------------------------------------------------------------------------
/*We're running a new contest to see who can get the most likes on a single photo.*/
-- TODO: Find WHO WON??!!.
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY 2
ORDER BY 4 DESC
LIMIT 1;

----------------------------------------------------------------------------------------------------------------------------------
/*Our Investors want to know...*/
-- TODO: How many times does the average user post?
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
	ROUND(
    (SELECT COUNT(*)FROM photos) / 
					(SELECT COUNT(*) FROM users),0) AS 'avg_post';	


-- TODO: user ranking by postings higher to lower
SELECT 
	username, 
    photos.user_id, 
    count(photos.image_url) AS 'total_photos'
FROM users
LEFT JOIN photos
	ON users.id = photos.user_id
group by 1
ORDER BY 3 DESC;


-- TODO: total numbers of users who have posted at least one time.
SELECT 
	COUNT(DISTINCT(users.id)) AS 'total_users_with_atleast_posts'
FROM users
LEFT JOIN photos 
	ON users.id = photos.user_id;
    
  
----------------------------------------------------------------------------------------------------------------------------------
/*A brand wants to know which hashtags to use in a post*/
-- TODO: What are the top 5 most commonly used hashtags?
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
	tag_name, 
    COUNT(tag_name) AS total
FROM tags
LEFT JOIN photo_tags 
	ON tags.id = photo_tags.tag_id
GROUP BY 1
ORDER BY 2 DESC;


----------------------------------------------------------------------------------------------------------------------------------
/*We also have a problem with celebrities*/
-- TODO: Find users who have never commented on a photo.
----------------------------------------------------------------------------------------------------------------------------------
SELECT 
COUNT(*) AS 'total_users_without_comments'
FROM
	(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY 1
	HAVING comment_text IS NULL) AS number_of_users_without_comments;
    
    
----------------------------------------------------------------------------------------------------------------------------------
/*We also have a problem with celebrities*/
-- TODO: Find users who have ever commented on a photo.
----------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS 'total_number_users_with_comments'
FROM
	(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NOT NULL) AS number_users_with_comments;
    

----------------------------------------------------------------------------------------------------------------------------------
											/* Mega Challenges */
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
/*Are we overrun with bots and celebrity accounts?*/
-- TODO: Find the percentage of our users who have either never commented on a photo or have commented on every photo.
----------------------------------------------------------------------------------------------------------------------------------
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who coments every photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_no_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB;

----------------------------------------------------------------------------------------------------------------------------------
/*We want to reward our users who have been around the longest.*/
-- TODO: Find the 5 oldest users.
----------------------------------------------------------------------------------------------------------------------------------
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who commented on photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB


