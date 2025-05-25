CREATE TABLE rangers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    region VARCHAR(255)
);
--insert data into rangers table 
INSERT INTO rangers (id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');
--fetch all rangers
SELECT * FROM rangers;
--create table 'species'
CREATE TABLE species(
    id SERIAL PRIMARY KEY,
    common_name VARCHAR(55),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);
--insert data into species tabel
INSERT INTO species (id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');
--fetch all species
SELECT * FROM species;
--create table 'sightings'

CREATE TABLE sightings(
    id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(id) on delete CASCADE, 
    species_id INT REFERENCES species(id) on delete CASCADE,
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes VARCHAR(50)
);
--insert data into sightings table
INSERT INTO sightings (id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

--fetch all sightings
SELECT * FROM sightings;

--register a new ranger with provided data with name = 'Darix Fox' and region ='coastal plains'
-- Reset the sequence to avoid duplicate key errors

INSERT INTO rangers (id,name, region) VALUES (4,'Darix Fox', 'Coastal Plains');
SELECT* FROM rangers;

--2.count unique species ever sighted

SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 3. find all sightings where the location includes "pass"
select * from sightings
WHERE location LIKE '%Pass%';

--4.list each rangers name and their total number of  sightings
select name  ,count(*) as "total_sightigns"  FROM sightings
join rangers ON sightings.ranger_id = rangers.id
GROUP BY NAME ;

--5.list species that have never been sighted
select common_name FROM species
LEFT JOIN sightings on species.id = sightings.species_id
where sightings.id IS NULL;

--6 .show the most recent 2 sightings
SELECT common_name,sighting_time,name FROM sightings
JOIN species ON sightings.species_id = species.id
JOIN rangers ON sightings.ranger_id = rangers.id     
ORDER BY sighting_time DESC
LIMIT 2;

--7. update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(YEAR FROM discovery_date) < 1800;
SELECT * FROM species;

--8. label each sightings time of day as 'Mornign','Afternoon' or 'Evening'

SELECT   id as sighting_Id,sighting_time,
CASE 
    WHEN EXTRACT(HOUR from  sighting_time)<12 THEN 'Mornign'
    WHEN EXTRACT(HOUR FROM   sighting_time) >=12 and EXTRACT(HOUR FROM   sighting_time) <17 THEN 'Afternoon' 
    ELSE  'evening'
END as time_of_day
FROM sightings;

--9. Delete rangers who have never sighted any species 
DELETE FROM rangers
WHERE id NOT IN (SELECT DISTINCT ranger_id FROM sightings);
/* DELETE from rangers
WHERE id=4; */
--done--



