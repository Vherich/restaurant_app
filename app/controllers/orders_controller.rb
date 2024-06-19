class OrdersController < ApplicationController
  before_action :set_order, only: %i[update destroy]
  before_action :set_tables, only: %i[new create]

  def index
    @orders = Order.all
    @current_orders = Order.current
    @completed_orders = Order.completed.includes(:order_items)
  end

  def new
    @order = Order.new
    @menu_items = MenuItem.where(availability: true)
    @tables = Table.all
  end

  def total
    self.total = order_items.sum { |item| item.menu_item.price * item.quantity }
    save!
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      Order.transaction do
        valid_order_items_attributes = order_params[:order_items_attributes].select { |_, item| item[:quantity].to_i > 0 }
        valid_order_items_attributes.each do |_, item_params|
          @order.order_items.build(item_params.permit(:menu_item_id, :quantity))
        end
      end # End the transaction here
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      @menu_items = MenuItem.where(availability: true)
      @tables = Table.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(status: params[:status])
      redirect_to orders_path, notice: 'Order status updated.'
    else
      redirect_to orders_path, alert: 'Order status update failed.'
    end
  end

  def destroy
    if @order.destroy
      redirect_to orders_path, notice: 'Order deleted successfully.'
    else
      redirect_to orders_path, alert: 'Order could not be deleted.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: 'Order not found.'
  end

  def set_tables
    @tables = Table.all
  end

  def order_params
    params.require(:order).permit(:table_id, :other_permitted_params, order_items_attributes: [:menu_item_id, :quantity])
  end
end
