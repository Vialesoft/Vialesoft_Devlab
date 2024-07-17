using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    public class Producto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }

        public double Precio { get; set; }

        public double GetPrecio(Cliente oCliente)
        {
            return this.Precio * (oCliente.IsPremium ? 0.8 : 1);
        }

        public double GetPrecio(ICliente oCliente)
        {
            return this.Precio * (oCliente.IsPremium ? 0.8 : 1);
        }

    }
}
