window.RepoList =
  Models: {}
  Collections: {}
  Views: {}
  router: {}
  agencies: {}
  
class RepoList.Models.Agency extends Backbone.Model

class RepoList.Collections.Agencies extends Backbone.Collection
  model: RepoList.Models.Agency
  url: '{{ site.sm_api }}'
  
  parse: (response) ->
    response.accounts
    
  initialize: -> 
    @on 'add', @getRepos
    
  getRepos: (model) ->
    repos = new RepoList.Collections.Repos()
    repos.agency = model
    model.set 'repos', repos
    repos.fetch()
  
class RepoList.Models.Repo extends Backbone.Model

class RepoList.Collections.Repos extends Backbone.Collection
  model: RepoList.Models.Repo
  agency: {}
  urlTemplate: '{{ site.gh_api }}'
  
  url: ->
    compiled = _.template @urlTemplate
    compiled @agency.toJSON()
    
  parse: (response) ->
    response.data
  
class RepoList.Views.Index extends Backbone.View
  el: "#repo-list"
  tagName: "li"
  class: "repo"
  template: $('#index_template').html()
  
  initialize: ->
    RepoList.agencies = new RepoList.Collections.Agencies
    RepoList.agencies.fetch update: true
    RepoList.agencies.on 'add', @render
    
  render: =>  
    html = ''
    _.each RepoList.agencies, (nil, i, agencies) ->
      view = new RepoList.Views.Agency model: agencies.models[i]
      html += view.render()
    
    @$el.html html
    
class RepoList.Views.Agency extends Backbone.View
  el: "#agencies"
  tagName: "li"
  class: "agency"
  template: $("#agency_template").html()
  
  render: ->
    repos = ''
    _.each @model.get 'repos', (repo) ->
      view = new RepoList.Views.Repo model: repo
      repos += view.render()
    
    compiled = _.template @template
    compiled agency: @model.toJSON(), repos: repos
    
class RepoList.Views.Repo extends Backbone.View
  el: ".repos"
  tagName: "li"
  class: "repo"
  template: $("#repo_template").html()
  
  render: ->
    compiled = _.template @template
    compiled @model.toJSON()
  
class router extends Backbone.Router
  
  routes:
    "": "index"
    
  index: ->
    view = new RepoList.Views.Index()
  
RepoList.router = new router()
Backbone.history.start()
