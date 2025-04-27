$(function() {
    function toggle_template() {
        if($('#page_type').val() == 'page-html') {
            $('#template_id').closest('label').addClass('d-none');
        }
        else {
            $('#template_id').closest('label').removeClass('d-none');
        }
    }
    
    $('#page_type').on('change', function() {
        toggle_template();
    });

    toggle_template();
})