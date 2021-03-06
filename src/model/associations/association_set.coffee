#= require ../../set/set_sort

class Batman.AssociationSet extends Batman.SetSort
  constructor: (@foreignKeyValue, @association) ->
    base = new Batman.Set
    super(base, '_batmanID')

  loaded: false
  @accessor 'loaded', Batman.Property.defaultAccessor

  load: (callback) ->
    return callback(undefined, @) unless @foreignKeyValue?
    @association.getRelatedModel().loadWithOptions @_getLoadOptions(), (err, records) =>
      @markAsLoaded() unless err
      callback(err, @)

  _getLoadOptions: ->
    loadOptions = data: {}
    loadOptions.data[@association.foreignKey] = @foreignKeyValue
    if @association.options.url
      loadOptions.collectionUrl = @association.options.url
      loadOptions.urlContext = @association.parentSetIndex().get(@foreignKeyValue)
    loadOptions

  markAsLoaded: ->
    @set('loaded', true)
    @fire('loaded')
