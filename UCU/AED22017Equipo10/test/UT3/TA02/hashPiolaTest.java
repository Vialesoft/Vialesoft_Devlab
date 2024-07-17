/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT3.TA02;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.BeforeClass;

/**
 *
 * @author Bettina
 */
public class hashPiolaTest {
    
    public hashPiolaTest() {
    }

    int clave_buscar = 3913899;

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @Before
    public void setUp() throws Exception {
    }

    @After
    public void tearDown() throws Exception {
    }
    @Test
    public void buscarHash() {
    }

    /**
     * Test of buscarHash method, of class hashPiola.
     */
    @Test
    public void testBuscarHash() {
        System.out.println("buscarHash");
        int clave = 0;
        hashPiola instance = new hashPiola();
        String expResult = "";
        String result = instance.buscarHash(clave);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of insertarHash method, of class hashPiola.
     */
    @Test
    public void testInsertarHash() {
        System.out.println("insertarHash");
        int clave = 0;
        hashPiola instance = new hashPiola();
        int expResult = 0;
        int result = instance.insertarHash(clave);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of funcionHash method, of class hashPiola.
     */
    @Test
    public void testFuncionHash() {
        System.out.println("funcionHash");
        String clave = "Hola";
        hashPiola instance = new hashPiola();
        int expResult = 1;
        int result = instance.funcionHash(clave);
        assertEquals(expResult, result);
    }
    
}
