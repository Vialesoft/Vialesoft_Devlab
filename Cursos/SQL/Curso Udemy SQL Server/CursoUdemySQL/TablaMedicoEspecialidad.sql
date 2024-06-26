USE CentroMedico;

CREATE TABLE MedicoEspecialidad(
	idMedico		INTEGER,
	idEspecialidad	INTEGER,
	descripcion		VARCHAR(MAX),
	CONSTRAINT PK_MedicoEspecialidades PRIMARY KEY (idMedico, idEspecialidad),
	CONSTRAINT FK_MedicoEspecialidadMedico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico),
	CONSTRAINT FK_MedicoEspecialidadEspecialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(idEspecialidad)
)