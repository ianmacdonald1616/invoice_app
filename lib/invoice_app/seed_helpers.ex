defmodule InvoiceApp.SeedHelpers do
  alias InvoiceApp.Repo
  alias InvoiceApp.Users.User
  alias InvoiceApp.Accounts.Account
  alias InvoiceApp.Accounts.AccountUser
  alias InvoiceApp.Customers.Customer
  alias InvoiceApp.Invoices.Invoice
  alias InvoiceApp.LineItems.LineItem

  def add_account(name, domain) do
    Repo.insert!(%Account{name: name, domain: domain})
  end

  def add_user_and_join_account(account, %{name: name, email: email, is_admin: admin?} = _user) do
    add_user(name, email)
    |> join_account_to_user(account, admin?)
  end

  defp add_user(name, email) do
    user_params =
      %{
        name: name,
        email: email,
        password: "password00",
        password_confirmation: "password00",
        confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      }
    User.registration_changeset(%User{}, user_params)
    |> Repo.insert!()
  end

  defp join_account_to_user(user, account, act_admin?) do
    %AccountUser{account_id: account.id, user_id: user.id, account_admin: act_admin?}
    |> Repo.insert!()
  end

  def add_customer(account, name, email) do
    Customer.changeset(%Customer{}, %{account_id: account.id, name: name, email: email})
    |> Repo.insert!()
  end

  def add_invoice_and_line_items(account, user_count, customer_count, line_items) do
    invoice =
      Invoice.changeset(%Invoice{},
        %{
          account_id: account.id,
          user_id: Enum.random(1..user_count),
          customer_id: Enum.random(1..customer_count),
          due_date: generate_random_due_date(60),
          currency: "USDC"
        }
      )
      |> Repo.insert!()

    Enum.each(line_items, &add_line_items(invoice, &1))
  end

  defp add_line_items(invoice, line_item) do
    LineItem.changeset(%LineItem{}, Map.merge(line_item, %{invoice_id: invoice.id, user_id: invoice.user_id}))
    |> Repo.insert!()
  end

  defp generate_random_due_date(max_offset) do
    Date.utc_today()
    |> Date.add(Enum.random(1..max_offset))
  end
end
