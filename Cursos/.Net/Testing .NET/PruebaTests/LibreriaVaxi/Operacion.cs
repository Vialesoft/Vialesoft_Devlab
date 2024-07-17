namespace LibreriaVaxi
{
    public class Operacion
    {
        public List<int> NumerosImpares = new List<int>();
        public int Suma(int n1, int n2)
        {
            return n1 + n2;
        }

        public bool EsPar(int n1)
        {
            return n1 % 2 == 0;
        }

        public double OtraSuma(double n1, double n2)
        {
            return n1 + n2;
        }

        public List<int> GetListaNumerosImpares(int minimo, int maximo)
        {
            NumerosImpares.Clear();

            if (minimo % 2 == 0)
            {
                minimo++;
            }

            while(minimo < maximo)
            {
                NumerosImpares.Add(minimo);
                minimo += 2;
            }

            return NumerosImpares;
        }

    }
}