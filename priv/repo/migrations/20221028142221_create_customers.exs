defmodule InvoiceApp.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string, null: false
      add :name,  :string, null: false

      add :account_id, references(:accounts, on_delete: :delete_all)
      
      timestamps()
    end
  end
end
