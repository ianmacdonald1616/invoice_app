defmodule InvoiceApp.LineItems do
  @moduledoc """
  The LineItems context.
  """

  import Ecto.Query, warn: false
  alias InvoiceApp.Repo
  alias InvoiceApp.Invoices.Invoice
  alias InvoiceApp.LineItems.LineItem
  alias InvoiceApp.Accounts.Account

  def get_line_item(item_id) do
    from(l in LineItem,
      where: l.id == ^item_id
    ) |> Repo.one!()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking line item changes.
  ## Examples
      iex> change_line_item(line_item)
      %Ecto.Changeset{source: %LineItem{}}
  """
  def change_line_item(line_item) do
    LineItem.edit_changeset(line_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for validating new line items.
  ## Examples
      iex> change_new_line_item_fields(line_item, attrs)
      %Ecto.Changeset{source: %LineItem{}}
  """
  def change_new_line_item_fields(%LineItem{} = line_item, attrs \\ %{}) do
    LineItem.changeset_new_line_item_fields(line_item, attrs)
  end

  def change_edit_line_item_fields(line_item, attrs \\ %{}) do
    LineItem.changeset(line_item, attrs)
  end

  @doc """
  Updates a line item
  ## Examples
      iex> update_line_item(line_item, %{field: new_value})
      {:ok, %LineItem{}}

      iex> update_line_item(line_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_line_item(%LineItem{} = line_item, attrs \\ %{}) do
    line_item
    |> LineItem.changeset(attrs)
    |> Repo.update()
  end

  def create_line_item(attrs \\ %{}, invoice_id, user_id) do
    LineItem.changeset(%LineItem{}, Map.merge(attrs, %{"invoice_id" => invoice_id, "user_id" => user_id}))
    |> Repo.insert()
  end

  def delete_line_item(%LineItem{} = line_item) do
    Repo.delete(line_item)
  end
end
