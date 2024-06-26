USE CentroMedico;

GO

CREATE PROCEDURE AltaEspecialidad(
	@nombre			VARCHAR(MAX)
)
AS
BEGIN
	IF NOT EXISTS (
		SELECT TOP 1 *
		FROM Especialidad
		WHERE nombreEspecialidad = @nombre
	)
	BEGIN
		INSERT INTO Especialidad(nombreEspecialidad)
		VALUES(@nombre)
	END
	ELSE
	BEGIN
		print('La especialidad ya existe!');
	END
END