# Disable file attachments
$(document).on 'trix-file-accept', (event) ->
  event.preventDefault()
  false

# Don't focus on the toolbar buttons when tab is pressed
$(document).on 'trix-initialize', (event) ->
  button.tabIndex = -1 for button in event.target.toolbarElement.querySelectorAll('button')

checkDuplicateTags = (newTag) ->
  hasDuplicate = false
  $('.tags-section .tag a').each ->
    if $(this).text() == newTag.val()
      hasDuplicate = true
    return
  hasDuplicate

# Add all the tags to the hidden field
buildTagsInput = ->
  tags = $('.tags-section .tag a').map(->
    $(this).text()
  ).get().join(', ')
  tags

$(window).load ->
  # Make the toolbar fixed when it's out of sight
  if $('section').hasClass('editor')
    $('.top-bar').height $('trix-toolbar').height()
    fixmeTop = $('trix-toolbar').offset().top

  $(window).scroll ->
    currentScroll = $(window).scrollTop()
    if currentScroll >= fixmeTop
      $('trix-toolbar').addClass 'fixed'
    else
      $('trix-toolbar').removeClass 'fixed'
    return

  # Add a new tag if it's unique
  $('.new-tag').keydown (event) ->
    if event.keyCode == 13
      event.preventDefault()
      newTag = $(this)
      if checkDuplicateTags(newTag)
        newTag.val ''
      else
        $('.tags-section ul li:last').before '<li class="tag"><a href="#" tabindex="-1">' + newTag.val() + '</a></li>'
        newTag.val ''
        $('.tags-section .tags').val(buildTagsInput()).trigger 'change'
    return

  # Remove the existing tag
  $('.tags-section').on 'click', '.tag', (event) ->
    event.preventDefault()
    $(this).remove()
    $('.tags-section .tags').val(buildTagsInput()).trigger 'change'
    return

  # Autosave
  timeoutId = undefined
  $('.editor form input:not(.new-tag), .editor form trix-editor, .editor form input.tags').on 'input propertychange change cut paste', ->
    clearTimeout timeoutId
    timeoutId = setTimeout((->
      # Runs 1 second (1000 ms) after the last change
      $('.save-state').text 'Saving'
      $('.editor form').submit()
      $('.editor form').on "ajax:success", ->
        $('.save-state').text 'Saved'
      return
    ), 1000)
    return
  return
