/***************************************************************************
                 masterrecalculostockmin.qs  -  description
                             -------------------
    begin                : mar 09 09 2008
    copyright            : (C) 2008 by KLO IngenierÃ­a InformÃ¡tica S.L.L.
    email                : software@klo.es
    partly based on code by
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
 /***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  tÃ©rminos  de  la  Licencia  PÃºblica General de GNU   en  su
   versiÃ³n 2, publicada  por  la  Free  Software Foundation.
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
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration klo */
//////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends oficial {
	function klo( context ) { oficial( context ); } 
	function lanzar() {
		return this.ctx.klo_lanzar();
	}
	function calcularUdVendidas(referencia:String):Number {
		return this.ctx.klo_calcularUdVendidas(referencia);
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
function interna_init()
{
	connect (this.child("toolButtonEjecutar"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
//////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
function klo_lanzar()
{
	var util:FLUtil = new FLUtil;
	
	var res:Number = MessageBox.information(util.translate("scripts", "Se va a actualizar el stock mínimo de los artículos filtrados. \nEsto sobreescribirá cualquier stock mínimo que haya sido modificado manualmente.\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;

	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
	var where:String = "";

	if (cursor.valueBuffer("d_secciones_codseccion")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codseccion >= '"+cursor.valueBuffer("d_secciones_codseccion")+"'";
	}
	if (cursor.valueBuffer("h_secciones_codseccion")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codseccion <= '"+cursor.valueBuffer("h_secciones_codseccion")+"'";
	}
	if (cursor.valueBuffer("d_familias_codfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codfamilia >= '"+cursor.valueBuffer("d_familias_codfamilia")+"'";
	}
	if (cursor.valueBuffer("h_familias_codfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codfamilia <= '"+cursor.valueBuffer("h_familias_codfamilia")+"'";
	}
	if (cursor.valueBuffer("d_subfamilias_codsubfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codsubfamilia >= '"+cursor.valueBuffer("d_subfamilias_codsubfamilia")+"'";
	}
	if (cursor.valueBuffer("h_subfamilias_codsubfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"codsubfamilia <= '"+cursor.valueBuffer("h_subfamilias_codsubfamilia")+"'";
	}
	if (cursor.valueBuffer("d_articulos_referencia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"referencia >= '"+cursor.valueBuffer("d_articulos_referencia")+"'";
	}
	if (cursor.valueBuffer("h_articulos_referencia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"referencia <= '"+cursor.valueBuffer("h_articulos_referencia")+"'";
	}

	var diasPrevision:Number = cursor.valueBuffer("diasprevision");
	var dfecha:Date = cursor.valueBuffer("dfecha");
	var hfecha:Date = cursor.valueBuffer("hfecha");
	var diasIntervalo:Number = util.daysTo(dfecha, hfecha);
	var query:FLSqlQuery = new FLSqlQuery();
	
	if (diasIntervalo == 0)
		diasIntervalo = 1;
	
	query.setTablesList("articulos");
	query.setSelect("referencia");
	query.setFrom("articulos");
	if (where != "")
		query.setWhere(where+";");
	
	debug("KLO--> query: "+query.sql());

	if (!query.exec()) {
		debug("query no ejecutado");
		return;
	}
	
	var paso:Number = 0;
	util.createProgressDialog( util.translate( "scripts", "Calculando stock mínimo automático..." ), query.size());

	var udVendidas:Number = 0;
	var stockMiniCalc:Number = 0;
	while (query.next()) {
		util.setProgress(paso++);
		udVendidas = this.iface.calcularUdVendidas(query.value(0));
		//debug("udVendidas: "+udVendidas+" diasIntervalo: "+diasIntervalo+" diasprevision: "+cursor.valueBuffer("diasprevision"));
		stockMiniCalc = util.roundFieldValue((udVendidas/diasIntervalo)*cursor.valueBuffer("diasprevision"), "articulos", "stockmin");
		util.sqlUpdate("articulos", "stockmin", stockMiniCalc, "referencia = '"+query.value(0)+"'");
	}
	util.destroyProgressDialog();

	return;
}

/** Calcula el stock mínimo estimado según la fórmula aplicada.
Devuelve el valor calculado del stock mínimo.
**/
function klo_calcularUdVendidas(referencia:String):Number
{
	var sumCantidad:Number = 0;
	var cursor:FLSqlCursor = this.cursor();
	var where:String = "";
	
	where = "albaranescli.codalmacen = '"+cursor.valueBuffer("codalmacen")+"' AND lineasalbaranescli.referencia = '"+referencia+"'";
	
	if (cursor.valueBuffer("dfecha") && cursor.valueBuffer("hfecha")) {
		if (where != "")
			where = where+" AND ";
		where = where+"albaranescli.fecha >= '"+cursor.valueBuffer("dfecha")+"' AND albaranescli.fecha <= '"+cursor.valueBuffer("hfecha")+"'";
	}

	// Suma las unidades vendidas en los albaranes de venta.
	var qryCant:FLSqlQuery = new FLSqlQuery();
	qryCant.setTablesList("albaranescli");
	qryCant.setSelect("sum(lineasalbaranescli.cantidad)");
	qryCant.setFrom("albaranescli inner join lineasalbaranescli on albaranescli.idalbaran = lineasalbaranescli.idalbaran");
	qryCant.setWhere(where);
	//debug("CalcularUdVendidas: "+qryCant.sql());
	
	if (!qryCant.exec()) {
		debug("qryCant2 no ejecutado");
		return 0;
	}
	
	if (qryCant.next())
		sumCantidad = qryCant.value(0);
	if (sumaCantidad = "")
		sumaCantidad = 0;

	//debug("udVendidas: "+sumCantidad);
	return sumCantidad;
}
//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////