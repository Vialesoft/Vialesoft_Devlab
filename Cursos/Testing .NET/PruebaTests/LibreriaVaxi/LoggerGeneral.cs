using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    public interface ILoggerGeneral
    {
        public int PrioridadLogger { get; set; }
        public string TipoLogger { get; set; }

        void Mensaje(string mensaje);
        bool LogDatabase(string mensaje);
        bool LogBalanceDespuesRetiro(int balance);
    }

    public  class LoggerGeneral : ILoggerGeneral
    {
        public int PrioridadLogger { get; set; }
        public string TipoLogger { get; set; }

        public void Mensaje(string mensaje)
        {
            Console.WriteLine(mensaje);
        }

        public bool LogDatabase(string mensaje)
        {
            Console.WriteLine(mensaje);
            return false;
        }

        public bool LogBalanceDespuesRetiro(int balance)
        {
            if(balance > 0)
            {
                Console.WriteLine("Un éxito, tenés tarasca todavía");
                return true;
            }

            Console.WriteLine("No tenés un mango ñe");
            return false;
        }
    }

    public class LoggerFake : ILoggerGeneral
    {
        public int PrioridadLogger { get; set; }
        public string TipoLogger { get; set; }

        public void Mensaje(string message)
        {
            
        }

        public bool LogDatabase(string mensaje)
        {
            Console.WriteLine(mensaje);
            return false;
        }

        public bool LogBalanceDespuesRetiro(int balance)
        {
            if (balance > 0)
            {
                Console.WriteLine("Un éxito, tenés tarasca todavía");
                return true;
            }

            Console.WriteLine("No tenés un mango ñe");
            return false;
        }
    }
}
