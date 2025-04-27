alter table posts add column published_date timestamp;
update posts set published_date = last_modified where published = true;
alter table posts drop column published;