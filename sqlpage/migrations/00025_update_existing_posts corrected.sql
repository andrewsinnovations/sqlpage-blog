update sqlpage_files 
set 
    contents = 'select ''dynamic'' as component; select sqlpage.run_sql(''.post.sql'') as properties;'
    , last_modified = current_timestamp
WHERE
    post_id is not null;