class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "********************"
    puts params
    puts "********************"
    
    @all_ratings = ['G','PG','PG-13','R']
  
    if(params["sort_movie_by"] != nil)
      session[:sort_movie_by] = params["sort_movie_by"]
      type_order = " ASC"
    else
      session[:sort_movie_by] = ""
      type_order = ""
    end
    
    
  
    if(params["ratings"] != nil)
      session[:selected_ratings] = params["ratings"].keys
      @movies = Movie.where(:rating =>session[:selected_ratings]).order(session[:sort_movie_by] + type_order)
    elsif(params["ratings"] == nil && params["commit"] == "Refresh")
      @movies = Movie.all
      session[:selected_ratings] = nil
    elsif (session[:selected_ratings] != nil)
      @movies = Movie.where(:rating =>session[:selected_ratings]).order(session[:sort_movie_by] + type_order)
    else
      @movies = Movie.order(session[:sort_movie_by])
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
