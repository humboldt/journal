@sortByTag = () ->
  #$('.tags-section').on "click", "a", (event) ->
  event.preventDefault()

  url = '/sort?tag_name=' + $(event.target).text()

  $.ajax(url: url).done (html) ->
    $(".entries-section").empty().append html
