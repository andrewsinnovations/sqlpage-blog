SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_object(
            'shell_title', 'Template History'
        )
    ) AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Templates' as title
    , '/admin/templates' as link;

SELECT
    'New Template' as title
    , true as active
WHERE
    $id is null;

SELECT
    name as title
    , true as active
FROM
    template
WHERE
    id = $id;

select 'dynamic' as component
    , sqlpage.run_sql('admin/templates/.tabs.sql') AS properties;

SELECT
    'table' as component
    , 'version' as markdown;

with revisions as (
    SELECT
        id
        , row_number() over (order by created_at) as revision
        , created_at
        , name
    FROM
        template_history
    WHERE
        template_id = $id
    order BY
        created_at DESC
),
special_revisions as (
    select 
        max(revision) as last_revision
    FROM
        revisions
)

SELECT
    '[' || case when revision = 1 then 'Initial Version'
        else 'Version ' || revision
    end || 
    case when revision = last_revision then ' - Current Version' else '' end ||
    '](revision?id=' || id || ')' as version
    , created_at as date
    , name    
FROM
    revisions, special_revisions
order BY
    revision DESC