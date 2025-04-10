SELECT
    'shell' as component
    , setting_value || ' - Dashboard' as title
    , '/admin/dashboard/posts' as link
    , ' ' as footer
    , 'https://cdn.jsdelivr.net/npm/trumbowyg@2/dist/ui/trumbowyg.min.css' as css
    , 'https://code.jquery.com/jquery-3.7.1.min.js' as javascript
    , 'https://cdn.jsdelivr.net/npm/trumbowyg@2/dist/trumbowyg.min.js' as javascript
    , JSON('{
        "title": "Posts", 
        "icon": "list-details",
        "link": "/admin/dashboard/posts"
    }') as menu_item
    , JSON('{
        "title": "Settings", 
        "icon": "settings",
        "link": "/admin/settings/config"
    }') as menu_item
    , JSON('{   
            "icon": "user"
            ,"title":"User"
            ,"submenu":[
                {
                    "link":"/admin/change_password"
                    ,"title":"Change Password"
                    ,"icon":"lock"
                },
                {
                    "type":"divider"
                },
                {
                    "link":"/admin/end_session"
                    ,"title":"Logout"
                    ,"icon":"logout"
                }
            ]
        }') as menu_item
FROM
    settings
WHERE
    setting_name = 'blog_name'
limit 1;