defmodule InvoiceApp.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name,   :string
    field :domain, :string
    field :active, :boolean, default: true

    has_many :customers,      InvoiceApp.Customers.Customer
    has_many :invoices,       InvoiceApp.Invoices.Invoice
    has_many :accounts_users, InvoiceApp.Accounts.AccountUser
    many_to_many :users,     InvoiceApp.Users.User, join_through: InvoiceApp.Accounts.AccountUser, unique: true

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :domain])
    |> validate_required([:name, :domain])
    |> validate_format(:domain, ~r/[a-z0-9]+\.[a-z.]+/)
    |> unsafe_validate_unique([:domain], Readyroom.Repo)
  end
end
