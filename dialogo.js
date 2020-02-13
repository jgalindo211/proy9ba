/**
* Configurar los elementos de la página.
*/
$(document).ready(function(){ 
    inicializar();
}); // Fin document.ready

function inicializar() {
    //////////////
    // Dialogos //
    //////////////
    // Dialogo para mensajes
    $("#dlgMsj").dialog({
        height: 160,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Aceptar": function() {
            $(this).dialog("close");
          }
        }
    });

}