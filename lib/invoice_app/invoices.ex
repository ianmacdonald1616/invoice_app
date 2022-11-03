defmodule InvoiceApp.Invoices do
  @moduledoc """
  The Invoices context.
  """

  import Ecto.Query, warn: false
  alias InvoiceApp.Repo
  alias InvoiceApp.Invoices.Invoice
  alias InvoiceApp.LineItems.LineItem
  alias InvoiceApp.Accounts.Account

  @doc """
  Gets invoices associated with an account
  ## Examples
      iex> get_invoices_for_account!(1)
      [%Invoice{}, ...]
  """
  def get_invoices_for_account(%Account{} = account) do
    account.id
    |> invoices_query()
    |> preload([i, c, u, l], [customer: c, user: u, line_items: l])
    |> Repo.all()
  end

  @doc """
  Gets a single invoice for an account by id
  Raises `Ecto.NoResultsError` if the Invoice does not exist
  ## Examples
      iex> get_invoice!(1)
      %Invoice{}

      iex> get_invoice!(582)
      ** (Ecto.NoResultsError)
  """
  def get_invoice!(_account_id, nil), do: nil
  def get_invoice!(account_id, id) do
    account_id
    |> invoices_query()
    |> preload([i, c, u, l], [customer: c, user: u, line_items: l])
    |> where([i], i.id == ^id)
    |> Repo.one!()
  end

  defp invoices_query(account_id) do
    from(i in Invoice,
      left_join: c in assoc(i, :customer),
      left_join: u in assoc(i, :user),
      left_join: l in assoc(i, :line_items),

      left_join: l_sum in subquery(sum_line_item_totals(account_id)), on: l_sum.invoice_id == i.id,
      left_join: item_count in subquery(count_line_items(account_id)), on: item_count.invoice_id == i.id,

      where: i.account_id == ^account_id,
      order_by: [desc: i.updated_at, desc: l.updated_at],
      select_merge: %{line_items: [l], total: l_sum.total, item_count: item_count.count |> coalesce(0)}
    )
  end

  # Subquery used to sum line item values for each invoice formatted with two decimal places
  defp sum_line_item_totals(account_id) do
    from(l in LineItem,
      left_join: i in assoc(l, :invoice),
      where: i.account_id == ^account_id,
      group_by: l.invoice_id,
      select: %{invoice_id: l.invoice_id, total: fragment("to_char(sum(?), 'FM999999999.00')", l.total)}
    )
  end

  # Subquery used to count line items for each invoice
  defp count_line_items(account_id) do
    from(l in LineItem,
      left_join: i in assoc(l, :invoice),
      where: i.account_id == ^account_id,
      group_by: l.invoice_id,
      select: %{invoice_id: l.invoice_id, count: count(l.id)}
    )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for validating new invoices.
  ## Examples
      iex> change_new_invoice_fields(invoice, attrs)
      %Ecto.Changeset{source: %Invoice{}}
  """
  def change_new_invoice_fields(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.changeset_new_invoice_fields(invoice, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.
  ## Examples
      iex> change_invoice(invoice)
      %Ecto.Changeset{source: %Invoice{}}
  """
  def change_invoice(invoice) do
    Invoice.edit_changeset(invoice)
  end

  @doc """
  Updates an invoice
  ## Examples
      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end
end
