package UT3.TA03;

//DECLARACION DE PAQUETE
import java.io.Serializable;

public abstract class Medible implements Serializable {

    public Medicion medir(Object... params){
        long init = System.nanoTime();
        ejecutar(params);
        long fin = System.nanoTime();
        
        String cosas1 = this.getClass().getSimpleName();
        
        
        return new Medicion(cosas1,ObjectSizeFetcher.getObjectSize(getObjetoAMedirMemoria()), fin-init);
    }
    
    abstract public void ejecutar(Object... params);
    
    abstract public Object getObjetoAMedirMemoria();
    
}
