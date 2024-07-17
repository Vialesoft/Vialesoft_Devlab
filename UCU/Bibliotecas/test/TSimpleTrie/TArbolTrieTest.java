/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TSimpleTrie;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Alf
 */
public class TArbolTrieTest {
    
    private TArbolTrie testTrie;
    
    public TArbolTrieTest() {
        this.testTrie = new TArbolTrie();
    }

    @Test
    public void testInsertar() {
        //Trie vacio
        assertEquals(0,this.testTrie.buscar("hola"));
        //Trie con un elemento
        this.testTrie.insertar("hola");
        assertEquals(4, this.testTrie.buscar("hola"));
    }

    @Test
    public void testBuscar() {
        //Trie vacio
        assertEquals(0,this.testTrie.buscar("hola"));
        //Busqueda exitosa
        this.testTrie.insertar("hola");
        assertEquals(4, this.testTrie.buscar("hola"));
        //Busquedas no exitosas en trie no vacio
        assertEquals(2, this.testTrie.buscar("hello"));
        assertEquals(2, this.testTrie.buscar("hoyo"));
        assertEquals(0, this.testTrie.buscar("casa"));
    }

    @Test
    public void testPredecir() {
        //Trie vacio
        assertEquals(0,this.testTrie.predecir("a").size());
        //Insertamos elementos
        this.testTrie.insertar("hola");
        this.testTrie.insertar("holanda");
        this.testTrie.insertar("hoyo");
        this.testTrie.insertar("homosapien");
        //Predicciones exitosas
        assertEquals(4,this.testTrie.predecir("h").size());
        assertEquals(2,this.testTrie.predecir("hol").size());
        assertEquals(1,this.testTrie.predecir("hoy").size());
        //Insertamos un nuevo elemento y comprobamos el prefijo 'hoy'
        this.testTrie.insertar("hoy");
        assertEquals(2,this.testTrie.predecir("hoy").size());
        //Predicciones no exitosas
        assertEquals(0,this.testTrie.predecir("w").size());
        assertEquals(0,this.testTrie.predecir("o").size());
    }
}
