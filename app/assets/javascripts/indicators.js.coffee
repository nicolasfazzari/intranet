jQuery ->
$(document).on "turbolinks:load", ->
  $('#indicators').sortable
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))