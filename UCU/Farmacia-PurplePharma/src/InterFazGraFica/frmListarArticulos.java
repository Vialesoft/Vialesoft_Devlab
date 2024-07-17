/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package InterFazGraFica;

import Clases.*;
import Interfaces.*;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Lithium582
 */
public class frmListarArticulos extends javax.swing.JFrame {

    private final Farmacia farmaArticulos;
    /**
     * Creates new form ListarArticulos
     */
    
    public frmListarArticulos() {
        initComponents();
        farmaArticulos = null;
        this.setSize(900,400);
        this.setResizable(false);
        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        this.setLocation(dim.width / 2 - this.getSize().width / 2,
                dim.height / 2 - this.getSize().height / 2);
        
    }
    
    public frmListarArticulos(Farmacia pFarma) {
        initComponents();
        
        this.dgArticulos.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        
        farmaArticulos = pFarma;
        
        this.setSize(900,400);
        this.setResizable(false);
        
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        this.setLocation(dim.width / 2 - this.getSize().width / 2,
                dim.height / 2 - this.getSize().height / 2);
        
        this.dgArticulos.setRowSelectionAllowed(true);
        this.dgArticulos.setRowSelectionAllowed(true);
        DefaultTableModel elementTable = (DefaultTableModel) this.dgArticulos.getModel();
        
//        ILista<IArticulo> listaArticulos = new Lista<IArticulo>();
//        listaArticulos = farmaArticulos.retornarArticulos("");
        

        ArrayList lista = farmaArticulos.retornarArticulos(0);

        if (lista != null){
            //INodoLista<IArticulo> nodoActual = listaArticulos.getPrimero();
            
        for (int i = 0; i < lista.size(); i+=2){
            IArticulo articuloActual = (Articulo)lista.get(i);
            String area = lista.get(i+1).toString();
            
                if (articuloActual != null){
                    String[] prodInfo = new String[12];
                    prodInfo[0] = area;
                    prodInfo[1] = articuloActual.getID().toString();
                    prodInfo[2] = articuloActual.getNombre();
                    prodInfo[3] = articuloActual.getDescripcion();
                    prodInfo[4] = Double.toString(articuloActual.getPrecio());
                    prodInfo[5] = articuloActual.getFechaCreacion().toString();
                    prodInfo[6] = articuloActual.getFechaActualizacion().toString();
                    prodInfo[7] = Integer.toString(articuloActual.getStock());
                    prodInfo[8] = Integer.toString(articuloActual.getAnoVencimiento());
                    prodInfo[9] = Boolean.toString(articuloActual.getRefrigerado());
                    prodInfo[10] = Boolean.toString(articuloActual.getReceta());
                    prodInfo[11] = Boolean.toString(articuloActual.getEstado());

                    elementTable.addRow(prodInfo);
                }
            //nodoActual = nodoActual.getSiguiente();
        }
            
//        while (nodoActual != null){
//            IArticulo articuloActual = nodoActual.getObjeto();
//            
//                if (articuloActual != null){
//                    String[] prodInfo = new String[12];
//                    prodInfo[0] = 
//                    prodInfo[0] = articuloActual.getID().toString();
//                    prodInfo[1] = articuloActual.getNombre();
//                    prodInfo[2] = articuloActual.getDescripcion();
//                    prodInfo[3] = Double.toString(articuloActual.getPrecio());
//                    prodInfo[4] = articuloActual.getFechaCreacion().toString();
//                    prodInfo[5] = articuloActual.getFechaActualizacion().toString();
//                    prodInfo[6] = Integer.toString(articuloActual.getStock());
//                    prodInfo[7] = Integer.toString(articuloActual.getAnoVencimiento());
//                    prodInfo[8] = Boolean.toString(articuloActual.getRefrigerado());
//                    prodInfo[9] = Boolean.toString(articuloActual.getReceta());
//                    prodInfo[10] = Boolean.toString(articuloActual.getEstado());
//
//                    elementTable.addRow(prodInfo);
//                }
//            nodoActual = nodoActual.getSiguiente();
//            }
        }else{
            JOptionPane.showMessageDialog(null, "El stock de productos se encuentra vacío", "Atención", JOptionPane.WARNING_MESSAGE);
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        btnCerrarForm = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        dgArticulos = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Listar Artículo");

        btnCerrarForm.setText("Cerrar");
        btnCerrarForm.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnCerrarFormActionPerformed(evt);
            }
        });

        dgArticulos.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
            },
            new String [] {
                "Área","ID","Nombre","Descripción","Precio","Fecha_Creacion","Fecha_Actualizacion", "Stock", "Año de Vencimiento", "Refrigerado", "Receta", "Estado"
            }
        ));
        jScrollPane2.setViewportView(dgArticulos);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 890, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(btnCerrarForm)
                .addGap(402, 402, 402))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 250, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(btnCerrarForm)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnCerrarFormActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnCerrarFormActionPerformed
        this.dispose();
    }//GEN-LAST:event_btnCerrarFormActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(frmListarArticulos.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(frmListarArticulos.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(frmListarArticulos.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(frmListarArticulos.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new frmListarArticulos().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnCerrarForm;
    private javax.swing.JTable dgArticulos;
    private javax.swing.JScrollPane jScrollPane2;
    // End of variables declaration//GEN-END:variables
}
