require 'will_paginate/array'
class CitiesController < ApplicationController
  before_filter :find_parent, only: [:new, :create]
  http_basic_authenticate_with name: "sammy1088", password: "Ce66$rio", except: [:show]
  
  def slug
    name.downcase.gsub(" ", "-")  
  end

  def to_param
    "#{id}-#{slug}"
  end

  
  def index
    @cities = City.all
    @links = Link.all

  end
  def new
    @city = City.new
    ##@link = @parent.links.new(link_params)
  end
  def create
   ##@link = @parent.links.new(link_params)
	 @city = City.new(city_params)
    @city.save
    redirect_to @city
  end
  def destroy
    @city = City.find(params[:id])
    @city.destroy
  end

  def show

    ##n@district = District.find(params[:id])
    @city = City.find(params[:id])
   
  
    @links = @city.links
    @districts = @city.districts
    @groups = @city.groups
    @resources = @city.resources
    @ads = @city.ads
    @bills = @city.bills.where(['date >= ?', DateTime.now.to_date]).limit(2)
    @jobs = @city.jobs.limit(5)
    @events = @city.events.where(['date >= ?', DateTime.now.to_date]).limit(5)
               
    
    
    if params[:sort_by] == "new"
      puts "sort queries called"
      
      @links = @links.order(created_at: :desc)

    else
    
    @links = @links.sort_by{ |l| l.hot }.reverse
    
    
    end

    @links = @links.paginate(:page => params[:page], :per_page => 15)
    
  respond_to do |format|
    format.html               # /app/views/articles/index.html.erb
    format.html.tablet     # /app/views/posts/index.html+tablet.erb
    end
  end
  private
   def city_params
    params.require(:city).permit(:title, :slug)
  end
  def find_parent
    if params[:city_id]
      @parent = City.find(params[:city_id])
  end
end
end
