using Education.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Education.Persistence
{
    public class EducationDBContext : DbContext
    {
        public EducationDBContext(DbContextOptions<EducationDBContext> options) : base(options)
        {

        }

        public DbSet<Curso> Cursos { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Curso>()
                .Property(c => c.Precio)
                .HasPrecision(14, 2);

            modelBuilder.Entity<Curso>().HasData(
                new Curso
                {
                    CursoId = Guid.NewGuid(),
                    Descripcion = "HOLA",
                    Titulo = "KE ASE",
                    FechaCreacion = DateTime.Now,
                    FechaPublicacion = DateTime.Now.AddYears(2),
                    Precio = 42
                }
            );

            modelBuilder.Entity<Curso>().HasData(
                new Curso
                {
                    CursoId = Guid.NewGuid(),
                    Descripcion = "ALOJA",
                    Titulo = "BIEJA",
                    FechaCreacion = DateTime.Now,
                    FechaPublicacion = DateTime.Now.AddYears(2),
                    Precio = 24
                }
            );
        }
    }
}
