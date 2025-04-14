--select '[]' as posts;
set date_format = (
    select coalesce(setting_value, 'MM/DD/YYYY')
    from settings
    where setting_name = 'post_date_format'
);

SELECT
    json_agg(post_data) as posts
FROM
(
    SELECT
        json_build_object(
            'title', posts.title,
            'slug_path', substr(sqlpage_files.path, 1, length(sqlpage_files.path) - 4),
            'db_path', sqlpage_files.path,
            'post_date_last_modified', TO_CHAR(sqlpage_files.last_modified at time zone timezone, $date_format),
            'post_date', TO_CHAR(posts.published_date at time zone timezone, $date_format),
            'content', posts.content
        ) as post_data
    FROM
        sqlpage_files
        inner join posts
            on sqlpage_files.post_id = posts.id
    WHERE
        ($post_id is null or posts.id = $post_id::int)
        and posts.published_date is not null
        and posts.published_date at time zone 'UTC' < now()
    order BY
        posts.published_date at time zone timezone desc
) posts