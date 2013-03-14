/***************************************************************************
                 tpv_dtocomandatactil.qs  -  description
                             -------------------
    begin                : mie nov 15 2006
    copyright            : Por ahora (C) 2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { 
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var porDto_:Number;
	var botones:Object;
	function oficial( context ) { interna( context ); }
	function modificarDescuento(numero:Number) {
		return this.ctx.oficial_modificarDescuento(numero);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C Se muestra el importe pendiente de pago seleccionado. Al pulsar Intro o Return el formulario se cerrar� con el importe que el usuario haya establecido.
*/
function interna_init()
{
	this.iface.porDto_ = this.cursor().valueBuffer("pordto");

	this.iface.botones = this.child("botones");
	connect(this.iface.botones, "clicked(int)", this, "iface.modificarDescuento");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_modificarDescuento(numero:Number)
{
	var util:FLUtil;
debug("numero " + numero);
	var cursor:FLSqlCursor = this.cursor();
	if(numero == 11) {
		cursor.setValueBuffer("pordto", 0);
		return;
	}

	var valor:Number = parseFloat(cursor.valueBuffer("pordto"));
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
debug("valor antes " + valor);
	var cantidad:String = "";
	if(valor && valor > 0) {
		valor = parseInt(valor*100);
		cantidad = valor.toString();
		while(cantidad.startsWith("0"))
			cantidad = cantidad.right(cantidad.length-1);
	}
debug("cantidad antes " + cantidad);
	if (numero == 10) {
		cantidad = cantidad + "00";
	} else {
		cantidad = cantidad + numero.toString();
	}
debug("cantidad despues " + cantidad);
	valor = parseInt(cantidad) / 100;
debug("valor despues " + valor);
	
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
	cursor.setValueBuffer("pordto",valor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
