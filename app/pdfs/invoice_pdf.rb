class InvoicePdf < Prawn::Document
  def initialize(order, customer_name, customer_cpf)
    super()
    @order = order
    @customer_name = customer_name
    @customer_cpf = customer_cpf
    generate_invoice
  end

  def generate_invoice
    # Header
    text "Nota Fiscal", size: 20, style: :bold, align: :center
    move_down 10
    text "[Nome da Empresa]", align: :center
    text "CNPJ: [CNPJ da Empresa]", align: :center
    text "Endereço: [Endereço da Empresa]", align: :center

    # Customer details
    move_down 20
    text "Dados do Cliente:", style: :bold
    text "Nome: #{@customer_name}"
    text "CPF: #{@customer_cpf}"

    # Order items
    move_down 20
    text "Itens Consumidos:", style: :bold
    table order_items_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [300, 100, 100, 100]
    end

    # Total
    move_down 20
    text "Total: #{number_to_currency(@order.total)}", align: :right
  end

  def order_items_rows
    [['Item', 'Quantidade', 'Preço Unitário', 'Total']] +
      @order.order_items.map do |item|
        [item.menu_item.name, item.quantity, number_to_currency(item.menu_item.price), number_to_currency(item.total_price)]
      end +
      @order.dishes.map do |dish|
        ["Prato por quilo (R$ #{dish.price.to_f})", '-', '-', number_to_currency(dish.price.to_f)]
      end
  end
end
