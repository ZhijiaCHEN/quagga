drop table rib;
create table rib(
	rid serial primary key,
	prefix varchar not null,
	local_preference smallint default 100,
	metric integer,
	next_hop varchar not null,
	as_path varchar,
	router varchar
);

INSERT INTO rib (prefix, local_preference, metric, next_hop, as_path, router) VALUES('103.1.0.0/16', 100, 0, '103.1.0.0', '', '103.1.0.0') returning rid;