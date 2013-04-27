class DemoKoCoffee.TwitterDemoViewModel
  
  constructor: (@lists, selected) ->
    @savedLists = ko.observableArray(@lists)
    @twitterList = ko.observableArray()
    @userNameToAdd = ko.observable("")
    @currentTweets = ko.observableArray()
    @loadingTweets = ko.observable(false)

    # The active user tweets are (asynchronously) from twitterList
    ko.computed => 
      @loadingTweets(true)
      twitterApi.getTweetsForUsers @twitterList(), (data) =>
        @loadingTweets(false)
        @currentTweets(data)
      
  removeFromList: (name) => @twitterList.remove(name) 

  addUser: =>
