defmodule InvoiceAppWeb.InvoiceLive.Show do
  use Phoenix.LiveComponent

  alias InvoiceAppWeb.Router.Helpers, as: Routes
  alias InvoiceApp.Invoices
  alias InvoiceApp.LineItems
  alias InvoiceApp.LineItems.LineItem
  alias InvoiceApp.Customers

  import InvoiceAppWeb.LiveHelpers

  require Logger

  def render(assigns), do: InvoiceAppWeb.InvoiceView.render("show.html", assigns)

  def mount(socket) do
    Logger.info("MOUNTING: #{__MODULE__}")
    {:ok, socket}
  end

  def update(assigns, socket) do
    %{invoice: i} = assigns
    socket =
      socket
      |> assign(assigns)
      |> assign(:manage_customer, false)
      |> assign(:customer_changeset, Customers.change_customer(i.customer))
      |> assign(:line_item, nil)
      |> assign(:line_item_changeset, nil)
      |> assign(:new_line_item_changeset, LineItems.change_new_line_item_fields(%LineItem{}))
      |> assign(:manage_new_line_item, false)
      |> assign(:manage_invoice, false)
      |> assign(:invoice_changeset, Invoices.change_invoice(i))

    {:ok, socket}
  end

  def handle_event("toggle-due-date", _params, socket) do
    {:noreply, update(socket, :manage_invoice, &(!&1))}
  end

  def handle_event("update-invoice", %{"invoice" => invoice_attrs}, socket) do
    %{invoice: i, current_account: a} = socket.assigns
    case Invoices.update_invoice(i, invoice_attrs) do
      {:ok, invoice} ->
        Logger.info("Successfully updated invoice. Account: #{a.domain}, Invoice: #{i.id}")
        broadcast_changed_invoice(a.domain, invoice.id)
        {:noreply, push_patch(socket, to: Routes.invoice_index_path(socket, :show_invoice, a.domain, i.id))}
      {:error, changeset} ->
        Logger.warn("Unable to update invoice: #{inspect(changeset)}")
        {:noreply, assign(socket, :invoice_changeset, changeset)}
    end
  end
  # `handle_event` for CUSTOMER EDITS
  def handle_event("toggle-edit-customer", _params, socket) do
    {:noreply, update(socket, :manage_customer, &(!&1))}
  end

  def handle_event("validate-customer", %{"customer" => customer_params}, socket) do
    %{invoice: %{customer: customer}} = socket.assigns
    changeset =
      customer
      |> Customers.change_edit_customer_fields(customer_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :customer_changeset, changeset)}
  end

  def handle_event("update-customer", %{"customer" => customer_params}, socket) do
    %{invoice: %{customer: customer} = invoice, current_account: a} = socket.assigns
    case Customers.update_customer(customer, customer_params) do
      {:ok, customer} ->
        Logger.info("Successfully updated customer. Account: #{a.domain}, Customer: #{customer.id}")
        broadcast_changed_invoice(a.domain, invoice.id)
        {:noreply, push_patch(socket, to: Routes.invoice_index_path(socket, :show_invoice, a.domain, invoice.id))}
      {:error, changeset} ->
        Logger.warn("Unable to update customer: #{inspect(changeset)}")
        {:noreply, assign(socket, :customer_changeset, changeset)}
    end
  end

  # `handle_event` for LINE ITEM EDITS
  def handle_event("edit-line-item", %{"item-id" => item_id}, socket) do
    line_item = LineItems.get_line_item(item_id)
    socket =
      socket
      |> assign(:line_item, line_item)
      |> assign(:line_item_changeset, LineItems.change_line_item(line_item))

    IO.inspect(socket.assigns.line_item_changeset)
    {:noreply, socket}
  end

  def handle_event("cancel-edit-line-item", _params, socket) do
    socket=
      socket
      |> assign(:line_item, nil)
      |> assign(:line_item_changeset, nil)
    {:noreply, socket}
  end

  def handle_event("validate-line-item", %{"line_item" => item_params}, socket) do
    changeset =
      %LineItem{}
      |> LineItems.change_edit_line_item_fields(item_params)
      |> Map.put(:action, :insert)
    IO.inspect(changeset)
    {:noreply, assign(socket, :line_item_changeset, changeset)}
  end

  def handle_event("update-line-item", %{"line_item" => item_params}, socket) do
    %{line_item: line_item, invoice: i, current_account: a} = socket.assigns
    case LineItems.update_line_item(line_item, item_params) do
      {:ok, line_item} ->
        Logger.info("UPDATED line item - #{line_item.id}")
        broadcast_changed_invoice(a.domain, i.id)
        {:noreply, push_patch(socket, to: Routes.invoice_index_path(socket, :show_invoice, a.domain, i.id))}
      {:error, changeset} ->
        Logger.warn("Unable to update line item - #{inspect(changeset)}")
        {:noreply, assign(socket, :line_item_changeset, changeset)}
    end
  end

  # `handle_event` for NEW LINE ITEMS
  def handle_event("toggle-new-line-item", _params, socket) do
    socket =
      socket
      |> update(:manage_new_line_item, &(!&1))
      |> assign(:line_item_changeset, LineItems.change_new_line_item_fields(%LineItem{}))

    {:noreply, socket}
  end

  def handle_event("create-line-item", %{"line_item" => item_params} = _params, socket) do
    %{invoice: i, current_user: u, current_account: a} = socket.assigns
    case LineItems.create_line_item(item_params, i.id, u.id) do
      {:ok, line_item} ->
        Logger.info("Successfully created new line item. Account: #{a.domain} Invoice: #{i.id} Line Item: #{line_item.id}")
        broadcast_changed_invoice(a.domain, i.id)
        {:noreply, push_patch(socket, to: Routes.invoice_index_path(socket, :show_invoice, a.domain, i.id))}

      {:error, changeset} ->
        Logger.warn("Unable to create new line item. #{inspect(changeset)}")
        {:noreply, assign(socket, :line_item_changeset, changeset)}
    end
  end

  def handle_event("delete-line-item", %{"item-id" => item_id} = _params, socket) do
    %{current_account: a, invoice: i} = socket.assigns
    line_item = LineItems.get_line_item(item_id)
    case LineItems.delete_line_item(line_item) do
      {:ok, _line_item} ->
        Logger.info("Successfully deleted line item - Account: #{a.domain}, Item: #{line_item.id}")
        broadcast_changed_invoice(a.domain, i.id)
        {:noreply, push_patch(socket, to: Routes.invoice_index_path(socket, :show_invoice, a.domain, i.id))}

      {:error, changeset} ->
        Logger.warn("Unable to delete line item - #{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
