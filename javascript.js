  $(document).on('click', 'button', function () {
    var $this   = $(this)
    var $target = $($this.attr('data-target'))

    $target.fadeIn( function (showEvent) {
	$target.one('hidden', function () {
            $this.is(':visible') && $this.trigger('focus')
	})
    })
});

// Ferme le modal si on click sur le bouton close
$(document).on('click', '[data-dismiss="modal"]', function(){
    $(this).closest(".modal").fadeOut()
});
// Ferme le modal si n'importe où
$(document).on('click', '.modal', function(){
    $(this).one().fadeOut()
});
// Empeche ka fermeture du modal si on click sur le rectangle d'information
$(document).on('click', '.modal-dialog', function(event){
    event.stopPropagation();
});
