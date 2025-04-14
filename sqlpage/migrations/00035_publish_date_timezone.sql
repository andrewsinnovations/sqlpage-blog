alter table posts drop column published_date;
alter table posts add column published_date timestamptz;