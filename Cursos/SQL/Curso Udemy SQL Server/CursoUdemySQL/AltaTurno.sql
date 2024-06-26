GO

ALTER PROCEDURE AltaTurno(
	@fechaHora		CHAR(14), --20190215 12:00
	@idPaciente		INTEGER,
	@idMedico		INTEGER,
	@observacion	VARCHAR(MAX) = ''
)
AS
BEGIN
	IF NOT EXISTS(
		SELECT TOP 1 *
		FROM Turno T
		WHERE T.fechaTurno = @fechaHora
	)
	BEGIN
		INSERT INTO Turno (fechaTurno, estado, observacion)
		VALUES(@fechaHora, 0, @observacion);

		DECLARE @idTurno INTEGER
		SET @idTurno = @@IDENTITY

		INSERT INTO TurnoPaciente (idTurno, idPaciente, idMedico)
		VALUES(@idTurno, @idPaciente, @idMedico)

		print ('El turno se agregó correctamente');
	END


END