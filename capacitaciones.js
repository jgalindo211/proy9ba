var formValid;
var formProveedor;
var formCapacitacion;
var formRep;
var formSubirArchivo;
  
/**
* Configurar los elementos de la página.
*/
$(document).ready(function(){ 
    inicializar();
}); // Fin document.ready

/**
* Efectua las operaciones de configuracion inicial de todos los elementos
* de la pagina.
*/
function inicializar() {
    $("#tabs").tabs();

    $('.ndecimal').keypress(function (event) {
        return isNumber(event, this)
    });
        
    $('.suma').keyup(function (event) {
        calcularTotales();
    });
        
    $('.suma2').keyup(function (event) {
        calcularTotalesCapacitacion();
    });
    
    obtenerTablaSolicitudes();
    obtenerTablaProveedores();
    obtenerTablaCapacitaciones();
    obtenerTablaCapacitacionesEmpleado();

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

    // Dialogo para adición o edición de solicitudes
    $("#dlgDatosSol").dialog({
        height: 700,
        width: 650,
        modal: true,
        autoOpen: false,
        resizable: false
    });
    
    // Diálogo para edición de datos de proveedores
    $("#dlgDatosProveedor").dialog({
        height: 200,
        width: 650,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Aceptar": function() {
          guardarProveedor();
            $(this).dialog("close");
          },
          "Cancelar": function() {
            cancelarProveedor();
          }
        }
    });
    
    // Diálogo para edición de datos de capacitación
    $("#dlgDatosCap").dialog({
        height: 280,
        width: 650,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Guardar": function() {
            guardarCapacitacion();
          },
          "Cancelar": function() {
            cancelarCapacitacion();
          }
        }
    });
    
    // Diálogo para edición de datos de capacitación de empleado
    $("#dlgDatosCapDet").dialog({
        height: 800,
        width: 650,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Cerrar": function() {
            cancelarCapacitacionEmp();
          }
        }
    });
    
    $("#dlgElimSolicitud").dialog({
        height: 120,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Aceptar": function() {
          eliminarSolicitud();
            $(this).dialog("close");
          },
          "Cancelar": function() {
            $(this).dialog("close");
          }
        }
    });
    
    $("#dlgElimProveedor").dialog({
        height: 120,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Aceptar": function() {
          eliminarProveedor();
            $(this).dialog("close");
          },
          "Cancelar": function() {
            $(this).dialog("close");
          }
        }
    });
    
    $("#dlgElimCapacitacion").dialog({
        height: 120,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: {
          "Aceptar": function() {
          eliminarCapacitacion();
            $(this).dialog("close");
          },
          "Cancelar": function() {
            $(this).dialog("close");
          }
        }
    }); 
    
    // Diálogo para carga de archivos
    $("#dlgCargarBrochureCap").dialog({
        height: 170,
        width: 500,
        modal: true,
        autoOpen: false,
        resizable: false,
        buttons: [{
            text: "Guardar",
            id: "btnGuardarBrochureCap",
            click: function() {
                if (!$("#fileUploadForm").valid()) 
                    return false;
                $("#fileUploadForm").submit();
                $("#fileAttachment").val('');                
            }
          }, {
              text: "Descargar",
              id: "btnDescargarBrochureCap",
              click: function() {
                descargarArchivo();
              }
          }, {
              text: "Cancelar",
              id: "btnCancelarBrochureCap",
              click: function() {
                $("#fileAttachment").val('');
                formSubirArchivo.resetForm();
                $(this).dialog("close");
              }
            }]
    });
    
    cargarSelectGenerico("selectTipoFiltro", "divSelectTipoFiltro", "obtFiltroCapacitaciones");
    $("#selectTipoFiltro").chosen({allow_single_deselect: true});
    $("#selectTipoFiltro" ).change(function() {
      obtenerTablaSolicitudes();
    });
    
    formSubirArchivo = $("#fileUploadForm").validate({
        rules: {
            fileUpload: {
                required: true,
                accept: "image/*,application/pdf"
            }
        },
         messages: {
            fileUpload: {
                accept: "Por favor ingrese una imagen o un archivo pdf"
            }
         }
    });
    
    formRep = $("#formRep").validate({ 
        rules: {
                txtAnio: {
                  required: true,
                  range: [2010,2050]
                },
                ddlFondo: {
                  required: true
                }
        },
        messages: {
            txtAnio: {
                range: "Ingrese un año valido"
            }
        }
    });
    
    formValid =  $("#formDatosSolicitud").validate({
          rules: {
            txtTema: {
              required: true
            },
            txtJustificacion: {
              required: true,
              maxlength: 500
            },
            txtFechas: {
              required: true
            },
            rbAmbito: {
              required: true
            },
            txtTiempoPuesto: {
              required: true,
              range: [0, 99]
            },
            txtInscripcion: {
              required: true,
              range: [0, 100000]
            },
            txtInsaforp: {
              required: true,
              range: [0, 100000]
            },
            txtProveedor: {
              required: true,
              range: [0, 100000]
            },
            txtViaticos: {
              required: true,
              range: [0, 100000]
            },
            txtPasaje: {
              required: true,
              range: [0, 100000]
            },
            txtBandesal: {
              required: true,
              min: 0
            },            
            txtCuenta: {
                required: true
            }
          },
          messages: {
            txtTiempoPuesto: {
                range: "Valores permitidos entre [0-99]"
            },
            txtInscripcion: {
                range: "Valores permitidos entre [0-100,000]"
            },
            txtInsaforp: {
                range: "Valores permitidos entre [0-100,000]"
            },
            txtProveedor: {
                range: "Valores permitidos entre [0-100,000]"
            },
            txtViaticos: {
                range: "Valores permitidos entre [0-100,000]"
            },
            txtPasaje: {
                range: "Valores permitidos entre [0-100,000]"
            },
            txtBandesal: {
                min: "Valor del campo BANDESAL no puede ser negativo."
            },
            txtJustificacion: {
                maxlength: "Por favor ingresar no mas de 500 caracteres."
            }
         }
    });
    
    formProveedor =  $("#formDatosProveedor").validate({
          rules: {
            txtNombreProveedor: {
              required: true
            }
          }
    });
    
    formCapacitacion =  $("#formDatosCap").validate({
          rules: {
            txtTemaCap: {
              required: true
            },
            rbAmbitoCap: {
              required: true
            },
            ddlTipoCapacitacionCap: {
              required: true
            },
            ddlProveedores: {
              required: true
            },
            txtFechasCap: {
              required: true
            }
          }
    });
    
    // Inicializar datepicker
    inicializarTxtFechas();
    inicializarTxtFechasCap();

    // Tabs
    if (admin == 'false') {
        $('[href="#tabs-2"]').closest('li').hide();
        $('[href="#tabs-4"]').closest('li').hide();
        $('[href="#tabs-5"]').closest('li').hide();
        
        
        $('#filaComentarioCae').addClass("invisible");
        $('#filaProveedorCae').addClass("invisible");
        $('#filaCapacitacionCae').addClass("invisible");
    }

     $("#fileUploadForm").on('submit',(function(e) {
      e.preventDefault();
      $.ajax({
             url        : "Capacitacion",
             type       : "POST",
             data       :  new FormData(this),
             contentType: false,
             cache      : false,
             processData: false,
             success    : function(data) {
                $("#dlgCargarBrochureCap").dialog("close");
                var error = data.split("@")[0].split("|")[1];

                if (error == "null") {
                    obtenerTablaSolicitudes();
                    obtenerTablaCapacitaciones();
                    obtenerTablaCapacitacionesEmpleado();
                } else {
                    $("#dlgMsj").dialog('option', 'title', 'Error');
                    $("#divTxtMsjError").html(error);
                    $("#dlgMsj").dialog("open");
                }
            },
            error: function(e) {
            
            }          
           });
     }));
     
     $('input[type=radio][name=rbAmbito]').on('change', function() {
        obtenerCuentaCapacitacion($("#ddlCodEmpleado").val(), $(this).val());
     });
     
     if (isValidSocSolicitudId()) {
         cargarDlgDatosSolicitud(socSolicitudId);
     }
       
}


function isValidSocSolicitudId() {
    if (socSolicitudId !== null && socSolicitudId !== '') {
        return isNaN(socSolicitudId) ? false : true;
    } else {
        return false;
    }
}

function inicializarTxtFechas() {
    $('#txtFechas').val('');
    $('#txtFechas').multiDatesPicker('destroy');
    $('#txtFechas').multiDatesPicker({
        minDate: 0
    });
}

function inicializarTxtFechasCap() {
    $('#txtFechasCap').val('');
    $('#txtFechasCap').multiDatesPicker('destroy');
    $('#txtFechasCap').multiDatesPicker({
        minDate: 0
    });
}

function cargarEmpleados(idSelect, idDivPais) {
  $.ajax({
      type: "post",
      url:  "Capacitacion",
      data: {"operacion"   : "obtSelectSulbalternos",
             "codEmpleado" : codEmpleado,
             "idSelect"    : idSelect
            },
      async: false,
      success: function(responseText){
        $("#" + idDivPais).empty();
        if (responseText.indexOf("exito") != -1) {
          $("#" + idDivPais).empty();
          $("#" + idDivPais).html(responseText.split("|")[1]);
          
          // Agregar evento para que se cambie el contenido del formulario cuando se cambie el código de empleado
          $( "#ddlCodEmpleado" ).change(function() {
            cargarSelectCapacitacionesCreadas("ddlCapacitacionesCreadas", "divDdlCapacitacionesCreadas", "obtSelectCapacitacionesCreadas");
            llenarSolicitud(null, 'S');
            if ($("input[name='rbAmbito']").is(":checked")) {
                obtenerCuentaCapacitacion($("#ddlCodEmpleado").val(), $("input[name='rbAmbito']:checked").val());            
            }
          });
        }
      },
      complete: function(responseText) {
          
      }
  });
}
      
function cargarJefe(idSelect, idDivPais) {
  $.ajax({
      type: "post",
      url:  "Capacitacion",
      data: {"operacion"   : "obtSelectJefe",
             "idSolicitud" : $("#hddIdSol").val(),
             "idSelect"    : idSelect
            },
      async: false,
      success: function(responseText){
        $("#" + idDivPais).empty();
        if (responseText.indexOf("exito") != -1) {
          $("#" + idDivPais).empty();
          $("#" + idDivPais).html(responseText.split("|")[1]);
          
        }
      },
      complete: function(responseText) {
          
      }
  });
}
      
function cargarSelectGenerico(idSelect, idDiv, operacion) {
  $.ajax({
      type: "post",
      url:  "Capacitacion",
      data: {"operacion"   : operacion,
             "idSelect"    : idSelect
            },
      async: false,
      success: function(responseText){
        $("#" + idDiv).empty();
        if (responseText.indexOf("exito") != -1) {
          $("#" + idDiv).empty();
          $("#" + idDiv).html(responseText.split("|")[1]);
          
        }
      },
      complete: function(responseText) {
          
      }
  });
}

function cargarDlgDatosCapacitacion(idCapacitacion) {
    cargarSelectGenerico("ddlTipoCapacitacionCap", "divDdlTipoCapacitacionCap", "obtSelectTipoCapacitacion");    
    cargarSelectGenerico("ddlProveedoresCap", "divDdlProveedoresCap", "obtSelectProveedores");    
        
    $('#ddlTipoCapacitacionCap').rules('add', {required: true, messages: {required: 'Tipo de capacitación es requerido'}});
    $('#ddlProveedoresCap').rules('add', {required: true, messages: {required: 'Proveedor es requerido'}});
    
    if (idCapacitacion != null) { // Edición
      $("#hddIdCap").val(idCapacitacion);
    }
    
    $.ajax({
        type: "post",
        url : "Capacitacion",
        data: {"operacion"      : "obtDatosCapacitacion",
               "idCapacitacion" : idCapacitacion
        },
        async: false,
        success: function(response){

          var error = response.split("@")[0].split("|")[1];
          if (error == "null") {
              var tema = response.split("@")[1].split("|")[1];
              $("#txtTemaCap").val(tema);
              
              var ambito = response.split("@")[2].split("|")[1];
              $("input[name='rbAmbitoCap'][value='"+ambito+"']").prop('checked', true);
              
              var cadenaFechas = response.split("@")[5].split("|")[1];

              var fechas = cadenaFechas.split(",")
              for (var i = 0; i < fechas.length; i++) {
                 var fec = fechas[i].trim();
                 if (fec.length > 0) {
                    $('#txtFechasCap').multiDatesPicker('toggleDate', fechas[i].trim());
                 }
              }
              
              var tipo = response.split("@")[3].split("|")[1];
              $("#ddlTipoCapacitacionCap").val(tipo);
              $('#ddlTipoCapacitacionCap').trigger("chosen:updated");
                                          
              var proveedor = response.split("@")[4].split("|")[1];
              $("#ddlProveedoresCap").val(proveedor);
              $('#ddlProveedoresCap').trigger("chosen:updated");
              
              var comentario = response.split("@")[6].split("|")[1];
              $("#txtComentarioCap").val(comentario);

              $("#dlgDatosCap").dialog('option', 'title', 'Datos de la capacitación');
              $("#dlgDatosCap").dialog("open");
              
              $("#ddlTipoCapacitacionCap").chosen({allow_single_deselect: true});
              $("#ddlProveedoresCap").chosen({allow_single_deselect: true});
                            
              var estado = response.split("@")[7].split("|")[1];

              if (estado == 'C') {
                $("#txtTemaCap").attr('disabled', true);
                $("#txtComentarioCap").attr('disabled', true);
                $("#txtFechasCap").attr('disabled', true);
                $("input[name='rbAmbitoCap']").attr('disabled', true);
                $("#ddlTipoCapacitacionCap").attr('disabled', true);
                $('#ddlTipoCapacitacionCap').trigger("chosen:updated");
                $("#ddlProveedoresCap").attr('disabled', true);
                $('#ddlProveedoresCap').trigger("chosen:updated");
              } else {
                  $("#txtFechasCap").attr('disabled', false);
              }
              
          } else {
              $("#dlgMsj").dialog('option', 'title', 'Error');
              $("#divTxtMsjError").html(error);
              $("#dlgMsj").dialog("open");
          }
        },
        complete: function(response) {
          
        }
    });
} 

function cargarDlgDatosProveedor(idProveedor) {
    if (idProveedor != null) { // Edición
      $("#hddIdProveedor").val(idProveedor);
    }
    
    $.ajax({
        type: "post",
        url : "Capacitacion",
        data: {"operacion"   : "obtDatosProveedor",
               "idSolicitud" : idProveedor
        },
        async: false,
        success: function(response){

          var error = response.split("@")[0].split("|")[1];
          if (error == "null") {
              var nombre = response.split("@")[1].split("|")[1];
              $("#txtNombreProveedor").val(nombre);
              
              $("#dlgDatosProveedor").dialog('option', 'title', 'Datos del proveedor');
              $("#dlgDatosProveedor").dialog("open");
          } else {
              $("#dlgMsj").dialog('option', 'title', 'Error');
              $("#divTxtMsjError").html(error);
              $("#dlgMsj").dialog("open");
          }
        },
        complete: function(response) {
          
        }
    });
} 


/**
* Manejador de eventos del boton cargar datos de la solicitud.
*/
function cargarDlgDatosSolicitud(idSolicitud) {

    if (idSolicitud != null) { // Edicion
      $("#hddIdSol").val(idSolicitud);
    }

    cargarEmpleados("ddlCodEmpleado", "divDdlEmpleados");
    cargarSelectGenerico("ddlTipoCapacitacion", "divDdlTipoCapacitacion", "obtSelectTipoCapacitacion");
    cargarSelectGenerico("ddlCentroCosto", "divDdlCentrosCosto", "obtSelectCentrosCosto");
    cargarSelectGenerico("ddlProveedores", "divDdlProveedores", "obtSelectProveedores");
    cargarSelectCapacitacionesCreadas("ddlCapacitacionesCreadas", "divDdlCapacitacionesCreadas", "obtSelectCapacitacionesCreadas");
    cargarSelectGenerico("ddlAutorizaCap", "divDdlAutorizaCap", "obtSelectEmpleadoAutorizaCap");

    llenarSolicitud(idSolicitud, 'N');
}

/**
* Manejador de eventos del boton cargar datos de la solicitud.
*/
function cargarDlgCapacitacionEmp(idCapacitacion) {
    cargarEmpleados("ddlCodEmpleadoCapDet", "divDdlEmpleadosCapDet");
    cargarSelectGenerico("ddlTipoCapacitacionCapDet", "divDdlTipoCapacitacionCapDet", "obtSelectTipoCapacitacion");
    cargarSelectGenerico("ddlCentroCostoCapDet", "divDdlCentrosCostoCapDet", "obtSelectCentrosCosto");
    cargarSelectGenerico("ddlProveedoresCapDet", "divDdlProveedoresCapDet", "obtSelectProveedores");
    cargarSelectGenerico("ddlCapacitacionesCreadasCapDet", "divDdlCapacitacionesCreadasCapDet", "obtSelectCapacitacionesCreadas")

    $("#hddIdCapDet").val(idCapacitacion);
    
    llenarCapacitacion(idCapacitacion, 'N');
}

/**
 * Carga los datos de la solicitud para su edición o para su creación.
 * @param idSolicitud 
 */
function llenarSolicitud(idSolicitud, esChange) {
    var codEmp;
    
    if (esChange == 'S') {
       codEmp = $("#ddlCodEmpleado").val();
    } else {
       codEmp = codEmpleado;
    }
    
    // Obtiene los datos de la solicitud
    $.ajax({
        type: "post",
        url : "Capacitacion",
        data: {"operacion"   : "obtDatosSolicitud",
               "idSolicitud" : $("#hddIdSol").val(),
               "codEmpleado" : codEmp
        },
        async: false,
        success: function(response){

          var error = response.split("@")[0].split("|")[1];
          if (error == "null") {
              var nombre = response.split("@")[1].split("|")[1];
              $("#ddlCodEmpleado").val(nombre);
              $('#ddlCodEmpleado').trigger("chosen:updated");

              if (admin == 'false' || idSolicitud != null) {
                $("#ddlCodEmpleado").attr('disabled', true);
              }
              
              var puesto = response.split("@")[2].split("|")[1];
              $("#txtPuesto").val(puesto);
              $("#txtPuesto").attr('disabled', true);
              
              var tiempo = response.split("@")[3].split("|")[1];
              $("#txtTiempo").val(tiempo);
              $("#txtTiempo").attr('disabled', true);
              
              var tiempoPuesto = response.split("@")[4].split("|")[1];
              $("#txtTiempoPuesto").val(tiempoPuesto);
              
              var fechaSolicitud = response.split("@")[5].split("|")[1];
              $("#txtFechaSolicitud").val(fechaSolicitud);
              $("#txtFechaSolicitud").attr('disabled', true);
              
              var tema = response.split("@")[6].split("|")[1];
              $("#txtTema").val(tema);
                                    
              var ambito = response.split("@")[7].split("|")[1];
              $("input[name='rbAmbito'][value='"+ambito+"']").prop('checked', true);
              
              var tipoCapacitacion = response.split("@")[8].split("|")[1];
              $("#ddlTipoCapacitacion").val(tipoCapacitacion);

              var justificacion = response.split("@")[9].split("|")[1];
              $("#txtJustificacion").val(justificacion);
              
              var inscripcion = response.split("@")[10].split("|")[1];
              $("#txtInscripcion").val(inscripcion);
              
              var viaticos = response.split("@")[11].split("|")[1];
              $("#txtViaticos").val(viaticos);
              
              var pasaje = response.split("@")[12].split("|")[1];
              $("#txtPasaje").val(pasaje);
              
              var total = response.split("@")[13].split("|")[1];
              $("#txtTotal").val(total);
                                    
              var cuentaContable = response.split("@")[14].split("|")[1];
              $("#txtCuenta").val(cuentaContable);
              $("#txtCuenta").attr('readonly', true);
              
              var centroCosto = response.split("@")[15].split("|")[1];
              $("#ddlCentroCosto").val(centroCosto);
              $("#ddlCentroCosto").attr('disabled', true);
              $('#ddlCentroCosto').trigger("chosen:updated");

              var jefe = response.split("@")[16].split("|")[1];
              cargarJefe("ddlJefe", "divDdlJefe");
              $("#ddlJefe").val(jefe);
              $("#ddlJefe").attr('disabled', true);
              $('#ddlJefe').trigger("chosen:updated");
              
              var estado = response.split("@")[25].split("|")[1];
              $("#hddCodEstSoc").val(estado);
              
              var opciones = response.split("@")[17].split("|")[1];              
              
              var cadenaFechas = response.split("@")[18].split("|")[1];
              var fechas = cadenaFechas.split(",")
              for (var i = 0; i < fechas.length; i++) {
                 var fec = fechas[i].trim();
                 if (fec.length > 0) {
                    $('#txtFechas').multiDatesPicker('toggleDate', fechas[i].trim());
                 }
              }
              
              var apoyoInsaforp = response.split("@")[19].split("|")[1];
              $("#txtInsaforp").val((apoyoInsaforp == '') ? 0 : apoyoInsaforp);
              
              var apoyoProveedor = response.split("@")[20].split("|")[1];
              $("#txtProveedor").val((apoyoProveedor == '') ? 0 : apoyoProveedor);
              
              var estadoDescripcion = response.split("@")[21].split("|")[1];
              $("#txtEstado").val(estadoDescripcion);
              $("#txtEstado").attr('disabled', true);
              
              var proveedor = response.split("@")[22].split("|")[1];
              $("#ddlProveedores").val(proveedor);
              $("#ddlProveedores").trigger("chosen:updated");
              
              var capacitacion = response.split("@")[23].split("|")[1];
              $("#ddlCapacitacionesCreadas").val(capacitacion);
              $("#ddlCapacitacionesCreadas").trigger("chosen:updated");
              
              var comentario = response.split("@")[24].split("|")[1];
              $("#txtComentario").val(comentario);
              
              var bandesal = response.split("@")[26].split("|")[1];
              $("#txtBandesal").val(inscripcion);
              
              var empAutorizaCap = response.split("@")[27].split("|")[1];
              if ($("#hddCodEstSoc").val() == 'A' && empAutorizaCap == '') {
                $("#ddlAutorizaCap").val(0);
              } else {
                $("#ddlAutorizaCap").val(empAutorizaCap);
              }
              $("#ddlAutorizaCap").trigger("chosen:updated");
              
              mostrarDialogoSolicitud(opciones);
              
          } else {
              $("#dlgMsj").dialog('option', 'title', 'Error');
              $("#divTxtMsjError").html(error);
              $("#dlgMsj").dialog("open");
          }
        },
        complete: function(response) {
          
        }
    });
}

function llenarCapacitacion(idSolicitud, esChange) {
    // Obtiene los datos de la solicitud
    $.ajax({
        type: "post",
        url : "Capacitacion",
        data: {"operacion"   : "consultarCapacitacionEmpleado",
               "idSolicitud" : idSolicitud
        },
        async: false,
        success: function(response){

          var error = response.split("@")[0].split("|")[1];
          if (error == "null") {
              var nombre = response.split("@")[1].split("|")[1];
              $("#ddlCodEmpleadoCapDet").val(nombre);
              $('#ddlCodEmpleadoCapDet').trigger("chosen:updated");
              $("#ddlCodEmpleadoCapDet").attr('disabled', true);
              
              var puesto = response.split("@")[2].split("|")[1];
              $("#txtPuestoCapDet").val(puesto);
              $("#txtPuestoCapDet").attr('disabled', true);
              
              var tiempo = response.split("@")[3].split("|")[1];
              $("#txtTiempoCapDet").val(tiempo);
              $("#txtTiempoCapDet").attr('disabled', true);
              
              var tiempoPuesto = response.split("@")[4].split("|")[1];
              $("#txtTiempoPuestoCapDet").val(tiempoPuesto);
              
              var fechaSolicitud = response.split("@")[5].split("|")[1];
              $("#txtFechaSolicitudCapDet").val(fechaSolicitud);
              $("#txtFechaSolicitudCapDet").attr('disabled', true);
              
              var tema = response.split("@")[6].split("|")[1];
              $("#txtTemaCapDet").val(tema);
                                    
              var ambito = response.split("@")[7].split("|")[1];
              $("input[name='rbAmbitoCapDet'][value='"+ambito+"']").prop('checked', true);
              
              var tipoCapacitacion = response.split("@")[8].split("|")[1];
              $("#ddlTipoCapacitacionCapDet").val(tipoCapacitacion);

              var justificacion = response.split("@")[9].split("|")[1];
              $("#txtJustificacionCapDet").val(justificacion);
              
              var inscripcion = response.split("@")[10].split("|")[1];
              $("#txtInscripcionCapDet").val(inscripcion);
              
              var viaticos = response.split("@")[11].split("|")[1];
              $("#txtViaticosCapDet").val(viaticos);
              
              var pasaje = response.split("@")[12].split("|")[1];
              $("#txtPasajeCapDet").val(pasaje);
              
              var total = response.split("@")[13].split("|")[1];
              $("#txtTotalCapDet").val(total);
                                    
              var cuentaContable = response.split("@")[14].split("|")[1];
              $("#txtCuentaCapDet").val(cuentaContable);
              $("#txtCuentaCapDet").attr('disabled', true);
              
              var centroCosto = response.split("@")[15].split("|")[1];
              $("#ddlCentroCostoCapDet").val(centroCosto);
              $("#ddlCentroCostoCapDet").attr('disabled', true);
              $('#ddlCentroCostoCapDet').trigger("chosen:updated");

              var jefe = response.split("@")[16].split("|")[1];
              cargarJefe("ddlJefeCapDet", "divDdlJefeCapDet");
              $("#ddlJefeCapDet").val(jefe);
              $("#ddlJefeCapDet").attr('disabled', true);
              $('#ddlJefeCapDet').trigger("chosen:updated");
              
              var opciones = response.split("@")[17].split("|")[1];
              
              var cadenaFechas = response.split("@")[18].split("|")[1];
              $('#txtFechasCapDet').val(cadenaFechas);
              
              var apoyoInsaforp = response.split("@")[19].split("|")[1];
              $("#txtInsaforpCapDet").val(apoyoInsaforp);
              
              var apoyoProveedor = response.split("@")[20].split("|")[1];
              $("#txtProveedorCapDet").val(apoyoProveedor);
              
              var estadoDescripcion = response.split("@")[21].split("|")[1];
              $("#txtEstadoCapDet").val(estadoDescripcion);
              $("#txtEstadoCapDet").attr('disabled', true);
              
              var proveedor = response.split("@")[22].split("|")[1];
              $("#ddlProveedoresCapDet").val(proveedor);
              $('#ddlProveedoresCapDet').trigger("chosen:updated");
              
              var capacitacion = response.split("@")[23].split("|")[1];
              $("#ddlCapacitacionesCreadasCapDet").val(capacitacion);
              $('#ddlCapacitacionesCreadasCapDet').trigger("chosen:updated");
              
              var estado = response.split("@")[24].split("|")[1];
              $("#hddEstadoCapDet").val(estado);
              
              var comentario = response.split("@")[25].split("|")[1];
              $("#txtComentarioCapDet").val(comentario);
              
              $("#dlgDatosCapDet").dialog('option', 'title', 'Datos de la capacitaci&oacute;n');
              $("#dlgDatosCapDet").dialog("open");
              $("#ddlCodEmpleadoCapDet").chosen({allow_single_deselect: true});
              $("#ddlTipoCapacitacionCapDet").chosen({allow_single_deselect: true});
              $("#ddlCentroCostoCapDet").chosen({allow_single_deselect: true});
              $("#ddlJefeCapDet").chosen({allow_single_deselect: true});
              $("#ddlProveedoresCapDet").chosen({allow_single_deselect: true});
              $("#ddlCapacitacionesCreadasCapDet").chosen({allow_single_deselect: true});
              calcularTotalesCapacitacion();
              
              bloquearControlesCapDet();
          } else {
              $("#dlgMsj").dialog('option', 'title', 'Error');
              $("#divTxtMsjError").html(error);
              $("#dlgMsj").dialog("open");
          }
        },
        complete: function(response) {
          
        }
    });
}

function bloquearControlesCapDet() {
    $("#txtTiempoPuestoCapDet").attr('disabled', true);
    $("#txtTemaCapDet").attr('disabled', true);
    $("input[name='rbAmbitoCapDet']").attr('disabled', true);
    $("#txtFechasCapDet").attr('disabled', true);
    $("#ddlTipoCapacitacionCapDet").attr('disabled', true);
    $("#txtJustificacionCapDet").attr('disabled', true);
    $("#ddlProveedoresCapDet").attr('disabled', true);
    $('#ddlProveedoresCapDet').trigger("chosen:updated");
    $("#ddlCentroCostoCapDet").attr('disabled', true);
    $('#ddlCentroCostoCapDet').trigger("chosen:updated");
    $('#ddlTipoCapacitacionCapDet').trigger("chosen:updated");
    $("#ddlCapacitacionesCreadasCapDet").attr('disabled', true);
    $('#ddlCapacitacionesCreadasCapDet').trigger("chosen:updated");            
    $("#txtInscripcionCapDet").attr('disabled', true);
    $("#txtInsaforpCapDet").attr('disabled', true);
    $("#txtViaticosCapDet").attr('disabled', true);
    $("#txtProveedorCapDet").attr('disabled', true);
    $("#txtPasajeCapDet").attr('disabled', true);
    $("#txtBandesalCapDet").attr('disabled', true);
    $("#txtComentarioCapDet").attr('disabled', true);    
}

/**
 * Muestra el diálogo de solicitud con las respectivas opciones.
 * @param opciones 
 */
function mostrarDialogoSolicitud(opciones) {
  var botones;
  $('#filaComentarioSoc').addClass("invisible");
  $("#txtComentario").attr('disabled', true);
  ocultarControlAutorizaCapacitacion();
  
  if ($("#hddIdSol").val() == null || $("#hddIdSol").val() == '') {
    botones = {"Enviar": enviarSolicitud, "Guardar": guardarSolicitud, "Cancelar": cancelarEnvio};
    desbloquearControles();
    controlesEditablesPorRrhh();
    controlesVisiblesPorRrhh();
  } else if (opciones == '1') {    
    botones = {"Enviar*": enviarSolicitud, "Guardar": guardarSolicitud,  "Cancelar": cancelarEnvio};
    bloquearControles();
    controlesEditablesPorRrhh();
    controlesVisiblesPorRrhh();
    if ($("#hddCodEstSoc").val() == 'R') {
        $('#filaComentarioSoc').removeClass("invisible");
    }
  } else if (opciones == '2') {    
    botones = {"Imprimir": imprimirSolicitud, "Cancelar": cancelarEnvio};
    bloquearControles();
    controlesVisiblesPorRrhh();
    if ($("#hddCodEstSoc").val() == 'A' && admin == 'true') {
        mostrarControlAutorizaCapacitacion();
    }
    if ($("#hddCodEstSoc").val() != 'E') {
        $('#filaComentarioSoc').removeClass("invisible");
    }    
  } else if (opciones == '3') {    
    botones = {"Imprimir": imprimirSolicitud, "Aprobar" : aprobarSolicitudJefatura, "Corregir" : rechazarSolicitud, "Denegar" : denegarSolicitud,  "Cancelar": cancelarEnvio};
    bloquearControles();
    controlesVisiblesPorRrhh();
    $('#filaComentarioSoc').removeClass("invisible");
    $("#txtComentario").attr('disabled', false);
    $("#txtComentario").val('');    
  } else if (opciones == '4') {   
    botones = {"Imprimir": imprimirSolicitud, "Aprobar*" : aprobarSolicitudRrhh, "Corregir" : rechazarSolicitud, "Denegar" : denegarSolicitud, "Cancelar": cancelarEnvio};
    desbloquearControles();
    controlesVisiblesPorRrhh();
    mostrarControlAutorizaCapacitacion();
    $('#filaComentarioSoc').removeClass("invisible");
    $("#txtComentario").attr('disabled', false);
    $("#txtComentario").val('');
  } else {
    botones = {"Cancelar": cancelarEnvio};
    bloquearControles();
    controlesVisiblesPorRrhh();
    $('#filaComentarioSoc').removeClass("invisible");
  }

  $("#dlgDatosSol").dialog('option', 'title', 'Datos de la solicitud');
  $("#dlgDatosSol").dialog("open");
  $("#ddlCodEmpleado").chosen({allow_single_deselect: true});
  $("#ddlTipoCapacitacion").chosen({allow_single_deselect: true});
  $("#ddlCentroCosto").chosen({allow_single_deselect: true});
  $("#ddlJefe").chosen({allow_single_deselect: true});
  $("#dlgDatosSol").dialog('option', 'buttons', botones);
  $("#ddlProveedores").chosen({allow_single_deselect: true});
  $("#ddlCapacitacionesCreadas").chosen({allow_single_deselect: true});
  $("#ddlAutorizaCap").chosen({allow_single_deselect: true});
  calcularTotales();
}

  function cargarEliminarSolicitud(idFamiliar) {
    $("#hddIdSol2").val(idFamiliar);
    $("#dlgElimSolicitud").dialog("open");
  }
  
  function cargarEliminarProveedor(idProveedor) {
    $("#hddIdProveedor").val(idProveedor);
    $("#dlgElimProveedor").dialog("open");
  }
  
  function cargarEliminarCapacitacion(idCapacitacion) {
    $("#hddIdCap").val(idCapacitacion);
    $("#dlgElimCapacitacion").dialog("open");
  }

function eliminarSolicitud() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "eliminarSolicitudCap",
                "idSolicitud"        : $("#hddIdSol2").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
    
}

function eliminarProveedor() {

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "eliminarProveedor",
                "idProveedor"        : $("#hddIdProveedor").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaProveedores();
        }
      },
      complete: function(response) {
        
      }
    });
    
}

function eliminarCapacitacion() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "eliminarCapacitacion",
                "idCapacitacion"     : $("#hddIdCap").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaCapacitaciones();
        }
      },
      complete: function(response) {
        
      }
    });
    
}


// Funciones de operaciones de solicitud y capacitaciones
function enviarSolicitud() {
    $("#txtComentario").val("");
    if (!guardarSolicitud()) {
        return false;
    }

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "enviarSolicitudCap",
                "idSolicitud"        : $("#hddIdSol2").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
}

function imprimirSolicitud() {
    window.open(ruta +"/empleado/Capacitacion?operacion=descFormCap&idSolicitud=" + $("#hddIdSol").val(), "_blank");
    cancelarEnvio();
}

function aprobarSolicitudJefatura() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "aprobarSolicitudCapJefe",
                "idSolicitud"        : $("#hddIdSol").val(),
                "txtComentario"      : $("#txtComentario").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
}

function rechazarSolicitud() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "rechazarSolicitutdCap",
                "idSolicitud"        : $("#hddIdSol").val(),
                "txtComentario"      : $("#txtComentario").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
}

function denegarSolicitud() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "denegarSolicitudCap",
                "idSolicitud"        : $("#hddIdSol").val(),
                "txtComentario"      : $("#txtComentario").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
}

function aprobarSolicitudRrhh() {
    if (!$("#ddlProveedores").valid()) {
        return false;
    }
    
    if (!$("#ddlAutorizaCap").valid()) {
        return false;
    }
    
    if (!guardarSolicitud()) {
        return false;
    }    

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"           : "aprobarSolicitudCapRrrhh",
                "idSolicitud"         : $("#hddIdSol2").val(),
                "idCapacitacion"      : $("#ddlCapacitacionesCreadas").val(),
                "codEmpleadoAutoriza" : $("#ddlAutorizaCap").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaSolicitudes();
            obtenerTablaCapacitaciones();
            obtenerTablaCapacitacionesEmpleado();
            cancelarEnvio();
        }
      },
      complete: function(response) {
        
      }
    });
}

function cancelarEnvio() {
    inicializarDatosSolicitud();
    $("#dlgDatosSol").dialog("close");
}

function guardarSolicitud() {
   if (!$("#formDatosSolicitud").valid()) return false;

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "guardarSolCap",
                "hddIdSol"           : $("#hddIdSol").val(),
                "ddlEmpleados"       : $("#ddlCodEmpleado").val(),
                "txtTema"            : $("#txtTema").val(),
                "rbAmbito"           : $("input[name='rbAmbito']:checked").val(),
                "ddlTipoCapacitacion": $("#ddlTipoCapacitacion").val(),
                "txtJustificacion"   : $("#txtJustificacion").val(),
                "txtInscripcion"     : $("#txtInscripcion").val(),
                "txtInsaforp"        : $("#txtInsaforp").val(),
                "txtProveedor"       : $("#txtProveedor").val(),
                "txtViaticos"        : $("#txtViaticos").val(),
                "txtPasaje"          : $("#txtPasaje").val(),
                "txtCuenta"          : $("#txtCuenta").val(),
                "ddlCentrosCosto"    : $("#ddlCentrosCosto").val(),
                "ddlJefe"            : $("#ddlJefe").val(),
                "txtTiempoPuesto"    : $("#txtTiempoPuesto").val(),
                "txtFechas"          : $("#txtFechas").val(),
                "ddlProveedores"     : $("#ddlProveedores").val(),
                "txtComentario"      : $("#txtComentario").val(),
                "brochure"           : $("#fileAttachment").val(),
                "txtBandesal"        : $("#txtBandesal").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            var numSol = response.split("@")[1].split("|")[1];
            cancelarEnvio();
            $("#hddIdSol2").val(numSol);
        }
      },
      complete: function(response) {
        
      }
    });
    
    return true;
}

function guardarProveedor() {
   if (!$("#formDatosProveedor").valid()) return false;

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "guardarProveedor",
                "idProveedor"        : $("#hddIdProveedor").val(),
                "nombre"             : $("#txtNombreProveedor").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaProveedores();
            cancelarProveedor();
        }
      },
      complete: function(response) {
        
      }
    });
    
    return true;
}

function cancelarProveedor() {
    $("#hddIdProveedor").val('');
    $("#txtNombreProveedor").val('');
    $("#dlgDatosProveedor").dialog("close");
}

function cancelarCapacitacion() {
    $("#hddIdCap").val('');
    $("#txtTemaCap").val('');
    $('#txtFechasCap').val('');
    $('#txtFechasCap').multiDatesPicker('destroy');
    $('#txtFechasCap').multiDatesPicker({});
    $("#ddlTipoCapacitacion").val('');
    $("#ddlProveedores").val('');
    $("#txtComentarioCap").val('');
    
    $("#txtTemaCap").attr('disabled', false);
    $("input[name='rbAmbitoCap']").attr('disabled', false);
    $("#ddlTipoCapacitacionCap").attr('disabled', false);
    $('#ddlTipoCapacitacionCap').trigger("chosen:updated");
    $("#ddlProveedoresCap").attr('disabled', false);
    $('#ddlProveedoresCap').trigger("chosen:updated");
    $("#txtComentarioCap").attr('disabled', false);
    
    inicializarTxtFechasCap();
    
    formCapacitacion.resetForm();
        
    $("#dlgDatosCap").dialog("close");
}


function guardarCapacitacion() {
   var isValid = true;
   if (!$("#formDatosCap").valid()) {
        isValid = false;
   }
   
   if (!$("#ddlTipoCapacitacionCap").valid()) {
        isValid = false;
    }
    
    if (!$("#ddlProveedoresCap").valid()) {
        isValid = false;
    }
    
    if (!isValid) return false;
    
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion"          : "guardarCapacitacion",
                "idCapacitacion"     : $("#hddIdCap").val(),
                "tema"               : $("#txtTemaCap").val(),
                "rbAmbito"           : $("input[name='rbAmbitoCap']:checked").val(),
                "tipo"               : $("#ddlTipoCapacitacionCap").val(),
                "proveedor"          : $("#ddlProveedoresCap").val(),
                "txtFechasCap"       : $("#txtFechasCap").val(),
                "txtComentarioCap"   : $("#txtComentarioCap").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            obtenerTablaCapacitaciones();
            cancelarCapacitacion();
        }
      },
      complete: function(response) {
        
      }
    });
    
    return true;
}

function bloquearControles() {
    if ($("#hddCodEstSoc").val() != 'N' && $("#hddCodEstSoc").val() != 'R') {
        $("#txtTiempoPuesto").attr('disabled', true);
        $("#txtTema").attr('disabled', true);
        $("input[name='rbAmbito']").attr('disabled', true);
        $("#txtFechas").attr('disabled', true);
        $("#ddlTipoCapacitacion").attr('disabled', true);
        $("#txtJustificacion").attr('disabled', true);
        $("#txtInscripcion").attr('disabled', true);
        $("#txtInsaforp").attr('disabled', true);
        $("#txtViaticos").attr('disabled', true);
        $("#txtProveedor").attr('disabled', true);
        $("#txtPasaje").attr('disabled', true);
        $("#ddlProveedores").attr('disabled', true);
        //$("#txtComentario").attr('disabled', true);
        $("#ddlCapacitacionesCreadas").attr('disabled', true);
        $('#ddlCentroCosto').trigger("chosen:updated");
        $('#ddlAutorizaCap').attr('disabled', true);
    } else {
        desbloquearControles();
    }
}

function desbloquearControles() {
    $("#txtTiempoPuesto").attr('disabled', false);
    $("#txtTema").attr('disabled', false);
    $("input[name='rbAmbito']").attr('disabled', false);
    $("#txtFechas").attr('disabled', false);
    $("#ddlTipoCapacitacion").attr('disabled', false);
    $("#txtJustificacion").attr('disabled', false);
    $("#txtInscripcion").attr('disabled', false);
    $("#txtInsaforp").attr('disabled', false);
    $("#txtViaticos").attr('disabled', false);
    $("#txtProveedor").attr('disabled', false);
    $("#txtPasaje").attr('disabled', false);
    $("#ddlProveedores").attr('disabled', false);
    //$("#txtComentario").attr('disabled', false);
    $('#ddlAutorizaCap').attr('disabled', false);
}

function controlesEditablesPorRrhh() {
    if (admin == 'true') {
        $("#txtInsaforp").attr('disabled', false);
        $("#txtProveedor").attr('disabled', false);
    } else {
        $("#txtInsaforp").attr('disabled', true);
        $("#txtProveedor").attr('disabled', true);
    }
}

function controlesVisiblesPorRrhh() {
     if (admin == 'false') {
        $("#filaDdlProveedor").addClass("invisible");
        $("#filaDdlCapacitacion").addClass("invisible");
        $("#ddlProveedores").rules("remove","required");
    } else {
        $("#filaDdlProveedor").removeClass("invisible");
        $("#filaDdlCapacitacion").removeClass("invisible");
        $("#ddlProveedores").rules('add', {required: true, messages: {required: 'Proveedor es requerido'}});
    }
}

function ocultarControlAutorizaCapacitacion() {
    $('#filaDdlAutorizaCap').addClass("invisible");
    $('#ddlAutorizaCap').rules('remove', "required");
}

function mostrarControlAutorizaCapacitacion() {
    $('#filaDdlAutorizaCap').removeClass("invisible");
    $('#ddlAutorizaCap').rules('add', {required: true, messages: {required: 'Autoriza capacitación es requerido'}});
}

      
/**
 * Devuelve la tabla de consulta de solicitudes.
 */
function obtenerTablaSolicitudes() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion" : "obtTablaSolicitudes",
                "filtro"   : $("#selectTipoFiltro").val()
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            var html = response.split("@")[1].split("|")[1];
            $("#divTabDatSol").html(html);
        }
      },
      complete: function(response) {
        
      }
    });
}

/**
 * Devuelve la tabla de consulta de solicitudes.
 */
function obtenerTablaProveedores() {

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion" : "obtTablaProveedores"
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            var html = response.split("@")[1].split("|")[1];
            $("#divTabProveedores").html(html);
        }
      },
      complete: function(response) {
        
      }
    });
}

function obtenerTablaCapacitaciones() {

    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion" : "obTablaCapacitaciones"
               },
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            var html = response.split("@")[1].split("|")[1];
            $("#divTabCapacitaciones").html(html);
        }
      },
      complete: function(response) {
        
      }
    });
}

/**
 * Devuelve la tabla de consulta de solicitudes.
 */
function obtenerTablaCapacitacionesEmpleado() {
    $.ajax({
      type   : "post",
      url    : "Capacitacion",
      data   : {"operacion" : "obtTablaCapacitacionEmpleado"},
      async  : false,
      success: function(response){
        var error = response.split("@")[0].split("|")[1];
        if (error != "null") { // Error
            $("#divTxtMsjError").html(error);
            $("#dlgMsj").dialog("open");
        } else { // Exito
            var html = response.split("@")[1].split("|")[1];
            $("#divTabCapEmp").html(html);
        }
      },
      complete: function(response) {
        
      }
    });
}

/**
 * Función que obliga a que se ingresen sólo números en un campo.
 * @param evt 
 * @param element 
 */
function isNumber(evt, element) {

    var charCode = (evt.which) ? evt.which : event.keyCode

    if (
        (charCode != 45 || $(element).val().indexOf('-') != -1) &&      // “-” CHECK MINUS, AND ONLY ONE.
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
 
/**
 * Calcula los totales de las solicitudes.
 */
function calcularTotales() {
    var inscripcion = $("#txtInscripcion").val() || 0;
    var insaforp = $("#txtInsaforp").val() || 0;
    var proveedor = $("#txtProveedor").val() || 0;
    var bandesal = parseFloat(inscripcion) - parseFloat(insaforp) - parseFloat(proveedor);
    $("#txtBandesal").val(bandesal.toFixed(2));
    
    var viaticos = $("#txtViaticos").val() || 0;
    var pasaje = $("#txtPasaje").val() || 0;
    var total = bandesal + parseFloat(viaticos) + parseFloat(pasaje);
    $("#txtTotal").val(total.toFixed(2));
}

function calcularTotalesCapacitacion() {
    var inscripcion = $("#txtInscripcionCapDet").val() || 0;
    var insaforp = $("#txtInsaforpCapDet").val() || 0;
    var proveedor = $("#txtProveedorCapDet").val() || 0;
    var bandesal = parseFloat(inscripcion) - parseFloat(insaforp) - parseFloat(proveedor);
    $("#txtBandesalCapDet").val(bandesal.toFixed(2));
    
    var viaticos = $("#txtViaticosCapDet").val() || 0;
    var pasaje = $("#txtPasajeCapDet").val() || 0;
    var total = bandesal + parseFloat(viaticos) + parseFloat(pasaje);
    $("#txtTotalCapDet").val(total);
}

function inicializarDatosSolicitud() {
    obtenerTablaSolicitudes(); 
    $("#hddIdSol").val("");
    $("#ddlCodEmpleado").val("");
    $("#txtPuesto").val("");
    $("#txtTiempo").val("");
    $("#txtTiempoPuesto").val("");
    $("#txtFechaSolicitud").val("");
    $("#rbAmbito").val("");
    $("input[name='rbAmbito'][value='N']").prop('checked', false);
    $("input[name='rbAmbito'][value='I']").prop('checked', false);
    $("#ddlTipoCapacitacion").val("");
    $("#txtJustificacion").val("");
    $("#txtInscripcion").val("");
    $("#txtViaticos").val("");
    $("#txtPasaje").val("");
    $("#txtTotal").val("");
    $("#txtBandesal").val("");
    $("#txtComentario").val("");
    inicializarTxtFechas();
    
    formValid.resetForm();
}

function cancelarCapacitacionEmp () {
    $("#hddIdCap").val("");
    $("#ddlCodEmpleadoCapDet").val("");
    $("#txtPuestoCapDet").val("");
    $("#txtTiempoCapDet").val("");
    $("#txtTiempoPuestoCapDet").val("");
    $("#txtFechaSolicitudCapDet").val("");
    $("#rbAmbitoCapDet").val("");
    $("#ddlTipoCapacitacionCapDet").val("");
    $("#txtJustificacionCapDet").val("");
    $("#txtInscripcionCapDet").val("");
    $("#txtViaticosCapDet").val("");
    $("#txtPasajeCapDet").val("");
    $("#txtTotalCapDet").val("");

    $("#dlgDatosCapDet").dialog("close");
}

function cargarArchivo(tipo, capacitacion, solicitud, ocultarBotonGuardar, 
                        ocultarBotonDescargar, nombreArchivoCargado) {
    var titulo = "";
    
    if (tipo == "1") {
        titulo = "Brochure de solicitud de capacitaci&oacute;n";
        $("#tipo").val('soc');
    } else if (tipo == "2") {
        titulo = "Brochure de capacitaci&oacute;n";
        $("#tipo").val('cap');
    } else if (tipo == "3") {
        titulo = "Diploma de capacitaci&oacute;n de empleado";
        $("#tipo").val('dip');
    }
    
    if (ocultarBotonGuardar == "1") {
        $("#fileAttachment").attr("disabled", true);
        $("#btnGuardarBrochureCap").hide(); 
    } else {
        $("#fileAttachment").attr("disabled", false);
        $("#btnGuardarBrochureCap").show();
    }
    
    if (ocultarBotonDescargar == "1") {
        $("#btnDescargarBrochureCap").hide();        
    } else {
        $("#btnDescargarBrochureCap").show();
    }
    
    if (nombreArchivoCargado == null) {
        $("#nombreArchivoCargado").html('');
    } else {
        $("#nombreArchivoCargado").html('Archivo cargado: ' + nombreArchivoCargado);
    }
    
    $("#dlgCargarBrochureCap").dialog("open");
    $("#dlgCargarBrochureCap").dialog('option', 'title', titulo);
    $("#idSolicitud").val(capacitacion);
    $("#idSolicitud2").val(solicitud);
    
}

function descargarArchivo() {
    $("#dlgCargarBrochureCap").dialog("close");
    var idSolicitud = $("#idSolicitud").val();
    var idSolicitud2 = $("#idSolicitud2").val();
    var tipo = $("#tipo").val();
    window.open(ruta +"/empleado/Capacitacion?operacion=descargarArchivo&id="+idSolicitud+"&id2="+idSolicitud2+"&tipo="+tipo, "_blank");
}

function obtenerCuentaCapacitacion(codEmpleado, ambito) {
  $.ajax({
      type: "post",
      url:  "Capacitacion",
      data: {"operacion"      : "obtCuentaCapEmpleado",
             "codEmpleado"    : codEmpleado,
             "ambito"         : ambito
            },
      async: false,
      success: function(responseText) {
        if (responseText.indexOf("exito") != -1) {
          $("#txtCuenta").val(responseText.split("|")[1]);        
        }
      },
      complete: function(responseText) {
          
      }
  });
}

function cargarSelectCapacitacionesCreadas(idSelect, idDiv, operacion) {   
    $.ajax({
      type: "post",
      url:  "Capacitacion",
      data: {"operacion"   : operacion,
             "idSelect"    : idSelect,
             "idSolicitud" : $("#hddIdSol").val()
            },
      async: false,
      success: function(responseText) {
        $("#" + idDiv).empty();
        if (responseText.indexOf("exito") != -1) {
          $("#" + idDiv).empty();
          $("#" + idDiv).html(responseText.split("|")[1]);          
        }
      },
      complete: function(responseText) {
          
      }
   });
}