/***************************************************************************
                 pagosmultiprov.qs  -  description
                             -------------------
    begin                : lun jul 10 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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

/** @ file */

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
	function validateForm() { return this.ctx.interna_validateForm(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function calculateCounter():Number { return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var bloqueoSubcuenta:Boolean;
	var longSubcuenta:Number;
	var contabActivada:Boolean;
	var divisaEmpresa:String;
	var posActualPuntoSubcuenta:Number;
	var noGenAsiento:Boolean;
	
	function oficial( context ) { interna( context ); } 
	function desconexion() {
		return this.ctx.oficial_desconexion();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function eliminarRecibo() {
		return this.ctx.oficial_eliminarRecibo();
	}
	function refrescarTablaRecibos() {
		return this.ctx.oficial_refrescarTablaRecibos();
	}
	function agregarRecibo():Boolean {
		return this.ctx.oficial_agregarRecibo();
	}
	function asociarPagoMulti(idRecibo:String, curPagoMulti:FLSqlCursor):Boolean {
		return this.ctx.oficial_asociarPagoMulti(idRecibo, curPagoMulti);
	}
	function establecerHabilitaciones() {
		return this.ctx.oficial_establecerHabilitaciones();
	}
	function excluirDePagoMulti(idPagoMulti:String, idRecibo:String):Boolean {
		return this.ctx.oficial_excluirDePagoMulti(idPagoMulti, idRecibo);
	}
	function obtenerTasaCambioFact():String {
		return this.ctx.oficial_obtenerTasaCambioFact();
	}
	function habilitarTasaConv() {
		return this.ctx.oficial_habilitarTasaConv();
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
	function pub_excluirDePagoMulti(idPagoMulti:String, idRecibo:String):Boolean {
		return this.excluirDePagoMulti(idPagoMulti, idRecibo);
	}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPagosMulti */
/////////////////////////////////////////////////////////////////
//// PUB PAGOS MULTI ////////////////////////////////////////////
class pubPagosMulti extends ifaceCtx {
    function pubPagosMulti( context ) { ifaceCtx( context ); }
}
//// PUB PAGOS MULTI ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C El marco 'Contabilidad' se habilitar� en caso de que est� cargado el m�dulo principal de contabilidad.
\end */
function interna_init()
{
	this.iface.refrescarTablaRecibos();
	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.noGenAsiento = false;

	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
			
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	if (this.iface.contabActivada) {
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.posActualPuntoSubcuenta = -1;
	} else {
		this.child("tbwPagosMulti").setTabEnabled("contabilidad", false);
	}

	this.child("fdbTasaConv").setDisabled(true);
	this.child("tdbRecibos").setReadOnly(true);
	this.child("tdbPartidas").setReadOnly(true);

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconexion");
	connect(this.child("tbInsert"), "clicked()", this, "iface.agregarRecibo");
	connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarRecibo");
	
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
			this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
			if (this.iface.contabActivada) {
				this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
			}
			break;
		}
	}
	this.iface.habilitarTasaConv()
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	/** \C
	Si se escoge la tasa de conversi�n de las facturas se vuelve a comprobar que todas tienen la misma tasa
	\end */
	if (cursor.valueBuffer("origentasaconv") == "Facturas") {
		if (!this.iface.obtenerTasaCambioFact()) {
			cursor.setValueBuffer("origentasaconv", "Tasa actual");
			return false;
		}
	}
	/** \C
	Si es una devoluci�n, est� activada la contabilidad y su pago correspondiente no genera asiento no puede generar asiento
	\end */
	if (this.iface.contabActivada && this.iface.noGenAsiento && this.cursor().valueBuffer("tipo") == "Devoluci�n" && !this.child("fdbNoGenerarAsiento").value()) {
		MessageBox.warning(util.translate("scripts", "No se puede generar el asiento de una devoluci�n cuyo pago no tiene asiento asociado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}	
	
	/** \C
	Si la contabilidad est� integrada, se debe seleccionar una subcuenta v�lida a la que asignar el asiento de pago o devoluci�n
	\end */
	if (this.iface.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0)) {
		MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta v�lida a la que asignar el asiento de pago o devoluci�n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:String;
	switch (fN) {
		/** \D
		La subcuenta contable por defecto ser� la asociada a la cuenta bancaria. Si �sta est� vac�a, ser� la subcuenta correspondienta a Caja
		\end */
		case "idsubcuentadefecto":
			if (this.iface.contabActivada) {
				var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
				if (codSubcuenta)
					res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
				else {
					var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
					qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
					qrySubcuenta.setSelect("s.idsubcuenta");
					qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
					qrySubcuenta.setWhere("c.codejercicio = '" + this.iface.ejercicioActual + "'" + " AND c.idcuentaesp = 'CAJA'");
					
					if (!qrySubcuenta.exec())
						return false;
					if (!qrySubcuenta.first())
						return false;
					res = qrySubcuenta.value(0);
				}
			}
			break;
		case "idsubcuenta":
			var codSubcuenta:String = cursor.valueBuffer("codsubcuenta").toString();
			if (codSubcuenta.length == this.iface.longSubcuenta)
				res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;
		/** \C
		La cuenta bancaria por defecto ser� la asociada al proveedor (Cuenta de pago).
		\end */
		case "codcuenta":
			res = false;
			var codProveedor:String = cursor.valueBuffer("codproveedor");
			if (codProveedor)
				res = util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'");
			break;
		case "dc":
			var entidad:String = cursor.valueBuffer("ctaentidad");
			var agencia:String = cursor.valueBuffer("ctaagencia");
			var cuenta:String = cursor.valueBuffer("cuenta");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() 
					&& entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var util:FLUtil = new FLUtil();
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				res = dc1 + dc2;
			}
			break;
		case "importe": {
			res = util.sqlSelect("recibosprov r INNER JOIN pagosdevolprov p ON r.idrecibo = p.idrecibo", "SUM(r.importe)", "p.idpagomulti = " + cursor.valueBuffer("idpagomulti"), "recibosprov,pagosdevolprov");
			res = util.roundFieldValue(res, "recibosprov", "importe");
			break;
		}
		case "importeeuros": {
			var importe:Number = parseFloat(cursor.valueBuffer("importe"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			res = importe * tasaConv;
			res = parseFloat(util.roundFieldValue(res, "pagosmultiprov", "importeeuros"));
			break;
		}
	}
	return res;
}

/** \D Calcula un nuevo c�digo de pago m�ltiple
\end */
function interna_calculateCounter():Number
{
	var util:FLUtil = new FLUtil();
	var cadena:String = util.sqlSelect("pagosmultiprov", "idpagomulti", "1 = 1 ORDER BY idpagomulti DESC");
	var valor:Number;
	if (!cadena)
		valor = 1;
	else
		valor = parseFloat(cadena) + 1;

	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconexion()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el c�digo de cuenta m�s tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end */
		case "codsubcuenta": {
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
				this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
			}
			break;
		}
			/** \C
			Si el usuario selecciona una cuenta bancaria, se tomar� su cuenta contable asociada como cuenta contable para el pago. La subcuenta contable por defecto ser� la asociada a la cuenta bancaria. Si �sta est� vac�a, ser� la subcuenta correspondienta a Caja
			\end */
		case "codcuenta":
		case "ctaentidad":
		case "ctaagencia":
		case "cuenta": {
			this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
			break;
		}
		case "importe":
		case "tasaconv": {
			this.child("fdbImporteEuros").setValue(this.iface.calculateField("importeeuros"));
			break;
		}
		case "codproveedor": {
			this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
			break;
		}
		case "origentasaconv": {
			var origenTasaConv:String = cursor.valueBuffer("origentasaconv");
			var tasaConv:String;
			if (origenTasaConv == "Facturas") {
				tasaConv = this.iface.obtenerTasaCambioFact();
				if (!tasaConv) {
					cursor.setValueBuffer("origentasaconv", "Tasa actual");
					return;
				}
			} else {
				tasaConv = util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
			}
			this.child("fdbTasaConv").setValue(tasaConv);
			this.iface.habilitarTasaConv();
			break;
		}
	}
}

function oficial_habilitarTasaConv()
{
	var cursor:FLSqlCursor = this.cursor();
	var origenTasaConv:String = cursor.valueBuffer("origentasaconv");
	if (origenTasaConv == "Facturas") {
		this.child("fdbTasaConv").setDisabled(true);
	} else {
		this.child("fdbTasaConv").setDisabled(false);
	}
}

function oficial_obtenerTasaCambioFact():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var tasaConv:String = util.sqlSelect("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo INNER JOIN facturasprov f ON f.idfactura = r.idfactura", "f.tasaconv", "p.idpagomulti = " + cursor.valueBuffer("idpagomulti"), "pagosdevolprov,recibosprov,facturasprov");
	
	if (tasaConv) {
		if (util.sqlSelect("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo INNER JOIN facturasprov f ON f.idfactura = r.idfactura", "f.tasaconv", "p.idpagomulti = " + cursor.valueBuffer("idpagomulti") + " AND f.tasaconv <> " + tasaConv, "pagosdevolprov,recibosprov,facturasprov")) {
			MessageBox.warning(util.translate("scripts", "La tasa de cambio no es la misma para todas las factuas"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		MessageBox.warning(util.translate("scripts", "No se ha encontrado la tasa de conversi�n para los recibos incluidos en el pago"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return tasaConv;
}

/** \D Se elimina el recibo activo del pago m�ltiple
\end */
function oficial_eliminarRecibo()
{
	var util:FLUtil = new FLUtil;
	if (!this.child("tdbRecibos").cursor().isValid())
		return;
	
	var idRecibo:String = this.child("tdbRecibos").cursor().valueBuffer("idrecibo");
	
	var cur:FLSqlCursor = new FLSqlCursor("empresa");
	cur.transaction(false);
	try {
		if (this.iface.excluirDePagoMulti(this.cursor().valueBuffer("idpagomulti"), idRecibo)) {
			cur.commit();
		} else {
			cur.rollback();
			var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
			MessageBox.warning(util.translate("scripts", "Hubo un error en la exclusi�n del recibo %1.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
		}
	} catch (e) {
		cur.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la exclusi�n del recibo:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}

	this.iface.refrescarTablaRecibos();
}

/** \D Elimina el pago de un recibo asociado a un pago m�ltiple. Para ello, el pago debe ser el �ltimo asociado al recibo
@param	idPagoMulti: Identificador del pago m�ltiple
@param	idRecibo: Identificador del Recibo que tiene asociado el pago a eliminar
\end */
function oficial_excluirDePagoMulti(idPagoMulti:String, idRecibo:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	var curPagosDev:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curRecibos.select("idrecibo = " + idRecibo);
	if (!curRecibos.first())
		return false;
	curRecibos.setModeAccess(curRecibos.Edit);
	curRecibos.refreshBuffer();
	
	curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY idpagodevol");
	if (!curPagosDev.last())
		return false;
	
	if (curPagosDev.valueBuffer("idpagomulti") != idPagoMulti) {
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
		MessageBox.warning(util.translate("scripts", "No puede eliminarse el pago del recibo %1 correspondiente al pago m�ltiple n�mero %2\nEl pago a eliminar no es el �ltimo pago del recibo").arg(codRecibo).arg(idPagoMulti), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var idPagoDevol:String = curPagosDev.valueBuffer("idpagodevol");
	curPagosDev.setUnLock("editable", true);

	curPagosDev.select("idpagodevol = " + idPagoDevol);
	if (!curPagosDev.first())
		return false;
	
	curPagosDev.setModeAccess(curPagosDev.Del);
	curPagosDev.refreshBuffer();
	if (!curPagosDev.commitBuffer())
		return false;
	
	curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY idpagodevol");
	if (curPagosDev.size() == 0)
		curRecibos.setValueBuffer("estado", "Emitido");
	else
		curRecibos.setValueBuffer("estado", "Devuelto");
	if (!curRecibos.commitBuffer())
		return false;

	return true;
}

/** \D Refresca la tabla de recibos en funci�n de los pagos asociados al pago m�ltiple
\end */
function oficial_refrescarTablaRecibos()
{
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	qryRecibos.setTablesList("pagosdevolprov");
	qryRecibos.setSelect("idrecibo");
	qryRecibos.setFrom("pagosdevolprov");
	qryRecibos.setWhere("idpagomulti = " + this.cursor().valueBuffer("idpagomulti"));
	try { qryRecibos.setForwardOnly( true ); } catch (e) {}
	
	if (!qryRecibos.exec())
		return false;
	
	var filtro:String = "";
	while (qryRecibos.next()) {
		if (filtro != "")
			filtro += ", ";
		filtro += qryRecibos.value(0);
	}
	if (filtro != "")
		filtro = "idrecibo IN (" + filtro + ")";
	else 
		filtro =  "1 = 2";
	this.child("tdbRecibos").cursor().setMainFilter(filtro);
	this.child("tdbRecibos").refresh();
	this.iface.establecerHabilitaciones();
	this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
}

/** \C Si hay uno o m�s recibos asignados al pago m�ltiple, ciertos campos deben deshabilitarse, como el c�digo de proveedor, la divisa, o el c�digo de cuenta.
\end */
function oficial_establecerHabilitaciones()
{
	if (this.child("tdbRecibos").cursor().size() > 0) {
		this.child("fdbCodProveedor").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
		this.child("fdbCodCuenta").setDisabled(true);
		this.child("fdbFecha").setDisabled(true);
		this.child("fdbIdPagoMulti").setDisabled(true);
	} else {
		this.child("fdbCodProveedor").setDisabled(false);
		this.child("fdbCodDivisa").setDisabled(false);
		this.child("fdbCodCuenta").setDisabled(false);
		this.child("fdbFecha").setDisabled(false);
		this.child("fdbIdPagoMulti").setDisabled(false);
	}
}

/** \D Se agrega un recibo al pago m�ltiple. 
\end */
function oficial_agregarRecibo():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.valueBuffer("coddivisa") == "") {
		MessageBox.warning(util.translate("scripts", "Debe especificar la divisa antes de agregar recibos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var filtro:String = "estado IN ('Emitido', 'Devuelto')";
	if (cursor.valueBuffer("codproveedor") != "")
		filtro += " AND codproveedor = '" + cursor.valueBuffer("codproveedor") + "'";
	else 
		filtro += " AND (codproveedor = '' OR codproveedor IS NULL)"; 
	
	var f:Object = new FLFormSearchDB("seleccionrecibosprov");
	var curRecibos:FLSqlCursor = f.cursor();
		
	curRecibos.select();
	if (!curRecibos.first())
		curRecibos.setModeAccess(curRecibos.Insert);
	else
		curRecibos.setModeAccess(curRecibos.Edit);
		
	f.setMainWidget();
	curRecibos.refreshBuffer();
	curRecibos.setValueBuffer("datos", "");
	curRecibos.setValueBuffer("filtro", filtro);
	var datos:String = f.exec("datos");
	if (!datos || datos == "") {
		return false;
	}
	var recibos:Array = datos.toString().split(",");
	var cur:FLSqlCursor = new FLSqlCursor("empresa");
	for (var i:Number = 0; i < recibos.length; i++) {
		cur.transaction(false);
		try {
			if (this.iface.asociarPagoMulti(recibos[i], cursor)) {
				cur.commit();
			} else {
				cur.rollback();
				var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + qryRecibos.value("r.idrecibo"));
				MessageBox.warning(util.translate("scripts", "Hubo un error en la asociaci�n del recibo %1 al pago m�ltiple").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
			}
		}
		catch (e) {
			cur.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la asociaci�n del recibo al pago m�ltiple:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	this.iface.refrescarTablaRecibos();
	this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
}

function oficial_asociarPagoMulti(idRecibo:String, curPagoMulti:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPagoMulti:String = curPagoMulti.valueBuffer("idpagomulti");
	var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);

	if (util.sqlSelect("recibosprov", "coddivisa", "idrecibo = " + idRecibo) != curPagoMulti.valueBuffer("coddivisa")) {
		MessageBox.warning(util.translate("scripts", "No es posible incluir el recibo %1.\nLa divisas del recibo y del pago deben coincidir.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}
	
	if (util.sqlSelect("pagosdevolprov", "idpagodevol", "idrecibo = " + idRecibo + " AND fecha > '" + curPagoMulti.valueBuffer("fecha") + "'")) {
		MessageBox.warning(util.translate("scripts", "El recibo %1 tiene un pago o devoluci�n con fecha superior a la del pago m�ltiple.\nEste recibo no ser� asociado").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}
	
	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	var idFactura:Number;
	
	curRecibos.select("idrecibo = " + idRecibo);
	if (curRecibos.next()) {
		curRecibos.setModeAccess(curRecibos.Edit);
		curRecibos.refreshBuffer();
		curRecibos.setValueBuffer("estado", "Pagado");
		if (!curRecibos.commitBuffer())
			return false;
	}
	
	var fecha:String = curPagoMulti.valueBuffer("fecha");
	var curPagosDev:FLSqlCursor = new FLSqlCursor("pagosdevolprov");

	curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY idpagodevol");
	if (curPagosDev.last()) {
		curPagosDev.setUnLock("editable", false);
	}
	curPagosDev.setModeAccess(curPagosDev.Insert);
	curPagosDev.setActivatedCheckIntegrity(false);
	
	curPagosDev.refreshBuffer();
	curPagosDev.setValueBuffer("idrecibo", idRecibo);
	curPagosDev.setValueBuffer("idpagomulti", idPagoMulti);
	curPagosDev.setValueBuffer("fecha", fecha);
	curPagosDev.setValueBuffer("codcuenta", curPagoMulti.valueBuffer("codcuenta"));
	curPagosDev.setValueBuffer("tipo", "Pago");
	curPagosDev.setValueBuffer("nogenerarasiento", true);
	curPagosDev.setNull("idsubcuenta");
	curPagosDev.setNull("codsubcuenta");
	
	if (!curPagosDev.commitBuffer())
		return false;;
	
	var idPagoDevol:String = curPagosDev.valueBuffer("idpagodevol");
	curPagosDev.select("idpagodevol = " + idPagoDevol);
	if (!curPagosDev.first())
		return false;
	curPagosDev.setUnLock("editable", false);

	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
