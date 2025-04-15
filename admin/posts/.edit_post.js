$(function() {
    function togglePublishingDate() {
        var checked = $('#published').is(':checked');
        
        if(checked) {
            const now = new Date();
            const local = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
            const localISO = local.toISOString().slice(0, 16);

            $('#published_date').val(localISO);
            $('#published_date').closest('label').removeClass('d-none');
            $('#timezone').closest('label').removeClass('d-none');
        }
        else {            
            $('#published_date').val(null);
            $('#published_date').closest('label').addClass('d-none');
            $('#timezone').closest('label').addClass('d-none');
        }
    }

    function hidePublishingDateIfNecessary()
    {
        var checked = $('#published').is(':checked');
        
        if(!checked) {          
            $('#published_date').val(null);
            $('#published_date').closest('label').addClass('d-none');
            $('#timezone').closest('label').addClass('d-none');
        }
    }

    $('#published').on('change', function() {
        togglePublishingDate();
    });

    hidePublishingDateIfNecessary();

    $('#content').trumbowyg();

    $('#revise_post').on('click', function() {
        let content = $('#content').trumbowyg('html');
        $(this).text('Please wait...');
        let button = $(this);
        button.prop('disabled', 'disabled');

        fetch('/admin/posts/ai_edit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: "request=" + encodeURIComponent(content)
        }).then(response => {
            response.json().then(data => {
                $('#content').trumbowyg('html', data.revision);
                
                button.prop('disabled', null);
                button.text('Revise With AI');
            });
        }).catch(error => {
            alert('Sorry, the AI revision did not succeed.');
        });
    });
})