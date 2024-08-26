class OrdersController < ApplicationController
  before_action :set_table, only: [:edit]
  before_action :set_order, only: %i[update destroy edit show print_order]
  before_action :set_tables_and_menu_items, only: %i[new create edit]

  def index
    if params[:table_id]
      @table = Table.find(params[:table_id])
      @current_orders = @table.orders.includes(:dishes).where.not(status: 'completed')
      @completed_orders = @table.orders.includes(:dishes).where(status: 'completed')
    else
      @current_orders = Order.includes(:dishes).where.not(status: 'completed')
      @completed_orders = Order.includes(:dishes).where(status: 'completed')
    end

    if params[:order_id].present?
      begin
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        # Handle the case where the order is not found
        respond_to do |format|
          format.html {
            flash[:alert] = "Order not found."
            redirect_to orders_path
          }
          format.js {
            render js: "alert('Order not found.'); $('#customerDetailsModal').modal('hide');"
          }
        end
        return # Stop further processing if the order is not found
      end
    end

    respond_to do |format|
      format.html # Render the normal index view
      format.js {
        # Render the modal partial if the request is an AJAX request
        render partial: 'customer_details_modal', locals: { order: @order }
      }
    end
  end

  def new
    @order = Order.new
    @order.order_type = :presencial if @order.order_type.nil?
    @order.dishes.build(dish_type: :prato_por_quilo) # Initialize one by default
  end

  def edit
    @order = Order.find(params[:id])
    @table = @order.table
    @menu_items = MenuItem.where(availability: true).order(:name)
  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.js { render partial: 'customer_details_modal', locals: { order: @order }, layout: false }
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      create_prato_por_quilo_dish
      create_order_items
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
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
      handle_order_completion
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

  def invoice
    @order = Order.find(params[:id])
    @customer_name = params[:customer_name]
    @customer_cpf = params[:customer_cpf]

    # Fetch additional data if needed, such as:
    # - Customer information (if not directly associated with the order)
    # - Any tax or discount calculations
    # - ...

    respond_to do |format|
      format.js { render partial: 'customer_details_modal', locals: { order: @order } } # Render the modal partial
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
    @order = Order.find(params[:id])
  end

  def set_tables_and_menu_items
    @tables = Table.all
    @menu_items = MenuItem.where(availability: true).order(:name)
  end

  def order_params
    params.require(:order).permit(
      :status,
      :table_id,
      :order_type,
      :amount_paid,
      :observations,
      dishes_attributes: [:id, :price, :menu_item_id, :_destroy], # Add menu_item_id
      order_items_attributes: [:id, :quantity, :menu_item_id, :_destroy]
    )
  end

  def create_prato_por_quilo_dish
    if params[:prato_por_quilo_price].present? && params[:prato_por_quilo_price].to_f > 0
      @order.dishes.create(price: params[:prato_por_quilo_price], dish_type: :prato_por_quilo)
    end
  end

  def create_order_items
    valid_order_items_attributes = order_params[:order_items_attributes].select { |_, item| item[:quantity].to_i > 0 }
    valid_order_items_attributes.each do |_, item_params|
      @order.order_items.build(item_params.permit(:menu_item_id, :quantity))
    end
  end

  def handle_order_completion
    if params[:order][:status] == "completed"
      if params[:order][:amount_paid].present?
        @change = @order.calculate_change(params[:order][:amount_paid].to_f)
        flash[:notice] = "Pedido completado! Troco: #{@change}"
      else
        flash[:alert] = "Por favor, insira a quantia paga para calcular o troco."
        return redirect_to edit_order_path(@order)
      end
    else
      flash[:notice] = "Pedido atualizado com sucesso!"
    end

    redirect_to params[:order][:table_id].present? ? table_orders_path(@order.table_id) : orders_path
  end
end
