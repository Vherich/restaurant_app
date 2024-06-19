class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[edit update destroy]

  def index
    if params[:query].present?
      @menu_items = MenuItem.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @menu_items = MenuItem.all.order(:name)
    end
    respond_to do |format|
      format.html # You might not need this if you're only using JSON
      format.json { render json: @menu_items }
    end
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to menu_items_path, notice: 'Menu item added successfully.'
    else
      render :new, status: :unprocessable_entity  # Use 422 status for invalid form submissions
    end
  end

  def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to menu_items_path, notice: 'Menu item updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to menu_items_path, notice: 'Menu item removed successfully.'
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(
      :name,
      :price,
      :description,
      :availability,
    )
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
end
