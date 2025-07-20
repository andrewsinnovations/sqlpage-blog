SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SET
    request = CASE
        WHEN $request IS NULL THEN ''
        ELSE $request
    END
;



SET
    request = json_build_object(
        'method',
        'POST',
        'timeout_ms',
        60000,
        'url',
        'https://api.openai.com/v1/chat/completions',
        'headers',
        json_build_object(
            'Content-Type',
            'application/json',
            'Authorization',
            'Bearer ' || sqlpage.environment_variable ('openai_api_key')
        ),
        'body',
        json_build_object(
            'model',
            'gpt-4.1-mini',
            'messages',
            json_build_array(
                json_build_object(
                    'role',
                    'system',
                    'content',
                    'You are a helpful blog editor. When given a piece of text, revise it to improve clarity and readability for the average reader while preserving the original tone. Avoid unnecessary introductory phrases and aim for direct, concise language. Do not default to creating 3-item lists unless the original text includes one. Ensure the revised text presents the author as friendly and approachable. Your input may be in HTML and you should response with HTML.'
                ),
                json_build_object('role', 'user', 'content', $request)
            ),
            'temperature',
            0.7
        )
    )
;



SET
    response = sqlpage.fetch ($request)
;



SET
    content = $response::jsonb -> 'choices' -> 0 -> 'message' ->> 'content'
;



SELECT
    'json' AS component,
    'jsonlines' AS type
;



SELECT
    $content AS revision
;