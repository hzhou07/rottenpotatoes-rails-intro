class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings].nil? and params[:sort].nil?
        puts '1'
        if session[:ratings].nil? and session[:sort].nil?
            puts '1.1'
            @ratings_to_show = Hash[@all_ratings.map{|rating| [rating, 1]}]
            session[:ratings] = @ratings_to_show
            session[:sort] = 'no_order'
            @movies = Movie.all
            return
        else
            puts 'outside'
            puts params[:outside]
            if params[:outside]
                @ratings_to_show = session[:ratings]
                @sorted = session[:sort]
            else
                @ratings_to_show = Hash[@all_ratings.map{|rating| [rating, 1]}]
                session[:ratings] = @ratings_to_show
                @sorted = session[:sort]
            end
            redirect_to movies_path({:sort=>@sorted, :ratings=>@ratings_to_show}) and return
        end
    end
    if params[:ratings].nil?
        puts '2'
        @ratings_to_show = session[:ratings]
        @sorted = params[:sort]
        session[:sort] = @sorted
        redirect_to movies_path({:sort=>@sorted, :ratings=>@ratings_to_show}) and return
    end
    if params[:sort].nil?
        puts '3'
        @sorted = session[:sort]
        @ratings_to_show = params[:ratings]
        session[:ratings] = @ratings_to_show
        redirect_to movies_path({:sort=>@sorted, :ratings=>@ratings_to_show}) and return
    end
    
    puts '4'
    puts params[:ratings]
    puts params[:sort]
    @ratings_to_show = params[:ratings]
    @sorted = params[:sort]
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
    rl=[]
    @ratings_to_show.each_key do |x|
        rl << x
    end
    @movies = Movie.with_ratings(rl)
    if @sorted
        if @sorted == 'title'
            @title_sort = 'hilite bg-warning'
            @movies = @movies.order(:title)
        end
        if @sorted == 'date'
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
