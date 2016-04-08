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
    
    @all_ratings = ['G','PG','PG-13','R']

    if params["commit"] == "Refresh"
      puts params
      redirect_to controller: "movies", action: "index", sort_movie_by: session["sort_movie_by"], ratings: params["ratings"]
    elsif (params["source"] == "link")
      puts params
      redirect_to controller: "movies", action: "index", sort_movie_by: session["sort_movie_by"], ratings: params["ratings"]
    else
      puts params
      query_movies
    end
    
  end
  
  def query_movies2
    if params["sort_movie_by"] == "" || params["sort_movie_by"] == nil
      if session["sort_movie_by"] == nil
        sort_movie_by = ""
        type_order = ""
      else
        params["sort_movie_by"] = session["sort_movie_by"] 
        sort_movie_by = params["sort_movie_by"]
        type_order = " ASC"  
      end
    else
      session["sort_movie_by"] = params["sort_movie_by"]
      sort_movie_by = params["sort_movie_by"]
      type_order = " ASC"
    end
    
    if params["ratings"] != nil
      @selected_ratings = params["ratings"].keys
      session[:selected_ratings] = params["ratings"].keys
      @movies = Movie.where(:rating =>@selected_ratings).order(sort_movie_by + type_order)
    else
      if session[:selected_ratings] == nil
        @selected_ratings = @all_ratings
        @movies = Movie.all
      else
        @selected_ratings = session[:selected_ratings]
        
        @movies = Movie.where(:rating =>@selected_ratings).order(sort_movie_by + type_order)
      end
    end
  end
  
  def query_movies
    if params["sort_movie_by"] == "" || params["sort_movie_by"] == nil
      if session["sort_movie_by"] == nil
        sort_movie_by = ""
        type_order = ""
      else
        params["sort_movie_by"] = session["sort_movie_by"] 
        sort_movie_by = params["sort_movie_by"]
        type_order = " ASC"  
      end
    else
      session["sort_movie_by"] = params["sort_movie_by"]
      sort_movie_by = params["sort_movie_by"]
      type_order = " ASC"
    end
    
    if params["ratings"] != nil
      @selected_ratings = params["ratings"].keys
      session[:selected_ratings] = params["ratings"].keys
      @movies = Movie.where(:rating =>@selected_ratings).order(sort_movie_by + type_order)
    else
      if session[:selected_ratings] == nil
        @selected_ratings = @all_ratings
        @movies = Movie.all
      else
        @selected_ratings = session[:selected_ratings]
        
        @movies = Movie.where(:rating =>@selected_ratings).order(sort_movie_by + type_order)
      end
    end
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
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  
end
