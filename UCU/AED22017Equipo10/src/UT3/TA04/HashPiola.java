package UT3.TA04;


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author Bettina
 */
public class HashPiola {

    int[] T;
    int m;
    double factorCarga;
    int contadorClaves = 0;
    
    public int proximoPrimo(int aPartirDe){
        aPartirDe++;
        int numeroPrimoQuest = 0;
        for(int i = 2; i < aPartirDe; i++){
            if(aPartirDe%i == 0){
                aPartirDe++;
                i = 2;
            }else{
                continue;
            }
        }
        
        return aPartirDe;
    }
    
    public HashPiola(int cantClaves, double facCarga){
        int cantPosiciones = (int)(cantClaves / facCarga);
        cantPosiciones = proximoPrimo(cantPosiciones);
        T = new int[cantPosiciones];
        m = cantPosiciones;
        factorCarga = facCarga;
    }
    
    public String buscarHashSimple(int clave){
        String[] v = ManejadorArchivosGenerico.leerArchivo("src/claves_buscar.txt");
        int i = 0;
        boolean encontrado = false;
        int comparaciones = 0;
        int n = 10;
        while (i < n && encontrado == false){
            if (v[i].equals(clave)){
                encontrado = true;
                return v[i];
            }
            else{
                i += 1;
            }
           comparaciones += 1;
        }
        return "";
    }
    
    public int buscarHashSimpleComparaciones(int clave){
        String[] v = ManejadorArchivosGenerico.leerArchivo("src/claves_buscar.txt");
        int i = 0;
        boolean encontrado = false;
        int comparaciones = 0;
        int n = 10;
        
        while (i < n && encontrado == false){
            if (v[i].equals(clave)){
                encontrado = true;
            }
            else{
                i += 1;
            }
           comparaciones += 1;
        }
        
        if(encontrado){
            return comparaciones;
        }else{
            return -(comparaciones);
        }
        
    }
    
    public int buscarHashCuadratico(int clave){
        int contador = 0;
        int posicionOriginal = this.funcionHash(clave);
        int posicionEnHash = posicionOriginal;
        boolean encontrado = false;
        
        if(T[posicionOriginal] == 0){
            T[posicionOriginal] = clave;
            contador++;
        }else{
            while(contador <= 5){
                posicionEnHash = (int)((posicionOriginal + Math.pow(contador,2)) % this.m);
                contador++;
                
                if(T[posicionEnHash] != 0){
                    if(T[posicionEnHash] == clave){
                        encontrado = true;
                        break;
                    }
                }
            }
        }
        
        if(encontrado){
            return contador;
        }else{
            return -(contador);
        }
    }
    
    public int buscarHashCuadraticoComparaciones(int clave){
        String[] v = ManejadorArchivosGenerico.leerArchivo("src/UT3/TA04/claves_buscar.txt");
        int i = 0;
        boolean encontrado = false;
        int comparaciones = 0;
        int n = 10;
        
        while (i < n && encontrado == false){
            if (v[i].equals(clave)){
                encontrado = true;
            }
            else{
                i += 1;
            }
           comparaciones += 1;
        }
        
        if(encontrado){
            return comparaciones;
        }else{
            return -(comparaciones);
        }
    }
    
    public int insertarHashSimple(int clave){
        int i = 0;
        int contador = 0;
        int j = this.funcionHash((clave));
        
        while (T[j] == 0 || i==m){
            if (T[j] == 0){
                contadorClaves ++;
                factorCarga = contadorClaves/this.m;
                return contador;
            }
            else{
                i++;
            }
            contador++;
        }
        
        return contador;
    }
    
    public int insertarHashCuadratico(int clave){
        int contador = 0;
        int posicionOriginal = this.funcionHash(clave);
        int posicionEnHash = posicionOriginal;
        boolean insertado = false;
        
        if(T[posicionOriginal] == 0){
            T[posicionOriginal] = clave;
            insertado = true;
            contadorClaves ++;
            factorCarga = contadorClaves/this.m;
            contador++;
        }else{
            while(contador <= 5){
                posicionEnHash = (int)((posicionOriginal + Math.pow(contador,2)) % this.m);
                contador++;
                
                if(T[posicionEnHash] == 0){
                    T[posicionEnHash] = clave;
                    insertado = true;
                    contadorClaves ++;
                    factorCarga = contadorClaves/this.m;
                    break;
                }
            }
        }
        
        if(insertado){
            return contador;
        }else{
            return -(contador);
        }
        
    }
    
    /**
     * La función consiste en tomar el último caracter de la palabra, 
     * asignarle un valor numérico según su posición en el alfabeto y 
     * efectuar la división entera entre diez para utilizar el resto 
     * de la misma como código.
     * @param clave Palabra solicitada.
     * @return Devuelve el hashcode de la palabra solicitada.
     */
    public int funcionHash(int clave){
        //return ((clave.toLowerCase().codePointAt(clave.length()-1)-96)%10);
        return clave%m;
    }
    
}