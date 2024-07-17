using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    [TestFixture]
    public class OperacionNUnitTest
    {
        [Test]
        public void SumarNumeros_InputDosNumeros_GetValorCorrecto()
        {
            Operacion op = new Operacion();
            int n1 = 14;
            int n2 = 27;

            int res = op.Suma(n1, n2);

            Assert.AreEqual(41, res);
        }

        [Test]
        [TestCase (4)]
        [TestCase(6)]
        [TestCase(20)]
        public void EsPar_InputValorPar_GetValorCorrecto(int n1)
        {
            Operacion op = new Operacion();

            bool res = op.EsPar(n1);

            Assert.IsTrue(res);
        }

        [Test]
        [TestCase(3, ExpectedResult = false)]
        [TestCase(5, ExpectedResult = false)]
        [TestCase(797, ExpectedResult = false)]
        public bool EsPar_InputValorImpar_GetValorCorrecto(int n1)
        {
            Operacion op = new Operacion();

            return op.EsPar(n1);
        }

        [Test]
        [TestCase(2.2, 1.2)] //3.4
        [TestCase(2.23, 1.24)] //3.47
        public void OtraSuma_InputDosNumeros_GetValorCorrecto(double n1, double n2)
        {
            Operacion op = new Operacion();

            double res = op.OtraSuma(n1, n2);

            Assert.AreEqual(3.4, res, 0.1); //Intervalo de +- 0.1
        }

        [Test]
        public void GetListaNumerosImpares_InputMinimoMaximoIntervalos_ReturnsListaImpares()
        {
            Operacion op = new Operacion();
            List<int> numerosEsperados = new List<int>()
            {
                5,7,9
            };

            List<int> numerosObtenidos = op.GetListaNumerosImpares(4, 10);

            Assert.That(numerosObtenidos, Is.EquivalentTo(numerosEsperados));
        }
    }
}
