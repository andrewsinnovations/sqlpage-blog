alter table posts drop column published_date;
alter table posts add column published_date timestamp;
alter table posts add column post_type text not null;