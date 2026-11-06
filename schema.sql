create table public.clientes (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome          text not null,
  cpf           text,
  data_cadastro date not null default current_date,
  vencimento    date not null,
  os            text not null,
  fotos         jsonb not null default '[]'::jsonb,   -- lista de fotos do exame
  criado_em     timestamptz not null default now()
);

-- Segurança: cada conta só enxerga e altera os próprios clientes
alter table public.clientes enable row level security;

create policy "ver os proprios"      on public.clientes for select using (auth.uid() = user_id);
create policy "inserir os proprios"  on public.clientes for insert with check (auth.uid() = user_id);
create policy "editar os proprios"   on public.clientes for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "excluir os proprios"  on public.clientes for delete using (auth.uid() = user_id);