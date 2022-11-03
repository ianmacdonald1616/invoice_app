defmodule InvoiceAppWeb.LiveHelpers do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def broadcast_changed_invoice(channel, invoice_id) do
    Phoenix.PubSub.broadcast(
      InvoiceApp.PubSub,
      channel,
      %{invoice_altered: %{invoice: invoice_id}}
    )
  end

  def modal(assigns) do
    ~H"""
    <div id={@id} class="admin-modal phx-modal fade-in" tabindex="-1">
      <div
        id={"#{@id}-container"}
        class="modal-dialog modal-lg fade-in-scale"
        phx-click-away={hide_modal(@id)}
        phx-window-keydown={hide_modal(@id)}
        phx-key="escape"
      >
        <div class="phx-modal-content">
          <.link patch={@return_to} class="hidden" data-modal-return></.link>
          <a href="#" class="close phx-modal-close" phx-click={hide_modal(@id)}>&times;</a>
          <.live_component module={@component} {assigns} />
        </div>
      </div>
    </div>
    """
  end

  def dialog_modal(assigns) do
    position = css_position(assigns.direction || "south")

    assigns =
      assigns
      |> assign_new(:panel_class, fn -> nil end)
      |> assign(:position, position)

    ~H"""
    <div class="position-relative" >
      <div class={"options-panel #{@panel_class}"}
          style={@position}
          phx-capture-click={@click_event}
          phx-window-keydown={@click_event}
          phx-key="escape"
          phx-target={@target}
          phx-page-loading>

        <div class="panel-header">
          <span class="panel-header=text"><%= render_slot(@header) %></span>
          <button type="button"
                  class="simple-close"
                  phx-click={@click_event}
                  phx-target={@target} >
            <span>&times;</span>
          </button>
        </div>
        <div class="panel-body">
          <div class="btn-group-vertical">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp css_position(direction) do
    case direction do
      "north" -> "top: .5rem;"
      "east"  -> "left: 30%;"
      "south" -> "top: 2rem;"
      "west"  -> "right: 102%;"
      _       ->  "top: 2rem;"
    end
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}", time: 100, transition: "fade-out")
    |> JS.hide(to: "##{id}-containter", time: 100, transition: "fade-out-scale")
    |> JS.dispatch("click", to: "##{id} [data-modal-return]")
  end
end
