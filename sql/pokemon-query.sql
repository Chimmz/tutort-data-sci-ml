-- How many rows exist in pokemongo_basedata and pokemongo_abilitydata?
select count(*) as rows_count from pokemongo_basedata;
select count(*) from pokemon_ability_data;

select * from pokemongo_basedata;
select * from pokemon_ability_data;

-- What is the most popular pokemon in terms of sighting?
select pokemonId, count(*) as sightings
from pokemongo_basedata
group by pokemonId
order by count(*) desc
limit 1;

-- Give the name of the most common pokemon
select a.Pokemon
from pokemongo_basedata b left join pokemon_ability_data a on b.pokemonId = a.PokemonID
group by a.Pokemon
order by count(*) desc
limit 1;

-- 2) What percent of pokemons appeared in urban, suburban, midurban and rural areas?
select
	case
		when urban='TRUE' then 'urban'
		when suburban='TRUE' then 'suburban'
		when urban='TRUE' then 'urban'
		when rural='TRUE' then 'rural'
		else 'Other'
		end as Area,
    count(pokemonId) as appearances
from
	pokemongo_basedata as a left join (
	select count(*) as  total_rows from pokemongo_basedata as b)
    on 1=1
    group by 1, total_rows
    order by count(pokemonId) desc;

-- 3) Which city is the most popular inhabitant of pokemons in "Clear" weather?
select appearedcity, count(*) as appearances
from pokemongo_basedata
where weather = 'Clear'
group by appearedcity
order by count(*) desc
limit 1;

-- 4) Pokemon are more likely to appear in which hour of the day for areas where population density varies between 200 to 700?
select appearedHour, count(*) as appearances
from pokemongo_basedata
where population_density between 200 and 700
group by appearedHour
order by count(*) desc
limit 1;

-- 5) What is the most common hidden ability of Pokemons
select Hidden_Ability, count(*) as ability
from pokemon_ability_data
group by Hidden_Ability
order by count(*) desc
limit 1;

-- 6) Name the pokemon which has the highest probability of appearing in morning, afternoon, 
-- evening and night respectively? (morning= 5 to 12 , afternoon=12 to 16, evening=16 to 19, night=19 to 5)											
select b.*
from (
	select
		a.time_of_day, a.pokemonId, a.appearances,
		rank() over (partition by time_of_day order by a.appearances desc) as ranking
	from (
		select
			case
				when appearedHour between 5 and 12 then 'Morning'
				when appearedHour between 12 and 16 then 'Afternoon'
				when appearedHour between 16 and 19 then 'Evening'
				when appearedHour between 19 and 24 then 'Night'
				when appearedHour between 0 and 5 then 'Night'
			end as time_of_day,
			pokemonId,
			count(pokemonId) as appearances
		from
			pokemongo_basedata 
		group by 1, pokemonId
	) as a
) as b
where b.ranking = 1

-- 2) What is the average population density of the area where "Pikachu" and "Bulbasur" appeared?											
-- 3) "Bulbasaur" has the highest probability to appear on which day of the week?
