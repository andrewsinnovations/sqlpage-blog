SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_object(
            'additional_javascript', JSON('["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]'),
            'additional_javascript_module', JSON('["/admin/settings/template/edit_script"]')
        )
    ) AS properties;

select 'dynamic' as component
    , sqlpage.run_sql('admin/settings/template/.tabs.sql') AS properties;

SELECT
    'text' as component;

select
    5 as size
    , name as contents
FROM
    template
WHERE
    id = $id;

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