class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#      session.clear
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || session[:ratings] || Hash[@all_ratings.map{|rating| [rating, 1]}]
    if @ratings_to_show != session[:ratings]
        session[:ratings] = @ratings_to_show
    end
    @sorted = params[:sort] || session[:sort]
    if @sorted != session[:sort]
        session[:sort] = @sorted
    end
    rl=[]
    @ratings_to_show.each_key do |x|
        rl << x
    end
    @movies = Movie.with_ratings(rl)
    if @sorted
        if @sorted == 'title' then
            @title_sort = 'hilite bg-warning'
            @movies = @movies.order(:title)
        else
            @date_sort = 'hilite bg-warning'
            @movies = @movies.order(:release_date)
        end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
