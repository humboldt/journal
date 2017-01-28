# Get entry content
@getEntry = (selector) ->
  makeRequest('main.main .container', '/show_single?id=' + $(selector).attr("id"))
  $('.edit-entry').attr('href', '/edit?entry_id=' + $(selector).attr("id"))

# Check if there's an active entry. If not, remove the Edit Entry link.
checkContent = ->
  if $('.main .container').text() == ''
    $('.edit-entry').removeClass 'visible'
  else
    $('.edit-entry').addClass 'visible'

# Check if there's an active entry
@checkEntries = () ->
  if $('.entries-container').text().length <= 1
    $('.main .container').text('')
  else
    if !$('.entry-single').hasClass('active')
      $('.entry-single').first().addClass 'active'
      getEntry('.entry-single.active')


@makeRequest = (selector, url) ->
  $.ajax(url: url).done (html) ->
    $(selector).empty().append html

@deleteEntryRequest = (selector, url) ->
  $.ajax(url: url).done (html) ->
    $('.tags-container').empty().append html

    if $('.tags-container').hasClass('active')
      $('.tags-container ul').css('display', 'block')

    $(selector).remove()
    checkEntries()

# Simple actions that require some animation
@actions =
  entries: (event) ->
    $('.mobile-container.entries').toggle 'slide', { direction: 'left' }, 300
    return

  tags: (event) ->
    $(this).toggleClass 'dripicons-chevron-down dripicons-chevron-up'
    $('.tags-container').toggleClass 'active'
    $('.tags-container ul').css('height', '0 !important').slideToggle(300, ->
      $(this).css('height', 'auto !important'))
    return

# Tags
@sortByTag = (event) ->
  event.preventDefault()
  $('#_search_term').val('')
  makeRequest('.entries-container', '/sort?tag_name=' + $(event.target).text())
  $('.toggle-tags-button').toggleClass 'dripicons-chevron-down dripicons-chevron-up'
  $('.tags-container a.active').removeClass 'active'
  $(event.target).addClass 'active'
  $('.tags-container').toggleClass 'active'
  $('.tags-container ul').slideToggle 300


# Search
@preventSubmit = (event) ->
  if event.keyCode == 13
    event.preventDefault()
    return false

lastEntry = ''
@search = () ->
  if $('#_search_term').val() != lastEntry
    term = 'term=' + $('#_search_term').val()
    tag = 'tag_name=' + $('.tags-container a.active').text()
    makeRequest('.entries-container', '/search?' + term + '&' + tag)

  lastEntry = $('#_search_term').val()

# Delete Entry
@deleteEntry = (event) ->
  event.preventDefault()

  activeEntry = $('.entry-single.active')
  deleteEntryRequest(activeEntry, '/destroy?entry_id=' + activeEntry.attr("id"))


$(document).ready ->
  # Move content around depending on the size of the screen
  checkSize = ->
    `var aside`
    if $('.entries').css('float') == 'left'
      aside = $('.mobile-container.entries .mobile-section > .container').detach()
      aside.appendTo '.aside.entries'
    else
      aside = $('.aside.entries > .container').detach()
      aside.appendTo '.mobile-container.entries .mobile-section'
    return

  checkSize()
  $(window).resize checkSize

  # Simple actions that require some animation
  $('*[data-action]').on 'click', (event) ->
    link = $(this)
    action = link.data('action')

    event.preventDefault()

    # If there's an action with the given name, call it
    if typeof actions[action] == 'function'
      actions[action].call this, event
    return

  # When the user clicks on an entry that's not active
  $('.entries-container').on 'click', '.entry-single:not(.active)', ->
    $('.entry-single.active').removeClass 'active'
    $(this).addClass 'active'
    getEntry($(this))

    # In case the user is on a small screen
    if $('.mobile-container.entries').find('div').hasClass 'container'
      $('.dripicons-arrow-thin-left').trigger 'click'

  # When content is added or deleted on the page
  $('.entries-container').bind 'DOMNodeInserted', ->
    checkEntries()

  $('.main .container').bind 'DOMNodeInserted DOMNodeRemoved', ->
    checkContent()

  return
