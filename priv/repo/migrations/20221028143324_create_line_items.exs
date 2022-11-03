defmodule InvoiceApp.Repo.Migrations.CreateLineItems do
  use Ecto.Migration

  def change do
    create table(:line_items) do
      add :name,        :string, null: false
      add :description, :text, null: false
      add :total,       :decimal, null: false

      add :invoice_id, references(:invoices, on_delete: :delete_all), null: false
      add :user_id,    references(:users)

      timestamps()
    end
  end
end
