USE CentroMedico;

GO

ALTER PROCEDURE AltaMedico(
	@nombre			VARCHAR(MAX),
	@idEspecialidad	INTEGER,
	@descripcion	VARCHAR(MAX) = ''
)
AS
BEGIN
	IF NOT EXISTS (
		SELECT TOP 1 *
		FROM Medico
		WHERE nombreMedico = @nombre
	)
	BEGIN
		INSERT INTO Medico(nombreMedico)
		VALUES(@nombre)

		DECLARE @idMedico INTEGER;
		SET @idMedico = @@IDENTITY

		INSERT INTO MedicoEspecialidad(idMedico, idEspecialidad, descripcion)
		VALUES(@idMedico, @idEspecialidad, @descripcion)
	END
END