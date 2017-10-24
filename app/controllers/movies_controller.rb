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
    
    if params[:sorting_mechanism].nil?
      @sorting_mechanism = session[:sorting_mechanism]
    else
      session[:sorting_mechanism] = params[:sorting_mechanism]
    end
    
    
    @movies = Movie.all
    
    @all_ratings = Movie.ratings
    if(!params[:ratings])
      @checked_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
      @movies = @movies.where(rating: @checked_ratings)
    else
      @checked_ratings = params[:ratings].keys
      @movies = @movies.where(rating: @checked_ratings)
    end
    
    if session[:sorting_mechanism] == "title"
      @movies = @movies.sort { |a,b| a.title <=> b.title }
      @movie_highlight = "hilite"
    elsif session[:sorting_mechanism] == "release_date"
      @movies = @movies.sort { |a,b| a.release_date <=> b.release_date }
      @date_highlight = "hilite"
    else
      
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
