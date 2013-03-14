/***************************************************************************
                 tarifas.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    function calculateCounter() { return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration klo */
//////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends oficial 
{
	var tblPreciosTarifas:QTable;

	function klo( context ) { oficial( context ); } 

	function init() { this.ctx.klo_init(); }
	function bufferChanged(fN:String) {
		return this.ctx.klo_bufferChanged(fN);
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.klo_commonBufferChanged(fN, miForm);
	}
}
//// KLO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends klo {
    function head( context ) { klo ( context ); }
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
function interna_calculateCounter()
{
/*
		var util:FLUtil = new FLUtil();
		return = util.nextCounter("codtarifa", this.cursor());
*/
		return ;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////

/** \C Crea la tabla temporal con los precios del art�culo seg�n las tariofas y desabilita la llamada al bot�n pbnGenerarArticulosTarifas. Este bot�n se quita porque en lugar de esto hay un grid sin tabla para visualizar los precios seg�n las tarifas calculados en el instante de entrar en la ficha del art�culo.
\end */
function klo_init()
{
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");

	// En caso de ser tarifa basada en otra, desactiva los controles normales.
	if (this.cursor().valueBuffer("tarifabase")!="") {
		this.child("fdbIncPorcentual").setDisabled(true);
		this.child("tdbMargenesTarifas").setReadOnly(true);
	}
}

function klo_bufferChanged(fN:String)
{
	this.iface.commonBufferChanged(fN, form);
		/** \C
	Al poner un valor en tarifa asociada se desactivan el campo de % por defecto y la tabla de art�culos pertenecientes a la tarifa actual.
	\end */
}

function klo_commonBufferChanged(fN:String, miForm:Object)
{
	switch (fN) {
		case "tarifabase":{
			if (this.cursor().valueBuffer("tarifabase")!="") {
				this.child("fdbIncPorcentual").setDisabled(true);
				this.child("tdbMargenesTarifas").setReadOnly(true);
			}
			break;
		}
	}
}

//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////