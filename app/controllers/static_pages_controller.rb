class StaticPagesController < ApplicationController
  def home
    @list_items_random = ListItem.take_random(take_num: 12)
  end
end
