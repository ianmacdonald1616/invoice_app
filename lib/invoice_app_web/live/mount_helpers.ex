defmodule InvoiceAppWeb.MountHelpers do
  import Phoenix.Component
  import Phoenix.LiveView

  alias InvoiceAppWeb.Router.Helpers, as: Routes
  alias InvoiceAppWeb.Exceptions.NoSession
  alias InvoiceApp.Users

  require Logger

  def assign_defaults(socket, params, session) do
    socket
    |> assign_current_user(session)
    |> assign_current_account(params)
    |> ensure_domain_access()
  end

  defp assign_current_user(socket, session) do
    socket = assign_new(socket, :current_user, fn ->
      Users.get_user_by_session_token(session["user_token"])
    end)

    if is_nil(socket.assigns.current_user) do
      Logger.info("LiveView session was terminated by user or admin.")
      raise NoSession
    else
      socket
    end
  end

  defp assign_current_account(socket, params) do
    assign_new(socket, :current_account, fn ->
      user   = socket.assigns.current_user
      domain = params["domain"]
      Users.account_if_member(user, domain)
    end)
  end

  defp ensure_domain_access(socket) do
    cond do
      is_nil(socket.assigns.current_account) ->
        socket
        |> push_redirect(to: Routes.page_path(socket, :index))

      true ->
        socket
    end
  end
end
