alter table template add column post_default boolean default false;
update template set post_default = false;
update template set post_default = true where name = 'Post';