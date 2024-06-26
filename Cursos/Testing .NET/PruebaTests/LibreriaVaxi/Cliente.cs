using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    public interface ICliente
    {
        bool IsPremium { get; set; }
    }

    public class Cliente
    {
        public int Descuento { get; set; }
        public string ClienteNombre { get; set; }
        public bool IsPremium { get; set; }

        public Cliente()
        {
            IsPremium = false;
            Descuento = 10;
        }

        public string CrearNombreCompleto(string n, string a)
        {
            if (string.IsNullOrEmpty(n))
            {
                throw new ArgumentException("Ta vacío Wachín");
            }

            Descuento = 30;
            ClienteNombre = $"{n} {a}";
            return ClienteNombre;
        }
    }
}
