/***************************************************************************
                 margenestarifas.qs  -  description
                             -------------------
    begin                : vie marzo 20 2009
    copyright            : (C) 2008 by KLO Ingeniería Informática S.L.L.
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
	var llamadaAlbaran:Boolean;
	var datosAlbaran:Array;

	function klo( context ) { oficial( context ); } 

	function init() { this.ctx.klo_init(); }
	
	// Con estas dos funciones sabremos si llama desde albarán y los datos que pasa.
	function establecerLlamadaAlbaran(a:Boolean) {
		return this.ctx.klo_establecerLlamadaAlbaran(a);
	}
	function establecerDatosAlbaran(a:Array) {
		return this.ctx.klo_establecerDatosAlbaran(a);
	}
	
	function calculateField(fN:String):String {
		return this.ctx.klo_calculateField(fN);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.klo_commonCalculateField(fN, cursor);
	}

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

/** @class_declaration pubklo */
/////////////////////////////////////////////////////////////////
//// PUBKLO /////////////////////////////////////////
class pubklo extends head {
	function pubklo( context ) { head( context ); }
	
	function pub_establecerLlamadaAlbaran(a:Boolean) {
		return this.establecerLlamadaAlbaran(a);
	}
	function pub_establecerDatosAlbaran(a:Array) {
		return this.establecerDatosAlbaran(a);
	}
}
//// PUBKLO /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubklo {
    function ifaceCtx( context ) { pubklo( context ); }
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

/** \C Controla que la tarifa sea de precio fijo o de porcentaje. En caso de ser de precio fijo, deshabilita el campo de porcentaje y al poner un precio calcula el porcentaje que sería según el precio dado con relación al último coste.
\end */
function klo_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.iface.bufferChanged("pvpfijo");

	cursor.setValueBuffer("benecosultimo", this.iface.calculateField("margenbeneficiocompra"));
	cursor.setValueBuffer("benecosmedstock", this.iface.calculateField("margenbeneficiocms"));
}

function klo_establecerLlamadaAlbaran(a:Boolean)
{
	this.iface.llamadaAlbaran = a;
}

function klo_establecerDatosAlbaran(a:Array)
{
	this.iface.datosAlbaran = a;
}

function klo_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
}

function klo_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	
	switch (fN) {
		case "margenbeneficiocompra": {
			var referencia:String = cursor.valueBuffer("referencia");
			if (referencia) {
				var costeUltimo:Number;
				if (this.iface.llamadaAlbaran)
					costeUltimo = this.iface.datosAlbaran.pvpunitario;
				else
					costeUltimo = util.sqlSelect("articulos","costeultimo","referencia = '"+referencia+"'");
				var codTarifa:String = cursor.valueBuffer("codtarifa");
				precioVenta = this.iface.commonCalculateField("precioventa", cursor);
				valor = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
			}
			else {
				valor = "";
			}
			break;
		}
		case "margenbeneficiocms": {
			var referencia:String = cursor.valueBuffer("referencia");
			if (referencia) {
				var ultCMS:Number;
				var CMS:Number = formRecordlineaspedidosprov.iface.pub_commonCalculateField("costemediostock", cursor);
				if (!CMS)
					CMS = 0;
				if (this.iface.llamadaAlbaran) {
					var stockFis:Number = util.sqlSelect( "articulos", "stockfis", "referencia = '" + referencia + "'");
					ultCMS = ((CMS*stockFis)+(this.iface.datosAlbaran.pvpunitario*this.iface.datosAlbaran.cantidad)) / (stockFis+this.iface.datosAlbaran.cantidad);
					ultCMS = util.roundFieldValue(ultCMS, "articulos", "costemediostock");
				}
				else
					ultCMS = CMS;
				var codTarifa:String = cursor.valueBuffer("codtarifa");
				precioVenta = this.iface.commonCalculateField("precioventa", cursor);
				valor = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
			}
			else {
				valor = "";
			}
			break;
		}
		case "precioventa": {
			var referencia:String = cursor.valueBuffer("referencia");
			if (cursor.valueBuffer("pvpfijo")) {
				valor = cursor.valueBuffer("pvp");
			}
			else {
				var codTarifa:String = cursor.valueBuffer("codtarifa");
				var tarifaBase:String = util.sqlSelect("tarifas", "tarifabase", "codtarifa = '" + codTarifa + "'");
				var incSobreBase:Number = 0;
				// Mira si la tarifa esta basada en otra.
				if (tarifaBase) {
					incSobreBase = util.sqlSelect("tarifas", "incsobrebase", "codtarifa = '" + codTarifa + "'");
					codTarifa = tarifaBase;
				}
				var incPorcentual:Number = cursor.valueBuffer("incporcentual");
				var costeArticulo:Number;
				var tipoCoste:Number = util.sqlSelect("tarifas", "origencoste", "codtarifa = '" + codTarifa + "'");
				var redondeo:Boolean = util.sqlSelect("tarifas", "redondeo", "codtarifa = '" + codTarifa + "'");
				// El default es el último coste.
				switch(tipoCoste) {
					case "Precio medio de compra": {
						costeArticulo = util.sqlSelect("articulos", "costemedio", "referencia = '" + referencia + "'");
						break;
					}
					case "Precio medio de stock": {
						var ultCMS:Number;
						var CMS:Number = formRecordlineaspedidosprov.iface.pub_commonCalculateField("costemediostock", cursor);
						if (!CMS)
							CMS = 0;
						if (this.iface.llamadaAlbaran) {
							var stockFis:Number = util.sqlSelect( "articulos", "stockfis", "referencia = '" + referencia + "'");
							ultCMS = ((CMS*stockFis)+(this.iface.datosAlbaran.pvpunitario*this.iface.datosAlbaran.cantidad)) / (stockFis+this.iface.datosAlbaran.cantidad);
							ultCMS = util.roundFieldValue(ultCMS, "articulos", "costemediostock");
						}
						else
							ultCMS = CMS;
						costeArticulo = CMS;
						break;
					}
					default: {
						if (this.iface.llamadaAlbaran)
							costeArticulo = this.iface.datosAlbaran.pvpunitario;
						else
							costeArticulo = util.sqlSelect("articulos","costeultimo","referencia = '"+referencia+"'");
						break;
					}
				}
				valor = (costeArticulo*(incPorcentual/100))+costeArticulo;
				valor = (valor*(incSobreBase/100))+valor;
				// Si está activado el redondeo a 0 y 5
				if (redondeo) {
					valor = this.iface.redondeoDecimal(valor);
				} else {
					valor = util.roundFieldValue(valor, "articulos", "pvp");
				}
			}
			break;
		}
	}
	return valor;
}

function klo_bufferChanged(fN:String)
{
	this.iface.commonBufferChanged(fN, form);
}

function klo_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "pvpfijo":
			if (cursor.valueBuffer("pvpfijo")) {
				this.child("fdbIncPorcentual").setDisabled(true);
				this.child("fdbPvp").setDisabled(false);
			}
			else {
				this.child("fdbIncPorcentual").setDisabled(false);
				this.child("fdbPvp").setDisabled(true);
			}
			break;
		case "pvp":
			if (cursor.valueBuffer("pvpfijo")) {
				if (cursor.valueBuffer("referencia")) {
					var pvp:Number = cursor.valueBuffer("pvp");
					var coste:Number = util.sqlSelect("articulos", "costeultimo", "referencia = '" + cursor.valueBuffer("referencia") + "'");
					var incPorcentual:Number;
					if (coste > 0)
						incPorcentual= ((pvp - coste)/coste)*100;
					else
						incPorcentual = 0;
					cursor.setValueBuffer("incporcentual",incPorcentual);
				}
			}
			cursor.setValueBuffer("benecosultimo", this.iface.calculateField("margenbeneficiocompra"));
			cursor.setValueBuffer("benecosmedstock", this.iface.calculateField("margenbeneficiocms"));
			break;
		case "incporcentual":
			cursor.setValueBuffer("benecosultimo", this.iface.calculateField("margenbeneficiocompra"));
			cursor.setValueBuffer("benecosmedstock", this.iface.calculateField("margenbeneficiocms"));
			break;
	}
}

//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////