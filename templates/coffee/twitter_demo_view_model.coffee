class DemoKoCoffee.TwitterDemoViewModel
  
  constructor: (@lists, selected) ->
    @savedLists = ko.observableArray(@lists)
    @twitterList = ko.observableArray()
    @currentTweets = ko.observableArray()
    @loadingTweets = ko.observable(false)
    @addUserVM = new AddTwitterUserViewModel(@twitterList)
    @reloadTweetsOnUpdate()
      
  removeFromList: (name) => @twitterList.remove(name) 

  addUser: =>

  reloadTweetsOnUpdate: =>
    # The active user tweets are (asynchronously) from twitterList
    ko.computed => 
      @loadingTweets(true)
      twitterApi.getTweetsForUsers @twitterList(), (data) =>
        @loadingTweets(false)
        @currentTweets(data)
    

class AddTwitterUserViewModel
  
  constructor: (@twitterList) ->
    @newUser = ko.observable('')
    
  add: =>
    @twitterList.push @newUser()
    @newUser('')