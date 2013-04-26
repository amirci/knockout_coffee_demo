class DemoKoCoffee.TwitterDemoViewModel
  
  constructor: (@lists, selected) ->
    @savedLists = ko.observableArray(lists)
    @editingList = 
      name: ko.observable(lists)
      userNames: ko.observableArray()
      
    @userNameToAdd = ko.observable("")
    @currentTweets = ko.observableArray()

    @hasUnsavedChanges = ko.computed =>
      return this.editingList.userNames().length > 0 if !this.editingList.name()
      savedData = @findSavedList(this.editingList.name()).userNames
      editingData = this.editingList.userNames()
      savedData.join("|") != editingData.join("|")
 
    @userNameToAddIsValid = ko.computed => this.userNameToAdd() == "" || this.userNameToAdd().match(/^\s*[a-zA-Z0-9_]{1,15}\s*$/) != null
      
    @canAddUserName = ko.computed => this.userNameToAddIsValid() && this.userNameToAdd() != ""

    # The active user tweets are (asynchronously) computed from editingList.userNames
    ko.computed => twitterApi.getTweetsForUsers this.editingList.userNames(), this.currentTweets()

    ko.computed =>
      # Observe viewModel.editingList.name(), so when it changes (i.e., user selects a different list) we know to copy the saved list into the editing list
      savedList = this.findSavedList(this.editingList.name())
      if savedList
        userNamesCopy = savedList.userNames.slice(0)
        this.editingList.userNames(userNamesCopy)
      else 
        this.editingList.userNames([])
      
  findSavedList: (name) =>
    lists = this.savedLists()
    ko.utils.arrayFirst lists, (list) -> list.name == name

  addUser: =>
    if this.userNameToAdd() && this.userNameToAddIsValid()
      this.editingList.userNames.push(this.userNameToAdd())
      this.userNameToAdd("")

  removeUser: => this.editingList.userNames.remove(userName) 

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
 
