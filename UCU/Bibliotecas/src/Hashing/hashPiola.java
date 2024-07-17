
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Hashing;

/**
 *
 * @author Bettina
 */
public class hashPiola {

    private final int[] lista;
    public int size;
    public int tamanoTabla;

    public hashPiola(int tamano, Double factor) {
        Double t = tamano / factor;
        this.size = 0;
        this.tamanoTabla = t.intValue();
        this.lista = new int[this.tamanoTabla];
    }

    public int buscarHash(int clave) {
        int i = 0;
        int contador = 1;
        int j = this.funcionHash((clave));

        while (this.lista[(j + i) % tamanoTabla] != 0 && i < this.tamanoTabla) {
            if (lista[(j + i) % tamanoTabla] == clave) {
                return contador;
            }
            i++;

            contador++;
        }

        return -(contador);
    }

    public int insertarHash(int clave) {
        int i = 0;
        int contador = 1;
        int j = this.funcionHash((clave));

        for (i = 0; i < tamanoTabla; i++) {
            if (lista[(j + i) % tamanoTabla] == 0) {
                size++;
                lista[(j + i) % tamanoTabla] = clave;
                return contador;
            } else{
                if(lista[(j + i) % tamanoTabla] == clave){
                    return contador;
                }
            }

            contador++;
        }

        if (i == this.tamanoTabla) {
            return -(contador);
        } else {
            return contador;
        }

    }

    public int funcionHash(int clave) {
        int total = 0;
        for (int i = 2; i < clave; i++) {
            total = (total + clave % i) % i;
        }

        return total % lista.length;
    }
}
