package UT7.TA2;

import UT6.TA041.*;
import UT6.TA012.*;
import UT6.TA01.*;
import java.util.Collections;

public class TClasificador {

    public static final int METODO_CLASIFICACION_INSERCION = 1;
    public static final int METODO_CLASIFICACION_SHELL = 2;
    public static final int METODO_CLASIFICACION_BURBUJA = 3;
    public static final int METODO_CLASIFICACION_QUICKSORT = 4;
    public static final int JEAP = 5;
    public static final int PRECISION = 1;

    private int[] vectorIncremento;

    public TClasificador() {
        this.vectorIncremento = new int[]{127, 17, 5, 1};
    }

    private int calcularVectorIncremento(int valor) {
        for (int i = this.vectorIncremento.length - 1; i >= 0; i--) {
            if (this.vectorIncremento[i] < valor) {
                return i;
            }
        }
        return -1;
    }

    /**
     * Punto de entrada al clasificador
     *
     * @param metodoClasificacion
     * @param orden
     * @param tamanioVector
     * @return Un vector del tam. solicitado, ordenado por el algoritmo
     * solicitado
     */
    public int[] clasificar(int[] datosParaClasificar, int metodoClasificacion, boolean cascara) {
        switch (metodoClasificacion) {
            case METODO_CLASIFICACION_INSERCION: {
                if (cascara) {
                    return ordenarPorInsercionCascara(datosParaClasificar);
                } else {
                    return ordenarPorInsercion(datosParaClasificar);
                }
            }
            case METODO_CLASIFICACION_SHELL:
                return shellSort(datosParaClasificar);
            case METODO_CLASIFICACION_BURBUJA:
                return ordenarPorBurbuja(datosParaClasificar);
            case METODO_CLASIFICACION_QUICKSORT:
                return ordenarPorQuickSort(datosParaClasificar);
            case JEAP:
                return ordenarPorHeapSort(datosParaClasificar);
            default:
                System.err.println("Este codigo no deberia haberse ejecutado");
                break;
        }
        return datosParaClasificar;
    }

    protected int[] ordenarPorHeapSort(int[] datosParaClasificar) {
        for (int i = (datosParaClasificar.length - 1) / 2; i >= 0; i--) {
            //Armo el heap inicial de n-1 div 2 hasta 0
            armaHeap(datosParaClasificar, i, datosParaClasificar.length - 1);
        }
        
        for (int i = datosParaClasificar.length - 1; i >= 1; i--) { //Eggog
            intercambiar(datosParaClasificar, 0, i);
            armaHeap(datosParaClasificar, 0, i - 1);
        }
        return datosParaClasificar;
    }

    private void armaHeap(int[] datosParaClasificar, int primero, int ultimo) {
        if (primero < ultimo) {
            int r = primero;
            while (r <= ultimo / 2) {
                if (ultimo == 2 * r) { //r tiene un hijo solo
                    if (datosParaClasificar[r] < datosParaClasificar[r * 2]) { //Eggog
                        intercambiar(datosParaClasificar, r, 2 * r);
                        //r = 2; //WHAAAAAT?
                    } else {
                        r = ultimo;
                    }
                } else { //r tiene 2 hijos
                    int posicionIntercambio = 0;
                    if (datosParaClasificar[2 * r] < datosParaClasificar[2 * r + 1]) {
                        posicionIntercambio = 2 * r + 1;
                    } else {
                        posicionIntercambio = 2 * r;
                    }
                    if (datosParaClasificar[r] < datosParaClasificar[posicionIntercambio]) { //Eggog
                        intercambiar(datosParaClasificar, r, posicionIntercambio);
                        r = posicionIntercambio;
                    } else {
                        r = ultimo;
                    }
                }
            }
        }
    }

    protected int[] ordenarPorInsercionCascara(int[] datosParaClasificar) {
        if (datosParaClasificar != null) {
            return datosParaClasificar;
        }
        return null;
    }

    private void intercambiar(int[] vector, int pos1, int pos2) {
        int temp = vector[pos2];
        vector[pos2] = vector[pos1];
        vector[pos1] = temp;
    }

    /**
     * @param datosParaClasificar
     * @return
     */
    private int[] ordenarPorShell(int[] datosParaClasificar) {
        int j, inc;
        int[] incrementos = new int[]{3223, 358, 51, 10, 3, 1};

        for (int posIncrementoActual = 1; posIncrementoActual < incrementos.length; posIncrementoActual++) {
            inc = incrementos[posIncrementoActual];
            if (inc < (datosParaClasificar.length / 2)) {
                for (int i = inc; i < datosParaClasificar.length; i++) {
                    j = i - inc;
                    while (j >= 0) {
                        if (datosParaClasificar[j] > datosParaClasificar[j + inc]) {
                            intercambiar(datosParaClasificar, j, j + inc);
                        }
                        j = j -= inc;
                    }
                }
            }
        }
        return datosParaClasificar;
    }

    private int[] ordenarPorShellB(int[] datosParaClasificar) {
        int pIzq;
        int cantValores = datosParaClasificar.length;
        int distancia = cantValores / 2;

        while (distancia > 0) {

            for (int i = distancia; i < cantValores; i++) {
                int pDer = datosParaClasificar[i];

                for (pIzq = i; (pIzq >= distancia) && (datosParaClasificar[pIzq - distancia] > pDer); pIzq -= distancia) {
                    datosParaClasificar[pIzq] = datosParaClasificar[pIzq - distancia];
                }

                datosParaClasificar[pIzq] = pDer;
            }

            distancia = distancia / 2;
        }
        return datosParaClasificar;
    }

    public int[] shellSort(int[] vector) {
        int indice = this.calcularVectorIncremento(vector.length);
        while (indice < this.vectorIncremento.length) {
            int incremento = this.vectorIncremento[indice];
            for (int i = incremento; i < vector.length; i++) {
                int aux = vector[i];
                int j = i - incremento;
                while (j >= 0 && aux < vector[j]) {
                    vector[j + incremento] = vector[j];
                    j -= incremento;
                }
                vector[j + incremento] = aux;
            }
            indice++;
        }

        return vector;
    }

    /**
     * @param datosParaClasificar
     * @return
     */
    protected int[] ordenarPorInsercion(int[] datosParaClasificar) {
        if (datosParaClasificar != null) {
            for (int i = 2; i < datosParaClasificar.length; i++) {
                int j = i - 1;
                while ((j >= 0) && (datosParaClasificar[j] > datosParaClasificar[j + 1])) {
                    intercambiar(datosParaClasificar, j + 1, j);
                    j--;
                }
            }
            return datosParaClasificar;
        }
        return null;
    }

    private int[] ordenarPorBurbuja(int[] datosParaClasificar) {
        System.out.println("Burbuja");
        //datosParaClasificar = null;
        int n = datosParaClasificar.length - 1;
        for (int i = 0; i <= n; i++) {
            for (int j = n; j >= (i + 1); j--) {
                if (datosParaClasificar[j] < datosParaClasificar[j - 1]) {
                    intercambiar(datosParaClasificar, j - 1, j);
                }
            }
        }
        return datosParaClasificar;
    }

    public static void main(String args[]) {
        TClasificador clasif = new TClasificador();
        GeneradorDatosGenericos gdg = new GeneradorDatosGenericos();
        int[] vectorAleatorio = gdg.generarDatosAleatorios();
        int[] vectorAscendente = gdg.generarDatosAscendentes();
        int[] vectorDescendente = gdg.generarDatosDescendentes();

        int[] resAleatorio = clasif.clasificar(vectorAleatorio,
                METODO_CLASIFICACION_INSERCION, false);
        for (int i = 0; i < resAleatorio.length; i++) {
            System.out.print(resAleatorio[i] + " ");
        }
        int[] resAscendente = clasif.clasificar(vectorAscendente,
                METODO_CLASIFICACION_INSERCION, false);
        for (int i = 0; i < resAscendente.length; i++) {
            System.out.print(resAscendente[i] + " ");
        }
        int[] resDescendente = clasif.clasificar(vectorDescendente,
                METODO_CLASIFICACION_INSERCION, false);
        for (int i = 0; i < resDescendente.length; i++) {
            System.out.print(resDescendente[i] + " ");
        }
    }

    public static String strArray(int[] vector) {
        String strRetorno = "";
        if (vector.length > 0) {
            strRetorno = String.valueOf(vector[0]);
            for (int i = 1; i < vector.length; i++) {
                strRetorno += "," + String.valueOf(vector[i]);
            }
        }
        return strRetorno;
    }

    public int[] quickSort2(int[] vector) {
        this.quickSort2(vector, 0, vector.length - 1);

        return vector;
    }

    public void quickSort2(int[] vector, int l, int h) {
        //vector = Collections.shuffle(vector);
        int p;
        int left = l;
        int right = h;
        if (right > l) {
            p = encuentraBigote(vector, l, h);

            if (p != 0) {
                while (right > left) {
                    while (vector[left] < p) {
                        left++;
                    }

                    while (vector[right] > p) {
                        right--;
                    }

                    int aux = vector[left];
                    vector[left] = vector[right];
                    vector[right] = aux;
                }

                quickSort2(vector, l, right - 1);
                quickSort2(vector, right, h);
            }
        }
    }

    private int encuentraBigote(int[] vector, int l, int h) {
        int res = vector[l];
        for (int i = l; i <= h; i++) {
            if (res != vector[i]) {
                res = -1;
                break;
            }
        }

        //Significa que encontró claves diferentes
        if (res == -1) {
            if (vector[l] >= vector[h]) {
                return vector[l];
            }

            return vector[h];
        }

        return 0;

    }

    public int[] quickSort(int[] vector) {
        this.quickSort(vector, 0, vector.length - 1);

        return vector;
    }

    public void quickSort(int[] vector, int l, int h) {
        int p;
        if (h > l) {
            p = particionar(vector, l, h);
            quickSort(vector, l, p - 1);
            quickSort(vector, p + 1, h);
        }
    }

    private int particionar(int[] vector, int l, int h) {
        int contador;
        int p;
        int firsthigh;
        p = h;
        firsthigh = l;
        for (contador = l; contador < h; contador++) {
            if (vector[contador] < vector[p]) {
                int aux = vector[contador];
                vector[contador] = vector[firsthigh];
                vector[firsthigh] = aux;
                firsthigh++;
            }
        }
        int aux = vector[p];
        vector[p] = vector[firsthigh];
        vector[firsthigh] = aux;
        return firsthigh;
    }

    protected int[] ordenarPorQuickSort(int[] datosParaClasificar) {
        quicksort(datosParaClasificar, 0, datosParaClasificar.length - 1);
        return datosParaClasificar;
    }

    private void quicksort(int[] entrada, int i, int j) {
        int izquierda = i;
        int derecha = j;

        int posicionPivote = encuentraPivote(izquierda, derecha, entrada);
        if (posicionPivote >= 0) {
            int pivote = entrada[posicionPivote];//El sexto error!!!!! :D

            while (izquierda <= derecha) {
                while ((entrada[izquierda] < pivote) && (izquierda < j)) {
                    izquierda++;//Error
                }

                while ((pivote < entrada[derecha]) && (derecha > i)) {
                    derecha--;//Error
                }

                if (izquierda <= derecha) {
                    intercambiar(entrada, izquierda, derecha);//Eggog
                    izquierda++;
                    derecha--;
                }
            }

            if (i < derecha) {
                quicksort(entrada, i, derecha); //Error
            }
            if (izquierda < j) {
                quicksort(entrada, izquierda, j); //Error
            }
        }
    }

    private int encuentraPivote(int l, int h, int[] vector) {
        //return l;
        int res = vector[l];
        for (int i = l; i <= h; i++) {
            if (res != vector[i]) {
                res = -1;
                break;
            }
        }

        //Significa que encontró claves diferentes
        if (res == -1) {
            if (vector[l] >= vector[h]) {
                //return vector[l];
                return l;
            }

            //return vector[h];
            return h;
        }

        return 0;

    }
}
