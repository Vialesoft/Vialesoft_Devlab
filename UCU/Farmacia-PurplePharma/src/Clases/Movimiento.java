/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import Interfaces.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Lithium582
 */
public class Movimiento implements IMovimiento {
    
    // <editor-fold defaultstate="extended" desc="Atributos">
        private static Integer ultimoIDGenerado = 0;
        private Comparable<Long> id;
        private Date Fecha;
        private Comparable<Integer> idArticulo;
        private Integer cantidad;
        private Double valorFinal;
    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Propiedades">
        public Comparable getID(){
            return this.id;
        }

        @Override
        public Date GetFecha() {
            return this.Fecha;
        }

        @Override
        public Comparable GetIdArticulo() {
            return this.idArticulo;
        }

        @Override
        public void SetIdArticulo(Comparable value) {
            this.idArticulo = value;
        }

        @Override
        public Integer GetCantidad() {
            return this.cantidad;
        }

        @Override
        public void SetCantidad(Integer value) {
            this.cantidad = value;
        }

        @Override
        public Double GetValorFinal() {
            return this.valorFinal;
        }
    // </editor-fold>
    
    //<editor-fold defaultstate="extended" desc="Constructores">
        public Movimiento(){
            this.id = -1L;
            this.Fecha = new Date();
            this.idArticulo = -1;
            this.valorFinal = 0D;
            this.cantidad = -1;
        }
        
        public Movimiento(IArticulo pArticulo, Integer pCantidad){
//            ultimoIDGenerado++;
            this.Fecha = Calendar.getInstance().getTime();
            
//            if(ultimoIDGenerado % 2 == 0){
//                this.Fecha.setTime(this.Fecha.getTime() + 43200000000L);
//            }
            
            this.id = this.Fecha.getTime();
            this.idArticulo = pArticulo.getID();
            this.cantidad = pCantidad;
            this.valorFinal = pArticulo.getPrecio() * pCantidad;
        }
    //</editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Funciones y Métodos">
        public String toString() {
            SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            String fecha = "";
            
            String cadenaRetorno = this.getID().toString();
            cadenaRetorno += " - " + "Fecha: " + dt.format(this.GetFecha());
            cadenaRetorno += " - " + "IDArticulo: " + this.GetIdArticulo();
            cadenaRetorno += " - " + "Cantidad: " + this.GetCantidad();
            cadenaRetorno += " - " + "Valor final del Movimiento: " + this.GetValorFinal();

            return cadenaRetorno;
        }

    // </editor-fold>
}
