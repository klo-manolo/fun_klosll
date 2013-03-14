/***************************************************************************
                 flfactalma.qs  -  description
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
	function afterCommit_stocks(curStock:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_stocks(curStock);
	}
	function beforeCommit_stocks(curStock:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_stocks(curStock);
	}
	function afterCommit_lineastransstock(curLTS:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineastransstock(curLTS);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); } 
	function cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean {
		return this.ctx.oficial_cambiarStock(codAlmacen, referencia, variacion, campo);
	}
	function cambiarCosteMedio(referencia:String):Boolean {
		return this.ctx.oficial_cambiarCosteMedio(referencia);
	}
	function controlStockPedidosCli(curLP:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockPedidosCli(curLP);
	}
	function controlStockPedidosProv(curLP:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockPedidosProv(curLP);
	}
	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockAlbaranesCli(curLA);
	}
	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockAlbaranesProv(curLA);
	}
	function controlStockFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockFacturasCli(curLF);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockComandasCli(curLV);
	}
	function controlStockFacturasProv(curLF:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockFacturasProv(curLF);
	}
	function crearStock(codAlmacen:String, referencia:String):Number {
		return this.ctx.oficial_crearStock(codAlmacen, referencia);
	}
	function controlStockLineasTrans(curLTS:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockLineasTrans(curLTS);
	}
	function controlStockValesTPV(curLinea:FLSqlCursor):Boolean {
		return this.ctx.oficial_controlStockValesTPV(curLinea);
	}
	function controlStock( curLinea:FLSqlCursor, campo:String, signo:Number, codAlmacen:String ):Boolean {
		return this.ctx.oficial_controlStock( curLinea, campo, signo, codAlmacen );
	}
	function controlStockPteRecibir(curLinea:FLSqlCursor, codAlmacen:String):Boolean {
		return this.ctx.oficial_controlStockPteRecibir(curLinea, codAlmacen);
	}
	function actualizarStockPteRecibir(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.oficial_actualizarStockPteRecibir(referencia, codAlmacen, idPedido);
	}
	function controlStockReservado(curLinea:FLSqlCursor, codAlmacen:String):Boolean {
		return this.ctx.oficial_controlStockReservado(curLinea, codAlmacen);
	}
	function actualizarStockReservado(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.oficial_actualizarStockReservado(referencia, codAlmacen, idPedido);
	}
	function comprobarStock(curStock:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarStock(curStock);
	}
	function valorDefectoAlmacen(fN:String):String {
		return this.ctx.oficial_valorDefectoAlmacen(fN);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA /////////////////////////////////////
class scab extends oficial {
	function scab( context ) { oficial ( context ); }
	function controlStockPedidosCli(curLP:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockPedidosCli(curLP);
	}
	function controlStockProv(curLP:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockPedidosProv(curLP);
	}
	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockAlbaranesCli(curLA);
	}
	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockAlbaranesProv(curLA);
	}
	function controlStockFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockFacturasCli(curLF);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockComandasCli(curLV);
	}
	function controlStockFacturasProv(curLF:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockFacturasProv(curLF);
	}
	function controlStockLineasTrans(curLTS:FLSqlCursor):Boolean {
		return this.ctx.scab_controlStockLineasTrans(curLTS);
	}
	function arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.scab_arraySocksAfectados(arrayInicial, arrayFinal);
	}
	function compararArrayStock(a:Array, b:Array):Number {
		return this.ctx.scab_compararArrayStock(a, b);
	}
	function actualizarStockFisico(referencia:String, codAlmacen:String, campo:String):Boolean {
		return this.ctx.scab_actualizarStockFisico(referencia, codAlmacen, campo);
	}
	function actualizarStockReservado(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.scab_actualizarStockReservado(referencia, codAlmacen, idPedido);
	}
	function actualizarStockPteRecibir(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.scab_actualizarStockPteRecibir(referencia, codAlmacen, idPedido);
	}
	function controlStockFisico(curLinea:FLSqlCursor, codAlmacen:String, campo):Boolean {
		return this.ctx.scab_controlStockFisico(curLinea, codAlmacen, campo);
	}
}
//// CONTROL STOCK CABECERA /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
class etiArticulo extends scab {
	function etiArticulo( context ) { scab ( context ); }
	function lanzarEtiArticulo(xmlKD:FLDomDocument) {
		return this.ctx.etiArticulo_lanzarEtiArticulo(xmlKD);
	}
	function tipoInformeEtiquetas() {
		return this.ctx.etiArticulo_tipoInformeEtiquetas();
	}
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
class pedidosauto extends etiArticulo {
	function pedidosauto( context ) { etiArticulo ( context ); }
// 	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
// 		return this.ctx.pedidosauto_controlStockAlbaranesCli(curLA);
// 	}
// 	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
// 		return this.ctx.pedidosauto_controlStockAlbaranesProv(curLA);
// 	}
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration klo */
/////////////////////////////////////////////////////////////////
//// KLO ///////////////////////////////////////////////
class klo extends pedidosauto 
{
	function klo( context ) { pedidosauto ( context ); }

	function cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean {
		return this.ctx.klo_cambiarStock(codAlmacen, referencia, variacion, campo);
	}
	function afterCommit_codigosdebarras(curCB:FLSqlCursor):Boolean {
		return this.ctx.klo_afterCommit_codigosdebarras(curCB);
	}
	function cambiarCosteMedio(referencia:String):Boolean {
		return this.ctx.klo_cambiarCosteMedio(referencia);
	}
	function cambiarUltimoCoste(referencia:String):Boolean {
		return this.ctx.klo_cambiarUltimoCoste(referencia);
	}
	function asignaPreciosProveedor(referencia:String, codProveedor:String, idLinea:Number):Boolean {
		return this.ctx.klo_asignaPreciosProveedor(referencia, codProveedor, idLinea);
	}
	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.klo_controlStockAlbaranesCli(curLA);
	}
	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.klo_controlStockAlbaranesProv(curLA);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.klo_controlStockComandasCli(curLV);
	}
	function controlStockLineasTrans(curLTS:FLSqlCursor):Boolean {
		return this.ctx.klo_controlStockLineasTrans(curLTS);
	}
	function afterCommit_lineasregstocks(curLRS:FLSqlCursor):Boolean {
		return this.ctx.klo_afterCommit_lineasregstocks(curLRS);
	}
	function afterCommit_transstock(curTS:FLSqlCursor):Boolean {
		return this.ctx.klo_afterCommit_transstock(curTS);
	}
	function ultimoCMS(referencia:String, codAlmacen:String):Array {
		return this.ctx.klo_ultimoCMS(referencia, codAlmacen);
	}
	function CMSenUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number {
		return this.ctx.klo_CMSenUnaFecha(referencia, codAlmacen, fechaFin);
	}
	function calculosUltCMS(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.klo_calculosUltCMS(referencia, codAlmacen);
	}
	function actualizaStock(referencia:String, codAlmacen:String, stock:Number):Boolean {
		return this.ctx.klo_actualizaStock(referencia, codAlmacen, stock);
	}
	function actualizaCMS(referencia:String, codAlmacen:String, cms:Number):Boolean {
		return this.ctx.klo_actualizaCMS(referencia, codAlmacen, cms);
	}
	function controlCMSAlbaranesCli(referencia:String, codAlmacen:String, fechaFin:Date):Boolean {
		return this.ctx.klo_controlCMSAlbaranesCli(referencia, codAlmacen, fechaFin);
	}
	function controlCMSFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.ctx.klo_controlCMSFacturasCli(curLF);
	}
	function arrayLineasAfectadas(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.klo_arrayLineasAfectadas(arrayInicial, arrayFinal);
	}
	function compararArrayLineas(a:Array, b:Array):Number {
		return this.ctx.klo_compararArrayLineas(a, b);
	}
	function controlArticulo(curLinea:FLSqlCursor, codAlmacen:String, fecha:Date):Boolean {
		return this.ctx.klo_controlArticulo(curLinea, codAlmacen, fecha);
	}
	function costeEnUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number {
		return this.ctx.klo_costeEnUnaFecha(referencia, codAlmacen, fechaFin);
	}
	function arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.klo_arraySocksAfectados(arrayInicial, arrayFinal);
	}
}
//// KLO ///////////////////////////////////////////////
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
	function pub_cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String, noAvisar:Boolean ):Boolean {
		return this.cambiarStock(codAlmacen, referencia, variacion,campo, noAvisar);
	}
	function pub_crearStock(codAlmacen:String, referencia:String):Number {
		return this.crearStock(codAlmacen, referencia);
	}
	function pub_cambiarCosteMedio(referencia:String):Boolean {
		return this.cambiarCosteMedio(referencia);
	}
	function pub_controlStockPedidosCli(curLP:FLSqlCursor):Boolean {
		return this.controlStockPedidosCli(curLP);
	}
	function pub_controlStockPedidosProv(curLP:FLSqlCursor):Boolean {
		return this.controlStockPedidosProv(curLP);
	}
	function pub_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.controlStockAlbaranesCli(curLA);
	}
	function pub_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.controlStockAlbaranesProv(curLA);
	}
	function pub_controlStockFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.controlStockFacturasCli(curLF);
	}
	function pub_controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.controlStockComandasCli(curLV);
	}
	function pub_controlStockFacturasProv(curLF:FLSqlCursor):Boolean {
		return this.controlStockFacturasProv(curLF);
	}
	function pub_controlStockValesTPV(curLinea:FLSqlCursor):Boolean {
		return this.controlStockValesTPV(curLinea);
	}
	function pub_valorDefectoAlmacen(fN:String):String {
		return this.valorDefectoAlmacen(fN);
	}
}

const iface = new pubklo( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubScab */
/////////////////////////////////////////////////////////////////
//// PUB SCAB ///////////////////////////////////////////////////
class pubScab extends ifaceCtx {
	function pubScab ( context ) { ifaceCtx( context ); }
	function pub_arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.arraySocksAfectados(arrayInicial, arrayFinal);
	}
	function pub_actualizarStockReservado(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.actualizarStockReservado(referencia, codAlmacen, idPedido);
	}
	function pub_actualizarStockPteRecibir(referencia:String, codAlmacen:String, idPedido:String):Boolean {
		return this.actualizarStockPteRecibir(referencia, codAlmacen, idPedido);
	}
	function pub_actualizarStockFisico(referencia:String, codAlmacen:String, campo:String):Boolean {
		return this.actualizarStockFisico(referencia, codAlmacen, campo);
	}
}
//// PUB SCAB ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEtiArticulo */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class pubEtiArticulo extends pubScab {
	function pubEtiArticulo( context ) { pubScab( context ); }
	function pub_lanzarEtiArticulo(xmlKD) {
		return this.lanzarEtiArticulo(xmlKD);
	}
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubklo */
/////////////////////////////////////////////////////////////////
//// PUB_KLO ///////////////////////////////////////////////
class pubklo extends pubEtiArticulo {
	function pubklo( context ) { pubEtiArticulo( context ); }

	//function pub_cambiarCosteMedio(referencia:String):Boolean {
	//	return this.cambiarCosteMedio(referencia);
	//}
	function pub_cambiarUltimoCoste(referencia:String):Boolean {
		return this.cambiarUltimoCoste(referencia);
	}
	function pub_asignaPreciosProveedor(referencia:String, codProveedor:String, idLinea:Number):Boolean {
		return this.asignaPreciosProveedor(referencia, codProveedor, idLinea);
	}
	function pub_CMSenUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number {
		return this.CMSenUnaFecha(referencia, codAlmacen, fechaFin);
	}
	function pub_calculosUltCMS(referencia:String, codAlmacen:String):Boolean {
		return this.calculosUltCMS(referencia, codAlmacen);
	}
	function pub_controlCMSAlbaranesCli(referencia:String, codAlmacen:String, fechaFin:Date):Boolean {
		return this.controlCMSAlbaranesCli(referencia, codAlmacen, fechaFin);
	}
	function pub_controlCMSFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.controlCMSFacturasCli(curLF);
	}
	function pub_arrayLineasAfectadas(arrayInicial:Array, arrayFinal:Array):Array {
		return this.arrayLineasAfectadas(arrayInicial, arrayFinal);
	}
	function pub_costeEnUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number {
		return this.costeEnUnaFecha(referencia, codAlmacen, fechaFin);
	}
}
//// PUB_KLO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \D Si no hay ningún almacén en la tabla almacenes se inserta uno por defecto
\end */
function interna_init()
{
	var cursor:FLSqlCursor = new FLSqlCursor("almacenes");
	cursor.select();
	if (!cursor.first()) {
		var util:FLUtil = new FLUtil();
		MessageBox.information(util.translate("scripts",
			"Se insertará un almacén por defecto para empezar a trabajar."),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		with (cursor) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("codalmacen","ALG");
			setValueBuffer("nombre", util.translate("scripts","ALMACEN GENERAL"));
			commitBuffer();
		}
		cursor = new FLSqlCursor("empresa");
		cursor.select();
		if (cursor.first()) {
			with (cursor) {
				setModeAccess(cursor.Edit);
				refreshBuffer();
				if (!valueBuffer("codalmacen")) {
					setValueBuffer("codalmacen","ALG");
					commitBuffer();
				}
			}
		}
	}

	///////////// BORRAR 25/09/08 ///////////////////////////////
	// Es para inicializar los dos campos nuevos Se compra y Se vende a true.
	var util:FLUtil;
	if(!util.sqlSelect("articulos","referencia","secompra OR sevende")) {
		MessageBox.information(util.translate("scripts", "A continuación se van a actualizar los nuevos campos de los artículos\nEsto puede llevar algunos segundos"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		util.sqlUpdate("articulos","secompra",true,"1 = 1");
		util.sqlUpdate("articulos","sevende",true,"1 = 1");
		MessageBox.information(util.translate("scripts", "Proceso finalizado"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	}
	///////////// BORRAR 25/09/08 ///////////////////////////////
}

/** \D
Actualiza el stock físico total en la tabla de artículos
\end */
function interna_afterCommit_stocks(curStock:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var referencia:String = curStock.valueBuffer("referencia");
	var stockFisico:Number = util.sqlSelect("stocks", "SUM(cantidad)", "referencia = '" + referencia + "'");
	switch (curStock.modeAccess()) {
		case curStock.Edit:
			var refAnterior:String = curStock.valueBufferCopy("referencia");
			if (referencia != refAnterior) {
				if (!util.sqlUpdate("articulos", "stockfis", stockFisico, "referencia = '" + refAnterior + "'"))
					return false;
			}
		case curStock.Insert:
// 			if((curStock.valueBufferCopy("cantidad") != curStock.valueBuffer("cantidad")) || (curStock.valueBufferCopy("reservada") != curStock.valueBuffer("reservada"))) {
// 				curStock.setValueBuffer("disponible",parseFloat(curStock.valueBuffer("cantidad")) - parseFloat(curStock.valueBuffer("reservada")));
// 			}
		case curStock.Del:
			if (!util.sqlUpdate("articulos", "stockfis", stockFisico, "referencia = '" + referencia + "'"))
				return false;
	}
	return true;
}

/** \D
Avisa al usuario en caso de querer borrar un stock con cantidad distinta de 0
\end */
function interna_beforeCommit_stocks(curStock:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curStock.modeAccess()) {
		case curStock.Del: {
			if (parseFloat(curStock.valueBuffer("cantidad")) != 0) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Va a eliminar un registro de stock con cantidad distinta de 0.\n¿Está seguro?"), MessageBox.No, MessageBox.Yes);
				if (res != MessageBox.Yes)
					return false;
			}
		}
	}
	return true;
}

function interna_afterCommit_lineastransstock(curLTS:FLSqlCursor):Boolean {
	return this.iface.controlStockLineasTrans(curLTS);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Cambia el valor del stock en un determinado almacén. Se comprueba si el valor de la variación es negativo y mayor al stock actual, en cuyo caso se avisa al usuario de la falta de existencias

@param codAlmacen Código del almacén
@param referencia Referencia del artículo
@param variación Variación en el número de existencias del artículo
@param	campo: Nombre del campo a modificar. Si el campo es vacío o es --cantidad-- se llama a la función padre
@return True si la modificación tuvo éxito, false en caso contrario
\end */
function oficial_cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String, noAvisar:Boolean ):Boolean
{
	var util:FLUtil = new FLUtil();
	if (referencia == "" || !referencia) {
		return true;
	}

	if (codAlmacen == "" || !codAlmacen) {
		return true;
	}

	if ( !campo || campo == "") {
		return false;
	}

	var idStock:String;
	idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}
	var curStock:FLSqlCursor = new FLSqlCursor( "stocks" );
	curStock.select( "idstock = " + idStock );
	if ( !curStock.first() ) {
		return false;
	}
	
	curStock.setModeAccess( curStock.Edit );
	curStock.refreshBuffer();
	
	var cantidadPrevia:Number = parseFloat( curStock.valueBuffer( campo ) );
	var nuevaCantidad:Number = cantidadPrevia + parseFloat( variacion );

// 	if (nuevaCantidad < 0 && campo == "cantidad") {
// 		if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
// 			MessageBox.warning( util.translate("scripts", "El artículo %1 no permite ventas sin stock. Este movimiento dejaría el stock de %2 con cantidad %3.\n").arg(referencia).arg(codAlmacen).arg(nuevaCantidad), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 	}

	curStock.setValueBuffer( campo, nuevaCantidad );
	if (campo == "cantidad" || campo == "reservada") {
		curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	}

	if (!this.iface.comprobarStock(curStock)) {
		return false;
	}

	if ( !curStock.commitBuffer() ) {
		return false;
	}

	return true;
}

/** \D Comprueba, en el caso de que el artículo no permita ventas sin stock, si el stock que se va a guardar incumple dicha condición
@param	curStock: Cursor a guardar
@return	True si la comprobación es correcta, false en caso contrario
\end */
function oficial_comprobarStock(curStock:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var referencia:String = curStock.valueBuffer("referencia");
	var codAlmacen:String = curStock.valueBuffer("codalmacen");
	if (util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
		return true;
	}

	var stockPedidos:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("stockpedidos");

	var cantidadControl:Number;
	if (stockPedidos) {
		cantidadControl = curStock.valueBuffer("disponible");
	} else {
		cantidadControl = curStock.valueBuffer("cantidad");
	}
	if (cantidadControl < 0) {
		var nombreCantidad:String;
		if (stockPedidos) {
			nombreCantidad = util.translate("scripts", "cantidad disponible");
		} else {
			nombreCantidad = util.translate("scripts", "cantidad en stock");
		}
		if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
			MessageBox.warning( util.translate("scripts", "El artículo %1 no permite ventas sin stock. Este movimiento dejaría el stock de %2 con %3 %4.\n").arg(referencia).arg(codAlmacen).arg(nombreCantidad).arg(cantidadControl), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/** \D Recalcula el coste medio de compra de un artículo como media del coste en todos los albaranes de proveedor

@param referencia Referencia del artículo
@return True si la modificación tuvo éxito, false en caso contrario
\end */
function oficial_cambiarCosteMedio(referencia:String):Boolean
{
	if (referencia == "")
		return true;

	var util:FLUtil = new FLUtil();
	var sumCant:Number = util.sqlSelect("lineasfacturasprov", "SUM(cantidad)", "referencia = '" + referencia + "'");
	if ( !sumCant )
		return true;
	var cM:Number = util.sqlSelect("lineasfacturasprov", "(SUM(pvptotal) / SUM(cantidad))", "referencia = '" + referencia + "'");
	if (!cM)
		cM = 0;

	var curArticulo:FLSqlCursor = new FLSqlCursor("articulos");
	curArticulo.select("referencia = '" + referencia + "'");
	if (curArticulo.first()) {
		curArticulo.setModeAccess(curArticulo.Edit);
		curArticulo.refreshBuffer();
		curArticulo.setValueBuffer("costemedio", cM);
		curArticulo.commitBuffer();
	}

	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockPedidosCli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'")) {
		return true;
	}

	var codAlmacen:String;
	var curRel:FLSqlCursor = curLP.cursorRelation();
	if (curRel && curRel.table() == "pedidoscli") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLP.valueBuffer("idpedido"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	if (!this.iface.controlStockReservado(curLP, codAlmacen)) {
		return false;
	}
	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
en caso de que no venga de un pedido, o que la opción general de control
de stocks en pedidos esté inhabilitada
\end */
function oficial_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
		return true;
	}

	var codAlmacen:String;
	var curRel:FLSqlCursor = curLA.cursorRelation();
	if (curRel && curRel.table() == "albaranescli") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	
	if (!this.iface.controlStock( curLA, "cantidad", -1, codAlmacen )) {
		return false;
	}

	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockFacturasCli(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		return true;
	}
	if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}

	var codAlmacen:String;
	var curRel:FLSqlCursor = curLF.cursorRelation();
	if (curRel && curRel.table() == "facturascli") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	if (!this.iface.controlStock(curLF, "cantidad", -1, codAlmacen)) {
		return false;
	}
	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockComandasCli(curLV:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLV.valueBuffer("referencia") + "'")) {
		return true;
	}

	var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	if (!this.iface.controlStock(curLV, "cantidad", -1, codAlmacen)) {
		return false;
	}

	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockPedidosProv(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'")) {
		return true;
	}

	var codAlmacen:String;
	var curRel:FLSqlCursor = curLP.cursorRelation();
	if (curRel && curRel.table() == "pedidosprov") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("pedidosprov", "codalmacen", "idpedido = " + curLP.valueBuffer("idpedido"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	if (!this.iface.controlStockPteRecibir(curLP, codAlmacen)) {
		return false;
	}
	
	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLA.valueBuffer("referencia") + "'")) {
		return true;
	}
	var codAlmacen:String;
	var curRel:FLSqlCursor = curLA.cursorRelation();
	if (curRel && curRel.table() == "albaranesprov") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	if (!this.iface.controlStock(curLA, "cantidad", 1, codAlmacen)) {
		return false;
	}
	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockFacturasProv(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		return true;
	}
	if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}
	var codAlmacen:String;
	var curRel:FLSqlCursor = curLF.cursorRelation();
	if (curRel && curRel.table() == "facturasprov") {
		codAlmacen = curRel.valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	}
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}

	if (!this.iface.controlStock(curLF, "cantidad", 1, codAlmacen)) {
		return false;
	}
	return true;
}

/** \D Crea un registro de stock para el almacén y artículo especificados
@param	codAlmacen: Almacén
@param	referencia: Referencia del artículo
@return	identificador del stock o false si hay error
\end */
function oficial_crearStock(codAlmacen:String, referencia:String):Number
{
	var util:FLUtil = new FLUtil;
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with(curStock) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("codalmacen", codAlmacen);
		setValueBuffer("referencia", referencia);
		setValueBuffer("nombre", util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'"));
		setValueBuffer("cantidad", 0);
		if (!commitBuffer())
			return false;
	}
	return curStock.valueBuffer("idstock");
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockLineasTrans(curLTS:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codAlmacenOrigen:String = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenOrigen || codAlmacenOrigen == "")
		return true;
		
	var codAlmacenDestino:String = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenDestino || codAlmacenDestino == "")
		return true;
	
	if (!this.iface.controlStock(curLTS, "cantidad", -1, codAlmacenOrigen))
			return false;

	if (!this.iface.controlStock(curLTS, "cantidad", 1, codAlmacenDestino))
			return false;

	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function oficial_controlStockValesTPV(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLinea.valueBuffer("referencia") + "'"))
		return true;

	var codAlmacen:String = curLinea.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "")
		return true;
	
	if (!this.iface.controlStock(curLinea, "cantidad", 1, codAlmacen))
			return false;

	return true;
}

/** \D Incrementa o decrementa el stock en función de la variación experimentada por una línea de documento de facturación
@param	curLinea: Cursor posicionado en la línea de documento de facturación
@param	campo: Campo a modificar
@param	operación: Indica si la cantidad debe sumarse o restarse del stock
@param	codAlmacen: Código del almacén asociado al stock a modificar
@return	True si el control se realiza correctamente, false en caso contrario
*/
function oficial_controlStock( curLinea:FLSqlCursor, campo:String, signo:Number, codAlmacen:String ):Boolean 
{
	var variacion:Number;
	var cantidad:Number = parseFloat( curLinea.valueBuffer( "cantidad" ) );
	var cantidadPrevia:Number = parseFloat( curLinea.valueBufferCopy( "cantidad" ) );

	if ( curLinea.table() == "lineaspedidoscli" || curLinea.table() == "lineaspedidosprov" ) {
		cantidad -= parseFloat( curLinea.valueBuffer( "totalenalbaran" ) );
		cantidadPrevia -= parseFloat( curLinea.valueBufferCopy( "totalenalbaran" ) );
	}

	switch(curLinea.modeAccess()) {
		case curLinea.Insert: {
			variacion = signo * cantidad;
			if ( !this.iface.cambiarStock( codAlmacen, curLinea.valueBuffer( "referencia" ), variacion, campo ) )
				return false;
			break;
		}
		case curLinea.Del: {
			variacion = signo * -1 * cantidad;
			if ( !this.iface.cambiarStock( codAlmacen, curLinea.valueBuffer( "referencia" ), variacion, campo ) )
				return false;
			break;
		}
		case curLinea.Edit: {
			if (curLinea.valueBuffer( "referencia" ) != curLinea.valueBufferCopy( "referencia" )) {
				variacion = signo * -1 * cantidadPrevia;
				if ( !this.iface.cambiarStock( codAlmacen, curLinea.valueBufferCopy( "referencia" ), variacion, campo ) )
					return false;
				variacion = signo * cantidad;
				if ( !this.iface.cambiarStock( codAlmacen, curLinea.valueBuffer( "referencia" ), variacion, campo, true ) )
					return false;
			}
			else {
				if(cantidad != cantidadPrevia);
				variacion = (cantidad - cantidadPrevia) * signo;
				if (!this.iface.cambiarStock( codAlmacen, curLinea.valueBuffer( "referencia" ), variacion, campo) )
					return false;
			}
			break;
		}
	}

	return true;
}

function oficial_controlStockPteRecibir(curLinea:FLSqlCursor, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idPedido:String = curLinea.valueBuffer("idpedido");
	var referencia:String = curLinea.valueBuffer("referencia");
	if (referencia && referencia != "") {
		if (!this.iface.actualizarStockPteRecibir(referencia, codAlmacen, idPedido)) {
			return false;
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	if (referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) {
		if (!this.iface.actualizarStockPteRecibir(referenciaPrevia, codAlmacen, idPedido)) {
			return false;
		}
	}
 
	return true;
}

function oficial_actualizarStockPteRecibir(referencia:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idStock:String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}
	var pteRecibir:Number = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidosprov,pedidosprov");

	if (isNaN(pteRecibir)) {
		pteRecibir = 0;
	}
	
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("pterecibir", pteRecibir);
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_controlStockReservado(curLinea:FLSqlCursor, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idPedido:String = curLinea.valueBuffer("idpedido");
	var referencia:String = curLinea.valueBuffer("referencia");
	if (referencia && referencia != "") {
		if (!this.iface.actualizarStockReservado(referencia, codAlmacen, idPedido)) {
			return false;
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	if (referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) {
		if (!this.iface.actualizarStockReservado(referenciaPrevia, codAlmacen, idPedido)) {
			return false;
		}
	}
 
	return true;
}

function oficial_actualizarStockReservado(referencia:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idStock:String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}

	var reservada:Number = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidoscli,pedidoscli");
	if (isNaN(reservada)) {
		reservada = 0;
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("reservada", reservada);
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!this.iface.comprobarStock(curStock)) {
		return false;
	}
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_valorDefectoAlmacen(fN:String):String
{
	var query:FLSqlQuery = new FLSqlQuery();

	query.setTablesList( "factalma_general" );
	query.setForwardOnly( true );
	query.setSelect( fN );
	query.setFrom( "factalma_general" );
	if ( query.exec() ) {
		if ( query.next() ) {
			return query.value( 0 );
		}
	}

	return "";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCKS CABECERA ////////////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function scab_controlStockPedidosCli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLP.cursorRelation();
	if (curRel && curRel.action() == "pedidoscli") {
		return true;
	}

	if (!this.iface.__controlStockPedidosCli(curLP)) {
		return false;
	}

	return true;
}

function scab_controlStockPedidosProv(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLP.cursorRelation();
	if (curRel && curRel.action() == "pedidosprov") {
		return true;
	}

	if (!this.iface.__controlStockPedidosProv(curLP)) {
		return false;
	}

	return true;
}

function scab_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLA.cursorRelation();
	if (curRel && curRel.action() == "albaranescli") {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}

	if (!this.iface.controlStockFisico(curLA, codAlmacen, "cantidadac")) {
		return false;
	}
	
	return true;
}

function scab_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLA.cursorRelation();
	if (curRel && curRel.action() == "albaranesprov") {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}

	if (!this.iface.controlStockFisico(curLA, codAlmacen, "cantidadap")) {
		return false;
	}
	
	return true;
}

function scab_controlStockFacturasCli(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLF.cursorRelation();
	if (curRel && curRel.action() == "facturascli") {
		return true;
	}

	if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}

	if (!this.iface.controlStockFisico(curLF, codAlmacen, "cantidadfc")) {
		return false;
	}
	
	return true;
}

function scab_controlStockFacturasProv(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRel:FLSqlCursor = curLF.cursorRelation();
	if (curRel && curRel.action() == "facturasprov") {
		return true;
	}

	if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}

	if (!this.iface.controlStockFisico(curLF, codAlmacen, "cantidadfp")) {
		return false;
	}
	
	return true;
}

function scab_controlStockComandasCli(curLV:FLSqlCursor):Boolean
{
debug("scab_controlStockComandasCli");
	var util:FLUtil = new FLUtil();

	var curRel:FLSqlCursor = curLV.cursorRelation();
	if (curRel && curRel.action() == "tpv_comandas") {
		return true;
	}
debug("scab_controlStockComandasCli pasa");
	var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	
	if (!this.iface.controlStockFisico(curLV, codAlmacen, "cantidadtpv")) {
		return false;
	}

	return true;
}

function scab_controlStockLineasTrans(curLTS:FLSqlCursor):Boolean
{
debug("scab_controlStockLineasTrans");
	var util:FLUtil = new FLUtil();

	var curRel:FLSqlCursor = curLTS.cursorRelation();
	if (curRel && curRel.action() == "transstock") {
		return true;
	}
debug("scab_controlStockLineasTrans pasa");
	var codAlmacenOrigen:String = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenOrigen || codAlmacenOrigen == "") {
		return true;
	}
	
	var codAlmacenDestino:String = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenDestino || codAlmacenDestino == "") {
		return true;
	}
	
	if (!this.iface.controlStockFisico(curLTS, codAlmacenOrigen, "cantidadts")) {
		return false;
	}

	if (!this.iface.controlStockFisico(curLTS, codAlmacenDestino, "cantidadts")) {
		return false;
	}

	return true;
}


function scab_arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

/*debug("ARRAY INICIAL");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["codalmacen"]);
}
*/
	arrayInicial.sort(this.iface.compararArrayStock);
	arrayFinal.sort(this.iface.compararArrayStock);
	
/*debug("ARRAY INICIAL ORDENADO");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL ORDENADO");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["codalmacen"]);
}*/
	var comparacion:Number;
	while (iAI < longAI || iAF < longAF) {
		if (iAI < longAI && iAF < longAF) {
			comparacion = this.iface.compararArrayStock(arrayInicial[iAI], arrayFinal[iAF]);
		} else if (iAF < longAF) {
			comparacion = 1;
		} else if (iAI < longAI) {
			comparacion = -1;
		}
		switch (comparacion) {
			case 1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAF]["idarticulo"];
				arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAF]["codalmacen"];
				iAF++;
				iAA++;
				break;
			}
			case -1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayInicial[iAI]["idarticulo"];
				arrayAfectados[iAA]["codalmacen"] = arrayInicial[iAI]["codalmacen"];
				iAI++;
				iAA++;
				break;
			}
			case 0: {
				if (arrayInicial[iAI]["cantidad"] != arrayFinal[iAF]["cantidad"]) {
					arrayAfectados[iAA] = [];
					arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAI]["idarticulo"];
					arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAI]["codalmacen"];
					iAA++;
				}
				iAI++;
				iAF++;
				break;
			}
		}
	}
	return arrayAfectados;
}

function scab_compararArrayStock(a:Array, b:Array):Number
{
	var resultado:Number = 0;
	if (a["codalmacen"] > b["codalmacen"]) {
		resultado = 1;
	} else if (a["codalmacen"] < b["codalmacen"]) {
		resultado = -1;
	} else if (a["codalmacen"] == b["codalmacen"]) {
		if (a["idarticulo"] > b["idarticulo"])  {
			resultado = 1;
		} else if (a["idarticulo"] < b["idarticulo"])  {
			resultado = -1;
		}
	}
	return resultado;
}

function scab_controlStockFisico(curLinea:FLSqlCursor, codAlmacen:String, campo:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var referencia:String = curLinea.valueBuffer("referencia");
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'")) {
		return true;
	}
debug("Referencia = " + referencia);
	if (referencia && referencia != "") {
debug("Llamando");
		if (!this.iface.actualizarStockFisico(referencia, codAlmacen, campo)) {
			return false;
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	if (referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) {
		if (!this.iface.actualizarStockFisico(referenciaPrevia, codAlmacen, campo)) {
			return false;
		}
	}
 
	return true;
}

function scab_actualizarStockFisico(referencia:String, codAlmacen:String, campo:String):Boolean
{
debug("scab_actualizarStockFisico para " + campo);
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'")) {
		return true;
	}

	var idStock:String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer(campo, formRecordregstocks.iface.pub_commonCalculateField(campo, curStock));
	
	stockFisico = formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock);
	if (stockFisico < 0) {
		if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
			MessageBox.warning( util.translate("scripts", "El artículo %1 no permite ventas sin stock. Este movimiento dejaría el stock de %2 con un valor de %3.\n").arg(referencia).arg(codAlmacen).arg(stockFisico), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	curStock.setValueBuffer("cantidad", stockFisico);
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function scab_actualizarStockReservado(referencia:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'")) {
		return true;
	}

	var idStock:String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock, idPedido));
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	
	return true;
}

function scab_actualizarStockPteRecibir(referencia:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("articulos", "nostock", "referencia = '" + referencia  + "'")) {
		return true;
	}

	var idStock:String = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	var stockFisico:Number;
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock, idPedido));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

//// CONTROL STOCKS CABECERA ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/** \D Lanza el informe de etiquetas de artículos.
\end */
function etiArticulo_lanzarEtiArticulo(xmlKD:FLDomDocument)
{
debug(xmlKD.toString(4));
	var rptViewer:FLReportViewer = new FLReportViewer();

	var datosReport:Array = this.iface.tipoInformeEtiquetas();
	try {
		rptViewer.setReportData(xmlKD);
	} catch (e) {
		return;
	}

	var etiquetaInicial:Array;
	if (datosReport["cols"] > 0) {
		etiquetaInicial = flfactinfo.iface.seleccionEtiquetaInicial();
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(datosReport["nombreinforme"]);
	rptViewer.setReportData(xmlKD);
	if (datosReport["cols"] > 0) {
		rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	} else {
		rptViewer.renderReport();
	}
	rptViewer.exec();
}

function etiArticulo_tipoInformeEtiquetas()
{
	var res:Array = [];
	res["nombreinforme"] = "i_a4_4x11";
	res["cols"] = 4;
	return res;
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
// function pedidosauto_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
// {
// 	var util:FLUtil = new FLUtil();
// 	var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
// 	if (!codAlmacen || codAlmacen == "")
// 		return true;
// 		
// 	switch(curLA.modeAccess()) {
// 		case curLA.Insert:
// 			// if provided through automatic order and if stock control is done via orders, silently return
// 			if ((curLA.valueBuffer("idlineapedido") != 0) && flfactppal.iface.pub_valorDefectoEmpresa("stockpedidos"))
// 				return true;
// 	}
// 	
// 	return this.iface.__controlStockAlbaranesCli(curLA);
// }

// function pedidosauto_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
// {
// 	var util:FLUtil = new FLUtil();
// 	
// 	if (!this.iface.__controlStockAlbaranesProv(curLA))
// 		return false;
// 		
// 	var pedAuto:Boolean = false;
// 	if (util.sqlSelect("lineaspedidosprov", "idpedidoaut", "idlinea = " + curLA.valueBuffer("idlineapedido")))
// 		pedAuto = true;
// 
// 
// 	if (pedAuto) {
// 		var cantidad:Number = -1 * parseFloat(curLA.valueBuffer("cantidad"));
// 		if (!flfacturac.iface.pub_cambiarStockOrd(curLA.valueBuffer("referencia"), cantidad))
// 			return false;
// 	}
// 	
// 	return true;
// }
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
/////////////////////////////////////////////////////////////////
//// KLO ///////////////////////////////////////////////

/** Esta función es exactamente como la oficial_ pero con el commitBuffer(true) para la detección de bloqueo.
Por eso no sobrecarga la oficial_
**/
function klo_cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String, noAvisar:Boolean ):Boolean
{
	var util:FLUtil = new FLUtil();
	if (referencia == "" || !referencia) {
		return true;
	}

	if (codAlmacen == "" || !codAlmacen) {
		return true;
	}

	if ( !campo || campo == "") {
		return false;
	}

	var idStock:String;
	idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'");
	if ( !idStock ) {
		idStock = this.iface.crearStock( codAlmacen, referencia );
		if ( !idStock ) {
			return false;
		}
	}
	var curStock:FLSqlCursor = new FLSqlCursor( "stocks" );
	curStock.select( "idstock = " + idStock );
	if ( !curStock.first() ) {
		return false;
	}
	
	curStock.setModeAccess( curStock.Edit );
	curStock.refreshBuffer();
	
	var cantidadPrevia:Number = parseFloat( curStock.valueBuffer( campo ) );
	var nuevaCantidad:Number = cantidadPrevia + parseFloat( variacion );

	curStock.setValueBuffer( campo, nuevaCantidad );
	if (campo == "cantidad" || campo == "reservada") {
		curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	}

	if (!this.iface.comprobarStock(curStock)) {
		return false;
	}

	// Aquí está la única diferencia con oficial_
	if ( !curStock.commitBuffer(true) ) {
		return false;
	}

	return true;
}

function klo_afterCommit_codigosdebarras(curCB:FLSqlCursor):Boolean 
{
	try {
		if (curCB.cursorRelation().valueBuffer("referencia"))
			formRecordarticulos.iface.comprobarPredeterminado();
	}
	catch (e) {
	}
}

/** \D
Recalcula el coste medio de compra de un artculo como media del coste en todos los albaranes de proveedor
@param referencia Referencia del artculo
@return True si la modificacin tuvo xito, false en caso contrario
\end */
function klo_cambiarCosteMedio(referencia:String):Boolean
{
	if (referencia == "")
		return true;

	var util:FLUtil = new FLUtil();
	var sumCant:Number = util.sqlSelect("lineasalbaranesprov", "SUM(cantidad)", "referencia = '" + referencia + "'");
	var cM:Number = 0;
	
	if ( sumCant ) {
		cM = util.sqlSelect("lineasalbaranesprov", "(SUM(pvptotal) / SUM(cantidad))", "referencia = '" + referencia + "'");
	}
	
	// Si no hay compras, el coste medio de compra ser el ltimo coste.
	if (!cM || !sumCant) {
		cM = util.sqlSelect("articulos", "costeultimo", "referencia = '" + referencia + "'");
	}

	var curArticulo:FLSqlCursor = new FLSqlCursor("articulos");
	curArticulo.select("referencia = '" + referencia + "'");
	if (curArticulo.first()) {
		curArticulo.setModeAccess(curArticulo.Edit);
		curArticulo.refreshBuffer();
		curArticulo.setValueBuffer("costemedio", cM);
		curArticulo.commitBuffer(true);
	}

	return true;
}

/** \D 
Asigna el ltimo coste de compra de un artculo entre todos los albaranes de proveedor teniendo en cuenta que sea del ltimo fecha+idalbaran.
@param referencia Referencia del artculo
@return True si la modificacin tuvo xito, false en caso contrario
\end */
function klo_cambiarUltimoCoste(referencia:String):Boolean
{
	debug("KLO--> cambiarUltimoCoste: "+referencia);
	if (referencia == "")
		return true;

	var util:FLUtil = new FLUtil();

	var sumCant:Number;
	sumCant = util.sqlSelect("lineasalbaranesprov", "SUM(cantidad)", "referencia = '" + referencia + "'");

	if ( !sumCant )
		return true;
	
	// Ahora asigna el ltimo coste al artículo.
	var curLineasProv:FLSqlQuery = new FLSqlQuery();
	
	curLineasProv.setSelect("albaranesprov.codigo,albaranesprov.fecha,lineasalbaranesprov.referencia,lineasalbaranesprov.pvpunitario");
	curLineasProv.setWhere("lineasalbaranesprov.referencia = '"+referencia+"'");
	curLineasProv.setFrom("albaranesprov INNER JOIN lineasalbaranesprov ON albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	curLineasProv.setOrderBy("albaranesprov.fecha DESC, albaranesprov.codigo DESC");
	curLineasProv.exec();
		
	var cM:Number;
	if (curLineasProv.next()) {
		cM = curLineasProv.value("lineasalbaranesprov.pvpunitario");
	}

	if (!cM)
		cM = 0;
	
	var curArticulo:FLSqlCursor = new FLSqlCursor("articulos");
	curArticulo.select("referencia = '" + referencia + "'");
	if (curArticulo.first()) {
		curArticulo.setModeAccess(curArticulo.Edit);
		curArticulo.refreshBuffer();
		curArticulo.setValueBuffer("costeultimo", cM);
		curArticulo.commitBuffer(true);
	}

	return true;
}

/** \D 
Asigna el ltimo coste de compra de un artculo que nos da un proveedor proveniente del albarn de compra. Si existe la lnea en la ficha del artculo, la actualiza con el precio, la fecha y el id del albarn de compra, si no existe, la da de alta.
@param referencia Referencia del artculo
@param codproveedor Cdigo del proveedor
@return True si la modificacin tuvo xito, false en caso contrario
\end */
function klo_asignaPreciosProveedor(referencia:String, codProveedor:String, idLinea:Number):Boolean
{
	if (referencia == "")
		return true;
	if (codProveedor == "")
		return true;

	var util:FLUtil = new FLUtil();

	// Capturo la lnea del albarn de compra para usar sus datos.
	var curLineaAlbaranProv:FLSqlCursor = new FLSqlCursor("lineasalbaranesprov");
	curLineaAlbaranProv.select("idlinea = '" + idLinea + "'");

	if (curLineaAlbaranProv.size()==0)
		return true;
	if (!curLineaAlbaranProv.first())
		return true;

	// Capturo el registro del proveedor para utilizar la divisa y el nombre porque articulospro.mtd los requiere.
	var curProveedores:FLSqlCursor = new FLSqlCursor("proveedores");
	curProveedores.select("codproveedor = '" + codProveedor + "'");

	if (!curProveedores.first())
		return true;

	// Capturo la posible lnea de precio del proveedor en la ficha del artculo. Si no existe la lnea la inserto y si existe, la actualizo.
	var curLineasPrecProv:FLSqlCursor = new FLSqlCursor("articulosprov");
	curLineasPrecProv.select("referencia = '" + referencia + "' and codproveedor = '"+codProveedor+"'");

	if (curLineasPrecProv.size()==0) {
		//Anterior. No funciona a veces. util.sqlInsert("articulosprov", "referencia,codproveedor,nombre,coddivisa,coste,idalbaran",referencia+","+codProveedor+","+curProveedores.valueBuffer("nombre")+","+curProveedores.valueBuffer("coddivisa")+","+curLineaAlbaranProv.valueBuffer("pvpunitario")+","+curLineaAlbaranProv.valueBuffer("idalbaran"));
		curLineasPrecProv.setModeAccess(curLineasPrecProv.Insert);
		curLineasPrecProv.refreshBuffer();
		curLineasPrecProv.setValueBuffer("referencia", referencia);
		curLineasPrecProv.setValueBuffer("codproveedor", codProveedor);
		curLineasPrecProv.setValueBuffer("nombre", curProveedores.valueBuffer("nombre"));
		curLineasPrecProv.setValueBuffer("coddivisa", curProveedores.valueBuffer("coddivisa"));
		curLineasPrecProv.setValueBuffer("coste", curLineaAlbaranProv.valueBuffer("pvpunitario"));
		curLineasPrecProv.setValueBuffer("idalbaran", curLineaAlbaranProv.valueBuffer("idalbaran"));
		if (!curLineasPrecProv.commitBuffer()) {
			MessageBox.warning(util.translate("scripts", "No se ha podido añadir el proveedor en la ficha del artículo"), MessageBox.Ok, MessageBox.NoButton);
			return true;
		}	
	}
	else {
		if (curLineasPrecProv.first()) {
			curLineasPrecProv.setModeAccess(curLineasPrecProv.Edit);
			curLineasPrecProv.refreshBuffer();
			curLineasPrecProv.setValueBuffer("idalbaran", curLineaAlbaranProv.valueBuffer("idalbaran"));
			curLineasPrecProv.setValueBuffer("coste", curLineaAlbaranProv.valueBuffer("pvpunitario"));
			curLineasPrecProv.commitBuffer(true)
		}
	}
	return true;
}

/** \C
Al actualizar el stock del artculo, hace el clculo del coste medio de stock.
Esto se ejecuta desde cualquier clase que modifique el stock.
\end */
function klo_controlCMSAlbaranesCli(referencia:String, codAlmacen:String, fechaFin:Date):Boolean
{
	debug("KLO--> controlCMSAlbaranesCli");
	var util:FLUtil = new FLUtil();
	var cms:Number;
	
	///////////////////////
	//--------------------
	// Si hay entradas posteriores, vuelve a calcular el ltimo coste mdio de stock porque puede cambiar el CMS.
	var qryA:FLSqlQuery = new FLSqlQuery();
	var qryF:FLSqlQuery = new FLSqlQuery();
	var qryT:FLSqlQuery = new FLSqlQuery();
	
	qryA.setTablesList("albaranesprov");
	qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha > '"+fechaFin+"' ORDER BY albaranesprov.fecha");
	if (!qryA.exec()) {
		debug("No puedo ejecutar qryA");
		return true;
	}

	qryF.setTablesList("facturasprov");
	qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaFin+"' ORDER BY facturasprov.fecha");
	if (!qryF.exec()) {
		debug("No puedo ejecutar qryF");
		return true;
	}

	qryT.setTablesList("transstock");
	qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
	qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacen+"' and transstock.fecha > '"+fechaFin+"' ORDER BY transstock.fecha");
	if (!qryT.exec()) {
		debug("No puedo ejecutar qryT");
		return true;
	}

	if (qryA.next() || qryF.next() || qryT.next()) {
		debug("Hay entradas posteriores. Se recalcula el ultimo cms");
		this.iface.calculosUltCMS(referencia, codAlmacen);
	}
	//----------------------
	/////////////////////////
	
	return true;
}

function klo_controlCMSFacturasCli(curLF:FLSqlCursor):Boolean
{
	debug("KLO--> controlCMSFacturasCli");
	var util:FLUtil = new FLUtil();
	var referencia:String = curLF.valueBuffer("referencia");
	var codAlmacen:String = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	var fechaFin:Date = util.sqlSelect("facturascli", "fecha", "idfactura = " + curLF.valueBuffer("idfactura"));
	var cms:Number;
	
	///////////////////////
	//--------------------
	// Si hay entradas posteriores, vuelve a calcular el ltimo coste mdio de stock porque puede cambiar el CMS.
	var qryA:FLSqlQuery = new FLSqlQuery();
	var qryF:FLSqlQuery = new FLSqlQuery();
	var qryT:FLSqlQuery = new FLSqlQuery();
	
	qryA.setTablesList("albaranesprov");
	qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha > '"+fechaFin+"' ORDER BY albaranesprov.fecha");
	if (!qryA.exec()) {
		debug("No puedo ejecutar qryA");
		return true;
	}

	qryF.setTablesList("facturasprov");
	qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaFin+"' ORDER BY facturasprov.fecha");
	if (!qryF.exec()) {
		debug("No puedo ejecutar qryF");
		return true;
	}

	qryT.setTablesList("transstock");
	qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
	qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacen+"' and transstock.fecha > '"+fechaFin+"' ORDER BY transstock.fecha");
	if (!qryT.exec()) {
		debug("No puedo ejecutar qryT");
		return true;
	}

	if (qryA.next() || qryF.next() || qryT.next()) {
		debug("Hay entradas posteriores. Se recalcula el ultimo cms");
		this.iface.calculosUltCMS(referencia, codAlmacen);
	}
	//----------------------
	/////////////////////////

	return true;
}

function klo_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
{
	debug("controlStockAlbaranesCli");
	if (!this.iface.__controlStockAlbaranesCli(curLA))
		return false;
	
	var util:FLUtil = new FLUtil;

	var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	var fecha:String = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));

	if (!this.iface.controlArticulo(curLA, codAlmacen, fecha)) {
		return false;
	}
	
	return true;
}

function klo_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
{
	debug("controlStockAlbaranesProv");
	if (!this.iface.__controlStockAlbaranesProv(curLA))
		return false;
	
	var util:FLUtil = new FLUtil;

	var codAlmacen:String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	var fecha:String = util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));

	if (!this.iface.controlArticulo(curLA, codAlmacen, fecha)) {
		return false;
	}
	
	return true;
}

function klo_controlStockFacturasCli(curLF:FLSqlCursor):Boolean
{
	debug("controlStockFacturasCli");
	if (!this.iface.__controlStockFacturasCli(curLF))
		return false;

	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	var fecha:String = util.sqlSelect("facturascli", "fecha", "idfactura = " + curLF.valueBuffer("idfactura"));

	if (!this.iface.controlArticulo(curLA, codAlmacen, fecha)) {
		return false;
	}
	
	return true;
}

function klo_controlStockFacturasProv(curLF:FLSqlCursor):Boolean
{
	debug("controlStockFacturasProv");
	if (!this.iface.__controlStockFacturasProv(curLF))
		return false;

	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}

	var codAlmacen:String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + curLF.valueBuffer("idfactura"));
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	var fecha:String = util.sqlSelect("facturasprov", "fecha", "idfactura = " + curLF.valueBuffer("idfactura"));

	if (!this.iface.controlArticulo(curLA, codAlmacen, fecha)) {
		return false;
	}
	
	return true;
}

function klo_controlStockComandasCli(curLV:FLSqlCursor):Boolean
{
	debug("KLO--> controlStockComandasCli");
	if (!this.iface.__controlStockComandasCli(curLV))
		return false;

	var util:FLUtil = new FLUtil();

	var curRel:FLSqlCursor = curLV.cursorRelation();

	var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
	if (!codAlmacen || codAlmacen == "") {
		return true;
	}
	var fecha:String = util.sqlSelect("tpv_comandas", "fecha", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"));
	
	if (!this.iface.controlArticulo(curLV, codAlmacen, fecha)) {
		return false;
	}
	return true;
}

function klo_controlStockLineasTrans(curLTS:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var referencia:String = curLTS.valueBuffer("referencia");
	var codAlmacenOrig:String = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + curLTS.valueBuffer("idtrans"));
	var codAlmacenDest:String = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + curLTS.valueBuffer("idtrans"));
	var fechaFin:Date = util.sqlSelect("transstock", "fecha", "idtrans = " + curLTS.valueBuffer("idtrans"));
	
	// Ejecuto la clase padre.
	if (!this.iface.__controlStockLineasTrans(curLTS))
		return false;
	
	// Pone el ltimo CMS en el ALMACN DESTINO siempre.
	//this.iface.ultimoCMS(referencia, codAlmacenDest);
	var valor:Array = this.iface.ultimoCMS(referencia, codAlmacenDest);
	debug("VALOR.STOCK: "+valor.stock);
	debug("VALOR.CMS: "+valor.cms);
	this.iface.actualizaStock(referencia, codAlmacenDest, valor.stock);
	this.iface.actualizaCMS(referencia, codAlmacenDest, valor.cms);
	
	///////////////////////
	//--------------------
	// Ahora comprueba para ver si calcula CMS en el ALMACN ORIGEN.
	// Si hay entradas posteriores, vuelve a calcular el ltimo coste mdio de stock porque puede cambiar el CMS.
	var qryA:FLSqlQuery = new FLSqlQuery();
	var qryF:FLSqlQuery = new FLSqlQuery();
	var qryT:FLSqlQuery = new FLSqlQuery();
	
	qryA.setTablesList("albaranesprov");
	qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacenOrig+"' and albaranesprov.fecha > '"+fechaFin+"' ORDER BY albaranesprov.fecha");
	if (!qryA.exec()) {
		debug("No puedo ejecutar qryA");
		return false;
	}

	qryF.setTablesList("facturasprov");
	qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacenOrig+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaFin+"' ORDER BY facturasprov.fecha");
	if (!qryF.exec()) {
		debug("No puedo ejecutar qryF");
		return false;
	}

	qryT.setTablesList("transstock");
	qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
	qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacenOrig+"' and transstock.fecha > '"+fechaFin+"' ORDER BY transstock.fecha");
	if (!qryT.exec()) {
		debug("No puedo ejecutar qryT");
		return false;
	}

	if (qryA.next() || qryF.next() || qryT.next()) {
		debug("Hay entradas posteriores en almacn origen. Se recalcula el ultimo cms");
		//this.iface.ultimoCMS(referencia, codAlmacenOrig);
		var valor:Array = this.iface.ultimoCMS(referencia, codAlmacenOrig);
		debug("VALOR.STOCK: "+valor.stock);
		debug("VALOR.CMS: "+valor.cms);
		this.iface.actualizaStock(referencia, codAlmacenOrig, valor.stock);
		this.iface.actualizaCMS(referencia, codAlmacenOrig, valor.cms);
	}
	//----------------------
	/////////////////////////

	return true;
}

function klo_afterCommit_lineasregstocks(curLRS:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var referencia:String = util.sqlSelect("stocks", "referencia", "idstock = " + curLRS.valueBuffer("idstock"));
	var codAlmacen:String = util.sqlSelect("stocks", "codalmacen", "idstock = " + curLRS.valueBuffer("idstock"));
	
	//this.iface.ultimoCMS(referencia, codAlmacen);
	var valor:Array = this.iface.ultimoCMS(referencia, codAlmacen);
	debug("VALOR.STOCK: "+valor.stock);
	debug("VALOR.CMS: "+valor.cms);
	this.iface.actualizaStock(referencia, codAlmacen, valor.stock);
	this.iface.actualizaCMS(referencia, codAlmacen, valor.cms);
	
	return true;
}

/** Al modificar la fecha de la transferencia de stock tiene que modificarla tambien en historialstocks
\end */
function klo_afterCommit_transstock(curTS:FLSqlCursor):Boolean
{
	if (curTS.modeAccess() == curTS.Edit && curTS.valueBuffer("fecha") != curTS.valueBufferCopy("fecha")) {
		var curLineasTransStock:FLSqlCursor = new FLSqlCursor( "lineastransstock" );
		curLineasTransStock.setContext(this);
		curLineasTransStock.select( "idtrans = " + curTS.valueBuffer("idtrans") );
	
		curLineasTransStock.setModeAccess( curLineasTransStock.Edit );
		curLineasTransStock.refreshBuffer();
		while (curLineasTransStock.next()) {
			this.iface.controlStockLineasTrans(curLineasTransStock);
		}
		curLineasTransStock.commitBuffer(true);
	}
	return true;
}

/**
Calcula el coste medio de stock actual del artculo.
 */
function klo_ultimoCMS(referencia:String, codAlmacen:String):Array
{
	debug("klo--> ultimoCMS");
	var util:FLUtil = new FLUtil();
	var cms:Number = 0;
	var stock:Number = 0;
	var valor:Array = [];
	var fechaIni:Date = new Date();
	fechaIni = new Date(1900,1,1);
	
	var qryReg:FLSqlQuery = new FLSqlQuery();
	var qrySalidas:FLSqlQuery = new FLSqlQuery();
	var salidas:Number = 0;
	var entradas:Number = 0;
	
	qryReg.setTablesList("stocks");
	qryReg.setSelect("lineasregstocks.fecha, lineasregstocks.cantidadfin, lineasregstocks.costemediostock");
	qryReg.setFrom("lineasregstocks inner join stocks on stocks.idstock = lineasregstocks.idstock");
	qryReg.setWhere("stocks.referencia = '"+referencia+"' and stocks.codalmacen = '"+codAlmacen+"' ORDER BY lineasregstocks.fecha DESC");
	if (!qryReg.exec()) {
		debug("No puedo ejecutar qryReg");
		return false;
	}
	
	if (qryReg.next()) {
		fechaIni = qryReg.value("lineasregstocks.fecha");
		stock = qryReg.value("lineasregstocks.cantidadfin");
		entradas = qryReg.value("lineasregstocks.cantidadfin");
		cms = qryReg.value("lineasregstocks.costemediostock");
	}
	
	var fechaAct:Date = fechaIni;
	var qryA:FLSqlQuery = new FLSqlQuery();
	var qryF:FLSqlQuery = new FLSqlQuery();
	var qryT:FLSqlQuery = new FLSqlQuery();
	
	qryA.setTablesList("albaranesprov");
	qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha > '"+fechaIni+"' ORDER BY albaranesprov.fecha");
	if (!qryA.exec()) {
		debug("No puedo ejecutar qryA");
		return false;
	}

	qryF.setTablesList("facturasprov");
	qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaIni+"' ORDER BY facturasprov.fecha");
	if (!qryF.exec()) {
		debug("No puedo ejecutar qryF");
		return false;
	}

	qryT.setTablesList("transstock");
	qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
	qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacen+"' and transstock.fecha > '"+fechaIni+"' ORDER BY transstock.fecha");
	if (!qryT.exec()) {
		debug("No puedo ejecutar qryT");
		return false;
	}

	// Variables para usar en el bucle.
	var finA:Boolean = false;
	var finF:Boolean = false;
	var finT:Boolean = false;
	var valorA:Date;
	var valorF:Date;
	var valorT:Date;
	var avanzaA = false;
	var avanzaF = false;
	var avanzaT = false;

	// Pongo el cursor en el pricipio de los 3 querys.
	if (!qryA.next()) {
		finA = true;
		debug("qryA vacio");
	}	
	if (!qryF.next()) {
		finF = true;
		debug("qryF vacio");
	}	
	if (!qryT.next()) {
		finT = true;
		debug("qryT vacio");
	}	
	
	// Bucle para asignar qu cursor qry es el que adelanta una posicin segn tenga la fecha ms baja de los tres.
	while(finA == false || finF == false || finT == false) {
		valorA = qryA.value("albaranesprov.fecha");
		valorF = qryF.value("facturasprov.fecha");
		valorT = qryT.value("transstock.fecha");
		
		if (!finA) {
			if (!finF && !finT) {
				if ((valorA == valorF) || (valorA == valorT)) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				}
				if ((valorA < valorF) && (valorA < valorT)) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				} 
			}
			if (!finF && finT) {
				if (valorA == valorF) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				} else if (valorA < valorF) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				}
			}
			if (finF && !finT) {
				if (valorA == valorT) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				}
				if (valorA < valorT) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				}
			}
			if (finF && finT) {
				fechaAct = qryA.value("albaranesprov.fecha");
				avanzaA = true;
				avanzaF = false;
				avanzaT = false;
			}
		}
	
		if (!finF) {
			if (!finA && !finT) {
				if ((valorF == valorA) || (valorF == valorT)) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
				if ((valorF < valorA) && (valorF < valorT)) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
			}
			if (!finA && finT) {
				if (valorF == valorA) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
				if (valorF < valorA) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
			}
			if (finA && !finT) {
				if (valorF == valorT) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
				if (valorF < valorT) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
			}
			if (finA && finT) {
				fechaAct = qryF.value("facturasprov.fecha");
				avanzaA = false;
				avanzaF = true;
				avanzaT = false;
			}
		}
		
		if (!finT) {
			if (!finA && !finF) {
				if ((valorT == valorA) || (valorT == valorF)) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}
				if ((valorT < valorA) && (valorT < valorF)) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}	
			}
			if (!finA && finF) {
				if (valorT == valorA) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}
				if (valorT < valorA) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}	
			}
			if (finA && !finF) {
				if (valorT == valorF) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}
				if (valorT < valorF) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}	
			}
			if (finA && finF) {
				fechaAct = qryT.value("transstock.fecha");
				avanzaA = false;
				avanzaF = false;
				avanzaT = true;
			}
		}
		
		/* Ahora se calculan las salidas de stock para calcular el stock actual.
		//
		Suma las salidas de los albaranes de venta. */
		qrySalidas.setTablesList("albaranescli");
		qrySalidas.setSelect("SUM(lineasalbaranescli.cantidad)");
		qrySalidas.setFrom("lineasalbaranescli inner join albaranescli on albaranescli.idalbaran = lineasalbaranescli.idalbaran");
		qrySalidas.setWhere("lineasalbaranescli.referencia = '"+referencia+"' and albaranescli.codalmacen = '"+codAlmacen+"'  and albaranescli.fecha > '"+fechaIni+"' and albaranescli.fecha <= '"+fechaAct+"' GROUP BY lineasalbaranescli.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de albaranes");
			return false;
		}
		if (qrySalidas.next())
			salidas = parseFloat(qrySalidas.value("SUM(lineasalbaranescli.cantidad)"));

		/* Suma las salidas de las facturas de venta no automticas. */
		qrySalidas.setTablesList("facturascli");
		qrySalidas.setSelect("SUM(lineasfacturascli.cantidad)");
		qrySalidas.setFrom("lineasfacturascli inner join facturascli on facturascli.idfactura = lineasfacturascli.idfactura");
		qrySalidas.setWhere("lineasfacturascli.referencia = '"+referencia+"' and facturascli.codalmacen = '"+codAlmacen+"'  and facturascli.automatica = false and facturascli.fecha > '"+fechaIni+"' and facturascli.fecha <= '"+fechaAct+"' GROUP BY lineasfacturascli.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de facturas");
			return false;
		}
		if (qrySalidas.next())
			salidas = salidas + parseFloat(qrySalidas.value("SUM(lineasfacturascli.cantidad)"));
		
		/* Suma las salidas de las comandas de TPV. */
		qrySalidas.setTablesList("tpv_comandas");
		qrySalidas.setSelect("SUM(tpv_lineascomanda.cantidad)");
		qrySalidas.setFrom("tpv_lineascomanda inner join tpv_comandas on tpv_comandas.idtpv_comanda = tpv_lineascomanda.idtpv_comanda inner join tpv_puntosventa on tpv_puntosventa.codtpv_puntoventa = tpv_comandas.codtpv_puntoventa");
		qrySalidas.setWhere("tpv_lineascomanda.referencia = '"+referencia+"' and tpv_puntosventa.codalmacen = '"+codAlmacen+"' and tpv_comandas.fecha > '"+fechaIni+"' and tpv_comandas.fecha <= '"+fechaAct+"' GROUP BY tpv_lineascomanda.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de comandas de TPV");
			return false;
		}
		if (qrySalidas.next())
			salidas = parseFloat(qrySalidas.value("SUM(tpv_lineascomanda.cantidad)"));

		/* Suma las salidas de las transferencias de stock. */
		qrySalidas.setTablesList("transstock");
		qrySalidas.setSelect("SUM(lineastransstock.cantidad)");
		qrySalidas.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
		qrySalidas.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmaorigen = '"+codAlmacen+"'  and transstock.fecha > '"+fechaIni+"' and transstock.fecha <= '"+fechaAct+"' GROUP BY lineastransstock.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de transferencias de stock.");
			return false;
		}
		if (qrySalidas.next())
			salidas = salidas + parseFloat(qrySalidas.value("SUM(lineastransstock.cantidad)"));
		
		/* Comprueba qu cursor avanza. */
		if (avanzaA) {
			//debug(cms+" * ("+entradas+"-"+salidas+"))+("+qryA.value("lineasalbaranesprov.pvpunitario")+"*"+qryA.value("lineasalbaranesprov.cantidad")+")) / "+stock+"+"+qryA.value("lineasalbaranesprov.cantidad")+"-"+salidas);
			if ((entradas-salidas) <= 0)
				cms = qryA.value("lineasalbaranesprov.pvpunitario");
			else
				cms = parseFloat((cms * (entradas-salidas))+(qryA.value("lineasalbaranesprov.pvpunitario")*qryA.value("lineasalbaranesprov.cantidad"))) / parseFloat(entradas+qryA.value("lineasalbaranesprov.cantidad")-salidas);
			
			cms = util.roundFieldValue(cms, "articulos", "costeultimo");
			entradas = entradas + qryA.value("lineasalbaranesprov.cantidad");
			//debug("entradas A: "+entradas);
			//stock = stock + qryA.value("lineasalbaranesprov.cantidad") - salidas;
			if (!qryA.next())
				finA = true;
		}
		if (avanzaF) {
			//debug(cms+" * ("+entradas+"-"+salidas+"))+("+qryF.value("lineasfacturasprov.pvpunitario")+"*"+qryF.value("lineasfacturasprov.cantidad")+")) / "+entradas+"+"+qryF.value("lineasfacturasprov.cantidad")+"-"+salidas);
			if ((entradas-salidas) <= 0)
				cms = qryF.value("lineasfacturasprov.pvpunitario");
			else
				cms = parseFloat((cms * (entradas-salidas))+(qryF.value("lineasfacturasprov.pvpunitario")*qryF.value("lineasfacturasprov.cantidad"))) / parseFloat(entradas+qryF.value("lineasfacturasprov.cantidad")-salidas);
			
			cms = util.roundFieldValue(cms, "articulos", "costeultimo");
			entradas = entradas + qryF.value("lineasfacturasprov.cantidad");
			//debug("entradas F: "+entradas);
			//stock = stock + qryF.value("lineasfacturasprov.cantidad") - salidas;
			if (!qryF.next())
				finF = true;
		}
		if (avanzaT) {
			//debug(cms+" * ("+entradas+"-"+salidas+"))+("+qryT.value("lineastransstock.costemediostock")+"*"+qryT.value("lineastransstock.cantidad")+")) / "+entradas+"+"+qryT.value("lineastransstock.cantidad")+"-"+salidas);
			if ((entradas-salidas) <= 0)
				cms = qryT.value("lineastransstock.costemediostock");
			else
				cms = parseFloat((cms * (entradas-salidas))+(qryT.value("lineastransstock.costemediostock")*qryT.value("lineastransstock.cantidad"))) / parseFloat(entradas+qryT.value("lineastransstock.cantidad")-salidas);
			
			cms = util.roundFieldValue(cms, "articulos", "costeultimo");
			entradas = entradas + qryT.value("lineastransstock.cantidad");
			//debug("entradas T: "+entradas);
			//stock = stock + qryT.value("lineastransstock.cantidad") - salidas;
			if (!qryT.next())
				finT = true;
		}
	}

	// Calcula el coste medio de stock y actualiza el dato.
	cms = util.roundFieldValue(cms, "articulos", "costeultimo");
	
	//this.iface.actualizaCMS(referencia, codAlmacen, cms);
	/*if (!util.sqlUpdate("stocks", "costemediostock", cms, "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'")) {
	debug("No he podido actualizar dato costemediostock en stocks.");
	return false;
}*/
	
	//---------------------------------
	// Calcula el stock actual y actualiza el dato.
	//
	// Suma las salidas de los albaranes de venta.
	salidas = 0;
	qrySalidas.setTablesList("albaranescli");
	qrySalidas.setSelect("SUM(lineasalbaranescli.cantidad)");
	qrySalidas.setFrom("lineasalbaranescli inner join albaranescli on albaranescli.idalbaran = lineasalbaranescli.idalbaran");
	qrySalidas.setWhere("lineasalbaranescli.referencia = '"+referencia+"' and albaranescli.codalmacen = '"+codAlmacen+"'  and albaranescli.fecha > '"+fechaIni+"' GROUP BY lineasalbaranescli.referencia");
	if (!qrySalidas.exec()) {
		debug("No puedo ejecutar qrySalidas de albaranes");
		return false;
	}
	if (qrySalidas.next()) {
		salidas = parseFloat(qrySalidas.value("SUM(lineasalbaranescli.cantidad)"));
	}
	// Suma las salidas de las facturas de venta no automticas.
	qrySalidas.setTablesList("facturascli");
	qrySalidas.setSelect("SUM(lineasfacturascli.cantidad)");
	qrySalidas.setFrom("lineasfacturascli inner join facturascli on facturascli.idfactura = lineasfacturascli.idfactura");
	qrySalidas.setWhere("lineasfacturascli.referencia = '"+referencia+"' and facturascli.codalmacen = '"+codAlmacen+"'  and facturascli.automatica = false and facturascli.fecha > '"+fechaIni+"' GROUP BY lineasfacturascli.referencia");
	if (!qrySalidas.exec()) {
		debug("No puedo ejecutar qrySalidas de facturas");
		return false;
	}
	if (qrySalidas.next()) {
		salidas = salidas + parseFloat(qrySalidas.value("SUM(lineasfacturascli.cantidad)"));
	}
	// Suma las salidas de las transferencias de stock.
	qrySalidas.setTablesList("transstock");
	qrySalidas.setSelect("SUM(lineastransstock.cantidad)");
	qrySalidas.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qrySalidas.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmaorigen = '"+codAlmacen+"'  and transstock.fecha > '"+fechaIni+"' GROUP BY lineastransstock.referencia");
	if (!qrySalidas.exec()) {
		debug("No puedo ejecutar qrySalidas de transferencias de stock.");
		return false;
	}
	if (qrySalidas.next()) {
		salidas = salidas + parseFloat(qrySalidas.value("SUM(lineastransstock.cantidad)"));
	}
	// Suma las salidas de las comandas de TPV.
	qrySalidas.setTablesList("tpv_comandas");
	qrySalidas.setSelect("SUM(tpv_lineascomanda.cantidad)");
	qrySalidas.setFrom("tpv_lineascomanda inner join tpv_comandas on tpv_comandas.idtpv_comanda = tpv_lineascomanda.idtpv_comanda inner join tpv_puntosventa on tpv_puntosventa.codtpv_puntoventa = tpv_comandas.codtpv_puntoventa");
	qrySalidas.setWhere("tpv_lineascomanda.referencia = '"+referencia+"' and tpv_puntosventa.codalmacen = '"+codAlmacen+"' and tpv_comandas.fecha > '"+fechaIni+"' GROUP BY tpv_lineascomanda.referencia");
	if (!qrySalidas.exec()) {
		debug("No puedo ejecutar qrySalidas de comandas de TPV");
		return false;
	}
	if (qrySalidas.next())
		salidas = parseFloat(qrySalidas.value("SUM(tpv_lineascomanda.cantidad)"));

	
	stock = entradas - salidas;
	
	//this.iface.actualizaStock(referencia, codAlmacen, stock);
	/*if (!util.sqlUpdate("stocks", "cantidad", stock, "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'")) {
	debug("No he podido actualizar dato cantidad en stocks.");
	return false;
}*/
	//debug("stock en ultimoCMS: "+stock);
	//debug("cms en ultimoCMS: "+cms);
	//----------------------

	valor["stock"] = stock;
	valor["cms"] = cms;
	
	debug("STOCK--> "+valor.stock);
	debug("CMS--> "+valor.cms);
	
	return valor;
}

/**
Funcin que devuelve el coste médio de stock en una fecha determinada.
En caso de que haya una entrada posterior a la fecha dada, se recalcula el último coste médio de stock.
 */
function klo_CMSenUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number
{
	var util:FLUtil = new FLUtil();
	var cms:Number = util.sqlSelect("stocks", "costemediostock", "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'");
	var fechaIni:Date = new Date();
	fechaIni = new Date(1900,1,1);

	var qryReg:FLSqlQuery = new FLSqlQuery();
	var qrySalidas:FLSqlQuery = new FLSqlQuery();
	var salidas:Number = 0;
	var entradas:Number = 0;
	
	if (fechaFin == "" || fechaFin == null)
		fechaFin = new Date();
	
	if (!cms || cms == "")
		cms = 0;
	
	qryReg.setTablesList("stocks");
	qryReg.setSelect("lineasregstocks.fecha, lineasregstocks.cantidadfin, lineasregstocks.costemediostock");
	qryReg.setFrom("lineasregstocks inner join stocks on stocks.idstock = lineasregstocks.idstock");
	qryReg.setWhere("stocks.referencia = '"+referencia+"' and stocks.codalmacen = '"+codAlmacen+"' and lineasregstocks.fecha <= '"+fechaFin+"' ORDER BY lineasregstocks.fecha DESC");
	if (!qryReg.exec()) {
		debug("No puedo ejecutar qryReg");
		return false;
	}
	
	if (qryReg.next()) {
		if (fechaFin == qryReg.value("lineasregstocks.fecha")) {
			cms = qryReg.value("lineasregstocks.costemediostock");
			return cms;
		}
		else {
			fechaIni = qryReg.value("lineasregstocks.fecha");
			stock = qryReg.value("lineasregstocks.cantidadfin");
			entradas = qryReg.value("lineasregstocks.cantidadfin");
			cms = qryReg.value("lineasregstocks.costemediostock");
		}
	} 
	
	var fechaAct:Date = fechaIni;
	var qryA:FLSqlQuery = new FLSqlQuery();
	var qryF:FLSqlQuery = new FLSqlQuery();
	var qryT:FLSqlQuery = new FLSqlQuery();
	
	///////////////////////
	//--------------------
	// Si hay entradas posteriores, vuelve a calcular el ltimo coste mdio de stock porque puede cambiar el CMS.
	qryA.setTablesList("albaranesprov");
	qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha > '"+fechaFin+"' ORDER BY albaranesprov.fecha");
	if (!qryA.exec()) {
		debug("No puedo ejecutar qryA");
		return cms;
	}

	qryF.setTablesList("facturasprov");
	qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaFin+"' ORDER BY facturasprov.fecha");
	if (!qryF.exec()) {
		debug("No puedo ejecutar qryF");
		return cms;
	}

	qryT.setTablesList("transstock");
	qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
	qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
	qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacen+"' and transstock.fecha > '"+fechaFin+"' ORDER BY transstock.fecha");
	if (!qryT.exec()) {
		debug("No puedo ejecutar qryT");
		return cms;
	}

	/*
	//////////////////////////////////////////////////////////////////
	Si no hay entradas posteriores, directamente devuelve el cms que hay en el almacn y no hace nada ms.
	En caso de que s las haya, calcula el cms a fecha del documento de venta.
	OJO: Aqui nunca se calcula el ltimo coste medio de stock ni se modifica el dato. Se limita a devolver el cms a la fecha pasada.
	*/
	if (qryA.next() || qryF.next() || qryT.next()) {
		debug("HAY ENTRADAS POSTERIORES");
		
		qryA.setTablesList("albaranesprov");
		qryA.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
		qryA.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
		qryA.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha > '"+fechaIni+"' and albaranesprov.fecha <= '"+fechaFin+"' ORDER BY albaranesprov.fecha");
		if (!qryA.exec()) {
			debug("No puedo ejecutar qryA");
			return false;
		}

		qryF.setTablesList("facturasprov");
		qryF.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
		qryF.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
		qryF.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha > '"+fechaIni+"' and facturasprov.fecha <= '"+fechaFin+"' ORDER BY facturasprov.fecha");
		if (!qryF.exec()) {
			debug("No puedo ejecutar qryF");
			return false;
		}

		qryT.setTablesList("transstock");
		qryT.setSelect("transstock.fecha, lineastransstock.cantidad, lineastransstock.costemediostock");
		qryT.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
		qryT.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmadestino = '"+codAlmacen+"' and transstock.fecha > '"+fechaIni+"' and transstock.fecha <= '"+fechaFin+"' ORDER BY transstock.fecha");
		if (!qryT.exec()) {
			debug("No puedo ejecutar qryT");
			return false;
		}

		// Variables para usar en el bucle.
		var finA:Boolean = false;
		var finF:Boolean = false;
		var finT:Boolean = false;
		var valorA:Date;
		var valorF:Date;
		var valorT:Date;
		var avanzaA = false;
		var avanzaF = false;
		var avanzaT = false;

		// Pongo el cursor en el pricipio de los 3 querys.
		if (!qryA.next()) {
			finA = true;
			debug("qryA vacio");
		}
		if (!qryF.next()) {
			finF = true;
			debug("qryF vacio");
		}
		if (!qryT.next()) {
			finT = true;
			debug("qryT vacio");
		}
	
		// Bucle para asignar qu cursor qry es el que adelanta una posicin segn tenga la fecha ms baja de los tres.
		while (finA == false || finF == false || finT == false) {
			valorA = qryA.value("albaranesprov.fecha");
			valorF = qryF.value("facturasprov.fecha");
			valorT = qryT.value("transstock.fecha");
		
			if (!finA) {
				if (!finF && !finT) {
					if ((valorA == valorF) || (valorA == valorT)) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					}
					if ((valorA < valorF) && (valorA < valorT)) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					} 
				}
				if (!finF && finT) {
					if (valorA == valorF) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					}
					if (valorA < valorF) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					}
				}
				if (finF && !finT) {
					if (valorA == valorT) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					}
					if (valorA < valorT) {
						fechaAct = qryA.value("albaranesprov.fecha");
						avanzaA = true;
						avanzaF = false;
						avanzaT = false;
					}
				}
				if (finF && finT) {
					fechaAct = qryA.value("albaranesprov.fecha");
					avanzaA = true;
					avanzaF = false;
					avanzaT = false;
				}
			}
	
			if (!finF) {
				if (!finA && !finT) {
					if ((valorF == valorA) || (valorF == valorT)) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
					if ((valorF < valorA) && (valorF < valorT)) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
				}
				if (!finA && finT) {
					if (valorF == valorA) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
					if (valorF < valorA) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
				}
				if (finA && !finT) {
					if (valorF == valorT) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
					if (valorF < valorT) {
						fechaAct = qryF.value("facturasprov.fecha");
						avanzaA = false;
						avanzaF = true;
						avanzaT = false;
					}
				}
				if (finA && finT) {
					fechaAct = qryF.value("facturasprov.fecha");
					avanzaA = false;
					avanzaF = true;
					avanzaT = false;
				}
			}
		
			if (!finT) {
				if (!finA && !finF) {
					if ((valorT == valorA) || (valorT == valorF)) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}
					if ((valorT < valorA) && (valorT < valorF)) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}	
				}
				if (!finA && finF) {
					if (valorT == valorA) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}
					if (valorT < valorA) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}	
				}
				if (finA && !finF) {
					if (valorT == valorF) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}
					if (valorT < valorF) {
						fechaAct = qryT.value("transstock.fecha");
						avanzaA = false;
						avanzaF = false;
						avanzaT = true;
					}	
				}
				if (finA && finF) {
					fechaAct = qryT.value("transstock.fecha");
					avanzaA = false;
					avanzaF = false;
					avanzaT = true;
				}
			}
		
			/*
			////////////////////////////////
			Ahora se calculan las salidas de stock para calcular el stock actual.
			*/
			// Suma las salidas de los albaranes de venta.
			qrySalidas.setTablesList("albaranescli");
			qrySalidas.setSelect("SUM(lineasalbaranescli.cantidad)");
			qrySalidas.setFrom("lineasalbaranescli inner join albaranescli on albaranescli.idalbaran = lineasalbaranescli.idalbaran");
			qrySalidas.setWhere("lineasalbaranescli.referencia = '"+referencia+"' and albaranescli.codalmacen = '"+codAlmacen+"'  and albaranescli.fecha > '"+fechaIni+"' and albaranescli.fecha <= '"+fechaAct+"' GROUP BY lineasalbaranescli.referencia");
			if (!qrySalidas.exec()) {
				debug("No puedo ejecutar qrySalidas de albaranes");
				return false;
			}
			if (qrySalidas.next()) {
				salidas = parseFloat(qrySalidas.value("SUM(lineasalbaranescli.cantidad)"));
			}
			// Suma las salidas de las facturas de venta no automticas.
			qrySalidas.setTablesList("facturascli");
			qrySalidas.setSelect("SUM(lineasfacturascli.cantidad)");
			qrySalidas.setFrom("lineasfacturascli inner join facturascli on facturascli.idfactura = lineasfacturascli.idfactura");
			qrySalidas.setWhere("lineasfacturascli.referencia = '"+referencia+"' and facturascli.codalmacen = '"+codAlmacen+"'  and facturascli.automatica = false and facturascli.fecha > '"+fechaIni+"' and facturascli.fecha <= '"+fechaAct+"' GROUP BY lineasfacturascli.referencia");
			if (!qrySalidas.exec()) {
				debug("No puedo ejecutar qrySalidas de facturas");
				return false;
			}
			if (qrySalidas.next()) {
				salidas = salidas + parseFloat(qrySalidas.value("SUM(lineasfacturascli.cantidad)"));
			}
			/* Suma las salidas de las comandas de TPV. */
			qrySalidas.setTablesList("tpv_comandas");
			qrySalidas.setSelect("SUM(tpv_lineascomanda.cantidad)");
			qrySalidas.setFrom("tpv_lineascomanda inner join tpv_comandas on tpv_comandas.idtpv_comanda = tpv_lineascomanda.idtpv_comanda inner join tpv_puntosventa on tpv_puntosventa.codtpv_puntoventa = tpv_comandas.codtpv_puntoventa");
			qrySalidas.setWhere("tpv_lineascomanda.referencia = '"+referencia+"' and tpv_puntosventa.codalmacen = '"+codAlmacen+"' and tpv_comandas.fecha > '"+fechaIni+"' and tpv_comandas.fecha <= '"+fechaAct+"' GROUP BY tpv_lineascomanda.referencia");
			if (!qrySalidas.exec()) {
				debug("No puedo ejecutar qrySalidas de comandas de TPV");
				return false;
			}
			if (qrySalidas.next()) {
				salidas = parseFloat(qrySalidas.value("SUM(tpv_lineascomanda.cantidad)"));
			}
			// Suma las salidas de las transferencias de stock.
			qrySalidas.setTablesList("transstock");
			qrySalidas.setSelect("SUM(lineastransstock.cantidad)");
			qrySalidas.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
			qrySalidas.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmaorigen = '"+codAlmacen+"'  and transstock.fecha > '"+fechaIni+"' and transstock.fecha <= '"+fechaAct+"' GROUP BY lineastransstock.referencia");
			if (!qrySalidas.exec()) {
				debug("No puedo ejecutar qrySalidas de transferencias de stock.");
				return false;
			}
			if (qrySalidas.next()) {
				salidas = salidas + parseFloat(qrySalidas.value("SUM(lineastransstock.cantidad)"));
			}
		
			// Comprueba qu cursor avanza.
			if (avanzaA) {
				if ((entradas-salidas) <= 0)
					cms = qryA.value("lineasalbaranesprov.pvpunitario");
				else
					cms = parseFloat((cms * (entradas-salidas))+(qryA.value("lineasalbaranesprov.pvpunitario")*qryA.value("lineasalbaranesprov.cantidad"))) / parseFloat(entradas+qryA.value("lineasalbaranesprov.cantidad")-salidas);
				
				cms = util.roundFieldValue(cms, "articulos", "costeultimo");
				entradas = entradas + qryA.value("lineasalbaranesprov.cantidad");
				//stock = stock + qryA.value("lineasalbaranesprov.cantidad") - salidas;
				if (!qryA.next()) {
					finA = true;
				//debug("finA = true");
				}
			}
			if (avanzaF) {
				if ((entradas-salidas) <= 0)
					cms = qryF.value("lineasfacturasprov.pvpunitario");
				else
					cms = parseFloat((cms * (entradas-salidas))+(qryF.value("lineasfacturasprov.pvpunitario")*qryF.value("lineasfacturasprov.cantidad"))) / parseFloat(entradas+qryF.value("lineasfacturasprov.cantidad")-salidas);
				
				cms = util.roundFieldValue(cms, "articulos", "costeultimo");
				entradas = entradas + qryF.value("lineasfacturasprov.cantidad");
				//stock = stock + qryF.value("lineasfacturasprov.cantidad") - salidas;
				if (!qryF.next()) {
					finF = true;
				//debug("finF = true");
				}
			}
			if (avanzaT) {
				if ((entradas-salidas) <= 0)
					cms = qryT.value("lineastransstock.costemediostock");
				else
					cms = parseFloat((cms * (entradas-salidas))+(qryT.value("lineastransstock.costemediostock")*qryT.value("lineastransstock.cantidad"))) / parseFloat(entradas+qryT.value("lineastransstock.cantidad")-salidas);
				
				cms = util.roundFieldValue(cms, "articulos", "costeultimo");
				entradas = entradas + qryT.value("lineastransstock.cantidad");
				//stock = stock + qryT.value("lineastransstock.cantidad") - salidas;
				if (!qryT.next()) {
					finT = true;
				//debug("finT = true");
				}
			}
		}

		// Calcula el coste medio de stock y actualiza el dato.
		cms = util.roundFieldValue(cms, "articulos", "costeultimo");
	
		//this.iface.actualizaCMS(referencia, codAlmacen, cms);
		/*if (!util.sqlUpdate("stocks", "costemediostock", cms, "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'")) {
		debug("No he podido actualizar dato costemediostock en stocks.");
		return false;
	}*/
	
		//---------------------------------
		// Calcula el stock actual y actualiza el dato.
		// Suma las salidas de los albaranes de venta.
		salidas = 0;
		qrySalidas.setTablesList("albaranescli");
		qrySalidas.setSelect("SUM(lineasalbaranescli.cantidad)");
		qrySalidas.setFrom("lineasalbaranescli inner join albaranescli on albaranescli.idalbaran = lineasalbaranescli.idalbaran");
		qrySalidas.setWhere("lineasalbaranescli.referencia = '"+referencia+"' and albaranescli.codalmacen = '"+codAlmacen+"'  and albaranescli.fecha > '"+fechaIni+"' GROUP BY lineasalbaranescli.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de albaranes");
			return false;
		}
		if (qrySalidas.next()) {
			salidas = parseFloat(qrySalidas.value("SUM(lineasalbaranescli.cantidad)"));
		}
		// Suma las salidas de las facturas de venta no automticas.
		qrySalidas.setTablesList("facturascli");
		qrySalidas.setSelect("SUM(lineasfacturascli.cantidad)");
		qrySalidas.setFrom("lineasfacturascli inner join facturascli on facturascli.idfactura = lineasfacturascli.idfactura");
		qrySalidas.setWhere("lineasfacturascli.referencia = '"+referencia+"' and facturascli.codalmacen = '"+codAlmacen+"'  and facturascli.automatica = false and facturascli.fecha > '"+fechaIni+"' GROUP BY lineasfacturascli.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de facturas");
			return false;
		}
		if (qrySalidas.next()) {
			salidas = salidas + parseFloat(qrySalidas.value("SUM(lineasfacturascli.cantidad)"));
		}
		// Suma las salidas de las transferencias de stock.
		qrySalidas.setTablesList("transstock");
		qrySalidas.setSelect("SUM(lineastransstock.cantidad)");
		qrySalidas.setFrom("lineastransstock inner join transstock on transstock.idtrans = lineastransstock.idtrans");
		qrySalidas.setWhere("lineastransstock.referencia = '"+referencia+"' and transstock.codalmaorigen = '"+codAlmacen+"'  and transstock.fecha > '"+fechaIni+"' GROUP BY lineastransstock.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de transferencias de stock.");
			return false;
		}
		if (qrySalidas.next()) {
			salidas = salidas + parseFloat(qrySalidas.value("SUM(lineastransstock.cantidad)"));
		}
		// Suma las salidas de las comandas de TPV.
		qrySalidas.setTablesList("tpv_comandas");
		qrySalidas.setSelect("SUM(tpv_lineascomanda.cantidad)");
		qrySalidas.setFrom("tpv_lineascomanda inner join tpv_comandas on tpv_comandas.idtpv_comanda = tpv_lineascomanda.idtpv_comanda inner join tpv_puntosventa on tpv_puntosventa.codtpv_puntoventa = tpv_comandas.codtpv_puntoventa");
		qrySalidas.setWhere("tpv_lineascomanda.referencia = '"+referencia+"' and tpv_puntosventa.codalmacen = '"+codAlmacen+"' and tpv_comandas.fecha > '"+fechaIni+"' GROUP BY tpv_lineascomanda.referencia");
		if (!qrySalidas.exec()) {
			debug("No puedo ejecutar qrySalidas de comandas de TPV");
			return false;
		}
		if (qrySalidas.next())
			salidas = parseFloat(qrySalidas.value("SUM(tpv_lineascomanda.cantidad)"));
	
		stock = entradas - salidas;
	
		//this.iface.actualizaStock(referencia, codAlmacen, stock);
		/* Utiliza nueva funcin if (!util.sqlUpdate("stocks", "cantidad", stock, "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'")) {
		debug("No he podido actualizar dato cantidad en stocks.");
		return false;
	} */
		//----------------------
	} else {
		cms = util.sqlSelect("stocks", "costemediostock", "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'");
		debug("NO HAY COMPRAS POSTERIORES. PONE EL CMS ACTUAL: "+cms);
		return cms;
	}

	return cms;
}

/**
Funcin que actualiza la cantidad en la ficha de stocks.
 */
function klo_actualizaStock(referencia:String, codAlmacen:String, stock:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	
	debug("ACTUALIZA STOCK Y DISPONIBLE KLO");
	
	// Se actualiza también el campo de stock disponible que es la cantidad - la reservada.
	var reservada:Number = parseFloat(util.sqlSelect("stocks","reservada","referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'"));
	var disponible:Number = stock - reservada;
	var curStocks:FLSqlCursor = new FLSqlCursor("stocks");
	curStocks.select("referencia = '" + referencia + "' and codalmacen = '"+codAlmacen+"'");
	if (curStocks.first()) {
		curStocks.setModeAccess(curStocks.Edit);
		curStocks.refreshBuffer();
		curStocks.setValueBuffer("cantidad", stock);
		curStocks.setValueBuffer("disponible", disponible);
		curStocks.commitBuffer(true)
	}
	return true;
}

/**
Funcin que actualiza el costemediostock en la ficha de stocks.
 */
function klo_actualizaCMS(referencia:String, codAlmacen:String, cms:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	
	debug("ACTUALIZA CMS KLO");
	if (!util.sqlUpdate("stocks", "costemediostock", cms, "referencia = '"+referencia+"' and codalmacen = '"+codAlmacen+"'")) {
		debug("No he podido actualizar dato costemediostock en stocks.");
		return false;
	}
	return true;
}

/**
Función que encapsula las llamadas a las funciones ultimoCMS(), sctualizaStock() y
actualizaCMS().
De esta forma solo hay que hacer una llamada.
 */
function klo_calculosUltCMS(referencia:String, codAlmacen:String):Boolean
{
	debug("KLO--> calculosUltCMS");
	var valor:Array = this.iface.ultimoCMS(referencia, codAlmacen);
	//debug("VALOR.STOCK: "+valor.stock);
	debug("VALOR.CMS: "+valor.cms);
	//this.iface.actualizaStock(referencia, codAlmacen, valor.stock);
	this.iface.actualizaCMS(referencia, codAlmacen, valor.cms);
	
	return true;
}

function klo_arrayLineasAfectadas(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

/*debug("ARRAY INICIAL");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["codalmacen"]);
}
*/
	arrayInicial.sort(this.iface.compararArrayLineas);
	arrayFinal.sort(this.iface.compararArrayLineas);
	
/*debug("ARRAY INICIAL ORDENADO");
for (var i:Number = 0; i < arrayInicial.length; i++) {
	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["codalmacen"]);
}
debug("ARRAY FINAL ORDENADO");
for (var i:Number = 0; i < arrayFinal.length; i++) {
	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["codalmacen"]);
}*/
	var comparacion:Number;
	while (iAI < longAI || iAF < longAF) {
		if (iAI < longAI && iAF < longAF) {
			comparacion = this.iface.compararArrayLineas(arrayInicial[iAI], arrayFinal[iAF]);
		} else if (iAF < longAF) {
			comparacion = 1;
		} else if (iAI < longAI) {
			comparacion = -1;
		}
		switch (comparacion) {
			case 1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAF]["idarticulo"];
				arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAF]["codalmacen"];
				arrayAfectados[iAA]["fecha"] = arrayFinal[iAF]["fecha"];
				iAF++;
				iAA++;
				break;
			}
			case -1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayInicial[iAI]["idarticulo"];
				arrayAfectados[iAA]["codalmacen"] = arrayInicial[iAI]["codalmacen"];
				arrayAfectados[iAA]["fecha"] = arrayInicial[iAI]["fecha"];
				iAI++;
				iAA++;
				break;
			}
			case 0: {
				if (arrayInicial[iAI]["cantidad"] != arrayFinal[iAF]["cantidad"]) {
					arrayAfectados[iAA] = [];
					arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAI]["idarticulo"];
					arrayAfectados[iAA]["codalmacen"] = arrayFinal[iAI]["codalmacen"];
					arrayAfectados[iAA]["fecha"] = arrayFinal[iAI]["fecha"];
					iAA++;
				}
				iAI++;
				iAF++;
				break;
			}
		}
	}
	return arrayAfectados;
}

function klo_compararArrayLineas(a:Array, b:Array):Number
{
	var resultado:Number = 0;
	if (a["codalmacen"] > b["codalmacen"]) {
		resultado = 1;
	} else if (a["codalmacen"] < b["codalmacen"]) {
		resultado = -1;
	} else if (a["codalmacen"] == b["codalmacen"]) {
		if (a["idarticulo"] > b["idarticulo"])  {
			resultado = 1;
		} else if (a["idarticulo"] < b["idarticulo"])  {
			resultado = -1;
		}
	}
	return resultado;
}

function klo_controlArticulo(curLinea:FLSqlCursor, codAlmacen:String, fecha:Date):Boolean
{
	debug("controlArticulo");
	var util:FLUtil = new FLUtil;
	var origen:String = "otros";
	var fN:String = curLinea.table();

	debug("KLO--> curLinea: "+fN);

	switch (fN) {
		case "tpv_lineascomanda":
		case "lineasalbaranescli":
		case "lineasfacturascli":{
			debug("KLO--> fechaFin: "+fecha);
			origen = "cliente";
			break;
		}
		case "lineasalbaranesprov":
		case "lineasfacturasprov":{
			origen = "proveedor";
			break;
		}
	}

	debug("KLO--> origen: "+origen);
	var referencia:String = curLinea.valueBuffer("referencia");
	debug("Referencia klo = " + referencia);

	if (referencia && referencia != "") {
	debug("Llamando klo");
		if (origen == "cliente") {
			if (!this.iface.controlCMSAlbaranesCli(referencia, codAlmacen, fecha)) {
				return false;
			}
		} else {
			this.iface.calculosUltCMS(referencia, codAlmacen);
		}
		if (origen == "proveedor") {
			this.iface.cambiarCosteMedio(referencia);
			this.iface.cambiarUltimoCoste(referencia);
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	if (referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) {
		if (origen = "cliente") {
			if (!this.iface.controlCMSAlbaranesCli(referencia, codAlmacen, fecha)) {
				return false;
			}
		} else {
			this.iface.calculosUltCMS(referencia, codAlmacen);
		}
	}
 
	return true;
}

/**
Devuelve el coste que tiene el artículo en una fecha dada.
**/
function klo_costeEnUnaFecha(referencia:String, codAlmacen:String, fechaFin:Date):Number
{
	var fechaAP:Date;
	var costeAP:Number;
	var fechaFP:Date;
	var costeFP:Number;
	var coste:Number;
	var util:FLUtil = new FLUtil;
	var qryAP:FLSqlQuery = new FLSqlQuery();
	var qryFP:FLSqlQuery = new FLSqlQuery();
	
	qryAP.setTablesList("albaranesprov");
	qryAP.setSelect("albaranesprov.fecha, lineasalbaranesprov.cantidad, lineasalbaranesprov.pvpunitario");
	qryAP.setFrom("lineasalbaranesprov inner join albaranesprov on albaranesprov.idalbaran = lineasalbaranesprov.idalbaran");
	qryAP.setWhere("lineasalbaranesprov.referencia = '"+referencia+"' and albaranesprov.codalmacen = '"+codAlmacen+"' and albaranesprov.fecha <= '"+fechaFin+"' ORDER BY albaranesprov.fecha DESC");
	if (!qryAP.exec()) {
		debug("No puedo ejecutar qryAP para coste");
		return false;
	}
	
	//debug(qryAP.sql());

	if(qryAP.next()) {
		fechaAP = qryAP.value("albaranesprov.fecha");
		costeAP = qryAP.value("lineasalbaranesprov.pvpunitario");
		//debug("KLO--> coste de albaran de fecha -> "+qryAP.value("albaranesprov.fecha")+" es: "+qryAP.value("lineasalbaranesprov.pvpunitario"));
	} else {
		fechaAP = 0;
	}

	//debug("KLO--> fechaAP: "+fechaAP);
	
	qryFP.setTablesList("facturasprov");
	qryFP.setSelect("facturasprov.fecha, lineasfacturasprov.cantidad, lineasfacturasprov.pvpunitario");
	qryFP.setFrom("lineasfacturasprov inner join facturasprov on facturasprov.idfactura = lineasfacturasprov.idfactura");
	qryFP.setWhere("lineasfacturasprov.referencia = '"+referencia+"' and facturasprov.codalmacen = '"+codAlmacen+"' and facturasprov.automatica = false and facturasprov.fecha <= '"+fechaFin+"' ORDER BY facturasprov.fecha DESC");
	if (!qryFP.exec()) {
		debug("No puedo ejecutar qryFP para coste");
		return false;
	}

	//debug(qryFP.sql());

	if (qryFP.next()) {
		fechaFP = qryFP.value("facturasprov.fecha");
		costeFP = qryFP.value("lineasfacturasprov.pvpunitario");
		//debug("KLO--> coste de factura de fecha -> "+qryFP.value("facturasprov.fecha")+" es: "+qryFP.value("lineasfacturasprov.pvpunitario"));
	} else {
		fechaFP = 0;
	}

	//debug("KLO--> fechaFP: "+fechaFP);

	// Nos vamos a quedar con el coste de fecha más cercana a la dada.
	if (fechaAP != 0 && fechaFP == 0)
		coste = qryAP.value("lineasalbaranesprov.pvpunitario");
	if (fechaAP == 0 && fechaFP != 0)
		coste = qryFP.value("lineasfacturasprov.pvpunitario");
	if (fechaAP == 0 && fechaFP == 0)
		coste = util.sqlSelect("articulos", "costeultimo", "referencia = '"+referencia+"'");
	if (fechaAP != 0 && fechaFP != 0) {
		if (fechaAP >= fechaFP)
			coste = qryAP.value("lineasalbaranesprov.pvpunitario");
		else
			coste = qryFP.value("lineasfacturasprov.pvpunitario");
	}
	
	//debug("fechaAP: "+fechaAP+" --> fechaFP: "+fechaFP);
		
	return coste;
}

/**
	Este método no hereda de scab puesto que hace lomismo pero pasando por todos
	los elementos de la lista, no por solo los cambiados como pasa en scab.
**/
function klo_arraySocksAfectados(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

	// KLO: quito todo y fusiono los arrays para que pase por todas las líneas.
	// Tanto si han cambiado como si no.
	
	arrayInicial.sort(this.iface.compararArrayStock);
	arrayFinal.sort(this.iface.compararArrayStock);
	
	var arrayConTodo:Array = [];
	arrayConTodo = arrayConTodo.concat(arrayInicial, arrayFinal);
	arrayConTodo.sort();

	debug("ARRAY CON TODO ORDENADO");
	for (var i:Number = 0; i < arrayConTodo.length; i++) {
		debug(" " + arrayConTodo[i]["idarticulo"] + "-" + arrayConTodo[i]["codalmacen"]);
	}

	return arrayConTodo;
}
/////KLO///////////////////////////////////////////////////
///////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////