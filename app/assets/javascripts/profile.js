function profiletoggle() {
    $( "#profiletoggle" ).click(function(event) {
        event.preventDefault();
        $( "#profile" ).slideToggle( "slow" );
    });
}

$(function () {
    $('.list-group-item > .show-menu').on('click', function(event) {
        event.preventDefault();
        $(this).closest('li').toggleClass('open');
    });

    profiletoggle();
});

/*$(function(){
    // attach table filter plugin to inputs
    $('[data-action="filter"]').filterTable();

    $('.contactlist ').on('click', '.contactlist .panel-heading span.filter', function(e){
        var $this = $(this),
                $panel = $this.parents('.panel');

        $panel.find('.contactlist .panel-body').slideToggle();
        if($this.css('display') != 'none') {
            $panel.find('.contactlist .panel-body input').focus();
        }
    });
    $('[data-toggle="tooltip"]').tooltip();
})*/
