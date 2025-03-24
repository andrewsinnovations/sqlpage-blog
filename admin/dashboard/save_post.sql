SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/check_session.sql') AS properties; 
 
 set slug = (
    select lower(value) from (
        select replace(value, '.', '') as value from (
        select replace(value, '--', '-') as value FROM
        (
            select 
            (
            -- remove a bunch of special characters
            TRIM(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(:title,',', ''), '!', ''), '?', ''), '&', 'and'), ' ', '-'), '--', '-'))
            ) as value
        )
        )
    )
);

set post_routes = (
    select setting_value from settings where setting_name = 'post_routes'
);

set url = (
    select case when $post_routes = 'ymd_slug' then strftime('%Y/%m/%d/', current_timestamp) ||  $slug 
        when $post_routes = 'ym_slug' then strftime('%Y/%m/', current_timestamp) || $slug 
        when $post_routes = 'y_slug' then strftime('%Y/', current_timestamp) || $slug 
        when $post_routes = 'date_slug' then strftime('%Y%m%d/', current_timestamp) || $slug 
        when $post_routes = 'slug' then $slug 
    end
)

set sqlpage_path = $url || '.sql';

insert into posts (
    title
    , slug
    , content
    , created_at
    , last_modified
    , post_type
)
SELECT
    :title
    , $slug
    , :content
    , current_timestamp
    , current_timestamp
    , :type
WHERE
    :id = 'new';

set post_id = last_insert_rowid();

delete from sqlpage_files 
where 
    path = $sqlpage_path and :id = 'new';

insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
)
SELECT
    $sqlpage_path
    , 'set id = (select posts.id as html from sqlpage_files inner join posts on sqlpage_files.post_id = posts.id where replace(sqlpage.path(), ''.sql'', '''''') = ''/'' || replace(sqlpage_files.path, ''.sql'', ''''''));
select ''status_code'' as component, 404 as status where $id is null;
select ''shell-empty'' as component;
select ''html'' as component, setting_value as html from settings where setting_name = ''before_post'';
select ''text'' as component, ''404 - Page Not Found'' as title, ''This page was not found.'' as contents where $id is null;
select ''html'' as component, ''<h1 style="font-size:150%">'' || title || ''</h1>'' as html from posts where id = $id;
select ''html'' as component, CASE strftime(''%m'', posts.last_modified)
    WHEN ''01'' THEN ''January''
    WHEN ''02'' THEN ''February''
    WHEN ''03'' THEN ''March''
    WHEN ''04'' THEN ''April''
    WHEN ''05'' THEN ''May''
    WHEN ''06'' THEN ''June''
    WHEN ''07'' THEN ''July''
    WHEN ''08'' THEN ''August''
    WHEN ''09'' THEN ''September''
    WHEN ''10'' THEN ''October''
    WHEN ''11'' THEN ''November''
    WHEN ''12'' THEN ''December''
  END || '' '' || strftime(''%d, %Y'', posts.last_modified) as html
  from posts where id = $id;
select ''html'' as component, ''<div class="mt-3">'' || content || ''</div>'' as html from posts where id = $id;
select ''html'' as component, setting_value as html from settings where setting_name = ''after_post'';' as contents
    , current_timestamp
    , current_timestamp
    , $post_id
WHERE
    :id = 'new'
    and $published is not null;
    
SELECT
    'redirect' as component
    , '/admin/dashboard/post?saved=1&id=' || $post_id as link
WHERE
    :id = 'new';

update posts
set
    title = :title
    , slug = $slug
    , content = :content
    , last_modified = current_timestamp
WHERE
    id = :id;

delete from sqlpage_files
WHERE
    path = $sqlpage_path
    or post_id = :id;

insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
)
SELECT
    $sqlpage_path
    , 'set id = (select posts.id as html from sqlpage_files inner join posts on sqlpage_files.post_id = posts.id where replace(sqlpage.path(), ''.sql'', '''''') = ''/'' || replace(sqlpage_files.path, ''.sql'', ''''''));
select ''status_code'' as component, 404 as status where $id is null;
select ''shell-empty'' as component;
select ''html'' as component, setting_value as html from settings where setting_name = ''before_post'';
select ''text'' as component, ''404 - Page Not Found'' as title, ''This page was not found.'' as contents where $id is null;
select ''html'' as component, ''<h1 style="font-size:150%">'' || title || ''</h1>'' as html from posts where id = $id;
select ''html'' as component, CASE strftime(''%m'', posts.last_modified)
    WHEN ''01'' THEN ''January''
    WHEN ''02'' THEN ''February''
    WHEN ''03'' THEN ''March''
    WHEN ''04'' THEN ''April''
    WHEN ''05'' THEN ''May''
    WHEN ''06'' THEN ''June''
    WHEN ''07'' THEN ''July''
    WHEN ''08'' THEN ''August''
    WHEN ''09'' THEN ''September''
    WHEN ''10'' THEN ''October''
    WHEN ''11'' THEN ''November''
    WHEN ''12'' THEN ''December''
  END || '' '' || strftime(''%d, %Y'', posts.last_modified) as html
  from posts where id = $id;
select ''html'' as component, ''<div class="mt-3">'' || content || ''</div>'' as html from posts where id = $id;
select ''html'' as component, setting_value as html from settings where setting_name = ''after_post'';' as contents
    , current_timestamp
    , current_timestamp
    , :id
WHERE
    $published is not null;

select 'redirect' as component
    , '/admin/dashboard/post?saved=1&id=' || :id as link;