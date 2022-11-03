defmodule InvoiceApp.Customers do
  @moduledoc """
  The Customers context.
  """

  import Ecto.Query, warn: false
  alias InvoiceApp.Repo
  alias InvoiceApp.Customers.Customer
  alias InvoiceApp.Accounts.Account

  @doc """
  Returns list of customers for a given account
  ## Examples
      iex> list_account_customers(%Account{} = account)
      [%Customer{}, ...]
  """
  def list_account_customers(%Account{} = account) do
    from(c in Customer,
      where: c.account_id == ^account.id
    ) |> Repo.all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for validating new customers.
  ## Examples
      iex> change_new_customer_fields(customer, attrs)
      %Ecto.Changeset{source: %Customer{}}
  """
  def change_new_customer_fields(%Customer{} = customer, attrs \\ %{}) do
    Customer.changeset_new_customer_fields(customer, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer changes.
  ## Examples
      iex> change_customer(customer)
      %Ecto.Changeset{source: %Customer{}}
  """
  def change_customer(%Customer{} = customer) do
    Customer.edit_changeset(customer)
  end

  def change_edit_customer_fields(%Customer{} = customer, attrs \\ %{}) do
    Customer.changeset(customer, attrs)
  end

  @doc """
  Updates a customer
  ## Examples
      iex> update_customer(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_customer(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_customer(%Customer{} = customer, attrs \\ %{}) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end
end
