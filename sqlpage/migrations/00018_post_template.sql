delete from sqlpage_files where path = 'sqlpage/templates/post.handlebars';
insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
    , file_id
)
select 
    'sqlpage/templates/post.handlebars'
    , '<!doctype html>
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
</html>'
    , CURRENT_TIMESTAMP
    , CURRENT_TIMESTAMP
    , NULL
    , NULL;

delete from sqlpage_files where path = 'sqlpage/templates/home.handlebars';

insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
    , file_id
)
values 
    (
    'sqlpage/templates/home.handlebars'
    , '<!doctype html>
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
'
    , CURRENT_TIMESTAMP
    , CURRENT_TIMESTAMP
    , NULL
    , NULL
    );