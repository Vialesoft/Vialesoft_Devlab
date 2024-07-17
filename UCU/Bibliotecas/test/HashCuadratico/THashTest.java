/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package HashCuadratico;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Alf
 */
public class THashTest {

    private THash testHash;

    public THashTest() {
        this.testHash = new THash(20, 0.5);
    }

    @Test
    public void testBuscar() {
        //Hash vacio
        assertEquals(-1, this.testHash.buscar(500));
        //Busqueda exitosa
        this.testHash.insertar(100);
        assertEquals(1, this.testHash.buscar(100));
        //Busqueda no exitosa
        assertEquals(-1, this.testHash.buscar(500));
    }

    @Test
    public void testInsertar() {
        //Hash vacio
        assertEquals(0, this.testHash.size);
        //Hash con un elemento
        this.testHash.insertar(100);
        assertEquals(1, this.testHash.size);
        //Colisiones
        this.testHash.insertar(100);
        assertEquals(2, this.testHash.size);
    }

    @Test
    public void testFuncionHashing() {
        //Clave 0
        assertEquals(0, this.testHash.funcionHashing(0));
        //Otras claves
        assertEquals(22, this.testHash.funcionHashing(32642));
        assertEquals(38, this.testHash.funcionHashing(2582));
        assertEquals(11, this.testHash.funcionHashing(021));
        assertEquals(35, this.testHash.funcionHashing(5010));
        //Comprobamos que el resultado es siempre el mismo, para la misma clave:
        assertEquals(22, this.testHash.funcionHashing(32642));
        assertEquals(38, this.testHash.funcionHashing(2582));
        assertEquals(11, this.testHash.funcionHashing(021));
        assertEquals(35, this.testHash.funcionHashing(5010));
    }

}
