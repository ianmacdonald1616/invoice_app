defmodule InvoiceApp.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :email, :string
    field :name,  :string

    belongs_to :account, InvoiceApp.Accounts.Account

    timestamps()
  end

  def changeset_new_customer_fields(customer, attrs) do
    customer
    |> cast(attrs, [:email, :name])
    |> validate_required([:email, :name])
  end

  def edit_changeset(customer) do
    change(customer)
  end

  @doc false
  def changeset(customer, attrs) do
    changeset_new_customer_fields(customer, attrs)
    |> assoc_constraint(:account)
  end
end
