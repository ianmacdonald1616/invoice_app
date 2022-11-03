defmodule InvoiceApp.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :due_date, :date, null: false
      add :currency, :string, null: false

      add :account_id,  references(:accounts, on_delete: :delete_all), null: false
      add :user_id,     references(:users)
      add :customer_id, references(:customers, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
