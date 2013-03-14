/***************************************************************************
                 tpv_lineascomanda.qs  -  description
                             -------------------
    begin                : lun ago 19 2005
    copyright            : Por ahora (C) 2005 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function desconectar() {
			return this.ctx.oficial_desconectar();
	}
	function bufferChanged(fN:String) {
			return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularPvpTarifa(referencia:String, codTarifa:String):Number {
		return this.ctx.oficial_calcularPvpTarifa(referencia, codTarifa);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO //////// ///////////////////////////////////////
class ivaIncluido extends oficial {
	var bloqueoPrecio:Boolean;
    function ivaIncluido( context ) { oficial( context ); } 	
	function init() {
		return this.ctx.ivaIncluido_init();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
	}
	function bufferChanged(fN:String) {
		return this.ctx.ivaIncluido_bufferChanged(fN);
	}
}
//// IVA INCLUIDO //////// ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends ivaIncluido 
{
	var ledCodigoDeBarras:Object;

	function klo( context ) { ivaIncluido ( context ); }
    
	function init() {
		return this.ctx.klo_init();
	}

	function codigodebarrasSet() {
		return this.ctx.klo_codigodebarrasSet();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.klo_commonCalculateField(fN, cursor);
	}
	function calcularPvpTarifa(referencia:String, codTarifa:String, cursor:FLSqlCursor):Number {
		return this.ctx.klo_calcularPvpTarifa(referencia, codTarifa, cursor);
	}
}
//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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
	function pub_calcularPvpTarifa(referencia:String, codTarifa:String):Number {
		return this.calcularPvpTarifa(referencia, codTarifa);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");

	if (cursor.modeAccess() == cursor.Insert)
		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
}

function interna_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	return formRecordlineaspedidoscli.iface.pub_commonCalculateField(fN, cursor);
	
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		/** \C
		El --pvpunitario-- se calcula como el pvp establecido para el art�culo seleccionado
		*/
		case "pvpunitario":{
			valor = this.iface.calcularPvpTarifa(cursor.valueBuffer("referencia"), cursor.cursorRelation().valueBuffer("codtarifa"));
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
			break;
		}
		/** \C
		El --pvpsindto-- es el el --pvpunitario-- multiplicado por la --cantidad--
		*/
		case "pvpsindto":{
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpsindto");
			break;
		}
		case "iva":{
			var fecha:String;
			var curComanda:FLSqlCursor = cursor.cursorRelation();
			if (curComanda) {
				fecha = curComanda.valueBuffer("fecha");
			} else {
				fecha = util.sqlSelect("tpv_comandas", "fecha", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
			}
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuesto"), fecha);
			if (!valor) {
				valor = 0;
			}
			break;
		}
		/** \C
		El descuento se calcula como el --pvpsindto-- por el porcentaje de descuento
		*/
		case "lbldtopor":{
			valor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpsindto");
			break;
		}
		/** \C
		El --pvptotal-- es el --pvpsindto-- menos el descuento menos el descuento lineal
		*/
		case "pvptotal": {
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "tpv_lineascomanda", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
		case "dtopor":{
			valor = cursor.valueBuffer("dtopor");
			break;
		}
		case "codimpuesto": {
			var codSerie:String = "";
			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, cursor.cursorRelation().valueBuffer("codcliente"))) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			}
			else {
				valor = "";
			}
			break;
		}
	}
	return valor;
}

/** \D
Desconecta la funci�n bufferChanged conectada en el init
*/
function oficial_desconectar()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
	return formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
	
	switch (fN) {
		/** \C
		Al cambiar la referencia se recalculan el --pvpunitario-- y el --codimpuesto--
		*/
		case "referencia":{
			this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
			this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto"));
			break;
		}
		/** \C
		Al cambiar el --codimpuesto-- se recalcula el porcentaje de iva que se aplicar�
		*/
		case "codimpuesto":{
			this.child("fdbIva").setValue(this.iface.calculateField("iva"));
			break;
		}
		/** \C
		Al cambiar la --cantidad-- o el --pvpunitario-- se recalcula el --pvpsindto--
		*/
		case "cantidad":
		case "pvpunitario":{
			this.child("fdbPvpSinDto").setValue(this.iface.calculateField("pvpsindto"));
			break;
		}
		case "pvpsindto":
		case "dtopor":{
			this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
		}
		/** \C
		Al cambiar el --dtolineal-- se recalcula el --pvptotal--
		*/
		case "dtolineal":{
			this.child("fdbPvpTotal").setValue(this.iface.calculateField("pvptotal"));
			break;
		}
	}
}

/** \D
Calcula el --pvpunitario-- aplicandole la tarifa establecida el el formulario de edici�n de comandas
@param referencia identificador del art�uclo
@param codTarifa identificador de la tarifa
@return devuelve el pvp del articulo con la tarifa apliada si la tiene o el pvp del art�culo si no hay ninguna tarifa especificada
*/
function oficial_calcularPvpTarifa(referencia:String, codTarifa:String):Number
{
	var util:FLUtil = new FLUtil();
	var pvp:Number;

	if (codTarifa)
		pvp = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
		
	if (!pvp)
		pvp = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
	
	return pvp;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO //////// ////////////////////////////////////////
function ivaIncluido_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "referencia": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
			
// 			if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
// 				this.child("fdbBarCode").setFilter("");
// 			else
// 				this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
// 			
// 			this.iface.bloqueoPrecio = true;
// 			this.child("fdbIvaIncluido").setValue(this.iface.commonCalculateField("ivaincluido", this.cursor()));
// 			this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", this.cursor()));
// 			this.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", this.cursor()));
// 			cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
// 			this.iface.bloqueoPrecio = false;
			break;
		}
		case "codimpuesto": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			this.child("fdbIva").setValue(this.iface.commonCalculateField("iva", this.cursor()));
// 			if (!this.iface.bloqueoPrecio) {
// 				this.iface.bloqueoPrecio = true;
// 				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
// 				this.iface.bloqueoPrecio = false;
// 			}
			break;
		}
		case "ivaincluido": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			if (this.cursor().valueBuffer("ivaincluido")) {
// 				this.child("fdbPvpUnitario").setDisabled(true);
// 				this.child("fdbPvpUnitarioIva").setDisabled(false);
// 			}
// 			else {			
// 				this.child("fdbPvpUnitario").setDisabled(false);
// 				this.child("fdbPvpUnitarioIva").setDisabled(true);
// 			}
		}
		case "pvpunitarioiva": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			if (!this.iface.bloqueoPrecio) {
// 				this.iface.bloqueoPrecio = true;
// 				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
// 				this.iface.bloqueoPrecio = false;
// 			}
			break;
		}
		case "pvpunitario": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			if (!this.iface.bloqueoPrecio) {
// 				this.iface.bloqueoPrecio = true;
// 				this.child("fdbPvpUnitarioIva").setValue(this.cursor().valueBuffer("pvpunitarioiva"));
// 				this.iface.bloqueoPrecio = false;
// 			}
		}
		case "cantidad": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			if (cursor.valueBuffer("ivaincluido")) {
// 				cursor.setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto", this.cursor()));
// 			} else {
// 				return this.iface.__bufferChanged(fN);
// 			}
			break;
		}
		case "pvpsindto":
		case "dtopor": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			this.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", this.cursor()));
		}
		case "dtolineal": {
			formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 			if (cursor.valueBuffer("ivaincluido")) {
// 				cursor.setValueBuffer("pvptotal", this.iface.commonCalculateField("pvptotal", this.cursor()));
// 			} else {
// 				return this.iface.__bufferChanged(fN);
// 			}
			break;
		}
		default:
			return this.iface.__bufferChanged(fN);
	}
}

function ivaIncluido_commonCalculateField(fN, cursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");

	switch (fN) {
		case "pvpunitarioiva":
		case "pvpunitarioiva2":
		case "pvpunitario2":
		case "pvpsindto":
		case "ivaincluido":
		case "pvptotal": {
			valor = formRecordlineaspedidoscli.iface.commonCalculateField(fN, cursor);
			break;
		}
		default: {
			return this.iface.__commonCalculateField(fN, cursor);
		}
	}
	/*
		
		case "pvpunitarioiva":
			valor = this.iface.__commonCalculateField("pvpunitario", cursor);
			break;
		case "pvpunitarioiva2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				iva = recargo;
			}
			iva += parseFloat(recargo);
			valor = cursor.valueBuffer("pvpunitario") * ((100 + iva) / 100);
			break;
		}
		case "pvpunitario2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				iva = recargo;
			}
			iva += parseFloat(recargo);
			valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) / ((100 + iva) / 100);
			break;
		}
		
		case "pvpunitario": {
			valor = cursor.valueBuffer("pvpunitarioiva");
debug("valor " + valor );
			if (cursor.valueBuffer("ivaincluido")) {
				var iva:Number = cursor.valueBuffer("iva");
debug("iva " + iva );
debug("codimpuesto " + cursor.valueBuffer("codimpuesto") );
				if (!iva) {
					iva = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuesto"), cursor.cursorRelation().valueBuffer("fecha"));
debug("iva2 " + iva );
				}
				valor = parseFloat(valor) / (1 + iva / 100);
debug("valor2 " + valor );
			}
			break;
		}
		case "pvpsindto": {
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			break;
		}
		case "ivaincluido": {
			valor = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
			break;
		}
		case "referencia": {
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
			break;
		}
	
		case "pvptotal": {
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			//dtoPor = util.roundFieldValue(dtoPor, "tpv_lineascomanda", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
		
		default: {
			return this.iface.__commonCalculateField(fN, cursor);
		}
	}*/
debug("Calcula " + fN + " = " + valor);
	
	return valor;
}

function ivaIncluido_init()
{
	this.iface.__init();
	
	this.child("fdbRecargo").close();
	this.child("fdbIRPF").close();
	formRecordlineaspedidoscli.iface.pub_habilitarPorIvaIncluido(form);
}
//// IVAINCLUIDO //////// ////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
function klo_init()
{
	this.iface.__init();
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.ledCodigoDeBarras = this.child("ledCodigoDeBarras");

	connect(this.iface.ledCodigoDeBarras, "returnPressed()", this, "iface.codigodebarrasSet");

	this.iface.ledCodigoDeBarras.text = "";
}

/** \D
Busca el c�digo de barras en la tabla de codigosdebarras
\end */
function klo_codigodebarrasSet()
{
	debug("codigodebarrasset");
	var util:FLUtil = new FLUtil;
	
	var refArticulo:String = util.sqlSelect( "codigosdebarras", "referencia", "codigodebarras = '" + this.iface.ledCodigoDeBarras.text + "'");
	var cantArticulo:Number = util.sqlSelect( "codigosdebarras", "unidades", "codigodebarras = '" + this.iface.ledCodigoDeBarras.text + "'");

	if (refArticulo)  {
		this.child("fdbReferencia").setValue(refArticulo);
		this.child("fdbCantidad").setValue(cantArticulo);
		this.child("fdbCantidad").setFocus();
	} else {
		this.iface.ledCodigoDeBarras.setText("");
		this.child("fdbReferencia").setFocus();
	}
}

function klo_calcularPvpTarifa(referencia:String, codTarifa:String, cursor:FLSqlCursor):Number
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	var codCliente:String = util.sqlSelect("tpv_comandas", "codcliente", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
	var referencia:String = cursor.valueBuffer("referencia");
	var usarPvp:Boolean = util.sqlSelect("articulos", "usarpvp", "referencia = '" + referencia + "'");

	debug("KLO--> calcularPvpTarifa de KLO para referencia: "+referencia);
	debug("KLO--> klo_calcularPvpTarifa(), codTarifa: "+codTarifa);
	debug("KLO--> usarPvp: "+usarPvp);
	if (usarPvp) {
		valor = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
	}
	else {
		if (codTarifa){
			valor = formRecordarticulos.iface.pub_obtenerPrecioCliente(referencia, codCliente);
			if (!valor) {
				valor = formRecordarticulos.iface.pub_obtenerPrecioTarifa(referencia, codTarifa);
			}
		}
	}
	valor = parseFloat(valor);

	return valor;
}

function klo_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	
	debug("KLO--> cursor commonCalculateField(): "+cursor.table());
	debug("KLO--> campo: "+fN);
	switch (fN) {
		/** \C
		El --pvpunitario-- se calcula como el pvp establecido para el art�culo seleccionado
		 */
		case "pvpunitarioiva":
		case "pvpunitario":{
			valor = this.iface.calcularPvpTarifa(cursor.valueBuffer("referencia"), cursor.cursorRelation().valueBuffer("codtarifa"), cursor);
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}
//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////