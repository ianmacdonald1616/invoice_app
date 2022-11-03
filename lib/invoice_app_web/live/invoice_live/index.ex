defmodule InvoiceAppWeb.InvoiceLive.Index do
  use Phoenix.LiveView
  alias InvoiceApp.Users
  alias InvoiceApp.Invoices
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    Logger.info("MOUNTING #{__MODULE__}.")
    %{current_account: a} = socket.assigns
    socket =
      socket
      |> assign(:invoices, Invoices.get_invoices_for_account(a))

    if connected?(socket) do
      Phoenix.PubSub.subscribe(InvoiceApp.PubSub, a.domain)
    end

    {:ok, socket}
  end

  def render(assigns), do: InvoiceAppWeb.InvoiceView.render("index.html", assigns)

  def handle_params(%{"invoice_id" => invoice_id}, _url, socket) do
    %{current_account: a} = socket.assigns
    {:noreply, assign(socket, :invoice, Invoices.get_invoice!(a.id, invoice_id))}
  end
  def handle_params(_params, _url, socket), do: {:noreply, socket}

  # Incoming sends
  # Invoice was updated by the local OR remote user and we are currently showing/editing that invoice.
  def handle_info(%{invoice_altered: %{invoice: invoice_id}}, %{assigns: %{invoice: %{id: invoice_id}}} = socket) do
    %{current_account: a} = socket.assigns
    socket =
      socket
      |> assign(:invoices, Invoices.get_invoices_for_account(a))
      |> assign(:invoice, Invoices.get_invoice!(a.id, invoice_id))

    {:noreply, socket}
  end

  # Invoice was update by remote user and we are not currently showing/editing that invoice
  def handle_event(%{invoice_altered: _msg}, socket) do
    %{current_account: a} = socket.assigns
    {:noreply, assign(socket, :invoices, Invoices.get_invoices_for_account(a))}
  end
end
