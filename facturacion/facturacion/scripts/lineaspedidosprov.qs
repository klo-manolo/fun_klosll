/***************************************************************************
                 lineaspedidosprov.qs  -  description
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
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.oficial_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function filtrarArtProv() {
		return this.ctx.oficial_filtrarArtProv();
	}
	function datosTablaPadre(cursor:FLSqlCursor):Array {
		return this.ctx.oficial_datosTablaPadre(cursor);
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
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.rappel_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.rappel_commonCalculateField(fN, cursor);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends rappel {
    function pedProvCli( context ) { rappel ( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration klo */
/////////////////////////////////////////////////////////////////
//// KLO /////////////////////////////////////////////////////
class klo extends pedProvCli 
{
	var ledCodigoDeBarras:Object;

	function klo( context ) { pedProvCli ( context ); }
	function init() {
		return this.ctx.klo_init();
	}
	function codigodebarrasSet() {
		return this.ctx.klo_codigodebarrasSet();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.klo_commonCalculateField(fN, cursor);
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
		function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
				return this.commonCalculateField(fN, cursor);
		}
		function pub_commonBufferChanged(fN:String, miForm:Object) {
				return this.commonBufferChanged(fN, miForm);
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
Este formulario realiza la gesti�n de las l�neas de pedidos a proveedores.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");
	connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
	
	var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + cursor.cursorRelation().valueBuffer("codserie") + "'");
	if (!irpf)
		irpf = 0;
	
	var serie:String = cursor.cursorRelation().valueBuffer("codserie");
	var codProveedor:String = cursor.cursorRelation().valueBuffer("codproveedor");
	var opcionIvaRec:Number = flfacturac.iface.pub_tieneIvaDocProveedor(serie, codProveedor);
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
	
// 	switch (opcionIvaRec) {
// 		case 0: {
// 			this.child("fdbCodImpuesto").setDisabled(true);
// 			this.child("fdbIva").setDisabled(true);
// 		}
// 		case 1: {
// 			this.child("fdbRecargo").setDisabled(true);
// 			break;
// 		}
// 	}
// 	var siniva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
// 	if(siniva){
// 		cursor.setValueBuffer("codimpuesto","");
// 		cursor.setValueBuffer("iva",0);
// 		cursor.setValueBuffer("recargo",0);
// 	}

	this.iface.filtrarArtProv();
}

function interna_calculateField(fN:String):String
{
		return this.iface.commonCalculateField(fN, this.cursor());
		/** \C
		El --pvpunitario-- ser� el correspondiente al coste por proveedor y moneda correspondiente a la --referencia-- seleccionada
		\end */
		/** \C
		El --codimpuesto-- ser� el correspondiente a la --referencia-- seleccionada
		\end */
		/** \C
		El --iva-- ser� el correspondiente al --codimpuesto-- en la tabla de impuestos
		\end */
		/** \C
		El --pvptotal-- ser� el --pvpsindto-- menos el --dtopor-- y menos el --dtolineal--
		\end */
		/** \C
		El --dtopor-- ser� el descuento asociado al proveedor
		\end */
		/** \C
		El --recargo-- ser� el correspondiente al --codimpuesto-- en la tabla de impuestos en el caso de la empresa tenga activado el campo Aplicar recargo de equivalencia en su correspondiente formulario.
		\end */
		/** \C
		El --pvpsindto-- ser� el producto del campo --cantidad-- por el campo --pvpunitario--
		\end */
}

function interna_validateForm():Boolean
{
		/** \C
		La cantidad de art�culos especificada ser� mayor o igual que la del --totalenalbaran--
		\end */
		if (parseFloat(this.cursor().valueBuffer("cantidad")) < parseFloat(this.cursor().valueBuffer("totalenalbaran")))
				return false;
		else
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

function oficial_bufferChanged(fN:String)
{
		this.iface.commonBufferChanged(fN, form);
		/** \C
		Al cambiar la --referencia-- se mostrar�n los valores asociados de --pvpvunitario-- y --codimpuesto--
		\end */
		/** \C
		Al cambiar el --codimpuesto-- se mostrar�n los valores asociados de --iva-- y --recargo--
		\end */
		/** \C
		Al cambiar la --cantidad-- o el --pvpunitario-- se mostrar� el valor asociado de --pvptotal--
		\end */
		/** \C
		Al cambiar el --pvpsindto--, el --dtopor-- o el --dtolineal-- se mostrar� el valor asociado de --pvptotal--
		\end */
}

function oficial_commonBufferChanged(fN:String, miForm:Object)
{
		switch (fN) {
		case "referencia":{
						var util:FLUtil = new FLUtil();
						miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
						miForm.child("fdbDtoPor").setValue(this.iface.commonCalculateField("dtopor", miForm.cursor()));
						var serie:String = miForm.cursor().cursorRelation().valueBuffer("codserie");
						var sinIva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
						if (!sinIva) {
							miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
						}
						break;
				}
		case "codimpuesto":{
						miForm.child("fdbIva").setValue(this.iface.commonCalculateField("iva", miForm.cursor()));
						miForm.child("fdbRecargo").setValue(this.iface.commonCalculateField("recargo", miForm.cursor()));
						break;
				}
		case "cantidad":
		case "pvpunitario":{
						miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
						break;
				}
		case "pvpsindto":
		case "dtopor":{
						miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
				}
		case "dtolineal":{
						miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
						break;
				}
		}
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var datosTP:Array = this.iface.datosTablaPadre(cursor);
	if (!datosTP)
		return false;
	var wherePadre:String = datosTP.where;
	var tablaPadre:String = datosTP.tabla;

	var valor:String;
	switch (fN) {
		case "pvpsindto": {
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			valor = util.roundFieldValue(valor, "lineaspedidosprov", "pvptotal");
			break;
		}
		case "codimpuesto":{
			var codProveedor:String = datosTP["codproveedor"];
			var codSerie:String = datosTP["codserie"];
			if (flfacturac.iface.pub_tieneIvaDocProveedor(codSerie, codProveedor)) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			} else {
				valor = "";
			}
			
			break;
		}
		case "iva":{
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuesto"), datosTP["fecha"]);
			if (isNaN(valor)) {
				valor = "";
			}
			break;
		}
		case "lbldtopor": {
			valor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			valor = util.roundFieldValue(valor, "lineaspedidosprov", "pvpsindto");
			break;
		}
		case "pvptotal": {
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidosprov", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
		case "dtopor": {
			var codProveedor:String = datosTP["codproveedor"];
			var codDivisa:String = datosTP["coddivisa"];
			valor = util.sqlSelect("articulosprov", "dto", "referencia = '" + cursor.valueBuffer("referencia") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
// 			valor = flfactppal.iface.pub_valorQuery("descuentosproveedores,descuentos", "SUM(d.dto)", "descuentosproveedores dc INNER JOIN descuentos d ON dc.coddescuento = d.coddescuento", "dc.codproveedor = '" + codProveedor + "'");
			break;
		}
		case "pvpunitario": {
			var codProveedor:String = datosTP["codproveedor"];
			var codDivisa:String = datosTP["coddivisa"];
			valor = util.sqlSelect("articulosprov", "coste", "referencia = '" + cursor.valueBuffer("referencia") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
			break;
		}
		case "recargo":{
			var aplicarRecEq:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia");
			if (aplicarRecEq == true) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuesto"), datosTP["fecha"]);
			} else {
				valor = "";
			}
			if (isNaN(valor)) {
				valor = "";
			}
			break;
		}
	}
	return valor;
}

/** \D Muestra �nicamente los art�culos del proveedor
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

/** \D Devuelve la tabla padre de la tabla par�metro, as� como la cl�usula where necesaria para localizar el registro padre
@param	cursor: Cursor cuyo padre se busca
@return	Array formado por:
	* where: Cl�usula where
	* tabla: Nombre de la tabla padre
o false si hay error
\end */
function oficial_datosTablaPadre(cursor:FLSqlCursor):Array
{
	var datos:Array;
	switch (cursor.table()) {
		case "lineaspedidosprov": {
			datos.where = "idpedido = "+ cursor.valueBuffer("idpedido");
			datos.tabla = "pedidosprov";
			break;
		}
		case "lineasalbaranesprov": {
			datos.where = "idalbaran = "+ cursor.valueBuffer("idalbaran");
			datos.tabla = "albaranesprov";
			break;
		}
		case "lineasfacturasprov": {
			datos.where = "idfactura = "+ cursor.valueBuffer("idfactura");
			datos.tabla = "facturasprov";
			break;
		}
	}
	var curRel:FLSqlCursor = cursor.cursorRelation();
	if (curRel && curRel.table() == datos.tabla) {
		datos["coddivisa"] = curRel.valueBuffer("coddivisa");
		datos["codproveedor"] = curRel.valueBuffer("codproveedor");
		datos["fecha"] = curRel.valueBuffer("fecha");
		datos["codserie"] = curRel.valueBuffer("codserie");
	} else {
		var qryDatos:FLSqlQuery = new FLSqlQuery;
		qryDatos.setTablesList(datos.tabla);
		qryDatos.setSelect("coddivisa, codproveedor, fecha, codserie");
		qryDatos.setFrom(datos.tabla);
		qryDatos.setWhere(datos.where);
		qryDatos.setForwardOnly(true);
		if (!qryDatos.exec()) {
			return false;
		}
		if (!qryDatos.first()) {
			return false;
		}
		datos["coddivisa"] = qryDatos.value("coddivisa");
		datos["codproveedor"] = qryDatos.value("codproveedor");
		datos["fecha"] = qryDatos.value("fecha");
		datos["codserie"] = qryDatos.value("codserie");
	}
	return datos;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_init()
{
	this.iface.__init();
	this.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", this.cursor()));
}

function rappel_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "referencia":
			miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
			var serie:String = miForm.cursor().cursorRelation().valueBuffer("codserie");
			var sinIva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
			if(sinIva == false)
				miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			break;
		case "dtorappel":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			break;
		case "cantidad":
			miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			break;
		case "pvpsindto":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			break;
		default:
			this.iface.__commonBufferChanged(fN, miForm);
			break;
	}
}

function rappel_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var datosTP:Array = this.iface.datosTablaPadre(cursor);
	if (!datosTP)
		return false;
	var wherePadre:String = datosTP.where;
	var tablaPadre:String = datosTP.tabla;

	var valor:String;
	switch (fN) {
		case "dtorappel":
			var cantidad:String = cursor.valueBuffer("cantidad");
			cantidad = parseFloat(cantidad); 
			if (!cantidad || cantidad < 0) {
				valor = 0;
				break;
			}
			var codProveedor:String = util.sqlSelect(tablaPadre, "codproveedor", wherePadre);
			var referencia:String = cursor.valueBuffer("referencia");
			valor = flfactppal.iface.pub_valorQuery( "articulosprov,rappelprovart", "descuento", "articulosprov inner join rappelprovart on articulosprov.id = rappelprovart.id", "articulosprov.referencia = '" + referencia + "' AND articulosprov.codproveedor = '" + codProveedor + "' AND limiteinferior <= " + cantidad + " AND limitesuperior >= " + cantidad );
			if (!valor) 
				valor = 0;
			break;
		case "lbldtorappel":
			valor = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			break;
		case "pvptotal":
			var dtoPor:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtopor"))) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidosprov", "pvpsindto");
			var dtoRappel:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			dtoRappel = util.roundFieldValue(dtoRappel, "lineaspedidosprov", "pvpsindto");
			valor = parseFloat(cursor.valueBuffer("pvpsindto")) - dtoPor - parseFloat(cursor.valueBuffer("dtolineal")) - dtoRappel;
			break;
		default:
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
	}
	return valor;
}

//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

/** @class_definition pedProvCli*/
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_init()
{
	this.iface.__init();
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Edit:
		case cursor.Browse: {
			var codPedidoCli:String = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "p.codigo", "lp.idlinea = " + cursor.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");
			if (codPedidoCli)
				this.child("lblPedidoCli").text = util.translate("scripts", "Pedido de cliente: ") + codPedidoCli;
			break;
		}
	} 
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition klo */
///////////////////////////////////////////////////////////////
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

function klo_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	//var datosTP:Array = this.iface.datosTablaPadre(cursor);
	//if (!datosTP)
	//	return false;
	//var wherePadre:String = datosTP.where;
	//var tablaPadre:String = datosTP.tabla;
	
	var valor:String;
	switch (fN) {
		case "costemediostock": {
			var totalCantXcms:Number = 0;
			var numeroAlmacenes:Number = 0;
			var totalCantidad = util.sqlSelect("stocks", "SUM(cantidad)",  "referencia='" + cursor.valueBuffer("referencia") + "' and cantidad is not null and cantidad > 0;");
			var totalCosteMedio = util.sqlSelect("stocks", "SUM(costemediostock)",  "referencia='" + cursor.valueBuffer("referencia") + "' and costemediostock is not null and costemediostock > 0;");
			if(totalCantidad == 0) {
				var numeroAlmacenes = util.sqlSelect("stocks", "COUNT(codalmacen)",  "referencia='" + cursor.valueBuffer("referencia") + "';");
				valor = totalCosteMedio / numeroAlmacenes;
			} else {
				totalCantXcms = util.sqlSelect("stocks", "SUM(cantidad*costemediostock)",  "referencia='" + cursor.valueBuffer("referencia") + "' and ((cantidad is not null and cantidad > 0) and (costemediostock is not null and costemediostock > 0));");
				valor = totalCantXcms / totalCantidad;
			}
			break;
		}
		default:
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
	}
	return valor;
}
//// KLO /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////