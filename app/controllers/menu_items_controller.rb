class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[edit update destroy]

  def index
    @menu_items = MenuItem.all
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

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to menu_items_path, alert: 'Menu item not found.'
  end

  def menu_item_params
    params.require(:menu_item).permit(
      :name,
      :price,
      :description,
      :availability,
      :category # Assuming you have a category field
    )
  end
end
