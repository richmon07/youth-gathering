-- Run this once in Supabase: SQL Editor > New query > Run
create table rsvps(user_id uuid primary key default auth.uid(), name text not null check(char_length(name) between 1 and 60), status text not null check(status in('going','maybe','no')), created_at timestamptz default now());
create table wall(id bigint generated always as identity primary key, user_id uuid default auth.uid(), name text not null check(char_length(name) between 1 and 60), text text not null check(char_length(text) between 1 and 500), created_at timestamptz default now());
create table joins(id bigint generated always as identity primary key, user_id uuid default auth.uid(), name text not null check(char_length(name) between 1 and 60), contact text check(char_length(contact)<=120), msg text check(char_length(msg)<=1000), created_at timestamptz default now());
create table messages(id bigint generated always as identity primary key, user_id uuid default auth.uid(), name text not null check(char_length(name) between 1 and 60), msg text not null check(char_length(msg) between 1 and 1000), created_at timestamptz default now());
alter table rsvps enable row level security; alter table wall enable row level security; alter table joins enable row level security; alter table messages enable row level security;
-- admin = a signed-in (non-anonymous) account that you create yourself
create function is_admin() returns boolean language sql stable as $$ select auth.role()='authenticated' and coalesce((auth.jwt()->>'is_anonymous')::boolean,false)=false $$;
create policy "read" on rsvps for select using(true);
create policy "own insert" on rsvps for insert to authenticated with check(user_id=auth.uid());
create policy "own update" on rsvps for update to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "own or admin delete" on rsvps for delete to authenticated using(user_id=auth.uid() or is_admin());
create policy "read" on wall for select using(true);
create policy "own insert" on wall for insert to authenticated with check(user_id=auth.uid());
create policy "own or admin delete" on wall for delete to authenticated using(user_id=auth.uid() or is_admin());
create policy "send" on joins for insert to authenticated with check(user_id=auth.uid());
create policy "admin read" on joins for select to authenticated using(is_admin());
create policy "admin delete" on joins for delete to authenticated using(is_admin());
create policy "send" on messages for insert to authenticated with check(user_id=auth.uid());
create policy "admin read" on messages for select to authenticated using(is_admin());
create policy "admin delete" on messages for delete to authenticated using(is_admin());
-- live updates
alter publication supabase_realtime add table rsvps, wall, joins, messages;
