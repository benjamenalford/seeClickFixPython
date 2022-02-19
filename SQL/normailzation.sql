select distinct status
from "seeClickFixExport";
--build status table
select distinct status into status
from "seeClickFixExport";
select *
from status
ALTER TABLE IF EXISTS public.status
ADD COLUMN id serial;
ALTER TABLE IF EXISTS public.status
ADD PRIMARY KEY (id);
--
select distinct summary into summary
from "seeClickFixExport";
ALTER TABLE IF EXISTS public.summary
ADD COLUMN id serial;
ALTER TABLE IF EXISTS public.summary
ADD PRIMARY KEY (id);
select *
from summary
select *
from "seeClickFixExport"
select id,
	(
		select id
		from status
		where status.status = "seeClickFixExport".status
	) as statusID,
	(
		select id
		from summary
		where summary.summary = "seeClickFixExport".summary
	) as summaryID,
	lat,
	lng,
	address,
	created_at,
	acknowledged_at,
	closed_at into issues
from "seeClickFixExport";
ALTER TABLE IF EXISTS public.issues
ALTER COLUMN id
SET NOT NULL;
ALTER TABLE IF EXISTS public.issues
ALTER COLUMN statusid
SET NOT NULL;
--
ALTER TABLE IF EXISTS public.issues
ALTER COLUMN summaryid
SET NOT NULL;
ALTER TABLE IF EXISTS public.issues
ADD PRIMARY KEY (id);
select *
from issues