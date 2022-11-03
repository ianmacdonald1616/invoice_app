defmodule InvoiceAppWeb.PageController do
  use InvoiceAppWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      account = InvoiceApp.Accounts.get_account_for_user(conn.assigns.current_user)
      redirect(conn, to: Routes.invoice_index_path(conn, :index, account.domain))
    else
      render(conn, :index, error_message: nil, page_title: "Log in to Parallax Invoice Demo")
    end
  end
end
