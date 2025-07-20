SELECT
    'redirect' AS component,
    '/admin/install?invalid=1' AS link
WHERE
    sqlpage.request_method () = 'POST'
    AND (
:password !=:password_confirm
        OR:password = ''
        OR:login = ''
        OR:blog_name = ''
    )
;



INSERT INTO
    login (username, password_hash)
SELECT
:login,
    sqlpage.hash_password (:password)
WHERE
    sqlpage.request_method () = 'POST'
;



INSERT INTO
    settings (setting_name, setting_value)
SELECT
    'blog_name',
:blog_name
WHERE
    sqlpage.request_method () = 'POST'
;



-- Setup default routing
INSERT INTO
    settings (setting_name, setting_value)
SELECT
    'post_routes',
    'y_slug'
WHERE
    sqlpage.request_method () = 'POST'
;



DELETE FROM sqlpage_files
WHERE
    path = 'sqlpage/templates/post.handlebars'
    AND sqlpage.request_method () = 'POST'
;



DELETE FROM sqlpage_files
WHERE
    path = 'sqlpage/templates/home.handlebars'
    AND sqlpage.request_method () = 'POST'
;



INSERT INTO
    sqlpage_files (path, contents, created_at, last_modified)
SELECT
    'sqlpage/templates/post.handlebars',
    '<!doctype html>
<html>
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" integrity="sha384-dpuaG1suU0eT09tx5plTaGMLBsfDLzUCCUXOY2j/LSvXYuG6Bqs43ALlhIqAJVRb" crossorigin="anonymous">

    <title>{{(default settings.blog_name "Blog")}}</title>
  </head>
  <body>
<div class="container-fluid">
<nav class="navbar bg-body-tertiary">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">{{(default settings.blog_name "Blog")}}</a>
  </div>
</nav>
</div>
<div class="container">
<h1>{{post.title}}</h1>
{{post.post_date}}<br>
{{{post.content}}}
</div></body>
</html>
',
    current_timestamp,
    current_timestamp
WHERE
    sqlpage.request_method () = 'POST'
;



INSERT INTO
    sqlpage_files (path, contents, created_at, last_modified)
SELECT
    'sqlpage/templates/home.handlebars',
    '<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" integrity="sha384-dpuaG1suU0eT09tx5plTaGMLBsfDLzUCCUXOY2j/LSvXYuG6Bqs43ALlhIqAJVRb" crossorigin="anonymous">
    <title>{{default settings.blog_name ''Blog''}}</title>
  </head>
  <body>
<div class="container-fluid">
<nav class="navbar bg-body-tertiary">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">{{default settings.blog_name ''Blog''}}</a>
  </div>
</nav>
</div>
<div class="container">
{{#if (eq (len posts) 0)}}
    <p>{{(default @settings.no_posts_text "There haven''t been any posts created yet.")}}</p>
{{else}}
    <ol>
    {{#each posts}}
        <li>
            <a href="/{{slug_path}}">{{title}}</a><br/>
            {{post_date}}
        </li>
    {{/each}}
    </ol>
{{/if}}

</div>
</body>
</html>
',
    current_timestamp,
    current_timestamp
WHERE
    sqlpage.request_method () = 'POST'
;



SELECT
    'redirect' AS component,
    '/admin?success=1' AS link
WHERE
    sqlpage.request_method () = 'POST'
;



SELECT
    'redirect' AS component,
    '/admin' AS link
WHERE
    EXISTS (
        SELECT
            *
        FROM
            login
    )
    AND sqlpage.request_method () = 'GET'
;



SELECT
    'shell' AS component,
    'New Blog Setup' AS title,
    '/admin/install' AS link,
    ' ' AS footer
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'alert' AS component,
    'Invalid password, or the passwords supplied do not match.' AS title,
    'red' AS color,
    'exclamation-circle' AS icon
    --, true as important
,
    TRUE AS dismissible
WHERE
    sqlpage.request_method () = 'GET'
    AND $invalid IS NOT NULL
;



SELECT
    'text' AS component,
    'Welcome to your new blog! Before you can start posting, you need to set up your database.' AS contents
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'form' AS component,
    '/admin/install' AS action,
    'post' AS method,
    'Save Configuration' AS validate
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'blog_name' AS name,
    'Blog Name' AS label,
    TRUE AS required
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'login' AS name,
    'Login' AS label,
    TRUE AS required
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'password' AS name,
    'Password' AS label,
    'password' AS type,
    TRUE AS required
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'password_confirm' AS name,
    'Confirm Your Password' AS label,
    'password' AS type,
    TRUE AS required
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'select' AS type,
    'Default Timezone' AS label,
    'timezone' AS name,
    TRUE AS required,
    'UTC' AS value,
    (
        SELECT
            json_agg(options)
        FROM
            (
                SELECT
                    json_build_object('label', name, 'value', name) AS options
                FROM
                    pg_timezone_names
                ORDER BY
                    name
            ) options
    ) AS options
;