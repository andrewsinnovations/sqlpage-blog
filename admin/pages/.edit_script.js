require.config({ paths: { "vs": "https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs" }});

require(["vs/editor/editor.main"], function() {
    const params = new URLSearchParams(window.location.search);
    const id = params.get("id");
    let editor;
    
    function setValue(value) {
        editor = monaco.editor.create(document.getElementById("html-content"), {
            value: value,
            language: "html",
            automaticLayout: true
        });

        editor.layout({ height: window.innerHeight - 525 });
    }

    function createEditor() {
        const form = document.getElementById("template-form");
        form.addEventListener("formdata", e =>
        {
            e.formData.append("content", editor.getModel().getValue());
        });
    }

    if(id) {
        fetch("/admin/pages/content?id=" + id)
        .then(response => response.text())
        .then(data => {
            setValue(data);
            createEditor();
        });    
    }
    else {
        setValue("");
        createEditor();
    }
    
});

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
});
