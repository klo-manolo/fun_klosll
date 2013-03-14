/***************************************************************************
                 i_mastertarifasarticulos.qs  -  description
                             -------------------
    begin                : mar oct 14 2008
    copyright            : (C) 2008 by KLO Ingeniería Informática S.L.L.
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
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function obtenerOrden(cursor:FLSqlCursor):String {
		return this.ctx.oficial_obtenerOrden(cursor);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration klo */
//////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends oficial {
	function klo( context ) { oficial( context ); } 
	function rellenarTabla() { return this.ctx.klo_rellenarTabla(); }
	function lanzar() {
		return this.ctx.klo_lanzar();
	}
	function nombreTarifa(codTarifa:String):String {
		return this.ctx.klo_nombreTarifa(codTarifa);
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
	function pub_lanzar() {
		return this.lanzar();
	}
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
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	
	this.iface.rellenarTabla();

	var nombreInforme:String = cursor.action();
	var orderBy:String = "";
	var o:String = "";
	
	o = this.iface.obtenerOrden(cursor);
	if (o) {
		if (orderBy == "")
			orderBy = o;
		else
			orderBy += ", " + o;
	}
	flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy);
}

function oficial_obtenerOrden(cursor:FLSqlCursor):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden");
	
	switch(orden) {
		case "Código": {
			ret += "articulos.referencia";
			break;
		}
		case "Nombre": {
			ret += "articulos.descripcion";
			break;
		}
	}
	
	if (ret != "") {
		var tipoOrden:String = cursor.valueBuffer("tipoorden");
		switch(tipoOrden) {
			case "Descendente": {
				ret += " DESC";
				break;
			}
		}
	}
	return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
//////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
function klo_lanzar()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
	var nombreInforme:String = cursor.action();

	this.iface.rellenarTabla();
	
	var q:FLSqlQuery = new FLSqlQuery("i_tarifasarticulos");
	
	debug("------ CONSULTA LANZAR -------" + q.sql());

	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (!q.first())  {
		MessageBox.warning(util.translate("scripts", "No hay datos para los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	flfactinfo.iface.setIdInforme(seleccion);

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_tarifasarticulos");
	rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();
}

function klo_rellenarTabla()
{
	var util:FLUtil = new FLUtil();
	var curTA:FLSqlCursor = new FLSqlCursor("i_tarifasarticulos_buffer");
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String;
	var descripcion:String;
	var pvpFijo:String;
	var codImpuesto:String;
	var iva:Number;
	var recargo:Number;
	var tarifa1:Number;
	var tarifa2:Number;
	
	if (!util.sqlDelete("i_tarifasarticulos_buffer", "1 = 1"))
		return false;
	
	var where:String = "";

	if (cursor.valueBuffer("d_secciones_codseccion")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codseccion >= '"+cursor.valueBuffer("d_secciones_codseccion")+"'";
	}
	if (cursor.valueBuffer("h_secciones_codseccion")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codseccion <= '"+cursor.valueBuffer("h_secciones_codseccion")+"'";
	}
	if (cursor.valueBuffer("d_familias_codfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codfamilia >= '"+cursor.valueBuffer("d_familias_codfamilia")+"'";
	}
	if (cursor.valueBuffer("h_familias_codfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codfamilia <= '"+cursor.valueBuffer("h_familias_codfamilia")+"'";
	}
	if (cursor.valueBuffer("d_subfamilias_codsubfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codsubfamilia >= '"+cursor.valueBuffer("d_subfamilias_codsubfamilia")+"'";
	}
	if (cursor.valueBuffer("h_subfamilias_codsubfamilia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.codsubfamilia <= '"+cursor.valueBuffer("h_subfamilias_codsubfamilia")+"'";
	}
	if (cursor.valueBuffer("d_articulos_referencia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.referencia >= '"+cursor.valueBuffer("d_articulos_referencia")+"'";
	}
	if (cursor.valueBuffer("h_articulos_referencia")) {
		if (where != "")
			where = where+" AND ";
		where = where+"a.referencia <= '"+cursor.valueBuffer("h_articulos_referencia")+"'";
	}

	if (where != "")
		where = where+" AND ";
	where = where+"a.debaja = '"+cursor.valueBuffer("mostrardebaja")+"'";

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("articulos");
	qry.setSelect("a.referencia, a.descripcion, a.usarpvp, a.codimpuesto");
	qry.setFrom("articulos a");
	qry.setWhere(where);
	debug("------ CONSULTA KLO ARTICULOS -------" + qry.sql());
	
	if (!qry.exec()) {
		debug("NO Ha ejecutado qry");
		return false;
	}

	var paso:Number = 0;
	util.createProgressDialog( util.translate( "scripts", "Calculando tarifas de artículos..." ), qry.size());
	while (qry.next()) {
		util.setProgress(paso++);
		referencia = qry.value("a.referencia");
		descripcion = qry.value("a.descripcion");
		if (qry.value("a.usarpvp"))
			pvpFijo = "F";
		else
			pvpFijo = "";
		codImpuesto = qry.value("a.codimpuesto");
		iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '"+codImpuesto+"'");
		recargo = util.sqlSelect("impuestos", "recargo", "codimpuesto = '"+codImpuesto+"'");
		if (cursor.valueBuffer("codtarifa1"))
			tarifa1 = formRecordarticulos.iface.pub_obtenerPrecioTarifa(referencia, cursor.valueBuffer("codtarifa1"));
		else
			tarifa1 = 0;
		if (cursor.valueBuffer("codtarifa2"))
			tarifa2 = formRecordarticulos.iface.pub_obtenerPrecioTarifa(referencia, cursor.valueBuffer("codtarifa2"));
		else
			tarifa2 = 0;
		
		curTA.setModeAccess(curTA.Insert);
		curTA.refreshBuffer();
		curTA.setValueBuffer("referencia", referencia);
		curTA.setValueBuffer("descripcion", descripcion);
		curTA.setValueBuffer("pvpfijo", pvpFijo);
		curTA.setValueBuffer("iva", iva);
		curTA.setValueBuffer("recargo", recargo);
		curTA.setValueBuffer("tarifa1", tarifa1);
		curTA.setValueBuffer("tarifa2", tarifa2);
		curTA.commitBuffer();
	}
	util.destroyProgressDialog();
	
	return true;
}
//// KLO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
