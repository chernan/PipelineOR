create table statuses(
id smallint,
name varchar(10),
primary key (id)
);

\copy statuses from 'db/seed_data/statuses.dat'

create table scripts(
id serial,
cmd text, -- without arguments
label text,
description text,
previous_script_ids text,
next_script_ids text,
primary key (id)
);

create table pfiles(
id serial,
name text,
script_id int references scripts,
primary key (id)
);

create table input_outputs(
id serial,
script_id int references scripts,
is_input bool,
argument_pos int, --optional
pfile_id int references pfiles,
primary key (id)
);

create table pipelines(
id serial,
name text,
"key" char(20),
email text,
status_id int references statuses,
primary key (id)
);

create table pipeline_items(
id serial,
script_id int references scripts,
pipeline_id int references pipelines,
exec_order smallint,
status_id int references statuses,
created_at timestamp,
primary key (id)
);

