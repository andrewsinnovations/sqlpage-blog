SELECT
    json_group_array(post_data) as posts
FROM
(
    SELECT
        json_object(
            'title', posts.title,
            'slug_path', substr(sqlpage_files.path, 1, length(sqlpage_files.path) - 4),
            'db_path', sqlpage_files.path,
            'post_date', CASE strftime('%m', sqlpage_files.last_modified)
                    WHEN '01' THEN 'January'
                    WHEN '02' THEN 'February'
                    WHEN '03' THEN 'March'
                    WHEN '04' THEN 'April'
                    WHEN '05' THEN 'May'
                    WHEN '06' THEN 'June'
                    WHEN '07' THEN 'July'
                    WHEN '08' THEN 'August'
                    WHEN '09' THEN 'September'
                    WHEN '10' THEN 'October'
                    WHEN '11' THEN 'November'
                    WHEN '12' THEN 'December'
                END || ' ' || strftime('%d, %Y', sqlpage_files.last_modified)
            , 'content', posts.content
        ) as post_data
    FROM
        sqlpage_files
        inner join posts
            on sqlpage_files.post_id = posts.id
    WHERE
        $post_id is null or posts.id = $post_id
    order BY
        sqlpage_files.last_modified desc
) posts