class TableController < ActionController::Base
  def show
    @my_zodiac = current_user.create_my_zodiac
  end
end
