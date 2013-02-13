#Models

class RepoList.Models.Agency extends Backbone.Model

  initialize: ->
    repos = new RepoList.Collections.Repos()
    repos.agency = @get 'account'
    @set "repos", repos
    @view = new RepoList.Views.Agency model: @

class RepoList.Collections.Agencies extends Backbone.Collection
  model: RepoList.Models.Agency
  url: '{{ site.sm_api }}'
  agencies: $('#agencies')

  parse: (response) ->
    response.accounts
    
  initialize: ->
    @on "sync", @initView
    @on "add", @getRepos
    
  getRepos: (model) ->
    repos = model.get "repos"
    repos.fetch update: true

  initView: (agency) =>
    for agency in @models
      @agencies.append agency.view.el
      agency.view.render()

  comparator: "organization"
  
class RepoList.Models.Repo extends Backbone.Model

  initialize: ->
    @view = new RepoList.Views.Repo model: @
    @on "change", @view.render()

class RepoList.Collections.Repos extends Backbone.Collection
  model: RepoList.Models.Repo
  agency: {}
  urlTemplate: '{{ site.gh_api }}'
  
  url: ->
    url = _.template @urlTemplate, account: @agency

    if "{{ site.client_id }}"
      url += "&client_id={{ site.client_id }}"
      url += "&client_secret={{ site.client_secret }}"
    
    url

  parse: (response) ->
    if response.meta.status != 200
      $("#agencies").html response.data.message
      return false
    response.data
  
# Views
        
class RepoList.Views.Agency extends Backbone.View
  className: "agency"

  id: ->
    @model.get "id"

  initialize: ->
    @model.get("repos").on "add", @addRepo
    @model.get("repos").on "all", @updateCount

  render: ->
    @$el.html RepoList.Templates.agency agency: @model.toJSON()

  addRepo: (repo) =>
    @$el.find('.repos').append repo.view.el

  updateCount: =>
    @$el.find('.count').html @model.get("repos").length

class RepoList.Views.Repo extends Backbone.View
  className: "repo"
  tagName: "li"
  
  render: ->
    @$el.html RepoList.Templates.repo @model.toJSON()

# Router

class Router extends Backbone.Router
  
  routes:
    "": "index"
    
  index: ->
    RepoList.agencies = new RepoList.Collections.Agencies()
    RepoList.agencies.fetch update: true

RepoList.router = new Router()
Backbone.history.start()