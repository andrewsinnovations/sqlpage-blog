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
            'post_date', TO_CHAR(sqlpage_files.last_modified, $date_format),
            'content', posts.content
        ) as post_data
    FROM
        sqlpage_files
        inner join posts
            on sqlpage_files.post_id = posts.id
    WHERE
        $post_id is null or posts.id = $post_id::int
    order BY
        sqlpage_files.last_modified desc
) posts