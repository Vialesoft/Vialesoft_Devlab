using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    [TestFixture]
    public class CuentaBancaria_NUnitTest
    {
        private CuentaBancaria _cuenta;

        private Mock<ILoggerGeneral> mocking = new Mock<ILoggerGeneral>();
        [SetUp]
        public void Setup()
        {
            

        }

        [Test]
        public void Deposito_InputMonto100LoggerFake_ReturnsTrue()
        {
            CuentaBancaria cuentaBancaria = new CuentaBancaria(new LoggerFake());
            var resultado = cuentaBancaria.Deposito(100);

            Assert.IsTrue(resultado);
            Assert.That(cuentaBancaria.ObtenerBalance, Is.EqualTo(100));
        }

        [Test]
        public void Deposito_Input100Mocking_ReturnsTrue()
        {   
            CuentaBancaria cuentaBancaria = new CuentaBancaria(mocking.Object);
            var resultado = cuentaBancaria.Deposito(100);

            Assert.IsTrue(resultado);
            Assert.That(cuentaBancaria.ObtenerBalance, Is.EqualTo(100));
        }

        [Test]
        [TestCase(200,100)]
        [TestCase(200, 150)]
        public void Retiro_Retiro100ConBalance200(int balance, int retiro)
        {
            mocking.Setup(m => m.LogBalanceDespuesRetiro(It.Is<int>(x => x>=0))).Returns(true);
            mocking.Setup(m => m.LogBalanceDespuesRetiro(It.Is<int>(x => x<0))).Returns(false);
            mocking.Setup(m => m.LogDatabase(It.IsAny<string>())).Returns(true);

            CuentaBancaria cuentaBancaria = new CuentaBancaria(mocking.Object);
            cuentaBancaria.balance = balance;

            var resultado = cuentaBancaria.Retiro(retiro);

            Assert.IsTrue(resultado);
        }

        [Test]
        public void CuentaBancariaLoggerGeneral_LogMockingPrioridadTipo_ReturnsTrue()
        {
            var loggerGeneralMock = new Mock<ILoggerGeneral>();
            loggerGeneralMock.Setup(u => u.TipoLogger).Returns("warning");
            loggerGeneralMock.Setup(u => u.PrioridadLogger).Returns(10);

            Assert.That(loggerGeneralMock.Object.TipoLogger, Is.EqualTo("warning"));
            Assert.That(loggerGeneralMock.Object.PrioridadLogger, Is.EqualTo(10));
        }
    }
}
