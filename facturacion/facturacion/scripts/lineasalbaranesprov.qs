/***************************************************************************
                 lineasalbaranesprov.qs  -  description
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
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
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
	function actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarEstadoPedido(idPedido, curAlbaran);
	}
	function actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_actualizarLineaPedido(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function obtenerEstadoPedido(idPedido:Number):String {
		return this.ctx.oficial_obtenerEstadoPedido(idPedido);
	}
	function filtrarArtProv() {
		return this.ctx.oficial_filtrarArtProv();
	}
	function dameFiltroReferencia():String {
		return this.ctx.oficial_dameFiltroReferencia();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial {
    function rappel( context ) { oficial ( context ); }
	function init() {
		return this.ctx.rappel_init();
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends rappel 
{
	var ledCodigoDeBarras:Object;
	var tblPreciosTarifas:QTable;
	var curMargenes_:FLSqlCursor;
	
	function klo( context ) { rappel ( context ); }
	function init() {
		return this.ctx.klo_init();
	}
	function codigodebarrasSet() {
		return this.ctx.klo_codigodebarrasSet();
	}

	function defineGridPrecios() {
		return this.ctx.klo_defineGridPrecios();
	}
	function bufferChanged(fN:String) {
		return this.ctx.klo_bufferChanged(fN);
	}
	function refrescaTarifas() {
		return this.ctx.klo_refrescaTarifas();
	}
	function abrirTarifa() {
		return this.ctx.klo_abrirTarifa();
	}
	function editarPrecioArt() {
		return this.ctx.klo_editarPrecioArt();
	}
	function obtenerPrecioTarifa(referencia:String, codTarifa:String):String {
		return this.ctx.klo_obtenerPrecioTarifa(referencia, codTarifa);
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

/** @class_declaration ifaceCtx*/
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.actualizarEstadoPedido(idPedido, curAlbaran);
	}
	function pub_actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number) {
		return this.actualizarLineaPedido(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function pub_obtenerEstadoPedido(idPedido:Number):String {
		return this.obtenerEstadoPedido(idPedido);
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
/** \C
Este formulario realiza la gestión de las líneas de albaranes a proveedores.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
	connect(form, "closed()", this, "iface.desconectar");

	var codSerieAlbaran:String;
	var codProveedor:String;
	if(cursor.cursorRelation()) {
		codSerieAlbaran = cursor.cursorRelation().valueBuffer("codserie");
		codProveedor = cursor.cursorRelation().valueBuffer("codproveedor");
	}
	else {
		codSerieAlbaran = util.sqlSelect("albaranesprov","codserie","idAlbaran = " + cursor.valueBuffer("idalbaran"));
		codProveedor = util.sqlSelect("albaranesprov","codproveedor","idAlbaran = " + cursor.valueBuffer("idalbaran"));
	}

	var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + codSerieAlbaran + "'");
	if (!irpf)
		irpf = 0;

	var opcionIvaRec:Number = flfacturac.iface.pub_tieneIvaDocProveedor(codSerieAlbaran, codProveedor);
	if (cursor.modeAccess() == cursor.Insert) {
		switch (opcionIvaRec) {
			case 0: {
				this.child("fdbCodImpuesto").setValue("");
				this.child("fdbIva").setValue(0);
			}
			case 1: {
				this.child("fdbRecargo").setValue(0);
				break;
			}
		}
		
		this.child("fdbIRPF").setValue(irpf);
// 		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
	}

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
// 	if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
// 		switch (opcionIvaRec) {
// 			case 0: {
// 				this.child("fdbCodImpuesto").setDisabled(true);
// 				this.child("fdbIva").setDisabled(true);
// 			}
// 			case 1: {
// 				this.child("fdbRecargo").setDisabled(true);
// 				break;
// 			}
// 		}
		
// 		var serie:String = cursor.cursorRelation().valueBuffer("codserie");
// 		var siniva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
// 		if(siniva){
// 			cursor.setValueBuffer("codimpuesto","");
// 			cursor.setValueBuffer("iva",0);
// 			cursor.setValueBuffer("recargo",0);
// 		}
// 	}

	this.iface.filtrarArtProv();
}

/** \C
Los campos calculados de este formulario son los mismos que los del formulario de líneas de pedido a proveedor
\end */
function interna_calculateField(fN:String):String
{
	return formRecordlineaspedidosprov.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_acceptedForm()
{
// 	var cursor:FLSqlCursor = this.cursor();
// 	this.iface.actualizarLineaPedido(cursor.valueBuffer("idlineapedido"), cursor.valueBuffer("idpedido") , cursor.valueBuffer("referencia"), cursor.valueBuffer("idalbaran"), cursor.valueBuffer("cantidad"));
// 	this.iface.actualizarEstadoPedido(cursor.valueBuffer("idpedido"), cursor);
}

/** \D Función a sobrecargar
\end */
function interna_validateForm():Boolean
{
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	disconnect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
}

/** \C
Las dependencias entre controles de este formulario son las mismas que las del formulario de líneas de pedido a proveedor
\end */
function oficial_bufferChanged(fN:String)
{
		formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, form);
}

/** \C
Obtiene el estado de un pedido
@param	idPedido: Id del pedido a actualizar
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_obtenerEstadoPedido(idPedido:Number):String
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.obtenerEstadoPedidoProv(idPedido);
}

/** \C
Marca el pedido como servido o parcialmente servido según corresponda.
@param	idPedido: Id del pedido a actualizar
@param	curAlbaran: Cursor posicionado en el albarán que modifica el estado del pedido
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.actualizarEstadoPedidoProv(idPedido, curAlbaran);
}

/** \C
Actualiza el campo total en albarán de la línea de pedido correspondiente (si existe).
@param	idLineaPedido: Id de la línea a actualizar
@param	idPedido: Id del pedido a actualizar
@param	referencia del artículo contenido en la línea
@param	idAlbaran: Id del albarán en el que se sirve el pedido
@param	cantidadLineaAlbaran: Cantidad total de artículos de la referencia actual en el albarán
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
}

/** \D Muestra únicamente los artículos del proveedor
*/
function oficial_filtrarArtProv()
{
	var filtroReferencia:String = this.iface.dameFiltroReferencia();
	this.child("fdbReferencia").setFilter(filtroReferencia);
}

function oficial_dameFiltroReferencia():String
{
	var filtroReferencia:String = "secompra";
	if (this.child("chkFiltrarArtProv").checked) {
		var codProveedor:String = this.cursor().cursorRelation().valueBuffer("codproveedor");
		if (codProveedor && codProveedor != "")
			filtroReferencia = "secompra AND referencia IN (SELECT referencia from articulosprov WHERE codproveedor = '" + codProveedor + "')";
	} else {
		filtroReferencia = "secompra";
	}
	return filtroReferencia;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_init()
{
	this.iface.__init();
	this.child("lblDtoRappel").setText(formRecordlineaspedidosprov.iface.pub_commonCalculateField("lbldtorappel", this.cursor()));
}
//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

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

	// Apartado donde se define el grid de precios.
	this.iface.defineGridPrecios();
	
	connect(this.child("pbnEditarTarifa"), "clicked()", this, "iface.abrirTarifa()");
	connect(this.child("pbnEditarPrecioArt"), "clicked()", this, "iface.editarPrecioArt()");
	connect(this.child("pbnRefrescaTarifas"), "clicked()", this, "iface.refrescaTarifas()");

}

/** \D
Busca el código de barras en la tabla de codigosdebarras
\end */
function klo_codigodebarrasSet()
{
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

function klo_defineGridPrecios()
{
	var util:FLUtil = new FLUtil();
	var precioVenta:Number = 0;
	var incPorcentual:Number = 0;
	var beneficioCompra:Number = 0;
	var beneficioCMS:Number = 0;
	
	var cursorLinea:FLSqlCursor = this.cursor();
	var cursorTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
	var cursorMargenes:FLSqlCursor = new FLSqlCursor("margenestarifas");
	
	var codTarifa:String;
	var incSobreBase:Number = 0;
	var referencia:String = cursorLinea.valueBuffer("referencia");
	var codFamilia:String = util.sqlSelect( "articulos", "codfamilia", "referencia = '" + referencia + "'");
	var codSubfamilia:String = util.sqlSelect( "articulos", "codsubfamilia", "referencia = '" + referencia + "'");
	var codSeccion:String = util.sqlSelect( "articulos", "codseccion", "referencia = '" + referencia + "'");
	var costeUltimo:String = cursorLinea.valueBuffer("pvpunitario");

	var CMS:String = formRecordlineaspedidosprov.iface.pub_commonCalculateField("costemediostock", this.cursor());
	if (!CMS)
		CMS = 0;
	var stockFis:Number = util.sqlSelect( "articulos", "stockfis", "referencia = '" + referencia + "'");
	var ultCMS:Number = ((CMS*stockFis)+((cursorLinea.valueBuffer("pvpunitario")*cursorLinea.valueBuffer("cantidad")))) / (stockFis+cursorLinea.valueBuffer("cantidad"));
	
	ultCMS = util.roundFieldValue(ultCMS, "articulos", "costemediostock");
	
	this.iface.tblPreciosTarifas = this.child("tblPreciosTarifas");
	
	this.iface.tblPreciosTarifas.setNumCols(5);
	this.iface.tblPreciosTarifas.setColumnWidth(0, 50);
	this.iface.tblPreciosTarifas.setColumnWidth(1, 110);
	this.iface.tblPreciosTarifas.setColumnWidth(2, 60);
	
	this.iface.tblPreciosTarifas.setColumnWidth(3, 75);
	this.iface.tblPreciosTarifas.setColumnWidth(4, 60);
	
	this.iface.tblPreciosTarifas.setColumnLabels("/", "Tarifa/Nombre/P.V.P./Bº Ult. cost./Bº C.M.S.");
	
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
					incPorcentual = "";
				}
				else {
					incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
				}
				precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
				beneficioCompra = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
				beneficioCMS = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
				this.iface.tblPreciosTarifas.setText(contador, 0, cursorMargenes.valueBuffer("codtarifa"));
				this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
				this.iface.tblPreciosTarifas.setText(contador, 2, precioVenta);
				this.iface.tblPreciosTarifas.setText(contador, 3, beneficioCompra);
				this.iface.tblPreciosTarifas.setText(contador, 4, beneficioCMS);
			}
			else {
				// Inserto las líneas con los datos de las tarifas según la subfamilia.
				if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codsubfamilia = '" + codSubfamilia + "'")) {
					if (cursorMargenes.size()>0) {
						cursorMargenes.first();
						if (cursorMargenes.valueBuffer("pvpfijo")) {
							incPorcentual = "";
						}
						else {
							incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
						}
						precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
						beneficioCompra = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
						beneficioCMS = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
						this.iface.tblPreciosTarifas.setText(contador, 0, cursorMargenes.valueBuffer("codtarifa"));
						this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
						this.iface.tblPreciosTarifas.setText(contador, 2, precioVenta);
						this.iface.tblPreciosTarifas.setText(contador, 3, beneficioCompra);
						this.iface.tblPreciosTarifas.setText(contador, 4, beneficioCMS);
					}
					else {
						// Inserto las líneas con los datos de las tarifas según la familia.
						if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codfamilia = '" + codFamilia + "'")) {
							if (cursorMargenes.size()>0) {
								cursorMargenes.first();
								if (cursorMargenes.valueBuffer("pvpfijo")) {
									incPorcentual = "";
								}
								else {
									incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
								}
								precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
								beneficioCompra = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
								beneficioCMS = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
								this.iface.tblPreciosTarifas.setText(contador, 0, cursorMargenes.valueBuffer("codtarifa"));
								this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
								this.iface.tblPreciosTarifas.setText(contador, 2, precioVenta);
								this.iface.tblPreciosTarifas.setText(contador, 3, beneficioCompra);
								this.iface.tblPreciosTarifas.setText(contador, 4, beneficioCMS);
							}
							else {
								// Inserto las líneas con los datos de las tarifas según la seccion.
								if (cursorMargenes.select("codtarifa = '"+codTarifa+"' and codseccion = '" + codSeccion + "'")) {
									if (cursorMargenes.size()>0) {
										cursorMargenes.first();
										if (cursorMargenes.valueBuffer("pvpfijo")) {
										incPorcentual = "";
										}
										else {
										incPorcentual = util.roundFieldValue(cursorMargenes.valueBuffer("incporcentual"), "tarifas", "incporcentual");
										}
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										beneficioCompra = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
										beneficioCMS = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorMargenes.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 3, beneficioCompra);
										this.iface.tblPreciosTarifas.setText(contador, 4, beneficioCMS);
									}
									else {
										incPorcentual = util.sqlSelect("tarifas", "incporcentual", "codtarifa = '"+codTarifa+"'")
										incPorcentual = util.roundFieldValue(incPorcentual, "tarifas", "incporcentual");
										precioVenta = this.iface.obtenerPrecioTarifa(referencia, cursorTarifas.valueBuffer("codtarifa"));
										beneficioCompra = formRecordarticulos.iface.calcularBeneCompra(referencia, costeUltimo, precioVenta);
										beneficioCMS = formRecordarticulos.iface.calcularBeneCMS(referencia, ultCMS, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 0, cursorTarifas.valueBuffer("codtarifa"));
										this.iface.tblPreciosTarifas.setText(contador, 1, cursorTarifas.valueBuffer("nombre"));
										this.iface.tblPreciosTarifas.setText(contador, 2, precioVenta);
										this.iface.tblPreciosTarifas.setText(contador, 3, beneficioCompra);
										this.iface.tblPreciosTarifas.setText(contador, 4, beneficioCMS);
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

function klo_bufferChanged(fN:String)
{
	this.iface.__bufferChanged(fN);
	
	switch (fN) {
		case "pvpunitario":{
			this.iface.refrescaTarifas();
			break;
		}
	}
}

function klo_refrescaTarifas()
{
	this.iface.tblPreciosTarifas.numRows() == 0;
	this.iface.tblPreciosTarifas.numCols() == 0;
	
	this.iface.defineGridPrecios();
}

function klo_abrirTarifa()
{
	var curTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
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
	var arrayDatos:Array;
	arrayDatos.pvpunitario = this.cursor().valueBuffer("pvpunitario");
	arrayDatos.cantidad = this.cursor().valueBuffer("cantidad");
	formRecordmargenestarifas.iface.pub_establecerLlamadaAlbaran(true);
	formRecordmargenestarifas.iface.pub_establecerDatosAlbaran(arrayDatos);

	connect(this.iface.curMargenes_, "bufferCommited()", this, "iface.refrescaTarifas");
	this.iface.curMargenes_.editRecord();
}

function klo_editarPrecioArt()
{
	var util:FLUtil = new FLUtil;
	var curTarifas:FLSqlCursor = new FLSqlCursor("tarifas");
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

/** \D Obtiene el precio del artículo según la TARIFA GENERAL asociada a un cliente
OJO: ESTA FUNCIÓN ES SOLO PARA AQUÍ. ESTÁ LA GENERAL EN ARTICULOS.QS
@param referencia: referencia del artículo
@param codTarifa: código de la tarifa asociada al cliente  
@return precio calculado del artículo asociado a la tarifa según el cliente
\end */
function klo_obtenerPrecioTarifa(referencia:String, codTarifa:String):Number
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
	if (pvpFijo) {
		precioArticulo = util.sqlSelect("margenestarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifaReal + "'");
	}
	else {
		incPorcentual = util.sqlSelect("margenestarifas", "incporcentual", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
	}
	
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
				costeArticulo = this.child("fdbPvpUnitario").value();
				break;
			}
		}
		precioArticulo = (costeArticulo*(incPorcentual/100))+costeArticulo;
		precioArticulo = (precioArticulo*(incSobreBase/100))+precioArticulo;
		// Si está activado el redondeo a 0 y 5
		if (redondeo) {
			precioArticulo = formRecordarticulos.iface.redondeoDecimal(precioArticulo);
		} else {
			precioArticulo = util.roundFieldValue(precioArticulo, "articulos", "pvp");
		}
	}
	return precioArticulo;
}
//// KLO /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////