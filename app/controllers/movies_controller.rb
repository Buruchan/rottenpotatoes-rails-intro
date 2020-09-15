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
   #@movies = Movie.all
   redirect = false
   @all_ratings = Movie.all_ratings

    if params[:sort_by]
      @sort_by = params[:sort_by]
      session[:sort_by] = @sort_by
    elsif session[:sort_by]
      redirect = 1
      @sort_by = session[:sort_by]
    else
      @sort_by = nil
    end

    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      redirect = 1
      @ratings = session[:ratings]
    else
      @ratings = nil
    end

    if redirect
      flash.keep
      redirect_to movies_path :sort_by => @sort_by, :ratings => @ratings
    end

  
    if !@ratings
      @ratings = Hash.new
      @all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end

    if @sort_by and @ratings
      @movies = Movie.where(:rating => @ratings.keys).order(@sort_by)
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    elsif @sort_by
      @movies = Movie.all.order(@sort_by)
    else
      @movies = Movie.all
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
