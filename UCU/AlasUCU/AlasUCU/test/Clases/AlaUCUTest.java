/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import UCUGrafos.*;
import java.util.LinkedList;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class AlaUCUTest {
    
    private AlaUCU alaUnica;
    private String archivoAeropuertos = "src/Archivos/Aeropuertos-SoloTests.csv";
    private String archivoVuelos = "src/Archivos/Vuelos-SoloTests.csv";
    private String archivoAerolineas = "src/Archivos/Aerolineas.csv";
    
    public AlaUCUTest() {
        this.alaUnica = AlaUCU.getInstancia();
        
        this.alaUnica.cargarGrafo(archivoAeropuertos, archivoAerolineas, archivoVuelos);
    }

    /**
     * Test of buscarAerolinea method, of class AlaUCU.
     */
    @Test
    public void testBuscarAerolinea() {
        Aerolinea aeroObjetoBuscado = this.alaUnica.buscarAerolinea("AA");
        assertEquals("AA", aeroObjetoBuscado.getID());
        
        aeroObjetoBuscado = this.alaUnica.buscarAerolinea("SS");
        assertEquals(null, aeroObjetoBuscado);
    }

    /**
     * Test of nuevaAerolinea method, of class AlaUCU.
     */
    @Test
    public void testNuevaAerolinea() {
        int kantAerolineas = this.alaUnica.getAerolineas().size();
        assertEquals(9, kantAerolineas);
        this.alaUnica.nuevaAerolinea(new Aerolinea("SS", "2WW Airlines"));
        
        kantAerolineas = this.alaUnica.getAerolineas().size();
        assertEquals(10, kantAerolineas);
    }

    /**
     * Test of nuevoAeropuerto method, of class AlaUCU.
     */
    @Test
    public void testNuevoAeropuerto() {
        int kantAeropuertos = this.alaUnica.getGrafo().getVertices().size();
        assertEquals(8, kantAeropuertos);
        
        this.alaUnica.nuevoAeropuerto(new Aeropuerto("SSS", "2WW Airport"));
        kantAeropuertos = this.alaUnica.getGrafo().getVertices().size();
        
        assertEquals(9, kantAeropuertos);
    }

    /**
     * Test of buscarVuelos method, of class AlaUCU.
     */
    @Test
    public void testBuscarVuelos() {
        LinkedList<IVuelo> vuelos;
        vuelos = this.alaUnica.buscarVuelos("04G", "06A");
        
        assertEquals(10, vuelos.size());
    }

    /**
     * Test of buscarAeropuerto method, of class AlaUCU.
     */
    @Test
    public void testBuscarAeropuerto() {
        Comparable aeroID = this.alaUnica.buscarAeropuerto("17G").getID();
        assertEquals("17G", aeroID);
        
        Aeropuerto aeroObjeto = this.alaUnica.buscarAeropuerto("SSS");
        assertEquals(null, aeroObjeto);
    }

    /**
     * Test of eliminarAeropuerto method, of class AlaUCU.
     */
    @Test
    public void testEliminarAeropuerto() {
        Comparable aeroID = this.alaUnica.buscarAeropuerto("17G").getID();
        assertEquals("17G", aeroID);
        
        this.alaUnica.eliminarAeropuerto("17G");
        Aeropuerto aeroObjeto = this.alaUnica.buscarAeropuerto("17G");
        assertEquals(null, aeroObjeto);
        
        assertEquals(false, this.alaUnica.eliminarAeropuerto("17G"));
    }

    /**
     * Test of cargarGrafo method, of class AlaUCU.
     */
    @Test
    public void testCargarGrafo() {
        AlaUCU unAlaUCUDePaloma = AlaUCU.getInstancia();
        
        String nuevoArchivoAeropuerto = "src/Archivos/Aeropuertos-SoloTests.csv";
        String nuevoArchivoVuelos = "src/Archivos/vuelos-SoloTests.csv";
        String nuevoArchivoAerolineas = "src/Archivos/Aerolineas.csv";
        
        boolean cargado = unAlaUCUDePaloma.cargarGrafo(nuevoArchivoAeropuerto, nuevoArchivoAerolineas, nuevoArchivoVuelos);
        
        assertEquals(true, cargado);
        assertEquals(8, unAlaUCUDePaloma.getGrafo().getVertices().size());
        
        assertEquals(9, unAlaUCUDePaloma.getAerolineas().size());
    }

    /**
     * Test of todosLosCaminos method, of class AlaUCU.
     */
    @Test
    public void testTodosLosCaminos() {
        TCaminos todosLosCaminos;
        todosLosCaminos = this.alaUnica.todosLosCaminos("04G", "09J", 4, "AA");
        assertEquals(2, todosLosCaminos.getCaminos().size());

        todosLosCaminos = this.alaUnica.todosLosCaminos("04G", "09J", 4, "AA");
        assertEquals(2, todosLosCaminos.getCaminos().size());

        todosLosCaminos = this.alaUnica.todosLosCaminos("0W3", "09J", 4, "AA");
        assertEquals(0, todosLosCaminos.getCaminos().size());

        todosLosCaminos = this.alaUnica.todosLosCaminos("0W3", "09J", 4, "SS");
        assertEquals(0, todosLosCaminos.getCaminos().size());
    }
}
