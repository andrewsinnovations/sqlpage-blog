alter table sqlpage_files drop column post_id;
alter table sqlpage_files add column post_id integer references posts(id);

alter table posts drop column url;
alter table posts drop column published_date;