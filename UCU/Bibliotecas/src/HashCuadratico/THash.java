/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package HashCuadratico;

/**
 *
 * @author Ignacio
 */
public class THash {

    private final int[] lista;
    public int size;
    public int tamanoTabla;

    public THash(int tamaño, Double factor) {
        Double t = tamaño / factor;
        this.size = 0;
        this.tamanoTabla = proximoPrimo(t.intValue());
        this.lista = new int[this.tamanoTabla];
    }

    public int getSizeLista() {
        return this.lista.length;
    }

    private int proximoPrimo(int aPartirDe) {
        aPartirDe++;
        int numeroPrimoQuest = 0;
        for (int i = 2; i < aPartirDe; i++) {
            if (aPartirDe % i == 0) {
                aPartirDe++;
                i = 2;
            }
        }

        return aPartirDe;
    }

    public int buscar(int unaClave) {
        int contador = 1;
        int i = 0;
        int a = 0;
        int pos = funcionHashing(unaClave);
        while (lista[pos] != 0 && a < lista.length) {
            if (lista[pos] == unaClave) {
                return contador;
            }
            
            i++;
            a = i * i;
            pos = (pos + a) % lista.length;
            
            contador++;
        }
        
        return (-contador);
    }

    public int insertar(int unaClave) {
        int contador = 1;
        int i = 0;
        int a = 0;
        int pos = funcionHashing(unaClave);
        while (lista[pos] != 0 && a < lista.length) {
            i++;
            a = i * i;
            pos = (pos + a) % lista.length;
            
            if (lista[pos] == unaClave) {
                return contador;
            }
            
            contador++;
        }

        if (a > lista.length) {
            return (-contador);
        } else {
            this.lista[pos] = unaClave;
            size++;
            return contador;
        }
    }

    public int funcionHashing(int unaClave) {
        int total = 0;
        for (int i = 2; i < unaClave; i++) {
            total = (total + unaClave % i) % i;
        }

        return total % lista.length;
    }
}
