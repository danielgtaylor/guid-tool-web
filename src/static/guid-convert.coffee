# Tool to query and render GUID conversions via REST API

delay = (ms, func) -> setTimeout func, ms

class window.GuidTool
    # Initialize on page load
    @init: =>
        $('#guid').select()

        delay 1500, =>
            $('#footer').fadeIn()

        $('#submit').click (event) =>
            event.preventDefault()
            GuidTool.query $('#guid').val()

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
                    html = '<div class="result error">Invalid input: ' + guid + '</div>'

                $('#results').prepend(html)
