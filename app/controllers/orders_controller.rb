class OrdersController < ApplicationController
  before_action :set_table, only: [:edit]
  before_action :set_order, only: %i[update destroy edit] # Move set_order after set_table
  before_action :set_tables, only: %i[new create]

  def index
    if params[:table_id]
      @table = Table.find(params[:table_id]) # Get the table for filtering
      @current_orders = @table.orders.where.not(status: 'completed')
      @completed_orders = @table.orders.where(status: 'completed')
    else
      @current_orders = Order.where.not(status: 'completed')
      @completed_orders = Order.where(status: 'completed')
    end
  end

  def new
    @order = Order.new
    @order.order_type = :presencial if @order.order_type.nil?
    @menu_items = MenuItem.where(availability: true)
    @tables = Table.all
  end

  def edit
    @order = Order.find(params[:id])
    @table = @order.table
    @menu_items = MenuItem.where(availability: true).order(:name)
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

  def print_order
    begin
      @order = Order.find(params[:id])
      @order.mark_as_printed

      respond_to do |format|
        format.html
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to orders_path, alert: 'Pedido não encontrado.'
    rescue => e
      logger.error("Error printing order: #{e.message}")
      redirect_to orders_path, alert: 'Ocorreu um erro ao imprimir o pedido.'
    end
  end

  def update
    if @order.update(order_params)
      if params[:order][:status] == "completed"
        @change = @order.calculate_change(params[:order][:amount_paid].to_f)
        flash[:notice] = "Pedido completado! Troco: #{@change}"
      else
        flash[:notice] = "Pedido atualizado com sucesso!"
      end

      if params[:order][:table_id].present?
        redirect_to table_orders_path(@order.table_id)  # Redirect to filtered orders if table_id is present
      else
        redirect_to orders_path
      end
    else
      render :edit
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

  def set_table
    @order = Order.find(params[:id]) # Set @order before trying to use it
    @table = @order.table
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: 'Order not found.'
  end

  def order_params
    params.require(:order).permit(
      :status,
      :table_id,
      :order_type,
      :amount_paid,
      order_items_attributes: [:id, :quantity, :menu_item_id, :_destroy]
    )
  end
end
