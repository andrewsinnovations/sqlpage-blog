create table uploaded_files (
    id integer primary key autoincrement,
    path text not null,
    contents blob not null,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp
)