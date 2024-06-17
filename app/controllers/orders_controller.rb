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
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to orders_path, notice: 'Order created successfully.'
    else
      render :new, status: :unprocessable_entity  # Use 422 status for invalid form submissions
    end
  end

  def update
    if @order.update(status: params[:status])
      redirect_to orders_path, notice: 'Order status updated.'
    else
      redirect_to orders_path, alert: 'Order status update failed.'  # Add error handling for updates
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
    params.require(:order).permit(:status, :table_id)  # Exclude total, which should be calculated
  end
end
