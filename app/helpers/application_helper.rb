module ApplicationHelper
  def alert_icon_class(type)
    case type
    when "success"
      "bi-check-circle-fill"
    when "info"
      "bi-info-circle-fill"
    when "warning"
      "bi-exclamation-triangle-fill"
    when "danger"
      "bi-x-circle-fill"
    else
      "bi-bell-fill" # Default icon for other alert types
    end
  end
end

module ApplicationHelper
  def my_invoice_order_path(order)
    "/orders/#{order.id}/invoice"
  end
end
