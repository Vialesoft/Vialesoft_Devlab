package TSimpleTrie;

import java.util.LinkedList;

public class TNodoTrie implements INodoTrie {

    private static final int CANT_CHR_ABECEDARIO = 26;
    private TNodoTrie[] hijos;
    private boolean esPalabra;

    public TNodoTrie() {
        hijos = new TNodoTrie[CANT_CHR_ABECEDARIO];
        esPalabra = false;
    }

    @Override
    public void insertar(String unaPalabra) {
        TNodoTrie nodo = this;
        String palabraFiltrada = this.filtrarPalabra(unaPalabra);
        for (int c = 0; c < palabraFiltrada.length(); c++) {
            int indice = palabraFiltrada.charAt(c) - 'a';

            if (indice < CANT_CHR_ABECEDARIO && indice >= 0) {
                if (nodo.hijos[indice] == null) {
                    nodo.hijos[indice] = new TNodoTrie();
                }
                nodo = nodo.hijos[indice];
            }
        }

        nodo.esPalabra = true;
    }

    private void imprimir(String s, TNodoTrie nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                System.out.println(s);
            }
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    imprimir(s + (char) (c + 'a'), nodo.hijos[c]);
                }
            }
        }
    }

    public String imprimirDos(String s, TNodoTrie nodo) {
        String s2 = "";
        if (nodo != null) {
            if (nodo.esPalabra) {
                s2 = s2 + s;
            }
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    imprimir(s + (char) (c + 'a'), nodo.hijos[c]);
                }
            }
        }
        return s2;
    }

    @Override
    public void imprimir() {
        imprimir("", this);
    }

    public int buscar(String palabra, int[] contador) {
        TNodoTrie nodo = this;
        String palabraFiltrada = this.filtrarPalabra(palabra);
        for (int c = 0; c < palabraFiltrada.length(); c++) {
            int indice = palabraFiltrada.charAt(c) - 'a';

            if (nodo.hijos[indice] != null) {
                contador[0]++;
                if (nodo.hijos[indice].esPalabra) {
                    return contador[0];
                } else {
                    nodo = nodo.hijos[indice];
                }
            }
        }

        return contador[0];
    }

    public TNodoTrie buscarNodo(String s) {
        TNodoTrie nodo = this;
        for (int c = 0; c < s.length(); c++) {
            int indice = s.charAt(c) - 'a';
            if (nodo.hijos[indice] == null) {
                return null;
            }
            nodo = nodo.hijos[indice];
        }

        return nodo;
    }

    private void predecir(String s, String prefijo, LinkedList<String> palabras, TNodoTrie nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                if (!s.trim().equals("")) {
                    palabras.add(s);
                }
            }

            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    predecir(s + (char) (c + 'a'), prefijo, palabras, nodo.hijos[c]);
                }
            }
        }
    }

    @Override
    public void predecir(String prefijo, LinkedList<String> palabras) {
        TNodoTrie nodo = buscarNodo(prefijo);
        if (nodo != null) {
            nodo.predecir(prefijo, prefijo, palabras, nodo);
        }
    }

    private String filtrarPalabra(String unaPalabra) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < unaPalabra.length(); i++) {
            char caracter = unaPalabra.charAt(i);
            if ((caracter >= 'A' && caracter <= 'Z')
                    || (caracter >= 'a' && caracter <= 'z')) {
                sb.append(caracter);
            }
        }
        return sb.toString().toLowerCase();
    }
}