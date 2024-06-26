using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    public class CuentaBancaria
    {
        public int balance { get; set; }
        private readonly ILoggerGeneral _logger;
        
        public CuentaBancaria(ILoggerGeneral logger)
        {
            balance = 0;
            _logger = logger;
        }

        public bool Deposito(int monto)
        {
            balance += monto;
            _logger.Mensaje("Se han depositado $" + monto.ToString());
            return true;
        }

        public bool Retiro(int monto)
        {
            if (RetiroValido(monto))
            {
                balance -= monto;
                _logger.LogDatabase("Se han retirado $" + monto.ToString());
                return _logger.LogBalanceDespuesRetiro(balance);
            }

            return false;
        }

        public int ObtenerBalance()
        {
            return balance;
        }

        private bool RetiroValido(int monto)
        {
            return balance >= monto;
        }
    }
}
