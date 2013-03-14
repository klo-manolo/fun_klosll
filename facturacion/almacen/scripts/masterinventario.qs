/***************************************************************************
                 masterinventario.qs  -  description
                             -------------------
    begin                : mar ago 31 2010
    copyright            : (C) 2010 by KLO Ingeniería Informática S.L.L.
    email                : software@klo.es
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
	var pbnTransferir:Object;
	function oficial( context ) { interna( context ); } 
	function init() { 
		this.ctx.oficial_init();
	}
	function pbnTransferir_clicked() {
		return this.ctx.oficial_pbnTransferir_clicked();
	}
	function transferirStock(idInventario:String):Boolean {
		return this.ctx.oficial_transferirStock(idInventario);
	}
	function transferencia(curLineasInve:FLSqlCursor):Boolean {
		return this.ctx.oficial_transferencia(curLineasInve);
	}
    function lanzar() {
        return this.ctx.oficial_lanzar();
    }
    function nombreInforme() {
        return this.ctx.oficial_nombreInforme();
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
/** \C La tabla de regularizaciones de stocks se muestra en modo de sólo lectura
\end */
function interna_init()
{
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_init()
{
	this.iface.__init();
	this.iface.pbnTransferir = this.child("pbnTransferir");

	connect(this.iface.pbnTransferir, "clicked()", this, "iface.pbnTransferir_clicked()");
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}

function oficial_pbnTransferir_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.valueBuffer("transferido")) {
		MessageBox.warning(util.translate("scripts", "El inventario actual ya está transferido. Puede desmarcarlo y cambiar fecha u hora."), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a transferir el inventario a Regularización de Stock.\n¿Está seguro?"), MessageBox.No, MessageBox.Yes);
	if (res != MessageBox.Yes)
		return true;

	this.iface.transferirStock(cursor.valueBuffer("idinventario"));
}

/** \D Realiza la transferencia desde el inventario a la regularización de stock
@param idInventario: Identificador del inventario desde el que se inicia la transferencia
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function oficial_transferirStock(idInventario:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var curLineasInve:FLSqlCursor = new FLSqlCursor("lineasinventario");

	curLineasInve.select("idinventario = " + idInventario);
	while (curLineasInve.next()) {
		if (!this.iface.transferencia(curLineasInve)) {
			return false;
		}
	}

	return true;
	
}

/** \D Realiza una transferencia stock desde el inventario
@param	curLineasInve: Cursor que contiene los datos de la transferencia a realizar
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function oficial_transferencia(curLineasInve:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	debug("KLO--> transferencia()");
		
	var curInve:FLSqlCursor = this.cursor();
	var codAlmacen:String = curInve.valueBuffer("codalmacen");
	var referencia:String = curLineasInve.valueBuffer("referencia");
	var idStock:Number = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");

	debug("KLO--> codAlmacen: "+codAlmacen);
	debug("KLO--> referencia: "+referencia);
	
	var estado:String;
	
	// Si no tiene una regualización, se crea para, después, poner los datos.
	if (!idStock) {
		debug("KLO--> El articulo: "+referencia+" en almacén: "+codAlmacen+", no tiene regularizacion");
		estado = "N";
		idStock = flfactalma.iface.pub_crearStock(codAlmacen, referencia);
		if (!idStock)
			return false;
		debug("KLO--> Stock creado");
	}

	// Editamos el idStock y actualizamos los datos.
	var curLineaReg:FLSqlCursor = new FLSqlCursor("lineasregstocks");
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", idStock);
		setValueBuffer("fecha", curInve.valueBuffer("fecha"));
		setValueBuffer("hora", curInve.valueBuffer("hora"));
		setValueBuffer("cantidadini", curLineasInve.valueBuffer("stockactual"));
		setValueBuffer("cantidadfin", curLineasInve.valueBuffer("stocknuevo"));
		setValueBuffer("costemediostock", curLineasInve.valueBuffer("costemediostock"));
		setValueBuffer("motivo", util.translate("scripts", "Inventario"));
		if (!commitBuffer())
			return false;
	}
	// Ahora actualizo la cabecera de stock del artículo.
	if (!util.sqlUpdate("stocks", "cantidad", curLineasInve.valueBuffer("stocknuevo"), "idstock = " + idStock)) {
		debug("No se puede actualizar la cantidad (idstock): "+idStock);
		return false;
	}
	if (!util.sqlUpdate("stocks", "costemediostock", curLineasInve.valueBuffer("costemediostock"), "idstock = " + idStock)) {
		debug("No se puede actualizar el coste medio de stock (idstock): "+idStock);
		return false;
	}
	debug("KLO--> Stock actualizado");
	
	with (curInve) {
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("transferido",true);
		if (!commitBuffer())
			return false;
	}
	return true;
}

function oficial_lanzar()
{
    var util:FLUtil = new FLUtil;
    var cursor:FLSqlCursor = this.cursor();
    var argumentos:String = "";
    var where:String = "";
    //var subtitulo:Array = this.iface.construirSubTitulo(cursor);
    var nombreInforme:String = this.iface.nombreInforme();
    if (!nombreInforme) return;
    
    /*if (cursor.valueBuffer("intervalo_diadesde")) {
        where = "tpv_comandas.fecha >= '" + cursor.valueBuffer("intervalo_diadesde") + "'";
    }
    if (cursor.valueBuffer("intervalo_diahasta")) {
        if (where && where!="") where += " AND ";
        where += "tpv_comandas.fecha <= '" + cursor.valueBuffer("intervalo_diahasta") + "'";
    }
    if (cursor.valueBuffer("referencia")) {
        if (where && where!="") where += " AND ";
        where += "articulos.referencia = '" + cursor.valueBuffer("referencia") + "'";
    }
    if (cursor.valueBuffer("codfamilia")) {
        if (where && where!="") where += " AND ";
        where += "familias.codfamilia = '" + cursor.valueBuffer("codfamilia") + "'";
    }
    if (!where || where=="") where = "1=1";
    argumentos = "WHERE=" + where + "\n";
    argumentos += "SUBTITLE=" + subtitulo["fecha"] + "\n";
    if (subtitulo["filtro"])
        argumentos += "FILTER=" + subtitulo["filtro"] + "\n";
    */
	 where = "inventario.idinventario = "+cursor.valueBuffer("idinventario");
	 argumentos = "WHERE="+where+"\n";
    flfactinfo.iface.lanzarJRXML("i_inventarioregu", nombreInforme, argumentos);
}

function oficial_nombreInforme()
{
    var util:FLUtil = new FLUtil;
    var nombre:String = "i_inventarioregu";
    
    return nombre;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////