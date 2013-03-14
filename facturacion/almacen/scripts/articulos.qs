/***************************************************************************
                 articulos.qs  -  description
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
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean {return this.ctx.interna_validateForm();}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
	var posActualPuntoSubcuenta:Number;
	var posActualPuntoSubcuentaIRPF:Number;
	var tbnProvDefecto:Object;
	
	function oficial( context ) { interna( context ); } 
	function generarArticulosTarifas() {
		return this.ctx.oficial_generarArticulosTarifas();
	}
	function calcularStockFisico() {
		return this.ctx.oficial_calcularStockFisico();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function genCodBar(fN:String) {
		return this.ctx.oficial_genCodBar(fN);
	}
	function eliminarStock():Boolean {
		return this.ctx.oficial_eliminarStock();
	}
	function borrarDatosStock(referencia:String):Boolean {
		return this.ctx.oficial_borrarDatosStock(referencia);
	}
	function marcarProvDefecto() {
		return this.ctx.oficial_marcarProvDefecto();
	}
	function establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean {
		return this.ctx.oficial_establecerProveedorDefecto(referencia, codProveedor);
	}
	function establecerDatosAlta() {
		return this.ctx.oficial_establecerDatosAlta();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); } 	
	function validateForm():Boolean {
		return this.ctx.ivaIncluido_validateForm();
	}
	function establecerDatosAlta() {
		return this.ctx.ivaIncluido_establecerDatosAlta();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration sfamilia */
//////////////////////////////////////////////////////////////////
//// SUBFAMILIA //////////////////////////////////////////////////
class sfamilia extends ivaIncluido {
    function sfamilia( context ) { ivaIncluido( context ); } 
	function bufferChanged(fN:String){return this.ctx.sfamilia_bufferChanged(fN);}
	function calculateField(fN:String):Number{return this.ctx.sfamilia_calculateField(fN);}
	function validateForm():Boolean {return this.ctx.sfamilia_validateForm();}
}
//// SUBFAMILIA //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration klo */
//////////////////////////////////////////////////////////////////
//// KLO //////////////////////////////////////////////////
class klo extends sfamilia 
{
	var tblPreciosTarifas:QTable;
	var curMargenes_:FLSqlCursor;
	
	function klo( context ) { sfamilia( context ); } 
	
	function init() { this.ctx.klo_init(); }
	function validateForm():Boolean {
		return this.ctx.klo_validateForm();
	}
	function bufferChanged(fN:String){
		return this.ctx.klo_bufferChanged(fN);
	}
	function calculateField(fN:String):Number {
		return this.ctx.klo_calculateField(fN);
	}
	
	function predeterminaCodBar() {
		return this.ctx.klo_predeterminaCodBar();
	}
	function comprobarPredeterminado() {
		return this.ctx.klo_comprobarPredeterminado();
	}
	function defineGridPrecios() {
		return this.ctx.klo_defineGridPrecios();
	}
	function tblPreciosTarifasClicked(row:Number, col:Number) {
		return this.ctx.klo_tblPreciosTarifasClicked(row, col);
	}
	function abrirTarifa() {
		return this.ctx.klo_abrirTarifa();
	}
	function refrescaTarifas() {
		return this.ctx.klo_refrescaTarifas();
	}
	function insertArticuloComp() {
		return this.ctx.klo_insertArticuloComp();
	}
	function capturaTab(QString:QWidget) {
		return this.ctx.klo_capturaTab(QString);
	}
		
	function calcularCosteMedioStock() {
		return this.ctx.klo_calcularCosteMedioStock();
	}
	function obtenerPrecioCliente(referencia:String, codCliente:String):String {
		return this.ctx.klo_obtenerPrecioCliente(referencia, codCliente);
	}
	function obtenerPrecioTarifa(referencia:String, codTarifa:String):String {
		return this.ctx.klo_obtenerPrecioTarifa(referencia, codTarifa);
	}
	function redondeoDecimal(precioArticulo:Number):Number {
		return this.ctx.klo_redondeoDecimal(precioArticulo);
	}
	function editarPrecioArt() {
		return this.ctx.klo_editarPrecioArt();
	}
	function calcularBeneCompra(referencia:String, costeUltimo:Number, pvp:Number):Number {
		return this.ctx.klo_calcularBeneCompra(referencia, costeUltimo, pvp);
	}
	function calcularBeneCMS(referencia:String, costeMedioStock:Number, pvp:Number):Number {
		return this.ctx.klo_calcularBeneCMS(referencia, costeMedioStock, pvp);
	}
	function defineGridPrecios() {
		return this.ctx.klo_defineGridPrecios();
	}
}
//// KLO /////////////////////////////////////////////////
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
	function pub_establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean {
		return this.establecerProveedorDefecto(referencia, codProveedor);
	}
}

const iface = new pubKlo( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubKlo */
/////////////////////////////////////////////////////////////////
//// PUBKLO /////////////////////////////////////////////////////
class pubKlo extends ifaceCtx
{
	function pubKlo( context ) { ifaceCtx ( context ); }
	
	function pub_obtenerPrecioCliente(referencia:String, codCliente:String):String {
		return this.obtenerPrecioCliente(referencia, codCliente);
	}
	function pub_obtenerPrecioTarifa(referencia:String, codTarifa:String):String {
		return this.obtenerPrecioTarifa(referencia, codTarifa);
	}
}
//// PUBKLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C El valor de --stockfis-- se calcula automáticamente para cada artículo como la suma de existencias del artículo en todos los almacenes.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnProvDefecto = this.child("tbnProvDefecto");
	
	connect (this.iface.tbnProvDefecto, "clicked()", this, "iface.marcarProvDefecto");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnGenerarArticulosTarifas"), "clicked()", this, "iface.generarArticulosTarifas");
	if (this.child("tdbStocks"))
		connect(this.child("tdbStocks").cursor(), "cursorUpdated()", this, "iface.calcularStockFisico()");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.iface.establecerDatosAlta();
			break;
		}
		case cursor.Browse: {
			this.child("pbnGenerarArticulosTarifas").enabled = false;
			break;
		}
		case cursor.Edit: {
			if (cursor.valueBuffer("nostock")) {
				this.child("tbwArticulo").setTabEnabled("stocks", false);
			} else {
				this.child("tbwArticulo").setTabEnabled("stocks", true);
			}
			break;
		}
	}
	this.iface.genCodBar("codbarras");
	
	this.iface.bufferChanged("secompra");
	this.iface.bufferChanged("sevende");
	
	if (sys.isLoadedModule("flcontppal")) {
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuenta = false;
		this.iface.posActualPuntoSubcuenta = -1;
		this.child("fdbIdSubcuentaCom").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuentaIrpfCom").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else
		this.child("tbwArticulo").setTabEnabled("contabilidad", false);
}

function interna_calculateField(nombreCampo:String):String
{
	var util:FLUtil = new FLUtil();
	/** \D El valor de --stockfis-- se calcula sumando todas las cantidades de esa referencia en la tabla stocks, esto es, las cantidades de todos los almacenes
	\end */
	if (nombreCampo == "stockfis")
		return util.sqlSelect("stocks", "SUM(cantidad)",  "referencia='" + this.cursor().valueBuffer("referencia") + "';");
}

function interna_validateForm():Boolean 
{
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Genera las líneas de tarifas para un determinado artículo mediante el pvp base y los incrementos de cada tarifa. Cada línea contiene la referencia del artículo, el código de tarifa y el precio calculado para la tarifa.
\end */
function oficial_generarArticulosTarifas()
{
		var cursor:FLSqlCursor = this.cursor();
		var referencia:String = cursor.valueBuffer("referencia");
		var pvp:Number = cursor.valueBuffer("pvp");
		var codTarifa:String;
		var incLineal:Number;
		var incPorcentual:Number;
		var pvpTarifa:Number;

		var curArtTar:FLSqlCursor = this.child("tdbArticulosTarifas").cursor()
		var qryTarifas:FLSqlQuery = new FLSqlQuery();

/** \D Los incrementos lineal y porcentual de la tarifa sobre el precio base pueden acumularse
Las tarifas del artículo son eliminadas y regeneradas después
\end */
		qryTarifas.setTablesList("tarifas");
		qryTarifas.setSelect("codtarifa,inclineal,incporcentual");
		qryTarifas.setFrom("tarifas");
		
		qryTarifas.exec();
		while (qryTarifas.next()) {
			codTarifa = qryTarifas.value(0);
			with(curArtTar) {
				select("referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
				if (first()) {
					setModeAccess(Del);
					refreshBuffer();
					commitBuffer();
				} 
			}
		}
		
		qryTarifas.exec();
		while (qryTarifas.next()) {
			codTarifa = qryTarifas.value(0);
			incLineal = parseFloat(qryTarifas.value(1));
			incPorcentual = parseFloat(qryTarifas.value(2));
			pvpTarifa = ((pvp * (100 + incPorcentual)) / 100) + incLineal;
			with(curArtTar) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("referencia", referencia);
				setValueBuffer("codtarifa", codTarifa);
				setValueBuffer("pvp", pvpTarifa);
				commitBuffer();
			}
		}
		
		this.child("tdbArticulosTarifas").refresh();
}

/** \D Informa el campo --stockfis--
\end */
function oficial_calcularStockFisico()
{
		this.child("fdbStockFisico").setValue(this.iface.calculateField("stockfis"));
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "tipocodbarras":
		case "codbarras": {
			this.iface.genCodBar(fN)
			break;
		}
		case "codsubcuentacom": {
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaCom", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentairpfcom": {
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuentaIRPF = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIrpfCom", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaIRPF);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "nostock": {
			if (cursor.valueBuffer("nostock")) {
				if (this.iface.eliminarStock()) {
					this.child("tbwArticulo").setTabEnabled("stocks", false);
				} else {
					this.child("fdbNoStock").setValue(false);
				}
			} else {
				this.child("tbwArticulo").setTabEnabled("stocks", true);
			}
			break;
		}
		case "secompra": {
			if(!cursor.valueBuffer("secompra"))
				this.child("tbwArticulo").setTabEnabled("compra", false);
			else
				this.child("tbwArticulo").setTabEnabled("compra", true);
			break;
		}
		case "sevende": {
			if(!cursor.valueBuffer("sevende"))
				this.child("tbwArticulo").setTabEnabled("venta", false);
			else
				this.child("tbwArticulo").setTabEnabled("venta", true);
			break;
		}
	}
}

function oficial_genCodBar(fN:String)
{
	if (fN == "tipocodbarras" || fN == "codbarras") {
		var cursor:FLSqlCursor = this.cursor();
		var type:String = cursor.valueBuffer("tipocodbarras");
		var value:String = cursor.valueBuffer("codbarras");

		var auxCodBar:FLCodBar = new FLCodBar(0);
		var codBar:FLCodBar = new FLCodBar(value, auxCodBar.nameToType(type), 10, 1, 0, 0, true);
		var pixmap:Object = codBar.pixmap();
		if (codBar.validBarcode())
			this.child("pixmapCodBar").setPixmap(pixmap);
		else
			this.child("pixmapCodBar").setPixmap(codBar.pixmapError());
	}
}

function oficial_eliminarStock():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var referencia:String = cursor.valueBuffer("referencia");
	if (util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "'")) {
		var res:Number = MessageBox.warning(util.translate("scripts", "Existen valores de stock para este artículo.\nSi lo que desea hacer es indicar que se permiten ventas sin stock de este material, pulse Cancelar e indíquelo en la pestaña de Stocks.\nSi quiere eliminar completamente los datos de stock asociados a este artículo pulse Aceptar. Esta acción no es reversible."), MessageBox.Cancel, MessageBox.Ok);
		if (res != MessageBox.Ok) {
			return false;
		}
	}
	var curTrans:FLSqlCursor = new FLSqlCursor("stocks");
	curTrans.transaction(false);
	try {
		if (this.iface.borrarDatosStock(referencia)) {
			curTrans.commit();
		} else {
			curTrans.rollback();
			return false;
		}
	}
	catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Error al eliminar los datos de stock para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function oficial_borrarDatosStock(referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!util.sqlDelete("stocks", "referencia = '" + referencia + "'")) {
		return false;
	}
	
	return true;
}

function oficial_marcarProvDefecto()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curProv:FLSqlCursor = this.child("tdbArticulosProv").cursor();
	if (!curProv.valueBuffer("id"))
		return;

	var referencia:String = cursor.valueBuffer("referencia");
	var codProveedor:String = curProv.valueBuffer("codproveedor");
	if (!this.iface.establecerProveedorDefecto(referencia, codProveedor)) {
		return;
	}
	this.child("tdbArticulosProv").refresh();
}

function oficial_establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!util.sqlUpdate("articulosprov", "pordefecto", false, "referencia = '" + referencia + "'")) {
		return false;
	}

	if (!util.sqlUpdate("articulosprov", "pordefecto", true, "referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'")) {
		return false;
	}

	return true;
}

function oficial_establecerDatosAlta()
{
debug("oficial_establecerDatosAlta " + flfactalma.iface.pub_valorDefectoAlmacen("codimpuesto"));
	this.child("fdbImpuesto").setValue(flfactalma.iface.pub_valorDefectoAlmacen("codimpuesto"));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
	
function ivaIncluido_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if(!this.iface.__validateForm())
		return false;

	if (cursor.valueBuffer("ivaincluido") && !cursor.valueBuffer("codimpuesto")) {
		MessageBox.critical(util.translate("scripts","Si el IVA del artículo está incluído se debe especificar el tipo de IVA"),
				MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
		return false;
	}

	return true;
}

function ivaIncluido_establecerDatosAlta()
{
	this.iface.__establecerDatosAlta();
	this.child("fdbIvaIncluido").setValue(flfactalma.iface.pub_valorDefectoAlmacen("ivaincluido"));
}
//// IVAINCLUIDO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition sfamilia */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIA /////////////////////////////////////////////////
function sfamilia_bufferChanged(fN:String)
{
	switch (fN) {
		case "codsubfamilia":
			this.child("fdbCodFamilia").setValue(this.iface.calculateField("codfamilia"));
			break;
		default:
			this.iface.__bufferChanged(fN);
	}
}

function sfamilia_calculateField(fN:String):Number
{
	var util:FLUtil = new FLUtil();
	var valor:Number;

	switch (fN) {
		case "codfamilia": {
			valor =  util.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + this.cursor().valueBuffer("codsubfamilia") + "';");
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

function sfamilia_validateForm():Boolean 
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.__validateForm())
		return false;
	
	var codFamilia:String = cursor.valueBuffer("codfamilia");
	var codSubfamilia:String = cursor.valueBuffer("codsubfamilia");
	
	if (!codFamilia || !codSubfamilia) return true;
	
	var codFamiliaSF:String = util.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + codSubfamilia + "';");
	
	if (codFamiliaSF != codFamilia) {
		MessageBox.critical(util.translate("scripts", "La subfamilia no pertenece a la familia"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

//// SUBFAMILIA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/** @class_definition klo */
////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////
function klo_init()
{
	this.iface.__init();

	connect (this.child("btnPredCodBar"), "clicked()", this, "iface.predeterminaCodBar()");
	this.child("pbnGenerarArticulosTarifas").enabled = false;

	this.iface.defineGridPrecios();
	
	connect(this.iface.tblPreciosTarifas, "currentChanged(int, int)", this, "iface.tblPreciosTarifasClicked");
	connect(this.child("pbnEditarTarifa"), "clicked()", this, "iface.abrirTarifa()");
	this.child("pbnEditarTarifa").enabled = false;
	connect(this.child("pbnEditarPrecioArt"), "clicked()", this, "iface.editarPrecioArt()");
	this.child("pbnEditarPrecioArt").enabled = false;
	
	connect(this.child("pbnRefrescaTarifas"), "clicked()", this, "iface.refrescaTarifas()");

	connect(this.child("tbwArticulo"), "currentChanged(QString)", this, "iface.capturaTab(QString)");

	if (this.child("tdbStocks"))
		iface.calcularCosteMedioStock();
	
	this.iface.bufferChanged("debaja");
	
	// Ponemos a false la llamada a margenestarifas porque esto no es un albarán.
	formRecordmargenestarifas.iface.pub_establecerLlamadaAlbaran(false);
}

function klo_validateForm():Boolean 
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.__validateForm())
		return false;
	
	// Si se está dando de alta se ponen las tarifas predeterminadas a referencia en caso de no estar ya dadas de alta
	// al pulsar la pestaña venta..
	if (this.cursor().modeAccess() == this.cursor().Insert)
		this.iface.capturaTab("venta");
	return true;
}

function klo_bufferChanged(fN:String)
{
	switch (fN) {
		case "codsubfamilia":
			this.child("fdbCodFamilia").setValue(this.iface.calculateField("codfamilia"));
			this.child("fdbImpuesto").setValue(this.iface.calculateField("ivasfamilia"));
			break;
		case "debaja":
			this.child("fdbFechaBaja").setValue(this.iface.calculateField("fechabaja"));
			break;
		case "pvp":
		case "codimpuesto":
		case "ivaincluido":
			this.iface.calculateField("margenbeneficio");
			break;
		default:
			this.iface.__bufferChanged(fN);
	}
}

function klo_calculateField(fN:String):Number
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
			
	switch (fN) {
		case "costemediostock": {
			var totalCantXcms:Number = 0;
			var numeroAlmacenes:Number = 0;
			var totalCantidad = util.sqlSelect("stocks", "SUM(cantidad)",  "referencia='" + this.cursor().valueBuffer("referencia") + "' and cantidad is not null and cantidad > 0;");
			var totalCosteMedio = util.sqlSelect("stocks", "SUM(costemediostock)",  "referencia='" + this.cursor().valueBuffer("referencia") + "' and costemediostock is not null and costemediostock > 0;");
			if(totalCantidad == 0) {
				var numeroAlmacenes = util.sqlSelect("stocks", "COUNT(codalmacen)",  "referencia='" + this.cursor().valueBuffer("referencia") + "';");
				valor = totalCosteMedio / numeroAlmacenes;
			} else {
				totalCantXcms = util.sqlSelect("stocks", "SUM(cantidad*costemediostock)",  "referencia='" + this.cursor().valueBuffer("referencia") + "' and ((cantidad is not null and cantidad > 0) and (costemediostock is not null and costemediostock > 0));");
				valor = totalCantXcms / totalCantidad;
			}
			break;
		}
		case "ivasfamilia": {
			valor =  util.sqlSelect("subfamilias", "codimpuesto", "codsubfamilia='" + this.cursor().valueBuffer("codsubfamilia") + "';");
			break;
		}
		case "fechabaja": {
			if (cursor.valueBuffer("debaja")) {
				if (cursor.isNull("fechabaja")) {
					var hoy:Date = new Date;
					valor = hoy.toString();
				}
				else
					valor = cursor.valueBuffer("fechabaja");
			} else {
				valor = "";
			}
			break;
		}
		case "margenbeneficio": {
			var beneficioCompra:Number = this.iface.calcularBeneCompra(cursor.valueBuffer("referencia"),cursor.valueBuffer("costeultimo"),cursor.valueBuffer("pvp"));
			var beneficioCMS:Number = this.iface.calcularBeneCMS(cursor.valueBuffer("referencia"),cursor.valueBuffer("costemediostock"),cursor.valueBuffer("pvp"));
			debug("beneficioCompra = "+beneficioCompra);
			debug("beneficioCMS = "+beneficioCMS);
			cursor.setValueBuffer("benecosultimo", beneficioCompra);
			cursor.setValueBuffer("benecosmedstock", beneficioCMS);
			this.iface.refrescaTarifas();
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

function klo_predeterminaCodBar()
{
	var curCodBar:FLSqlCursor = this.child("tdbCodigosDeBarras").cursor();
	var codBarras:String = curCodBar.valueBuffer("codigodebarras");
	var tipoCodBarras:String = curCodBar.valueBuffer("tipocodbarras");

	// Si no hay cod. barras en el grid, pone el predeterminaod vacio.
	if (!codBarras) {
		this.cursor().setValueBuffer("codbarras", "");
		this.cursor().setValueBuffer("tipocodbarras", "");
		var util:FLUtil = new FLUtil;
		return;
	}
	
	this.cursor().setValueBuffer("codbarras", codBarras);
	this.cursor().setValueBuffer("tipocodbarras", tipoCodBarras);
	var util:FLUtil = new FLUtil;
	
	return;
}

function klo_comprobarPredeterminado()
{
	var curCodBar:FLSqlCursor = this.child("tdbCodigosDeBarras").cursor();
	curCodBar.select();
	
	// Sólo hay uno?
	if (curCodBar.size() == 1)
		this.iface.predeterminaCodBar();
}

function klo_tblPreciosTarifasClicked(row:Number, col:Number)
{
	var codigo:String;
	
	codigo = this.iface.tblPreciosTarifas.text(row, 0);
	if (!codigo || codigo == "") {
		this.child("pbnEditarTarifa").enabled = false;
		this.child("pbnEditarPrecioArt").enabled = false;
		return;
	}
	this.child("pbnEditarTarifa").enabled = true;
	this.child("pbnEditarPrecioArt").enabled = true;
}

function klo_abrirTarifa()
{
	var curTarifas = new FLSqlCursor("tarifas");
	var columna:Number = this.iface.tblPreciosTarifas.currentColumn();
	var fila:Number = this.iface.tblPreciosTarifas.currentRow();
	var codigo:String;
	
	codigo = this.iface.tblPreciosTarifas.text(fila, 0);
	if (!codigo || codigo == "")
		return;
	
	var referencia:String = this.cursor().valueBuffer("referencia");
	var codSubfamilia:String = this.cursor().valueBuffer("codsubfamilia");
	var codFamilia:String = this.cursor().valueBuffer("codfamilia");
	var codSeccion:String = this.cursor().valueBuffer("codseccion");
	
	if (this.iface.curMargenes_) {
		delete this.iface.curMargenes_;
	}
	//if (!this.iface.curMargenes_) {
	this.iface.curMargenes_ = new FLSqlCursor("margenestarifas");
	//}
	if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and referencia = '"+referencia+"'")) {
		if (!this.iface.curMargenes_.first()) {
			if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codsubfamilia = '"+codSubfamilia+"'")) {
				if (!this.iface.curMargenes_.first()) {
					if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codfamilia = '"+codFamilia+"'")) {
						if (!this.iface.curMargenes_.first()) {
							if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codseccion = '"+codSeccion+"'")) {
								if (!this.iface.curMargenes_.first()) {
									curTarifas.setAction("tarifas");
									curTarifas.select("codtarifa = '" + codigo + "'");
									if (curTarifas.first())
										curTarifas.editRecord();
									return;
								}
							}
						}
					}
				}
			}
		}
	}
	connect(this.iface.curMargenes_, "bufferCommited()", this, "iface.refrescaTarifas");
	this.iface.curMargenes_.editRecord();
}

/**
Al pulsar el botón de refresco.
Vuelve a rehacer la tabla con las tarifas y sus correspondientes precios.
 */
function klo_refrescaTarifas()
{
	this.iface.tblPreciosTarifas.numRows() == 0;
	this.iface.tblPreciosTarifas.numCols() == 0;
	
	// Si se está dando de alta se ponen las tarifas predeterminadas a referencia.
	//if (this.cursor().modeAccess() == this.cursor().Insert) {
		//this.iface.capturaTab("venta");
	//} else {
	this.iface.defineGridPrecios();
	//}
}

function klo_defineGridPrecios()
{
	var util:FLUtil = new FLUtil();
	var precioVenta:Number = 0;
	var incPorcentual:Number = 0;
	
	var cursorArticulos:FLSqlCursor = this.cursor();
	var cursorTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
	var cursorMargenes:FLSqlCursor = new FLSqlCursor("margenestarifas");

	var codTarifa:String;
	var incSobreBase:Number = 0;
	var referencia:String = cursorArticulos.valueBuffer("referencia");
	var codFamilia:String = cursorArticulos.valueBuffer("codfamilia");
	var codSubfamilia:String = cursorArticulos.valueBuffer("codsubfamilia");
	var codSeccion:String = cursorArticulos.valueBuffer("codseccion");
	var costeUltimo:String = cursorArticulos.valueBuffer("costeultimo");
	
	this.iface.tblPreciosTarifas = this.child("tblPreciosTarifas");

	this.iface.tblPreciosTarifas.setNumCols(7);
	this.iface.tblPreciosTarifas.setColumnWidth(0, 80);
	this.iface.tblPreciosTarifas.setColumnWidth(1, 180);
	this.iface.tblPreciosTarifas.setColumnWidth(2, 90);
	this.iface.tblPreciosTarifas.setColumnWidth(3, 100);
	this.iface.tblPreciosTarifas.setColumnWidth(4, 90);
	this.iface.tblPreciosTarifas.setColumnWidth(4, 90);
	this.iface.tblPreciosTarifas.setColumnWidth(4, 90);
	this.iface.tblPreciosTarifas.setColumnLabels("/", "Tarifa/Nombre/Porcentaje/Nivel/Precio de venta/Tarifa base/% sobre base");

	// Creo un cursor con todas las tarifas para recorrerlas con un bucle.
	cursorTarifas.select("codtarifa != ''");

	var contador:Number = 0;
	var x:Number;
	var numeroDeTarifas:Number = cursorTarifas.size();

	//Inserto las líneas correspondientes a todas las tarifas para, despues adjudicar los datos.
	if (this.iface.tblPreciosTarifas.numRows()==0)
		for (x=0; x<numeroDeTarifas; x++)
			this.iface.tblPreciosTarifas.insertRows(this.iface.tblPreciosTarifas.numRows());
	
	// Busco las coincidencias para rellenar los datos.
	while (cursorTarifas.next()) {
		if (cursorTarifas.valueBuffer("tarifabase") != "") {
			codTarifa = cursorTarifas.valueBuffer("tarifabase");
			incSobreBase = cursorTarifas.valueBuffer("incsobrebase");
		}
		else {
			codTarifa = cursorTarifas.valueBuffer("codtarifa");
			incSobreBase = 0;
		}
		
		// Inserto las líneas con los datos de las tarifas según la referencia.
		if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and referencia = '" + referencia + "'")) {
			if (cursorMargenes.size()>0) {
				cursorMargenes.first();
				if (cursorMargenes.valueBuffer("pvpfijo")) {
					//precioVenta = cursorMargenes.valueBuffer("pvp");
					incPorcentual = "";
				}
				else {
					//precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
					//precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
					//precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
					incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
				}
				precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
				this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
				this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
				this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
				this.iface.tblPreciosTarifas.setText(contador, 3, "ARTICULO");
				this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
				this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
				this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
			}
			else {
				// Inserto las líneas con los datos de las tarifas según la subfamilia.
				if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codsubfamilia = '" + codSubfamilia + "'")) {
					if (cursorMargenes.size()>0) {
						cursorMargenes.first();
						if (cursorMargenes.valueBuffer("pvpfijo")) {
							//precioVenta = cursorMargenes.valueBuffer("pvp");
							incPorcentual = "";
						}
						else {
							//precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
							//precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
							//precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
							incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
						}
						precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
						this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
						this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
						this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
						this.iface.tblPreciosTarifas.setText(contador, 3, "SUBFAMILIA");
						this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
						this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
						this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
					}
					else {
						// Inserto las líneas con los datos de las tarifas según la familia.
						if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codfamilia = '" + codFamilia + "'")) {
							if (cursorMargenes.size()>0) {
								cursorMargenes.first();
								if (cursorMargenes.valueBuffer("pvpfijo")) {
									//precioVenta = cursorMargenes.valueBuffer("pvp");
									incPorcentual = "";
								}
								else {
									//precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
									//precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
									//precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
									incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
								}
								precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
								this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
								this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
								this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
								this.iface.tblPreciosTarifas.setText(contador, 3, "FAMILIA");
								this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
								this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
								this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
							}
							else {
								// Inserto las líneas con los datos de las tarifas según la seccion.
								if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codseccion = '" + codSeccion + "'")) {
									if (cursorMargenes.size()>0) {
										cursorMargenes.first();
										if (cursorMargenes.valueBuffer("pvpfijo")) {
											//precioVenta = cursorMargenes.valueBuffer("pvp");
										incPorcentual = "";
										}
										else {
											//precioVenta =  costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
											//precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
											//precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
										incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
										}
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
										this.iface.tblPreciosTarifas.setText(contador, 3, "SECCIÓN");
										this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
										this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
									}
									else {
										incPorcentual = util.sqlSelect("tarifas", "incporcentual", "codtarifa = '"+codTarifa+"'")
										incPorcentual = util.roundFieldValue(incPorcentual, "tarifas", "incporcentual");
										//precioVenta = costeUltimo+(costeUltimo*(incPorcentual/100));
										//precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
										//precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
										this.iface.tblPreciosTarifas.setText(contador, 3, "POR DEFECTO");
										this.iface.tblPreciosTarifas.setText(contador,4,precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
										this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
									}
								}
							}
						}
					}
				}
			}
		}
		contador++;
	}
}

function klo_insertArticuloComp()
{
	var util:FLUtil;
	
	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		// ESTE PROCEDIMIENTO ES IGUAL QUE EL ORIGINAL PERO ATACA EL COMMIT DE LA TABLA TDBSTOCKS PORQUE LA ORIGINAL LA QUITAMOS PARA LAS TARIFAS AUTOMÁTICAS.
		//KLO if (!this.child("tdbArticulosTarifas").cursor().commitBufferCursorRelation())
		//KLO	return false;
		if (!this.child("tdbStocks").cursor().commitBufferCursorRelation())
			return false;
	
		//this.iface.crearArbolComponentes();
		this.iface.anadirComponente();
		this.iface.crearArbolCompuestos();
	}

	if (!this.iface.componenteSeleccionado)
		return;

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "")
		return;

	this.iface.referenciaComp_ = referencia;

	disconnect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");
	delete this.iface.curArticulosComp_;
	this.iface.curArticulosComp_ = new FLSqlCursor("articuloscomp");
	connect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");

	this.iface.guardarExpansiones();
	this.iface.curArticulosComp_.insertRecord();
}

/*
Al pulsar la pestaña de venta.
Vuelve a rehacer la tabla con las tarifas y sus correspondientes precios.
 */
function klo_capturaTab(QString:QWidget):Boolean
{
	var util:FLUtil;

	if (QString == "venta") {
		if (this.cursor().modeAccess() == this.cursor().Insert) {
			var referencia:String = this.cursor().valueBuffer("referencia");
			if (!referencia || !this.cursor().valueBuffer("descripcion")) {
				MessageBox.warning(util.translate("scripts", "Debe introducir una referencia y descripción y refrescar las tarifas."), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
			
			/* Esto falla aunque ahora quieren que el nivel sea por defecto.
			this.cursor().commitBuffer();
		
			var cursorTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
			var curMargTarifas:FLSqlCursor = new FLSqlCursor("margenestarifas");
			// Creo un cursor con todas las tarifas para recorrerlas con un bucle.
			cursorTarifas.select("codtarifa != ''");
			while (cursorTarifas.next()) {
			if (!util.sqlSelect("margenestarifas","referencia","referencia = '" + referencia + "' AND codtarifa = 	"+cursorTarifas.valueBuffer("codtarifa"))) {
			util.sqlInsert("margenestarifas", "codtarifa,referencia",cursorTarifas.valueBuffer("codtarifa")+","+referencia);
		}
		}*/
		}
		this.iface.calculateField("margenbeneficio");
		this.iface.refrescaTarifas();
	}
	return true;
}

function klo_calcularCosteMedioStock()
{
	this.child("fdbCosteMedioStock").setValue(this.iface.calculateField("costemediostock"));
}

/** \D Obtiene el precio del artículo según la TARIFA ESPECIAL de un cliente.
Esta tarifa está en la ficha del cliente y son precios especiales para este.
Primero mira aqui y despues en la tarifa general asociada.
@param referencia: referencia del artículo
@return precio calculado del artículo asociado a la tarifa según el cliente
\end */
function klo_obtenerPrecioCliente(referencia:String, codCliente:String):String
{
	var util:FLUtil = new FLUtil;
	var codSubfamilia:String	
			var codFamilia:String	
			var codSeccion:String	
			var costeArticulo:String
			var incPorcentual:String
			var precioArticulo:String	

	// Busca el margen de la tarifa especial para la referencia.
			incPorcentual = util.sqlSelect("tarifasclientes", "incporcentual", "referencia = '" + referencia + "' AND codcliente = '" + codCliente + "'");

	// Si no hay margen para la referencia, busca en subfamilia.
	if (!incPorcentual){
		codSubfamilia = util.sqlSelect("articulos", "codsubfamilia", "referencia = '" + referencia + "'");
		incPorcentual = util.sqlSelect("tarifasclientes", "incporcentual", "codsubfamilia = '" + codSubfamilia + "' AND codcliente = '" + codCliente + "'");

		// Si no hay margen para la subfamilia, busca en familia.
		if (!incPorcentual){
			codFamilia = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
			incPorcentual = util.sqlSelect("tarifasclientes", "incporcentual", "codfamilia = '" + codFamilia + "' AND codcliente = '" + codCliente + "'");

			// Si no hay margen para la familia, busca en seccion.
			if (!incPorcentual){
				codSeccion = util.sqlSelect("articulos", "codseccion", "referencia = '" + referencia + "'");
				incPorcentual = util.sqlSelect("tarifasclientes", "incporcentual", "codseccion = '" + codSeccion + "' AND codcliente = '" + codCliente + "'");

				// Si no hay margen en ninguno, sale vacio para buscar en tarifa general.
				if (!incPorcentual){
					precioArticulo = "";
					return precioArticulo;
				}
			}
		}
	}	

	costeArticulo = util.sqlSelect("articulos", "costeultimo", "referencia = '" + referencia + "'");
	precioArticulo = (costeArticulo*(incPorcentual/100))+costeArticulo

			return precioArticulo;
}

/** \D Obtiene el precio del artículo según la TARIFA GENERAL asociada a un cliente
@param referencia: referencia del artículo
@param codTarifa: código de la tarifa asociada al cliente  
@return precio calculado del artículo asociado a la tarifa según el cliente
\end */
function klo_obtenerPrecioTarifa(referencia:String, codTarifa:String):String
{
	var util:FLUtil = new FLUtil;
	var codSubfamilia:String;
	var codFamilia:String;
	var codSeccion:String;	
	var costeArticulo:Number;
	var incPorcentual:Number;
	var precioArticulo:Number;	
	var pvpFijo:Boolean;
	var codTarifaReal:String = codTarifa;

	var tarifaBase:String = util.sqlSelect("tarifas", "tarifabase", "codtarifa = '" + codTarifa + "'");
	var incSobreBase:Number = 0;

	// Mira si la tarifa esta basada en otra.
	if (tarifaBase) {
		incSobreBase = util.sqlSelect("tarifas", "incsobrebase", "codtarifa = '" + codTarifa + "'");
		codTarifa = tarifaBase;
	}
	
	// Busca el margen de la tarifa para la referencia.
	pvpFijo = util.sqlSelect("margenestarifas", "pvpfijo", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifaReal + "'");
	if (pvpFijo)
		precioArticulo = util.sqlSelect("margenestarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifaReal + "'");
	else
		incPorcentual = util.sqlSelect("margenestarifas", "incporcentual", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");

	// Si no hay margen para la referencia, busca en subfamilia.
	if (!incPorcentual){
		if (!precioArticulo) {
			codSubfamilia = util.sqlSelect("articulos", "codsubfamilia", "referencia = '" + referencia + "'");
			pvpFijo = util.sqlSelect("margenestarifas", "pvpfijo", "codsubfamilia = '" + codSubfamilia + "' AND codtarifa = '" + codTarifaReal + "'");
			if (pvpFijo)
				precioArticulo = util.sqlSelect("margenestarifas", "pvp", "codsubfamilia = '" + codSubfamilia + "' AND codtarifa = '" + codTarifaReal + "'");
			else
				incPorcentual = util.sqlSelect("margenestarifas", "incporcentual", "codsubfamilia = '" + codSubfamilia + "' AND codtarifa = '" + codTarifa + "'");
		}

		// Si no hay margen para la subfamilia, busca en familia.
		if (!incPorcentual){
			if (!precioArticulo) {
				codFamilia = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
				pvpFijo = util.sqlSelect("margenestarifas", "pvpfijo", "codfamilia = '" + codFamilia + "' AND codtarifa = '" + codTarifaReal + "'");
				if (pvpFijo)
					precioArticulo = util.sqlSelect("margenestarifas", "pvp", "codfamilia = '" + codFamilia + "' AND codtarifa = '" + codTarifaReal + "'");
				else
					incPorcentual = util.sqlSelect("margenestarifas", "incporcentual", "codfamilia = '" + codFamilia + "' AND codtarifa = '" + codTarifa + "'");
			}

			// Si no hay margen para la familia, busca en seccion.
			if (!incPorcentual){
				if (!precioArticulo) {
					codSeccion = util.sqlSelect("articulos", "codseccion", "referencia = '" + referencia + "'");
					pvpFijo = util.sqlSelect("margenestarifas", "pvpfijo", "codseccion = '" + codSeccion + "' AND codtarifa = '" + codTarifaReal + "'");
					if (pvpFijo)
						precioArticulo = util.sqlSelect("margenestarifas", "pvp", "codseccion = '" + codSeccion + "' AND codtarifa = '" + codTarifaReal + "'");
					else
						incPorcentual = util.sqlSelect("margenestarifas", "incporcentual", "codseccion = '" + codSeccion + "' AND codtarifa = '" + codTarifa + "'");
				}
				// Si no hay margen o precio fijo en ninguno, captura el general de la tarifa que solo es porcentual (no fijo).
				if (!incPorcentual && !precioArticulo){
					incPorcentual = util.sqlSelect("tarifas", "incporcentual", "codtarifa = '" + codTarifa + "'")
				}
			}
		}
	}	
	//debug("KLO--> tarifa: "+codTarifaReal+" - tarifaBase: "+tarifaBase+" - con incremento: "+incSobreBase+" - pvpFijoBase: "+pvpFijo);
	
	if (!pvpFijo) {
		var tipoCoste:Number = util.sqlSelect("tarifas", "origencoste", "codtarifa = '" + codTarifa + "'");
		var redondeo:Boolean = util.sqlSelect("tarifas", "redondeo", "codtarifa = '" + codTarifa + "'");
		// El default es el último coste.
		switch(tipoCoste) {
			case "Precio medio de compra": {
				costeArticulo = util.sqlSelect("articulos", "costemedio", "referencia = '" + referencia + "'");
				break;
			}
			case "Precio medio de stock": {
				costeArticulo = this.iface.calculateField("costemediostock");
				break;
			}
			default: {
				costeArticulo = util.sqlSelect("articulos", "costeultimo", "referencia = '" + referencia + "'");
				break;
			}
		}
		precioArticulo = parseFloat((costeArticulo*(incPorcentual/100))+costeArticulo);
		if (tarifaBase) {
			precioArticulo = parseFloat(this.iface.obtenerPrecioTarifa(referencia, codTarifa));
		}
		precioArticulo = (precioArticulo*(incSobreBase/100))+precioArticulo;
		// Si está activado el redondeo a 0 y 5
		if (redondeo) {
			precioArticulo = this.iface.redondeoDecimal(precioArticulo);
		} else {
			precioArticulo = util.roundFieldValue(precioArticulo, "articulos", "pvp");
		}
	}
	return precioArticulo;
}

/** \D Obtiene el precio del artículo según la TARIFA GENERAL asociada a un cliente
@param precioArticulo: Precio del artículo 
\end */
function klo_redondeoDecimal(precioArticulo:Number):Number
{
	var util:FLUtil = new FLUtil;
	var valor:Number = util.roundFieldValue(precioArticulo, "articulos", "pvp");
	var ultimaCifra:Number = valor.right(1);
	debug("ULTIMA CIFRA PARA REDONDEO: "+ultimaCifra);
	switch(ultimaCifra) {
		case "1":
			case "2":{
				valor = parseFloat(valor) - parseFloat((ultimaCifra/100));
				break;
			}
		case "3":
			case "4":{
				valor = parseFloat(valor) + parseFloat((5-ultimaCifra)/100);
				break;
			}
		case "6":
			case "7":{
				valor = parseFloat(valor) - parseFloat((ultimaCifra-5)/100);
				break;
			}
		case "8":
			case "9":{
				valor = parseFloat(valor) + parseFloat((10-ultimaCifra)/100);
				break;
			}
	}	
	debug("PRECIO REDONDEADO: "+valor);
	
	return valor;
}

function klo_editarPrecioArt()
{
	var util:FLUtil = new FLUtil;
	var curTarifas = new FLSqlCursor("tarifas");
	var columna:Number = this.iface.tblPreciosTarifas.currentColumn();
	var fila:Number = this.iface.tblPreciosTarifas.currentRow();
	var codigo:String;
	
	codigo = this.iface.tblPreciosTarifas.text(fila, 0);
	if (!codigo || codigo == "")
		return;
	
	var referencia:String = this.cursor().valueBuffer("referencia");
	var codSubfamilia:String = this.cursor().valueBuffer("codsubfamilia");
	var codFamilia:String = this.cursor().valueBuffer("codfamilia");
	var codSeccion:String = this.cursor().valueBuffer("codseccion");
	
	if (this.iface.curMargenes_) {
		delete this.iface.curMargenes_;
	}
	//if (!this.iface.curMargenes_) {
	this.iface.curMargenes_ = new FLSqlCursor("margenestarifas");
	//}
	if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and referencia = '"+referencia+"'")) {
		if (!this.iface.curMargenes_.first()) {
			if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codsubfamilia = '"+codSubfamilia+"'")) {
				if (!this.iface.curMargenes_.first()) {
					if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codfamilia = '"+codFamilia+"'")) {
						if (!this.iface.curMargenes_.first()) {
							if (this.iface.curMargenes_.select("codtarifa = '"+codigo+"' and codseccion = '"+codSeccion+"'")) {
								if (!this.iface.curMargenes_.first()) {
									curTarifas.setAction("tarifas");
									curTarifas.select("codtarifa = '" + codigo + "'");
									with(this.iface.curMargenes_) {
										setModeAccess(Insert);
										refreshBuffer();
										setValueBuffer("codtarifa", codigo);
										setValueBuffer("referencia", referencia);
										setValueBuffer("pvp", 0);
										setValueBuffer("pvpfijo", false);
										setValueBuffer("incporcentual", 0);
										if (!commitBuffer())
										return false;
									}
									this.iface.refrescaTarifas();
									this.iface.abrirTarifa();
									return;
								}
							}
						}
					}
				}
			}
		}
	}
	connect(this.iface.curMargenes_, "bufferCommited()", this, "iface.refrescaTarifas");
	this.iface.curMargenes_.editRecord();
}

function klo_calcularBeneCompra(referencia:String, costeUltimo:Number, pvp:Number):Number
{
	var util:FLUtil;
	var hoy:Date = new Date();
	var valor:Number = 0;
	var ivaIncluido:Boolean; // = this.child("fdbIvaIncluido").value();
	var codImpuesto:String; // = this.child("fdbImpuesto").value();
	  
	  // Comprueba que es la ficha del artículo viendo si están activas las pestañas
	  // si no es así es porque llaman a la función desde fuera.
	if(this.child("tbwArticulo")) {
		ivaIncluido = this.child("fdbIvaIncluido").value();
	} else {
		ivaIncluido = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
	}
	  
	if (ivaIncluido) {
		if(this.child("tbwArticulo")) {
			codImpuesto = this.child("fdbImpuesto").value();
		} else {
			codImpuesto = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'");
		}
		var iva:Number = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, util.dateAMDtoDMA(hoy));
		var precioSinIVA:Number = pvp - (pvp * (iva/100))
				pvp = precioSinIVA;
	}
	if (pvp == 0) {
		valor = 0;
		return valor;
	}
	valor = 100 - ((costeUltimo/pvp)*100)
			valor = util.roundFieldValue(valor, "articulos", "pvp");
	debug("formula costeUltimo: 100 - (("+costeUltimo+" / "+pvp+") * 100 = "+valor);
	return valor;
}

function klo_calcularBeneCMS(referencia:String, costeMedioStock:Number, pvp:Number):Number
{
	var util:FLUtil;
	var hoy:Date = new Date();
	var valor:Number = 0;
	var ivaIncluido:Boolean; // = this.child("fdbIvaIncluido").value();
	var codImpuesto:String; // = this.child("fdbImpuesto").value();
	  
	  // Comprueba que es la ficha del artículo viendo si están activas las pestañas
	  // si no es así es porque llaman a la función desde fuera.
	if(this.child("tbwArticulo")) {
		ivaIncluido = this.child("fdbIvaIncluido").value();
	} else {
		ivaIncluido = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
	}
	  
	if (ivaIncluido) {
		if(this.child("tbwArticulo")) {
			codImpuesto = this.child("fdbImpuesto").value();
		} else {
			codImpuesto = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'");
		}
		var iva:Number = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, util.dateAMDtoDMA(hoy));
		var precioSinIVA:Number = pvp - (pvp * (iva/100))
				pvp = precioSinIVA;
	}
	if (pvp == 0) {
		valor = 0;
		return valor;
	}
	valor = 100 - ((costeMedioStock/pvp)*100)
			valor = util.roundFieldValue(valor, "articulos", "pvp");
	debug("formula CMS: 100 - (("+costeMedioStock+" / "+pvp+") * 100 = "+valor);
	  
	return valor;
}

function klo_defineGridPrecios()
{
	var util:FLUtil = new FLUtil();
	var precioVenta:Number = 0;
	var incPorcentual:Number = 0;
	var beneficioCompra:Number = 0;
	var beneficioCMS:Number = 0;
	  
	var cursorArticulos:FLSqlCursor = this.cursor();
	var cursorTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
	var cursorMargenes:FLSqlCursor = new FLSqlCursor("margenestarifas");
	  
	var codTarifa:String;
	var incSobreBase:Number = 0;
	var referencia:String = cursorArticulos.valueBuffer("referencia");
	var codFamilia:String = cursorArticulos.valueBuffer("codfamilia");
	var codSubfamilia:String = cursorArticulos.valueBuffer("codsubfamilia");
	var codSeccion:String = cursorArticulos.valueBuffer("codseccion");
	var costeUltimo:String = cursorArticulos.valueBuffer("costeultimo");
	var CMS:String = cursorArticulos.valueBuffer("costemediostock");
	  
	this.iface.tblPreciosTarifas = this.child("tblPreciosTarifas");
	  
	this.iface.tblPreciosTarifas.setNumCols(9);
	this.iface.tblPreciosTarifas.setColumnWidth(0, 60);
	this.iface.tblPreciosTarifas.setColumnWidth(1, 170);
	this.iface.tblPreciosTarifas.setColumnWidth(2, 50);
	this.iface.tblPreciosTarifas.setColumnWidth(3, 100);
	this.iface.tblPreciosTarifas.setColumnWidth(4, 80);
	this.iface.tblPreciosTarifas.setColumnWidth(5, 70);
	this.iface.tblPreciosTarifas.setColumnWidth(6, 85);
	  
	this.iface.tblPreciosTarifas.setColumnWidth(7, 80);
	this.iface.tblPreciosTarifas.setColumnWidth(8, 75);
	  
	this.iface.tblPreciosTarifas.setColumnLabels("/", "Tarifa/Nombre/%/Nivel/Precio venta/Tarifa base/% sobre base/Bº Ult. cost./Bº C.M.S.");
	  
	  // Creo un cursor con todas las tarifas para recorrerlas con un bucle.
	cursorTarifas.select("codtarifa != ''");
	  
	var contador:Number = 0;
	var x:Number;
	var numeroDeTarifas:Number = cursorTarifas.size();
	  
	  //Inserto las líneas correspondientes a todas las tarifas para, despues adjudicar los datos.
	if (this.iface.tblPreciosTarifas.numRows()==0)
		for (x=0; x<numeroDeTarifas; x++)
			this.iface.tblPreciosTarifas.insertRows(this.iface.tblPreciosTarifas.numRows());
			
			// Busco las coincidencias para rellenar los datos.
	while (cursorTarifas.next()) {
		if (cursorTarifas.valueBuffer("tarifabase") != "") {
			codTarifa = cursorTarifas.valueBuffer("tarifabase");
			incSobreBase = cursorTarifas.valueBuffer("incsobrebase");
		}
		else {
			codTarifa = cursorTarifas.valueBuffer("codtarifa");
			incSobreBase = 0;
		}
				  
				  // Inserto las líneas con los datos de las tarifas según la referencia.
		if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and referencia = '" + referencia + "'")) {
			if (cursorMargenes.size()>0) {
				cursorMargenes.first();
				if (cursorMargenes.valueBuffer("pvpfijo")) {
				 //precioVenta = cursorMargenes.valueBuffer("pvp");
					incPorcentual = "";
				}
				else {
				 //precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
				 //precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
				 //precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
					incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
				}
				precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
				beneficioCompra = this.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
				beneficioCMS = this.iface.calcularBeneCMS(referencia, CMS, precioVenta);
				this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
				this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
				this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
				this.iface.tblPreciosTarifas.setText(contador, 3, "ARTICULO");
				this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
				this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
				this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
				this.iface.tblPreciosTarifas.setText(contador, 7, beneficioCompra);
				this.iface.tblPreciosTarifas.setText(contador, 8, beneficioCMS);
			}
			else {
		   // Inserto las líneas con los datos de las tarifas según la subfamilia.
				if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codsubfamilia = '" + codSubfamilia + "'")) {
					if (cursorMargenes.size()>0) {
						cursorMargenes.first();
						if (cursorMargenes.valueBuffer("pvpfijo")) {
					   //precioVenta = cursorMargenes.valueBuffer("pvp");
							incPorcentual = "";
						}
						else {
					   //precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
					   //precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
					   //precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
							incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
						}
						precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
						beneficioCompra = this.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
						beneficioCMS = this.iface.calcularBeneCMS(referencia, CMS, precioVenta);
						this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
						this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
						this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
						this.iface.tblPreciosTarifas.setText(contador, 3, "SUBFAMILIA");
						this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
						this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
						this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
						this.iface.tblPreciosTarifas.setText(contador, 7, beneficioCompra);
						this.iface.tblPreciosTarifas.setText(contador, 8, beneficioCMS);
					}
					else {
					   // Inserto las líneas con los datos de las tarifas según la familia.
						if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codfamilia = '" + codFamilia + "'")) {
							if (cursorMargenes.size()>0) {
								cursorMargenes.first();
								if (cursorMargenes.valueBuffer("pvpfijo")) {
								   //precioVenta = cursorMargenes.valueBuffer("pvp");
									incPorcentual = "";
								}
								else {
								   //precioVenta = costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
								   //precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
								   //precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
									incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
								}
								precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
								beneficioCompra = this.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
								beneficioCMS = this.iface.calcularBeneCMS(referencia, CMS, precioVenta);
								this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
								this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
								this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
								this.iface.tblPreciosTarifas.setText(contador, 3, "FAMILIA");
								this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
								this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
								this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
								this.iface.tblPreciosTarifas.setText(contador, 7, beneficioCompra);
								this.iface.tblPreciosTarifas.setText(contador, 8, beneficioCMS);
							}
							else {
							 // Inserto las líneas con los datos de las tarifas según la seccion.
								if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codseccion = '" + codSeccion + "'")) {
									if (cursorMargenes.size()>0) {
										cursorMargenes.first();
										if (cursorMargenes.valueBuffer("pvpfijo")) {
											   //precioVenta = cursorMargenes.valueBuffer("pvp");
										incPorcentual = "";
										}
										else {
											   //precioVenta =  costeUltimo+(costeUltimo*(cursorMargenes.valueBuffer("incporcentual")/100));
											   //precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
											   //precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
										incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
										}
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										beneficioCompra = this.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
										beneficioCMS = this.iface.calcularBeneCMS(referencia, CMS, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
										this.iface.tblPreciosTarifas.setText(contador, 3, "SECCIÓN");
										this.iface.tblPreciosTarifas.setText(contador, 4, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
										this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
										this.iface.tblPreciosTarifas.setText(contador, 7, beneficioCompra);
										this.iface.tblPreciosTarifas.setText(contador, 8, beneficioCMS);
									}
									else {
										incPorcentual = util.sqlSelect("tarifas", "incporcentual", "codtarifa = '"+codTarifa+"'")
										incPorcentual = util.roundFieldValue(incPorcentual, "tarifas", "incporcentual");
										 //precioVenta = costeUltimo+(costeUltimo*(incPorcentual/100));
										 //precioVenta = precioVenta+(precioVenta*(incSobreBase/100));
										 //precioVenta = util.roundFieldValue(precioVenta, "articulos", "pvp");
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										beneficioCompra = this.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
										beneficioCMS = this.iface.calcularBeneCMS(referencia, CMS, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, incPorcentual);
										this.iface.tblPreciosTarifas.setText(contador, 3, "POR DEFECTO");
										this.iface.tblPreciosTarifas.setText(contador,4,precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 5, cursorTarifas.valueBuffer("tarifabase"));
										this.iface.tblPreciosTarifas.setText(contador, 6, incSobreBase);
										this.iface.tblPreciosTarifas.setText(contador, 7, beneficioCompra);
										this.iface.tblPreciosTarifas.setText(contador, 8, beneficioCMS);
									}
								}
							}
						}
					}
				}
			}
		}
		contador++;
	}
}
//// KLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////