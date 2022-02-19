select distinct status from "seeClickFixExport";

--build status table
select distinct status into status from "seeClickFixExport";
select * from status
ALTER TABLE IF EXISTS public.status
    ADD COLUMN id serial;
ALTER TABLE IF EXISTS public.status
    ADD PRIMARY KEY (id);
	
--
select distinct summary into summary from "seeClickFixExport";
ALTER TABLE IF EXISTS public.summary
    ADD COLUMN id serial;
ALTER TABLE IF EXISTS public.summary
    ADD PRIMARY KEY (id);
select * from  summary

select * from "seeClickFixExport"
select 
	id,
	(select id from status where status.status="seeClickFixExport".status) as statusID,
	(select id from summary where summary.summary="seeClickFixExport".summary) as summaryID,
	lat,
	lng,
	address,
	created_at,
	acknowledged_at,
	closed_at
	into issues
from "seeClickFixExport";
ALTER TABLE IF EXISTS public.issues
    ALTER COLUMN id SET NOT NULL;

ALTER TABLE IF EXISTS public.issues
    ALTER COLUMN statusid SET NOT NULL;
--
ALTER TABLE IF EXISTS public.issues
    ALTER COLUMN summaryid SET NOT NULL;
ALTER TABLE IF EXISTS public.issues
    ADD PRIMARY KEY (id);
select * from issues

ALTER TABLE IF EXISTS public.issues
    ADD CONSTRAINT status_fk FOREIGN KEY (statusid)
    REFERENCES public.status (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public.issues
    ADD CONSTRAINT summary_fk FOREIGN KEY (summaryid)
    REFERENCES public.summary (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

create view all_issues as 
select 
issues.id,
	summary,
	status,
	created_at,
	acknowledged_at,
	closed_at
from issues 
inner join summary on summaryid = summary.id
inner join status on statusid = status.id

--use the view
select 
	created_at,
	acknowledged_at,
	acknowledged_at - created_at as time_to_ack,
	closed_at - created_at as time_to_close,
	closed_at - acknowledged_at as time_to_resolve
from all_issues

DROP VIEW public.all_issues;
CREATE OR REPLACE VIEW public.all_issues
    AS
    select 
issues.id,
	summary,
	status,
	created_at,
	acknowledged_at,
	closed_at,
	acknowledged_at - created_at as time_to_ack,
	closed_at - created_at as time_to_close,
	closed_at - acknowledged_at as time_to_resolve
from issues 
inner join summary on summaryid = summary.id
inner join status on statusid = status.id;

select summary,avg(time_to_ack) from all_issues
group by summary

select status,avg(time_to_close) from all_issues
group by status

select status,avg(time_to_resolve) from all_issues
group by status

