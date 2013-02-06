#Models

class RepoList.Models.Agency extends Backbone.Model
    
class RepoList.Collections.Agencies extends Backbone.Collection
  model: RepoList.Models.Agency
  url: '{{ site.sm_api }}'
  
  parse: (response) ->
    response.accounts
    
  initialize: ->
    @on "add", @getRepos
    @on "add", @initView
    
  getRepos: (model) ->
    repos = new RepoList.Collections.Repos()
    repos.agency = model.get("account")
    model.set 'repos', repos
    repos.fetch update: true
    
  initView: (agency) ->
    new RepoList.Views.Agency(model: agency).render()
  
class RepoList.Models.Repo extends Backbone.Model

class RepoList.Collections.Repos extends Backbone.Collection
  model: RepoList.Models.Repo
  agency: {}
  urlTemplate: '{{ site.gh_api }}'
  
  url: ->
    _.template @urlTemplate, account: @agency
    
  parse: (response) ->
    response.data
    
  initialize: ->
    @on "add", @initView
    
  initView: (repo) ->
    new RepoList.Views.Repo(
      model: repo
      el: "#" + @agency + " .repos"
    ).render()

# Views
        
class RepoList.Views.Agency extends Backbone.View
  el: "#agencies"
  
  render: ->
    @$el.append RepoList.Templates.agency agency: @model.toJSON()
    
class RepoList.Views.Repo extends Backbone.View
  
  render: ->
    @$el.append RepoList.Templates.repo @model.toJSON()

# Router

class Router extends Backbone.Router
  
  routes:
    "": "index"
    
  index: ->
    RepoList.agencies = new RepoList.Collections.Agencies()
    RepoList.agencies.fetch update: true

RepoList.router = new Router()
Backbone.history.start()