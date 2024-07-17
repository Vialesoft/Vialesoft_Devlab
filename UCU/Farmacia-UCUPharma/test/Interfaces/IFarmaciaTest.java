/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import Clases.Lista;
import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class IFarmaciaTest {
    
    public IFarmaciaTest() {
    }

    @Test
    public void testGetDireccion() {
    }

    @Test
    public void testSetDireccion() {
    }

    @Test
    public void testGetTelefono() {
    }

    @Test
    public void testSetTelefono() {
    }

    @Test
    public void testGetNombre() {
    }

    @Test
    public void testGetArticulos() {
    }

    @Test
    public void testGetVentas() {
    }

    @Test
    public void testCargarArticulos() {
    }

    @Test
    public void testBuscarXID() {
    }

    @Test
    public void testBuscarXDescripcion() {
    }

    @Test
    public void testBuscarXNombre() {
    }

    @Test
    public void testInsertarArticulo() {
    }

    @Test
    public void testEliminarArticulo() {
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
    public void testCargarStock() {
    }

    public class IFarmaciaImpl implements IFarmacia {

        public String getDireccion() {
            return "";
        }

        public void setDireccion(String value) {
        }

        public String getTelefono() {
            return "";
        }

        public void setTelefono(String value) {
        }

        public String getNombre() {
            return "";
        }

        public Lista<IArticulo> getArticulos() {
            return null;
        }

        public Lista<IVenta> getVentas() {
            return null;
        }

        public Boolean cargarArticulos(String rutaArchivo) {
            return null;
        }

        public IArticulo BuscarXID(Integer id) {
            return null;
        }

        public String buscarXDescripcion(String pDescripcion) {
            return "";
        }

        public String buscarXNombre(String pNombre) {
            return "";
        }

        public Boolean InsertarArticulo(IArticulo pArticulo) {
            return null;
        }

        public Boolean EliminarArticulo(Integer pId) {
            return null;
        }

        public Boolean GuardarVenta(IVenta pVenta) {
            return null;
        }

        public Boolean ReintegroVenta(Integer pIdVenta) {
            return null;
        }

        public String retornarArticulos() {
            return "";
        }

        public String retornarArticulos(String pSeparador) {
            return "";
        }

        public String retornarVentas() {
            return "";
        }

        public String retornarVentas(String pSeparador) {
            return "";
        }

        public String ListadoVenta(Date pFechaComienzo, Date pFechaFin) {
            return "";
        }

        public Boolean cargarStock(String rutaArchivo) {
            return null;
        }
    }
    
}
