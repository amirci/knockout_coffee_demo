class DemoKoCoffee.MovieLibraryViewModel
  
  constructor: (title) ->
    @title = ko.observable(title)
    @movies = ko.observableArray()
    @editingTitle = ko.observable(false)
    @newTitle = ko.observable()
    @count = ko.computed => @movies().length
    @newMovieVM = new NewMovieViewModel(@movies)
    @loadMovies()
    
  loadMovies: =>
    $.get '/movies.json', (data) =>
      @movies(new Movie(m) for m in data.movies)
      
  newMovie: => @newMovieVM.active(true)
    
  editTitle: => 
    @newTitle @title()
    @editingTitle(true)
  
  saveEditing: => 
    @title @newTitle()
    @editingTitle(false)
  
  cancelEditing: => @editingTitle(false)

class NewMovieViewModel

  constructor: (@movies) ->
    @active = ko.observable(false)
    @relDate = @title = ''
    @active.subscribe @activate
    
  activate: (active) => 
    @relDate = @title = '' if active
    
  save: =>
    @active(false)
    @movies.push new Movie({title: @title, release: new Date @relDate})
    
  cancel: => @active(false)
    
class Movie

  constructor: (json) ->
    ko.mapping.fromJS(json, {}, this)
    @releaseDate = ko.computed => $.format.date new Date(@release()), 'MMM dd yyyy'
    