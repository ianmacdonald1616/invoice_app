defmodule InvoiceAppWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias InvoiceAppWeb.MountHelpers

  def on_mount(:default, params, session, socket) do
    {:cont, MountHelpers.assign_defaults(socket, params, session)}
  end
end
