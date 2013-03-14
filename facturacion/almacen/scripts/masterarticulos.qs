/***************************************************************************
                 masterarticulos.qs  -  description
                             -------------------
    begin                : jue jun 28 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	var curArticulo:FLSqlCursor;
	var curTarifa:FLSqlCursor;
	var curArticuloProv:FLSqlCursor;
	var curArticuloAgen:FLSqlCursor;
	var tdbRecords:FLTableDB;
	var toolButtonCopy:Object;
	function oficial( context ) { interna( context ); }
	function copiarArticulo_clicked() {
		return this.ctx.oficial_copiarArticulo_clicked();
	}
	function copiarArticulo(refOriginal:String):String {
		return this.ctx.oficial_copiarArticulo(refOriginal);
	}
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarAnexosArticulo(refOriginal, refNueva);
	}
	function copiarTablaTarifas(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaTarifas(refOriginal, refNueva);
	}
	function copiarTablaArticulosProv(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaArticulosProv(refOriginal, refNueva);
	}
	function copiarTablaArticulosAgen(refOrigen:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaArticulosAgen(refOrigen, refNueva);
	}
	function datosArticuloAgen(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticuloAgen(cursor, campo);
	}
	function datosArticulo(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticulo(cursor, campo);
	}
	function datosTarifa(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosTarifa(cursor, campo);
	}
	function datosArticuloProv(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticuloProv(cursor, campo);
	}
	function copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean {
		return this.ctx.oficial_copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVAINCLUIDO ////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial ( context ); }
	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.ivaIncluido_datosArticulo(cursor,referencia);
	}
}
//// IVAINCLUIDO ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
class etiArticulo extends ivaIncluido {
	var tbnEtiquetas:Object;
    function etiArticulo( context ) { ivaIncluido ( context ); }
	function init() {
		return this.ctx.etiArticulo_init();
	}
	function imprimirEtiquetas() {
		return this.ctx.etiArticulo_imprimirEtiquetas();
	}
}
//// ETIQUETAS DE ART�CULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends etiArticulo {
	var curRappelArticulo:FLSqlCursor;
	var curRappelProvArt:FLSqlCursor;
    function rappel( context ) { etiArticulo ( context ); }
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.rappel_copiarAnexosArticulo(refOriginal, refNueva);
	}
	function copiarTablaRappelArticulos(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.rappel_copiarTablaRappelArticulos(refOriginal, refNueva);
	}
	function datosRappelArticulo(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.rappel_datosRappelArticulo(cursor, campo);
	}
// 	function copiarTablaArticulosProv(nuevaReferencia:String):Boolean {
// 		return this.ctx.rappel_copiarTablaArticulosProv(nuevaReferencia);
// 	}
	function copiarTablaRappelProvArt(idArticuloProvOrigen:String, idArticuloProvNuevo:String):Boolean {
		return this.ctx.rappel_copiarTablaRappelProvArt(idArticuloProvOrigen, idArticuloProvNuevo);
	}
	function datosRappelProvArt(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.rappel_datosRappelProvArt(cursor, campo);
	}
	function copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean {
		return this.ctx.rappel_copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration subfamilias */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIAS ////////////////////////////////////////////////
class subfamilias extends rappel {
    function subfamilias( context ) { rappel ( context ); }
}
//// SUBFAMILIAS ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////
class klo extends subfamilias {
	var tbnEtiquetas:Object;
	function klo( context ) { subfamilias ( context ); }
	function imprimirEtiquetas() {
		return this.ctx.klo_imprimirEtiquetas();
	}
}
//// KLO /////////////////////////////////////
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
/** \C El Al copiar un art�culo se copian tambi�n sus tarifas y sus precios por proveedor.
\end */
function interna_init()
{
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.toolButtonCopy = this.child("toolButtonCopy");
	connect(this.iface.toolButtonCopy, "clicked()", this, "iface.copiarArticulo_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_copiarArticulo_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (!cursor.isValid()) {
		return;
	}
// 	var referencia:String = this.iface.curArticulo.valueBuffer("referencia");
	var referencia:String = cursor.valueBuffer("referencia");
	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);

	if (!referencia) {
		MessageBox.information(util.translate("scripts", "No hay ning�n registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	try {
		if (this.iface.copiarArticulo(referencia)) {
			curTransaccion.commit();
		} else {
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Hubo un error al copiar el art�culo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		}
	}
	catch (e) {
		curTransaccion.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al copiar el art�culo %1").arg(referencia) + ":\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbRecords.refresh();

	return true;
}

function oficial_copiarArticulo(refOriginal:String):String
{
	var util:FLUtil;

    var nuevaReferencia = Input.getText(util.translate("scripts", "Introduzca la nueva referencia:"), "", util.translate("scripts", "Copiar art�culo"));
    if (!nuevaReferencia || nuevaReferencia == "") {
		MessageBox.warning(util.translate("scripts", "Debe introducir una referencia para crear el nuevo art�culo."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (util.sqlSelect("articulos","referencia","referencia = '" + nuevaReferencia + "'")) {
		MessageBox.warning(util.translate("scripts", "Ya existe un art�culo con esa referencia"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curArticuloOrigen:FLSqlCursor = new FLSqlCursor("articulos");
	curArticuloOrigen.select("referencia = '" + refOriginal + "'");
	if (!curArticuloOrigen.first()) {
		return false;
	}
	curArticuloOrigen.setModeAccess(curArticuloOrigen.Browse);
	curArticuloOrigen.refreshBuffer();
	
	if (!this.iface.curArticulo) {
		this.iface.curArticulo = new FLSqlCursor("articulos");
	}
	this.iface.curArticulo.setModeAccess(this.iface.curArticulo.Insert);
	this.iface.curArticulo.refreshBuffer();
	this.iface.curArticulo.setValueBuffer("referencia", nuevaReferencia);

	var campos:Array = util.nombreCampos("articulos");
	var totalCampos:Number = campos[0];
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.datosArticulo(curArticuloOrigen, campos[i])) {
			return false;
		}
	}

	if (!this.iface.curArticulo.commitBuffer()) {
		return false;
	}

	if (!this.iface.copiarAnexosArticulo(refOriginal, nuevaReferencia)) {
		return false;
	}
	
	return nuevaReferencia;
}

function oficial_datosArticulo(cursor:FLSqlCursor, campo:String):Boolean 
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "referencia": {
			return true;
			break;
		}
		case "stockfis": {
			this.iface.curArticulo.setValueBuffer(campo, 0);
			break;
		}
		default: {
			if (cursor.isNull(campo)) {
				this.iface.curArticulo.setNull(campo);
			} else {
				this.iface.curArticulo.setValueBuffer(campo, cursor.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.copiarTablaTarifas(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaArticulosProv(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaArticulosAgen(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

function oficial_copiarTablaTarifas(refOriginal:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curTarifa) {
		this.iface.curTarifa = new FLSqlCursor("articulostarifas");
	}
	
	var campos:Array = util.nombreCampos("articulostarifas");
	var totalCampos:Number = campos[0];

	var curTarifaOrigen:FLSqlCursor = new FLSqlCursor("articulostarifas");
	curTarifaOrigen.select("referencia = '" + refOriginal + "'");
	while (this.iface.curTarifa.next()) {
		this.iface.curTarifa.setModeAccess(this.iface.curTarifa.Insert);
		this.iface.curTarifa.refreshBuffer();
		this.iface.curTarifa.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosTarifa(curTarifaOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curTarifa.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function oficial_copiarTablaArticulosProv(refOriginal:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curArticuloProv) {
 		this.iface.curArticuloProv = new FLSqlCursor("articulosprov");
	}
	
	var campos:Array = util.nombreCampos("articulosprov");
	var totalCampos:Number = campos[0];

	var idArtProvNuevo:String, idArtProvOrigen:String;
	var curArticuloProvOrigen:FLSqlCursor = new FLSqlCursor("articulosprov");
	curArticuloProvOrigen.select("referencia = '" + refOriginal + "'");
	while (curArticuloProvOrigen.next()) {
		this.iface.curArticuloProv.setModeAccess(this.iface.curArticuloProv.Insert);
		this.iface.curArticuloProv.refreshBuffer();
		this.iface.curArticuloProv.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosArticuloProv(curArticuloProvOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curArticuloProv.commitBuffer()) {
			return false;
		}
		idArtProvOrigen = curArticuloProvOrigen.valueBuffer("id");
		idArtProvNuevo = this.iface.curArticuloProv.valueBuffer("id");
		if (!this.iface.copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo)) {
			return false;
		}
	}

	return true;
}

function oficial_copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean
{
	return true;
}

function oficial_copiarTablaArticulosAgen(refOrigen:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curArticuloAgen) {
		this.iface.curArticuloAgen = new FLSqlCursor("articulosagen");
	}
	
	var campos:Array = util.nombreCampos("articulosagen");
	var totalCampos:Number = campos[0];

	var curArticuloAgenOrigen:FLSqlCursor = new FLSqlCursor("articulosagen");
	curArticuloAgenOrigen.select("referencia = '" + refOrigen + "'");
	while (curArticuloAgenOrigen.next()) {
		this.iface.curArticuloAgen.setModeAccess(this.iface.curArticuloAgen.Insert);
		this.iface.curArticuloAgen.refreshBuffer();
		this.iface.curArticuloAgen.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosArticuloAgen(curArticuloAgenOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curArticuloAgen.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function oficial_datosTarifa(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curTarifa.setNull(campo);
			} else {
				this.iface.curTarifa.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_datosArticuloAgen(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curArticuloAgen.setNull(campo);
			} else {
				this.iface.curArticuloAgen.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_datosArticuloProv(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curArticuloProv.setNull(campo);
			} else {
				this.iface.curArticuloProv.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVAINCLUIDO ////////////////////////////////////////////////
function ivaIncluido_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean 
{
	if (!this.iface.__datosArticulo(cursor,referencia))
		return false	

	cursor.setValueBuffer("ivaincluido",this.iface.curArticulo.valueBuffer("ivaincluido"));
	
	return true;
}
//// IVAINCLUIDO ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS POR ART�CULO /////////////////////////////////////
function etiArticulo_init()
{
	this.iface.__init();
	this.iface.tbnEtiquetas = this.child("tbnEtiquetas");

	connect(this.iface.tbnEtiquetas, "clicked()", this, "iface.imprimirEtiquetas");
}

/** \D Imprime las etiquetas correspondientes a todas las l�neas del albar�n seleccionado
\end */
function etiArticulo_imprimirEtiquetas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia) {
		return false;
	}

	var cantidad:Number = Input.getNumber(util.translate("scripts", "N� etiquetas"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
	if (!cantidad) {
		return false;
	}
	
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	for (var i:Number = 0; i < cantidad; i++) {
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("barcode", cursor.valueBuffer("codbarras"));
		eRow.setAttribute("referencia", cursor.valueBuffer("referencia"));
		eRow.setAttribute("descripcion", cursor.valueBuffer("descripcion"));
		eRow.setAttribute("pvp", cursor.valueBuffer("pvp"));
		eRow.setAttribute("level", 0);
		xmlKD.firstChild().appendChild(eRow);
	}

	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}
//// ETIQUETAS POR ART�CULO /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva)) {
		return false;
	}	
	if (!this.iface.copiarTablaRappelArticulos(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

function rappel_copiarTablaRappelArticulos(refOriginal:String, refNueva:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curRappelArticulo) {
		this.iface.curRappelArticulo = new FLSqlCursor("rappelarticulos");
	}
	
	var campos:Array = util.nombreCampos("rappelarticulos");
	var totalCampos:Number = campos[0];

	var curRappelArticuloOrigen:FLSqlCursor = new FLSqlCursor("rappelarticulos");
	curRappelArticuloOrigen.select("referencia = '" + refOriginal + "'");
	while (curRappelArticuloOrigen.next()) {
		this.iface.curRappelArticulo.setModeAccess(this.iface.curRappelArticulo.Insert);
		this.iface.curRappelArticulo.refreshBuffer();
		this.iface.curRappelArticulo.setValueBuffer("referencia", refNueva);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosRappelArticulo(curRappelArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curRappelArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function rappel_datosRappelArticulo(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curRappelArticulo.setNull(campo);
			} else {
				this.iface.curRappelArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}

	return true;
}

// function rappel_copiarTablaArticulosProv(nuevaReferencia:String):Boolean
// {
// 	var util:FLUtil;
// 
// 	this.iface.curArticuloProv = new FLSqlCursor("articulosprov");
// 	this.iface.curArticuloProv.select("referencia = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");
// 	
// 	var curArticuloProvNuevo:FLSqlCursor = new FLSqlCursor("articulosprov");
// 	var campos:Array = util.nombreCampos("articulosprov");
// 	var totalCampos:Number = campos[0];
// 
// 	while (this.iface.curArticuloProv.next()) {
// 		curArticuloProvNuevo.setModeAccess(curArticuloProvNuevo.Insert);
// 		curArticuloProvNuevo.refreshBuffer();
// 		curArticuloProvNuevo.setValueBuffer("referencia", nuevaReferencia);
// 	
// 		for (var i:Number = 1; i <= totalCampos; i++) {
// 			if (!this.iface.datosArticuloProv(curArticuloProvNuevo,campos[i]))
// 				return false;
// 		}
// 
// 		if (!curArticuloProvNuevo.commitBuffer())
// 			return false;
// 
// 		var idArticuloProvNuevo:Number = curArticuloProvNuevo.valueBuffer("id");
// 		if(!idArticuloProvNuevo)
// 			return false;
// 		if(!this.iface.copiarTablaRappelProvArt(idArticuloProvNuevo))
// 			return false;
// 	}
// 
// 	return true;
// }

function rappel_copiarTablaRappelProvArt(idArticuloProvOrigen:String, idArticuloProvNuevo:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curRappelProvArt) {
		this.iface.curRappelProvArt = new FLSqlCursor("rappelprovart");
	}
	
	var campos:Array = util.nombreCampos("rappelarticulos");
	var totalCampos:Number = campos[0];

	var curRappelProvArtOrigen:FLSqlCursor = new FLSqlCursor("rappelprovart");
	curRappelProvArtOrigen.select("id = '" + idArticuloProvOrigen + "'");
	while (curRappelProvArtOrigen.next()) {
		this.iface.curRappelProvArt.setModeAccess(this.iface.curRappelProvArt.Insert);
		this.iface.curRappelProvArt.refreshBuffer();
		this.iface.curRappelProvArt.setValueBuffer("id", idArticuloProvNuevo);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosRappelProvArt(curRappelProvArtOrigen,campos[i])) {
				return false;
			}
		}

		if (!this.iface.curRappelProvArt.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function rappel_datosRappelProvArt(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "idrappel": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curRappelProvArt.setNull(campo);
			} else {
				this.iface.curRappelProvArt.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}

	return true;
}

function rappel_copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean
{
	if (!this.iface.__copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo)) {
		return false;
	}

	if (!this.iface.copiarTablaRappelProvArt(idArtProvOrigen, idArtProvNuevo)) {
		return false;
	}
	return true;
}
//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////


/** @class_definition subfamilias */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIAS ////////////////////////////////////////////////
//// SUBFAMILIAS ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////
/** \D Imprime las etiquetas correspondientes a todas las l�neas del albar�n seleccionado
\end */
function klo_imprimirEtiquetas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia) {
		return false;
	}
	
	////////////// KLO. NUEVO ETIQUETAS
	var curEti:FLSqlCursor = new FLSqlCursor("i_etiquetasart");
	
	curEti.setAction("i_etiquetasart");
	curEti.select("1=1");

	if(!curEti.first()){
		with(curEti) {
			setModeAccess(Insert);
			refreshBuffer();
		}
		if (!curEti.commitBuffer())
			return false; 
	}
	with(curEti) {
		setModeAccess(Edit);
		refreshBuffer();
	}
	curEti.first();
	debug("KLO--> cursor: "+cursor.table());
	// Asigno la variable del cursor padre a i_etiquetasart.
	formRecordi_etiquetasart.iface.curPadre_ = cursor;
	curEti.editRecord();
	
	return true;
	//////////////// --- FIN NUEVO ETIQUETAS

	var cantidad:Number = Input.getNumber(util.translate("scripts", "N� etiquetas"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
	if (!cantidad) {
		return false;
	}
	
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	for (var i:Number = 0; i < cantidad; i++) {
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("barcode", cursor.valueBuffer("codbarras"));
		eRow.setAttribute("referencia", cursor.valueBuffer("referencia"));
		eRow.setAttribute("descripcion", cursor.valueBuffer("descripcion"));
		eRow.setAttribute("pvp", cursor.valueBuffer("pvp"));
		eRow.setAttribute("nomsubfamilia", util.sqlSelect("subfamilias","descripcion","codsubfamilia = '" + cursor.valueBuffer("codsubfamilia") + "'"));
		eRow.setAttribute("level", 0);
		xmlKD.firstChild().appendChild(eRow);
	}
	
	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}
//// KLO /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////