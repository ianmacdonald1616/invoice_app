defmodule InvoiceApp.Accounts.AccountUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts_users" do
    field :active,        :boolean
    field :account_admin, :boolean

    belongs_to :account, InvoiceApp.Accounts.Account
    belongs_to :user,    InvoiceApp.Users.User

    timestamps()
  end

  @doc false
  def changeset(account_user, attrs \\ %{}) do
    account_user
    |> cast(attrs, [:user_id, :account_id, :active])
    |> validate_required([:user_id, :account_id])
    |> maybe_make_account_admin(attrs)
  end

  def maybe_make_account_admin(changeset, attrs) do
    if attrs["role"] == "admin" do
      put_change(changeset, :account_admin, true)
    else
      put_change(changeset, :account_admin, false)
    end
  end
end
