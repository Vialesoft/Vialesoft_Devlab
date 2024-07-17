/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.util.Calendar;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class FarmaciaTest {
    Farmacia objFarmacia;
    
    public FarmaciaTest() {
        objFarmacia = new Farmacia("Farmacia Test","Av Sr. Tester Yei Unit","12345");
        objFarmacia.cargarArticulos("farmacia_articles_tests.csv");
        objFarmacia.cargarStock("farmacia_stock_tests.csv");
    }

    @Test
    public void testCargarArticulos() {
        //assertTrue("Carga Artículos",objFarmacia.cargarArticulos("farmacia_articles_tests.csv"));
    }

    @Test
    public void testCargarStock() {
        assertTrue("Carga Stock",objFarmacia.cargarStock("farmacia_stock_tests.csv"));
    }

    @Test
    public void testBuscarXID() {
        assertEquals("BuscarXID","100002",objFarmacia.BuscarArticuloXID(100002, new String[1]).getID().toString());
    }

    @Test
    public void testBuscarXDescripcion() {
        assertEquals("BuscarXDescripcion","",objFarmacia.buscarXDescripcion(""));
    }

    @Test
    public void testBuscarXNombre() {
        assertEquals("BuscarXNombre","",objFarmacia.buscarXNombre(""));
    }

    @Test
    public void testInsertarArticulo() {
        assertTrue("InsertarArticulo",objFarmacia.InsertarArticulo(new Articulo(),"Area51"));
    }

    @Test
    public void testEliminarArticulo() {
        //objFarmacia.EliminarArticulo();
    }

    @Test
    public void testGuardarVenta() {
    }

    @Test
    public void testReintegroVenta() {
    }

    @Test
    public void testRetornarArticulos_0args() {
    }

    @Test
    public void testRetornarArticulos_String() {
    }

    @Test
    public void testRetornarVentas_0args() {
    }

    @Test
    public void testRetornarVentas_String() {
    }

    @Test
    public void testListadoVenta() {
    }

    @Test
    public void testFormatoFecha() throws Exception {
    }

    @Test
    public void testBuscarArticuloXID() {
    }

    @Test
    public void testGetCompras() {
    }
    
}
