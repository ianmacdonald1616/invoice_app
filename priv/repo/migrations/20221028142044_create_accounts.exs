defmodule InvoiceApp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name,   :string,  null: false
      add :domain, :string,  null: false
      add :active, :boolean, null: false, default: true

      timestamps()
    end

    create unique_index(:accounts, [:domain])
  end
end
