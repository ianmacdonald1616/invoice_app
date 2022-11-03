defmodule InvoiceAppWeb.InvoiceView do
  use InvoiceAppWeb, :view

  def invoice_entry(assigns) do
    ~H"""
    <.link patch={Routes.invoice_index_path(@socket, :show_invoice, @current_account.domain, @invoice.id)} class="invoice-card">
      <div class="invoice-entry">
        <div class="invoice-title">
          Invoice No. <%= @invoice.id %>
        </div>
         <div class="updated-at">
          (updated <%= from_now(@invoice.updated_at) %>)
        </div>
        <div class="invoice-entry-info">
          <div style="width: 10%;">
            <div class="invoice-subtitle">
              <%= @invoice.customer.name %>
            </div>
            <div>
              <%= @invoice.customer.email %>
            </div>
          </div>

          <div>
            <div class="invoice-subtitle">Items</div>
            <%= @invoice.item_count %>
          </div>

          <div>
            <div class="invoice-subtitle">Total</div>
            $<%= @invoice.total %> <%= @invoice.currency %>
          </div>

          <div>
            <div class="invoice-subtitle">Due</div>
            <div class="invoice-date"><%= format_date(@invoice.due_date) %></div>
          </div>

          <div>
            <div class="invoice-subtitle">Created</div>
            <div><%= format_date(@invoice.inserted_at) %></div>
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def line_item_form(assigns) do
    ~H"""
    <div class="table-row" style="grid-column: span 3;">
      <.form :let={f}
              for={@line_item_changeset}
              id="edit-item-form"
              phx_submit={@submit_event}
              phx_change="validate-line-item"
              phx_target={@target}
      >
        <div class="form-data">
          <div class="table-cell first-cell body-cell">
            <div>
              <%= text_input f, :name %>
              <%= InvoiceAppWeb.ErrorHelpers.error_tag(f, :name) %>
            </div>
            <div>
              <%= textarea f, :description %>
              <%= InvoiceAppWeb.ErrorHelpers.error_tag(f, :description) %>
            </div>
          </div>
          <div class="table-cell second-cell body-cell">
            <div>
              <%= text_input f, :total %>
              <%= InvoiceAppWeb.ErrorHelpers.error_tag(f, :total) %>
            </div>
          </div>
          <div class="table-cell third-cell body-cell">
            <.form_options id="line-item-options" changeset={@line_item_changeset} {assigns} />
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def form_options(assigns) do
    ~H"""
    <div id={@id}>
      <button type="submit" class="hidden" disabled={!@changeset.valid?} data-form-return></button>
      <a href="#" class="submit-btn" phx-click={submit_form(@id)}>
        <i class="fas fa-save save-icon"></i>
      </a>
      <a href="#" phx-click={@cancel_event} phx-target={@target}>
        <i class="fas fa-window-close cancel-btn"></i>
      </a>
    </div>
    """
  end

  defp submit_form(js \\ %JS{}, id) do
    js
    |> JS.dispatch("click", to: "##{id} [data-form-return]")
  end

  def show_edit_line_item?(%{id: id} = _line_item, %{id: id} = _edit_item), do: true
  def show_edit_line_item?(_line_item, _edit_item), do: false

  def from_now(datetime) do
    case Timex.format(datetime, "{relative}", :relative) do
      {:ok, from_now} ->
        from_now

      {:error, _} ->
        datetime
    end
  end

  def human_duration(minutes) do
    minutes
    |> Timex.Duration.from_minutes()
    |> Timex.Format.Duration.Formatters.Humanized.format
  end

  def format_datetime(datetime) do
    Timex.format!(datetime, "{M}/{D}/{YY} at {h12}:{m}{am}")
  end

  def format_date(date) do
    Timex.format!(date, "{Mshort} {D}, {YYYY}")
  end
end
