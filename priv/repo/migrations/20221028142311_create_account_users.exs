defmodule InvoiceApp.Repo.Migrations.CreateAccountUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :account_id, references(:accounts)
      add :user_id,    references(:users)

      add :active,        :boolean, null: false, default: true
      add :account_admin, :boolean, null: false, default: false
      
      timestamps()
    end

    create unique_index(:accounts_users, [:account_id, :user_id])
  end
end
