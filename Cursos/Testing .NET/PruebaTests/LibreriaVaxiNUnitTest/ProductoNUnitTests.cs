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
    public class ProductoNUnitTests
    {
        private Cliente cPremium = new Cliente
        {
            IsPremium = true
        };

        private Cliente cNoPremium = new Cliente();
        private Mock<ICliente> iCliente = new Mock<ICliente>();

        [Test]
        public void GetPrecio_ClientePremium()
        {
            Producto p = new Producto();
            p.Precio = 100;

            double precio = p.GetPrecio(cPremium);

            Assert.AreEqual(precio, 80);
        }

        [Test]
        public void GetPrecio_ClienteNoPremium()
        {
            Producto p = new Producto();
            p.Precio = 100;

            double precio = p.GetPrecio(cNoPremium);

            Assert.AreEqual(precio, 100);
        }

        [Test]
        public void GetPrecio_ClientePremiumMock()
        {
            Producto p = new Producto();
            p.Precio = 100;

            iCliente.Setup(c => c.IsPremium).Returns(true);

            double precio = p.GetPrecio(iCliente.Object);

            Assert.AreEqual(precio, 80);
        }
    }
}
