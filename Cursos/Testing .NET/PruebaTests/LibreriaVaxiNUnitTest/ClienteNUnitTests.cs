using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaVaxi
{
    [TestFixture]
    public class ClienteNUnitTests
    {
        private Cliente _cliente;

        [SetUp]
        public void Setup()
        {
            _cliente = new Cliente();
        }

        [Test]
        public void CrearNombreCompleto_InputDosNumeros_GetValorCorrecto()
        {
            string n = "Cacho";
            string a = "Rita";

            _cliente.CrearNombreCompleto(n, a);

            Assert.Multiple(() =>
            {
                Assert.That(_cliente.ClienteNombre, Is.EqualTo("Cacho Rita"));
                Assert.That(_cliente.ClienteNombre, Does.Contain("Rita"));
                Assert.That(_cliente.ClienteNombre, Does.Contain("rita").IgnoreCase);
            });
        }

        [Test]
        public void ClienteNombre_NoValue_ReturnsNull()
        {
            Assert.IsNull(_cliente.ClienteNombre);
        }

        [Test]
        public void DescuentoEvaluacion_DefaultClient_ReturnsDescuentoIntervalo()
        {
            int descuento = _cliente.Descuento;
            Assert.That(descuento, Is.InRange(5, 24));
        }


        [Test]
        public void CrearNombreCompleto_InputNombre_ReturnsNotNull()
        {
            _cliente.CrearNombreCompleto("Abigail", "Pepez");

            Assert.Multiple(() =>
            {
                Assert.IsNotNull(_cliente.ClienteNombre);
                Assert.IsFalse(string.IsNullOrEmpty(_cliente.ClienteNombre));
            });
        }

        [Test]
        public void CrearNombreCompleto_InputNombreEnBlanco_ThrowsException()
        {
            var exceptionDetalle = Assert.Throws<ArgumentException>(() =>
            {
                _cliente.CrearNombreCompleto("", "Rita");
            });

            Assert.Multiple(() =>
            {
                Assert.AreEqual("Ta vacío Wachín", exceptionDetalle.Message);

                Assert.That(() => _cliente.CrearNombreCompleto("", "Cacho"),
                    Throws.ArgumentException.With.Message.EqualTo("Ta vacío Wachín")
                );
            });

        }
    }
}
