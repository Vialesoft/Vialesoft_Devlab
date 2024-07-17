package TSimpleTrie;



import java.util.LinkedList;

public class TArbolTrie implements IArbolTrie {

    private TNodoTrie raiz;

    @Override
    public void insertar(String palabra) {
        if (raiz == null) {
            raiz = new TNodoTrie();
        }
        raiz.insertar(palabra);
    }

    @Override
    public void imprimir() {
        if (raiz != null) {
            raiz.imprimir();
        }
    }
    public String imprimirDos() {
        if (raiz != null) {
            return raiz.imprimirDos("",raiz);
        }
        return "";
    }

    @Override
    public int buscar(String palabra) {
        if(raiz == null){
            return 0;
        }
        else{
            int[] cont = new int[1];
            cont[0] = 0;
            return raiz.buscar(palabra,cont);   
        }
    }

    @Override
    public LinkedList<String> predecir(String prefijo) {
        LinkedList<String> palabras = new LinkedList<String>();
        if(raiz !=null){
            raiz.predecir(prefijo, palabras);
        }
        return palabras;
    }
    
    public static String filtrarPalabra(String unaPalabra) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < unaPalabra.length(); i++) {
            char caracter = unaPalabra.charAt(i);
            if ((caracter >= 'A' && caracter <= 'Z') ||
                (caracter >= 'a' && caracter <= 'z'))
                sb.append(caracter);
        }
        return sb.toString().toLowerCase();
    }
}
