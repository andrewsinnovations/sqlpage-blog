--select '[]' as posts;
SELECT
    json_agg(post_data) as posts
FROM
(
    SELECT
        json_build_object(
            'title', posts.title,
            'slug_path', substr(sqlpage_files.path, 1, length(sqlpage_files.path) - 4),
            'db_path', sqlpage_files.path,
            'post_date', case TO_CHAR(sqlpage_files.last_modified, 'MM')
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
                END || ' ' || to_char(sqlpage_files.last_modified, 'DD, YY')
            , 'content', posts.content
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