/***************************************************************************
                 recalcosteventas.qs  -  description
                             -------------------
    begin                : mar nov 16 2010
    copyright            : (C) 2010 by KLO Ingeniería Informática S.L.L.
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
    function main() { this.ctx.interna_main(); }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var pbnIniciarRecalculo:Object;
    function oficial( context ) { interna( context ); } 
	function pbnIniciarRecalculo_clicked() {
		return this.ctx.oficial_pbnIniciarRecalculo_clicked();
	}
	function recalcularCostePresupuestos() {
		return this.ctx.oficial_recalcularCostePresupuestos();
	}
	function recalcularCostePedidos() {
		return this.ctx.oficial_recalcularCostePedidos();
	}
	function recalcularCosteAlbaranes() {
		return this.ctx.oficial_recalcularCosteAlbaranes();
	}
	function recalcularCosteFacturas() {
		return this.ctx.oficial_recalcularCosteFacturas();
	}
	function recalcularCosteTpv() {
		return this.ctx.oficial_recalcularCosteTpv();
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	debug("KLO--> init() recalcosteventas.");
	this.iface.pbnIniciarRecalculo = this.child("pbnIniciarRecalculo");
	connect(this.iface.pbnIniciarRecalculo, "clicked()", this, "iface.pbnIniciarRecalculo_clicked");
}

/** \C Se abre un diálogo que permite seleccionar un ejercicio entre los existentes, o bien crear un nuevo ejercicio
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("recalcosteventas");
	/*var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
			return false;
	else
			cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
			acpt = false;
			f.exec("codejercicio");
			acpt = f.accepted();
			if (!acpt) {
					// Quito la acción de pulsar cancel. if (cursor.rollback())
					//commitOk = true;
					// Y pongo lo mismo que si se pulsase OK
					if (cursor.commitBuffer()) {
							cursor.commit();
							commitOk = true;
					}
					//---
			} else {
					if (cursor.commitBuffer()) {
							cursor.commit();
							commitOk = true;
					}
			}
			f.close();
	}*/
	f.setMainWidget();
	f.exec("codejercicio");
	f.close();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial*/
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pbnIniciarRecalculo_clicked()
{
	var util:FLUtil = new FLUtil();

	this.iface.recalcularCostePresupuestos();
	this.iface.recalcularCostePedidos();
	this.iface.recalcularCosteAlbaranes();
	this.iface.recalcularCosteFacturas();
	if (sys.isLoadedModule("flfact_tpv")) {
		this.iface.recalcularCosteTpv();
	}
	MessageBox.information(util.translate("scripts", "Se actualizaron los costes en las lineas de venta."), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_recalcularCostePresupuestos()
{
	debug("KLO--> recalcularCostePresupuestos()");
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery;
	var curLineas:FLSqlCursor;
	var paso:Number = 0;
	var coste:Number = 0;
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var fecha:Date;
	var idLinea:Number;
	
	// Repasamos los presupuestos de venta.
	q = new FLSqlQuery();
	q.setTablesList("lineaspresupuestoscli");
	q.setSelect("p.fecha,p.codalmacen,lp.referencia,lp.coste,lp.idlinea");
	q.setFrom("lineaspresupuestoscli lp INNER JOIN presupuestoscli p ON p.idpresupuesto = lp.idpresupuesto");
	q.setWhere("p.codejercicio = '"+codEjercicio+"'");

	//debug(q.sql());

	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
		MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recalculando coste en lineas de presupuestos..." ), q.size() );
	
	curLineas = new FLSqlCursor("lineaspresupuestoscli");
	curLineas.setActivatedCommitActions(false);

	while(q.next()) {
		fecha = q.value("p.fecha");
		idLinea = q.value("lp.idlinea");
		//debug("KLO--> fecha: "+fecha+" --> codalmacen: "+q.value("p.codalmacen")+" --> referencia: "+q.value("lp.referencia")+" --> coste: "+q.value("lp.coste"));
		coste = flfactalma.iface.pub_costeEnUnaFecha(q.value("lp.referencia"), q.value("p.codalmacen"), fecha)
		//debug("KLO--> coste en factura de proveedor para fecha "+fecha+" es: "+coste);
		//------
		curLineas.select("idlinea = " + idLinea);
		curLineas.next();
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
		//debug("Valor antes: "+curLineas.valueBuffer("coste"));
		curLineas.setValueBuffer("coste", coste);
		curLineas.commitBuffer();
		//debug("Valor despues: "+curLineas.valueBuffer("coste"));
		//if (q.value("lp.referencia") == "352849")
		//	MessageBox.critical("coste para "+q.value("lp.referencia")+" = "+coste, MessageBox.Ok, MessageBox.NoButton);

		//-----
		//util.sqlUpdate("lineaspedidoscli","coste",123,"idlinea = "+idLinea);
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	return;
}

function oficial_recalcularCostePedidos()
{
	debug("KLO--> recalcularCostePedidos()");
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery;
	var paso:Number = 0;
	var coste:Number = 0;
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var fecha:Date;
	var idLinea:Number;
	
	// Repasamos los pedidos de venta.
	q = new FLSqlQuery();
	q.setTablesList("lineaspedidoscli");
	q.setSelect("p.fecha,p.codalmacen,lp.referencia,lp.coste,lp.idlinea");
	q.setFrom("lineaspedidoscli lp INNER JOIN pedidoscli p ON p.idpedido = lp.idpedido");
	q.setWhere("p.codejercicio = '"+codEjercicio+"'");

	debug(q.sql());

	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
		MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recalculando coste en lineas de pedidos..." ), q.size() );
	
	var curLineas:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	curLineas.setActivatedCommitActions(false);

	while(q.next()) {
		fecha = q.value("p.fecha");
		idLinea = q.value("lp.idlinea");
		//debug("KLO pedidos--> fecha: "+fecha+" --> codalmacen: "+q.value("p.codalmacen")+" --> referencia: "+q.value("lp.referencia")+" --> coste: "+q.value("lp.coste"));
		coste = flfactalma.iface.pub_costeEnUnaFecha(q.value("lp.referencia"), q.value("p.codalmacen"), fecha)
		//debug("KLO pedidos--> idLinea: "+idLinea+". Coste en factura de proveedor para fecha "+fecha+" es: "+coste);
		//------
		curLineas.select("idlinea = " + idLinea);
		curLineas.next();
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
		curLineas.next();
		curLineas.setValueBuffer("coste", coste);
		curLineas.commitBuffer();
		//-----
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	return;
}

function oficial_recalcularCosteAlbaranes()
{
	debug("KLO--> recalcularCosteAlbaranes()");
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery;
	var paso:Number = 0;
	var coste:Number = 0;
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var fecha:Date;
	var idLinea:Number;
	
	// Repasamos los albaranes de venta.
	q = new FLSqlQuery();
	q.setTablesList("lineasalbaranescli");
	q.setSelect("p.fecha,p.codalmacen,lp.referencia,lp.coste,lp.idlinea");
	q.setFrom("lineasalbaranescli lp INNER JOIN albaranescli p ON p.idalbaran = lp.idalbaran");
	q.setWhere("p.codejercicio = '"+codEjercicio+"'");

	debug(q.sql());

	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
		MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recalculando coste en lineas de albaranes..." ), q.size() );
	
	var curLineas:FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
	curLineas.setActivatedCommitActions(false);

	while(q.next()) {
		fecha = q.value("p.fecha");
		idLinea = q.value("lp.idlinea");
		//debug("KLO pedidos--> fecha: "+fecha+" --> codalmacen: "+q.value("p.codalmacen")+" --> referencia: "+q.value("lp.referencia")+" --> coste: "+q.value("lp.coste"));
		coste = flfactalma.iface.pub_costeEnUnaFecha(q.value("lp.referencia"), q.value("p.codalmacen"), fecha)
		//debug("KLO pedidos--> idLinea: "+idLinea+". Coste en factura de proveedor para fecha "+fecha+" es: "+coste);
		//------
		curLineas.select("idlinea = " + idLinea);
		curLineas.next();
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
		curLineas.next();
		curLineas.setValueBuffer("coste", coste);
		curLineas.commitBuffer();
		//-----
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	return;
}

function oficial_recalcularCosteFacturas()
{
	debug("KLO--> recalcularCosteFacturas()");
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery;
	var paso:Number = 0;
	var coste:Number = 0;
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var fecha:Date;
	var idLinea:Number;
	
	// Repasamos los albaranes de venta.
	q = new FLSqlQuery();
	q.setTablesList("lineasfacturascli");
	q.setSelect("p.fecha,p.codalmacen,lp.referencia,lp.coste,lp.idlinea");
	q.setFrom("lineasfacturascli lp INNER JOIN facturascli p ON p.idfactura = lp.idfactura");
	q.setWhere("p.codejercicio = '"+codEjercicio+"'");

	debug(q.sql());

	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
		MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recalculando coste en lineas de facturas..." ), q.size() );
	
	var curLineas:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	curLineas.setActivatedCommitActions(false);

	while(q.next()) {
		fecha = q.value("p.fecha");
		idLinea = q.value("lp.idlinea");
		//debug("KLO pedidos--> fecha: "+fecha+" --> codalmacen: "+q.value("p.codalmacen")+" --> referencia: "+q.value("lp.referencia")+" --> coste: "+q.value("lp.coste"));
		coste = flfactalma.iface.pub_costeEnUnaFecha(q.value("lp.referencia"), q.value("p.codalmacen"), fecha)
		//debug("KLO pedidos--> idLinea: "+idLinea+". Coste en factura de proveedor para fecha "+fecha+" es: "+coste);
		//------
		curLineas.select("idlinea = " + idLinea);
		curLineas.next();
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
		curLineas.next();
		curLineas.setValueBuffer("coste", coste);
		curLineas.commitBuffer();
		//-----
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	return;
}

function oficial_recalcularCosteTpv()
{
	debug("KLO--> recalcularCosteTpv()");
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery;
	var paso:Number = 0;
	var coste:Number = 0;
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var fecha:Date;
	var idLinea:Number;
	var fechaIni:Date = util.sqlSelect("ejercicios","fechainicio","codEjercicio = '"+codEjercicio+"'");
	var fechaFin:Date = util.sqlSelect("ejercicios","fechafin","codEjercicio = '"+codEjercicio+"'");
	
	// Repasamos las comandas de TPV
	q = new FLSqlQuery();
	q.setTablesList("tpv_lineascomanda");
	q.setSelect("p.fecha,pv.codalmacen,lp.referencia,lp.coste,lp.idtpv_linea");
	q.setFrom("tpv_lineascomanda lp INNER JOIN tpv_comandas p ON p.idtpv_comanda = lp.idtpv_comanda INNER JOIN tpv_puntosventa pv ON pv.codtpv_puntoventa = p.codtpv_puntoventa");
	q.setWhere("p.fecha >= '"+fechaIni+"' AND p.fecha <= '"+fechaFin+"'");

	debug(q.sql());

	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
		MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recalculando coste en lineas de T.P.V...." ), q.size() );
	
	var curLineas:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLineas.setActivatedCommitActions(false);

	while(q.next()) {
		fecha = q.value("p.fecha");
		idLinea = q.value("lp.idtpv_linea");
		//debug("KLO pedidos--> fecha: "+fecha+" --> codalmacen: "+q.value("pv.codalmacen")+" --> referencia: "+q.value("lp.referencia")+" --> coste: "+q.value("lp.coste"));
		coste = flfactalma.iface.pub_costeEnUnaFecha(q.value("lp.referencia"), q.value("pv.codalmacen"), fecha)
		//debug("KLO pedidos--> idLinea: "+idLinea+". Coste en factura de proveedor para fecha "+fecha+" es: "+coste);
		//------
		curLineas.select("idtpv_linea = " + idLinea);
		curLineas.next();
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
		curLineas.next();
		curLineas.setValueBuffer("coste", coste);
		curLineas.commitBuffer();
		//-----
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	return;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
