jQuery ->
    $(window).on 'scroll', ->
      more_orders_url = $('.pagination .next_page a').attr('href')
      if more_orders_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
            $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
            $.getScript more_orders_url
        return
