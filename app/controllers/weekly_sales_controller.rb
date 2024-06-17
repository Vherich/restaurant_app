class WeeklySalesController < ApplicationController
  def index
    @weekly_sales = WeeklySale.all
  end
end
