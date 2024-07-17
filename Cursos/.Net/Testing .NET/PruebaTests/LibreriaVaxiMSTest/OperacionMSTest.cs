using LibreriaVaxi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxiMSTest
{
    [TestClass]
    public class OperacionMSTest
    {
        [TestMethod]
        public void SumarNumeros_InputDosNumeros_GetValorCorrecto()
        {
            Operacion op = new Operacion();
            int n1 = 14;
            int n2 = 27;

            int res = op.Suma(n1, n2);

            Assert.AreEqual(41, res);
        }
    }
}
