class SlidesController < ApplicationController
  def index
    @slides = Slide.find_all
  end

  def view
    @slide = Slide.find(params[:id].to_i)
  end
end
