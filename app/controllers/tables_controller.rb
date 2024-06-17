class TablesController < ApplicationController
  before_action :set_table, only: %i[edit update destroy]

  def index
    @tables = Table.all
  end

  def new
    @table = Table.new
  end

  def edit
  end

  def create
    @table = Table.new(table_params)

    if @table.save
      redirect_to tables_path, notice: 'Table was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @table.update(table_params)
      redirect_to tables_path, notice: 'Table was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @table.destroy
    redirect_to tables_path, notice: 'Table was successfully deleted.'
  end

  private

  def set_table
    @table = Table.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tables_path, alert: 'Table not found.'
  end

  def table_params
    params.require(:table).permit(:number)
  end
end
