defmodule InvoiceAppWeb.Exceptions.NoSession do
  defexception message: "No session exists for supplied user token."
end
