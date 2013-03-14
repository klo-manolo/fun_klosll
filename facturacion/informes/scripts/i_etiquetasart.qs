/***************************************************************************
                 i_etiquetasart.qs  -  description
-------------------
begin                : jue Marz 12 2010
copyright            : (C) 2010 by KLO Ingeniería Informítica S.L.L.
email                : software@klo.es
partly based on code by
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
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var curPadre_:FLSqlCursor;
   function oficial( context ) { interna( context ); } 
	function init() { this.ctx.oficial_init(); }
	function bufferChanged(fN:String) { this.ctx.oficial_bufferChanged(fN); }
	function generaDatos() { this.ctx.oficial_generaDatos(); }
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
function interna_init()
{
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_init()
{
	this.iface.__init();

	connect(this.child("btnImprimeEti"), "clicked()", this, "iface.generaDatos()");
	
	var cursor:FLSqlCursor = this.cursor();
	if(cursor.valueBuffer("pvpmanual")) {
		this.child("fdbCodTarifa").setDisabled(true);
	}else {
		this.child("fdbCodTarifa").setDisabled(false);
	}
	if(cursor.valueBuffer("cantidadpre")) {
		this.child("fdbCantidadEti").setDisabled(true);
	}else {
		this.child("fdbCantidadEti").setDisabled(false);
	}
	
	this.child("pushButtonFirst").setDisabled(true);
	this.child("pushButtonPrevious").setDisabled(true);
	this.child("pushButtonNext").setDisabled(true);
	this.child("pushButtonLast").setDisabled(true);
	this.child("pushButtonAcceptContinue").setDisabled(true);
	
	debug("KLO--> curPadre_: "+this.iface.curPadre_.table());
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN){
		case "pvpmanual":{
			if(cursor.valueBuffer("pvpmanual")) {
				this.child("fdbCodTarifa").setDisabled(true);
			}else {
				this.child("fdbCodTarifa").setDisabled(false);
			}
			break;
		}
		case "cantidadpre":{
			if(cursor.valueBuffer("cantidadpre")) {
				this.child("fdbCantidadEti").setDisabled(true);
			}else {
				this.child("fdbCantidadEti").setDisabled(false);
			}
			break;
		}
	}
}

function oficial_generaDatos()
{
	var util:FLUtil;
	var curPadre:FLSqlCursor = this.iface.curPadre_;
	var tablaPadre:String = this.iface.curPadre_.table();
	var cantidad:Number = this.cursor().valueBuffer("cantidadeti");
	if (!cantidad) {
		return false;
	}
	debug("KLO--> tablaPadre: "+tablaPadre);
	
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	switch(tablaPadre){
		case "articulos":{
			for (var i:Number = 0; i < cantidad; i++) {
				eRow = xmlKD.createElement("Row");
				eRow.setAttribute("barcode", curPadre.valueBuffer("codbarras"));
				eRow.setAttribute("referencia", curPadre.valueBuffer("referencia"));
				eRow.setAttribute("descripcion", curPadre.valueBuffer("descripcion"));
				eRow.setAttribute("pvp", curPadre.valueBuffer("pvp"));
				eRow.setAttribute("nomsubfamilia", util.sqlSelect("subfamilias","descripcion","codsubfamilia = '" + curPadre.valueBuffer("codsubfamilia") + "'"));
				eRow.setAttribute("level", 0);
				xmlKD.firstChild().appendChild(eRow);
				debug("KLO--> Dato de etiqueta: "+curPadre.valueBuffer("referencia"));
			}
			break;
		}
		case "albaranesprov":{
			var qryLineas:FLSqlQuery = new FLSqlQuery();
			with (qryLineas) {
				setTablesList("lineasalbaranesprov,articulos");
				setSelect("la.referencia, la.cantidad, la.descripcion, a.codbarras, a.pvp");
				setFrom("lineasalbaranesprov la LEFT OUTER JOIN articulos a ON la.referencia = a.referencia");
				setWhere("idalbaran = " + curPadre.valueBuffer("idalbaran") + " ORDER BY referencia");
				setForwardOnly(true);
			}
			if (!qryLineas.exec()) {
				return false;
			}
			while (qryLineas.next()) {
				if (this.cursor().valueBuffer("cantidadpre"))
					cantidad = parseInt(qryLineas.value("la.cantidad"));
				for (var i:Number = 0; i < cantidad; i++) {
					eRow = xmlKD.createElement("Row");
					eRow.setAttribute("barcode", qryLineas.value("a.codbarras"));
					eRow.setAttribute("referencia", qryLineas.value("la.referencia"));
					eRow.setAttribute("descripcion", qryLineas.value("la.descripcion"));
					eRow.setAttribute("pvp", qryLineas.value("a.pvp"));
					eRow.setAttribute("level", 0);
					xmlKD.firstChild().appendChild(eRow);
				}
			}
		}
	}
	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
