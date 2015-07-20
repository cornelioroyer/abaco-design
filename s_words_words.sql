
select count(*) from words_words;








/*

select mistakes, puntos, english, spanish from words_words 
order by mistakes desc limit 100;

select next_question, count(*) from words_words
group by 1
order by 1;



drop table tmp_matame;
create table tmp_matame as select id, mistakes, puntos, english, spanish from words_words order by mistakes desc limit 20;

update words_words
set puntos = 0
where id in (select id from tmp_matame);


select mistakes, puntos, english, spanish from words_words order by mistakes desc limit 100;

select updated, english from words_words order by 1 desc limit 3



select sum(puntos) from words_words;

select next_question, puntos, count(*) from words_words
group by 1, 2
order by 1, 2;

select next_question, puntos, * from words_words
where spanish like '%insignia%'



select next_question, puntos, * from words_words
where english like  '%abs%';




select next_question, puntos, english, spanish
from words_words
order by 1, 2;

*/

