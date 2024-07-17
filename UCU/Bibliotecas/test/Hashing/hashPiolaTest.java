/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Hashing;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author R2-D2
 */
public class hashPiolaTest {
    
    private hashPiola testHash;
    
    public hashPiolaTest() {
        this.testHash = new hashPiola(20, 0.5);
    }

    /**
     * Test of buscarHash method, of class hashPiola.
     */
    @Test
    public void testBuscarHash() {
        //Hash vacio
        assertEquals(-1,this.testHash.buscarHash(100));
        //Insertamos elementos
        this.testHash.insertarHash(101);
        this.testHash.insertarHash(653);
        this.testHash.insertarHash(261);
        //Busqueda exitosa
        assertEquals(1,this.testHash.buscarHash(101));
        //Busqueda no exitosa
        assertEquals(-1,this.testHash.buscarHash(202));
    }

    /**
     * Test of insertarHash method, of class hashPiola.
     */
    @Test
    public void testInsertarHash() {
        //Hash vacio
        assertEquals(0,this.testHash.size);
        //Insertamos elementos
        this.testHash.insertarHash(101);
        assertEquals(1,this.testHash.size);
        this.testHash.insertarHash(653);
        assertEquals(2,this.testHash.size);
        this.testHash.insertarHash(261);
        assertEquals(3,this.testHash.size);
        //Insercion de duplicado
        this.testHash.insertarHash(261);
        assertEquals(3,this.testHash.size);
    }

    /**
     * Test of funcionHash method, of class hashPiola.
     */
    @Test
    public void testFuncionHash() {
        //Clave 0
        assertEquals(0, this.testHash.funcionHash(0));
        //Otras claves
        assertEquals(8, this.testHash.funcionHash(2582));
        assertEquals(11, this.testHash.funcionHash(021));
        assertEquals(1, this.testHash.funcionHash(5010));
        //Comprobamos que el resultado es siempre el mismo, para la misma clave:
        assertEquals(8, this.testHash.funcionHash(2582));
        assertEquals(11, this.testHash.funcionHash(021));
        assertEquals(1, this.testHash.funcionHash(5010));
    }
    
}
