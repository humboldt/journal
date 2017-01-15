# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@makeRequest = (selector, url) ->
  $.ajax(url: url).done (html) ->
    $(selector).empty().append html

@sortByTag = () ->
  event.preventDefault()
  makeRequest('.entries-section', '/sort?tag_name=' + $(event.target).text())

@preventSubmit = () ->
  if event.keyCode == 13
    event.preventDefault()
    return false

lastEntry = ''
@search = () ->
  if $('#_search_term').val() != lastEntry
    makeRequest('.entries-section', '/search?term=' + $('#_search_term').val())

  lastEntry = $('#_search_term').val()
