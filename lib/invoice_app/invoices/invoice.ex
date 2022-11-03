defmodule InvoiceApp.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :due_date,   :date
    field :currency,   :string, default: "USDC"
    field :total,      :decimal, virtual: true
    field :item_count, :integer, virtual: true

    belongs_to :account,  InvoiceApp.Accounts.Account
    belongs_to :user,     InvoiceApp.Users.User
    belongs_to :customer, InvoiceApp.Customers.Customer
    has_many   :line_items, InvoiceApp.LineItems.LineItem

    timestamps()
  end

  def changeset_new_invoice_fields(invoice, attrs) do
    invoice
    |> cast(attrs, [:due_date, :currency])
    |> validate_required([:due_date, :currency])
  end

  def edit_changeset(invoice) do
    change(invoice)
  end

  @doc false
  def changeset(invoice, attrs) do
    changeset_new_invoice_fields(invoice, attrs)
    |> cast(attrs, [:account_id, :user_id, :customer_id])
    |> assoc_constraint(:account)
    |> assoc_constraint(:user)
    |> assoc_constraint(:customer)
  end
end
