class DemoKoCoffee.TwitterDemoViewModel
  
  constructor: (@lists, selected) ->
    @savedLists = ko.observableArray(@lists)
    @editingList = ko.observableArray()
    @twitterList = ko.observableArray()
    @userNameToAdd = ko.observable("")
    @currentTweets = ko.observableArray()
    @hasUnsavedChanges = ko.computed => false

    # The active user tweets are (asynchronously) from twitterList
    ko.computed => twitterApi.getTweetsForUsers @twitterList(), @currentTweets
      

  addUser: =>

  findSavedList: (name) =>
    lists = this.savedLists()
    ko.utils.arrayFirst lists, (list) -> list.name == name

  removeFromList: (name) => @twitterList.remove(name) 

  saveChanges: =>
    saveAs = prompt("Save as", this.editingList.name())
    if saveAs
      dataToSave = this.editingList.userNames().slice(0)
      existingSavedList = this.findSavedList(saveAs)
      if existingSavedList
        existingSavedList.userNames = dataToSave # Overwrite existing list
      else
        this.savedLists.push {name: saveAs, userNames: dataToSave } # Add new list
        this.editingList.name saveAs

  deleteList: =>
    nameToDelete = this.editingList.name()
    savedListsExceptOneToDelete = $.grep this.savedLists(), (list) -> list.name != nameToDelete
    this.editingList.name(if savedListsExceptOneToDelete.length == 0 then null else savedListsExceptOneToDelete[0].name)
    this.savedLists(savedListsExceptOneToDelete)
 
