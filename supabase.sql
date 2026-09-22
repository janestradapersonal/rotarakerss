-- ==========================================================
-- ROTARACT ATTENDANCE
-- DATABASE
-- ==========================================================


-- EXTENSIÓ PER GENERAR UUIDS

create extension if not exists pgcrypto;


-- ==========================================================
-- MEMBRES
-- ==========================================================

create table if not exists public.members (

  id uuid
    primary key
    default gen_random_uuid(),

  name text
    not null,

  active boolean
    not null
    default true,

  created_at timestamptz
    not null
    default now()

);


-- ==========================================================
-- REUNIONS
-- ==========================================================

create table if not exists public.meetings (

  id uuid
    primary key
    default gen_random_uuid(),

  date date
    not null,

  active boolean
    not null
    default false,

  created_at timestamptz
    not null
    default now()

);


-- ==========================================================
-- ASSISTÈNCIES
-- ==========================================================

create table if not exists public.attendance (

  id uuid
    primary key
    default gen_random_uuid(),

  member_id uuid
    not null
    references public.members(id)
    on delete cascade,

  meeting_id uuid
    not null
    references public.meetings(id)
    on delete cascade,

  checked_in_at timestamptz
    not null
    default now(),

  constraint unique_member_meeting
    unique (
      member_id,
      meeting_id
    )

);


-- ==========================================================
-- ROW LEVEL SECURITY
-- ==========================================================

alter table public.members
enable row level security;

alter table public.meetings
enable row level security;

alter table public.attendance
enable row level security;


-- ==========================================================
-- MEMBRES
-- ==========================================================

drop policy if exists
"public_read_active_members"
on public.members;


create policy
"public_read_active_members"

on public.members

for select

to anon

using (
  active = true
);


-- ADMIN

drop policy if exists
"authenticated_manage_members"
on public.members;


create policy
"authenticated_manage_members"

on public.members

for all

to authenticated

using (true)

with check (true);


-- ==========================================================
-- REUNIONS
-- ==========================================================

drop policy if exists
"public_read_meetings"
on public.meetings;


create policy
"public_read_meetings"

on public.meetings

for select

to anon

using (true);


drop policy if exists
"authenticated_manage_meetings"
on public.meetings;


create policy
"authenticated_manage_meetings"

on public.meetings

for all

to authenticated

using (true)

with check (true);


-- ==========================================================
-- ASSISTÈNCIES
-- ==========================================================


-- Els usuaris poden consultar
-- les assistències.

drop policy if exists
"public_read_attendance"
on public.attendance;


create policy
"public_read_attendance"

on public.attendance

for select

to anon

using (true);


-- Els usuaris poden registrar
-- una assistència.

drop policy if exists
"public_insert_attendance"
on public.attendance;


create policy
"public_insert_attendance"

on public.attendance

for insert

to anon

with check (true);


-- L'administrador pot modificar
-- assistències.

drop policy if exists
"authenticated_manage_attendance"
on public.attendance;


create policy
"authenticated_manage_attendance"

on public.attendance

for all

to authenticated

using (true)

with check (true);


-- ==========================================================
-- MEMBRES DE PROVA
-- ==========================================================

insert into public.members (name)

select 'Jan Estrada'
where not exists (
  select 1
  from public.members
  where name = 'Jan Estrada'
);


insert into public.members (name)

select 'Joan García'
where not exists (
  select 1
  from public.members
  where name = 'Joan García'
);


insert into public.members (name)

select 'Júlia Martínez'
where not exists (
  select 1
  from public.members
  where name = 'Júlia Martínez'
);


insert into public.members (name)

select 'Marc López'
where not exists (
  select 1
  from public.members
  where name = 'Marc López'
);


insert into public.members (name)

select 'Anna Puig'
where not exists (
  select 1
  from public.members
  where name = 'Anna Puig'
);


insert into public.members (name)

select 'Laia Ferrer'
where not exists (
  select 1
  from public.members
  where name = 'Laia Ferrer'
);


insert into public.members (name)

select 'Pau Soler'
where not exists (
  select 1
  from public.members
  where name = 'Pau Soler'
);


insert into public.members (name)

select 'Maria Costa'
where not exists (
  select 1
  from public.members
  where name = 'Maria Costa'
);