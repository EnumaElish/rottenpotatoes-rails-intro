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
    @hiliteHeader = ''
    puts params
  
  #if(params.size == 2)
  if(params.size==2 && (session["sort_movie_by"]==nil || session[:selected_ratings]==nil))
      session[:selected_ratings] = @all_ratings
      @selected_ratings = @all_ratings
      session["sort_movie_by"] = ''
      @movies = Movie.all
  end
  
  if(params["ratings"]!=nil)
    if (params["ratings"]!=session[:selected_ratings])
      session[:selected_ratings] = params["ratings"]
      @selected_ratings = params["ratings"]
    end
  end
  
  if (params["sort_movie_by"]!= nil)
    if (params["sort_movie_by"]=='title'||params["sort_movie_by"]=='release_date' )
      session["sort_movie_by"] = params["sort_movie_by"]
    end
  end
  
  if(params.size==2 && (session["sort_movie_by"]!=nil || session[:selected_ratings]!=nil))
    
     redirect_to movies_path(:sort_movie_by=>session["sort_movie_by"],:ratings=>session[:selected_ratings])
     session["sort_movie_by"]=nil
     session[:selected_ratings]=nil
     return
    
  end
  
    if (params["orderItems"] == "orderItems" )
      session["sort_movie_by"] = params["sort_movie_by"]
      flash.keep
      return redirect_to movies_path(:sort_movie_by=>session["sort_movie_by"],:ratings=>session[:selected_ratings])
      
    elsif (params["commit"] == "Refresh")
      if (params["ratings"]!=nil)
        session[:selected_ratings] = params["ratings"]
        @selected_ratings = params["ratings"].keys
      end
      flash.keep
      return redirect_to movies_path(:sort_movie_by=>session["sort_movie_by"], :ratings=>session[:selected_ratings])
    elsif (params["fromShow"] == "fromShow" )
      flash.keep
      return redirect_to movies_path(:sort_movie_by=>session["sort_movie_by"], :ratings=>session[:selected_ratings])
    else
      query_movies
    end
  end
  
  def query_movies
    if(session[:selected_ratings].kind_of?(Array))
      @selected_ratings = session[:selected_ratings]
    else
      @selected_ratings = session[:selected_ratings].keys
    end

      @hiliteHeader = session["sort_movie_by"]
      if(session["sort_movie_by"]!=nil && session["sort_movie_by"]!='')
        @movies = Movie.where(:rating =>@selected_ratings).order(session["sort_movie_by"]  + " ASC")
      else
        @movies = Movie.where(:rating =>@selected_ratings)
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
