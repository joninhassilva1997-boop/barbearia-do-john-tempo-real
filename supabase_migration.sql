-- Migração V1 do app de gestão da Barbearia do John
-- Execute no SQL Editor do mesmo projeto Supabase usado pelo site.

alter table public.bookings
  add column if not exists amount numeric(10,2),
  add column if not exists payment_method text,
  add column if not exists paid_at timestamptz;

update public.bookings set amount = case service
  when 'Corte' then 25
  when 'Barba' then 10
  when 'Corte + Barba' then 35
  when 'Luzes' then 80
  when 'Selagem' then 60
  when 'Alisamento' then 50
  when 'Platinado' then 90
  when 'Acabamento' then 10
  when 'Consultoria de estilo' then 0
  else 0 end
where amount is null;

create index if not exists bookings_status_date_idx on public.bookings(status, booking_date);

-- Realtime: no painel do Supabase, confirme que public.bookings está na publicação supabase_realtime.
-- Isso permite que o app receba novos agendamentos enquanto estiver aberto.
