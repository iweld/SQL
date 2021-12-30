/*
	Simple PostgreSQL exercises using one column of English words.
*/

-- Just like it says, drop the table if it exists

DROP TABLE IF EXISTS WORDS;

-- Create a one column table and use that column as the primary key

CREATE TABLE WORDS (
	WORD VARCHAR(50),
	PRIMARY KEY (WORD)
);

-- Import csv from wheverever you have it stored.  Note the delimiter.

COPY WORDS
FROM '** Path to your **/csv/words.csv'
DELIMITER ',';

-- Test table by randomly grabbing an awesome word from the record

SELECT WORD
FROM WORDS
WHERE WORD = 'shaker';

-- How many words are we starting with?

SELECT COUNT(*)
FROM WORDS;

-- How many words start with the letter 'j'?

SELECT COUNT(*)
FROM WORDS
WHERE WORD like 'j%';

-- How many words contain 'jaime'?

SELECT COUNT(*)
FROM WORDS
WHERE WORD like '%jaime%';

-- There's only one and only.  How many words contain 'shaker'?

SELECT COUNT(*)
FROM WORDS
WHERE WORD like '%shaker%';

-- 13? Must be a lucky word.  What are those words?

SELECT WORD
FROM WORDS
WHERE WORD like '%shaker%';

-- Speaking of 13.  How many words are 13 letters long?

SELECT COUNT(*)
FROM WORDS
WHERE LENGTH(WORD) = 13;

-- What is the longest word in this table and how many characters does it contain?

SELECT WORD as "Longest Word", length(word) as "Word Length" 
FROM WORDS
WHERE LENGTH(WORD) =
		(SELECT MAX(LENGTH(WORD))
			FROM WORDS);

-- What is the Average word length?

SELECT AVG(LENGTH(WORD))
FROM WORDS;

-- That returned a floating point value.  Can you round that number?

SELECT ROUND(AVG(LENGTH(WORD)))
FROM WORDS;

-- What is the Median length?

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY length(word)) 
FROM words;

-- What is the 90th percentile length?

SELECT PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY length(word)) 
FROM words;

-- What is the 25th percentile length?

SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY length(word)) 
FROM words;

-- What row number is the word 'shaker' in?  

SELECT ROW_NUM AS "Row Number",
	WORD AS "Cool Last Name"
FROM
	(SELECT WORDS.*,
			ROW_NUMBER() OVER() AS ROW_NUM
		FROM WORDS) AS ROW
WHERE WORD = 'shaker';

-- Find the count of all the palindromes (Excluding single and double letter words)

SELECT COUNT(*)
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3;

-- Give me the first 10 of all the palindromes (Excluding single and double letter words)

SELECT WORD
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
ORDER BY WORD 
LIMIT 10;

-- Give me the 15th palindrome (Excluding single and double letter words) 
-- of words that start with the letter 's'

SELECT WORD
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
	and word like 's%'
ORDER BY WORD 
LIMIT 1 
OFFSET 14;

-- Find the row number for every month of the year and
-- sort them in chronological order

SELECT ROW_NUM AS "Row Number",
	WORD AS "Month"
FROM
	(SELECT WORDS.*,
			ROW_NUMBER() OVER() AS ROW_NUM
		FROM WORDS) AS ROW
WHERE WORD in (
	'january',
	'february',
	'march',
	'april',
	'may',
	'june',
	'july',
	'august',
	'september',
	'october',
	'november',
	'december')
ORDER BY TO_DATE(WORD,'Month');
