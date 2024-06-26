using AutoMapper;
using Education.Application.DTO;
using Education.Domain;
using Education.Persistence;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Education.Application.Cursos
{
    public class GetCursoQuery
    {
        public class GetCursoQueryRequest : IRequest<List<CursoDTO>>
        {

        }

        public class GetCursoQueryHandler : IRequestHandler<GetCursoQueryRequest, List<CursoDTO>>
        {
            private readonly EducationDBContext _context;
            private readonly IMapper _mapper;

            public GetCursoQueryHandler(EducationDBContext context, IMapper mapper)
            {
                _context = context;
                _mapper = mapper;
            }

            public async Task<List<CursoDTO>> Handle(GetCursoQueryRequest request, CancellationToken cancellationToken)
            {
                var cursos = await _context.Cursos.ToListAsync();
                var cursosDTO = _mapper.Map<List<Curso>, List<CursoDTO>>(cursos);

                return cursosDTO;
            }
        }
    }
}
