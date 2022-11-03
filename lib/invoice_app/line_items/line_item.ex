defmodule InvoiceApp.LineItems.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "line_items" do
    field :name,        :string
    field :description, :string
    field :total,       :decimal

    belongs_to :invoice, InvoiceApp.Invoices.Invoice
    belongs_to :user,    InvoiceApp.Users.User

    timestamps()
  end

  @name_length 255

  def changeset_new_line_item_fields(line_item, attrs \\ %{}) do
    line_item
    |> cast(attrs, [:name, :description, :total])
    |> validate_required([:name, :description, :total])
    |> validate_length(:name, max: @name_length)
  end

  def edit_changeset(line_item) do
    change(line_item)
  end

  @doc false
  def changeset(line_item, attrs) do
    changeset_new_line_item_fields(line_item, attrs)
    |> cast(attrs, [:invoice_id, :user_id])
    |> assoc_constraint(:invoice)
    |> assoc_constraint(:user)
  end
end
