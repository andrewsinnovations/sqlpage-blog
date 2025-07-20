--select '[]' as posts;
SET
    date_format = (
        SELECT
            coalesce(setting_value, 'MM/DD/YYYY')
        FROM
            settings
        WHERE
            setting_name = 'post_date_format'
    )
;



SELECT
    json_agg(post_data) AS posts
FROM
    (
        SELECT
            json_build_object(
                'title',
                posts.title,
                'slug_path',
                substr(
                    sqlpage_files.path,
                    1,
                    length(sqlpage_files.path) - 4
                ),
                'db_path',
                sqlpage_files.path,
                'post_date_last_modified',
                to_char(
                    sqlpage_files.last_modified at time zone timezone,
                    $date_format
                ),
                'post_date',
                to_char(
                    posts.published_date at time zone timezone,
                    $date_format
                ),
                'content',
                posts.content
            ) AS post_data
        FROM
            sqlpage_files
            INNER JOIN posts ON sqlpage_files.post_id = posts.id
        WHERE
            (
                $all_posts::bool = TRUE
                OR posts.id = $post_id::int
            )
            AND posts.post_type = 'post'
            AND posts.published_date IS NOT NULL
            AND posts.published_date at time zone 'UTC' < now()
        ORDER BY
            posts.published_date at time zone timezone DESC
    ) posts