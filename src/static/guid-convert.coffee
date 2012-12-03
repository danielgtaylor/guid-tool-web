# Tool to query and render GUID conversions via REST API

delay = (ms, func) -> setTimeout func, ms

class window.GuidTool
    # Initialize on page load
    @init: =>
        $('#guid').select()

        delay 2000, =>
            $('.nav, #footer').fadeIn()

        $('#submit').click (event) =>
            event.preventDefault()
            GuidTool.query $('#guid').val()
            $('#guid').val('').focus()

    # RFC 4122 Section 4.4 GUID generation from pseudo-random numbers
    @generate: =>
        'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) =>
            r = Math.random() * 16 | 0
            v = if c is 'x' then r else r & 0x3 | 0x8
            return v.toString 16

    # Query the server for a given GUID
    @query: (guid) =>
        $.ajax
            url: '/'
            type: 'post'
            data:
                guid: guid
            success: (data, status, xhr) =>
                # Check for success and show conversions or error
                if data.status is 'success'
                    html = '<div class="result"><label>Int:</label>' + data.int + '<br/><label>Hex:</label>' + data.hex + '<br/><label>B64:</label>' + data.b64 + '</div>'
                else
                    guid = "no input given" if guid is ''
                    html = '<div class="result error">Invalid input: ' + guid + '</div>'

                $('#results').prepend(html)
