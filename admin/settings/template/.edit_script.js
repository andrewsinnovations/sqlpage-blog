require.config({ paths: { "vs": "https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs" }});

require(["vs/editor/editor.main"], function() {
    const params = new URLSearchParams(window.location.search);
    const id = params.get("id");
    let editor;
    
    function setValue(value) {
        editor = monaco.editor.create(document.getElementById("template-content"), {
            value: value,
            language: "html",
            automaticLayout: true
        });

        editor.layout({ height: window.innerHeight - 350 });
    }

    function createEditor() {
        const form = document.getElementById("template-form");
        form.addEventListener("formdata", e =>
        {
            e.formData.append("template", editor.getModel().getValue());
        });
    }

    if(id) {
        fetch("/admin/settings/template/content?id=" + id)
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