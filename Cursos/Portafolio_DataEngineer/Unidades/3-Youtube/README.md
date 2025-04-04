** _config.py Estructura: **
API_KEY = 'XxYyZzXxYyZzXxYyZzXxYyZzXxYyZz' [La API Key de Google "YouTube Data API v3"]

https://developers.google.com/youtube/code_samples?hl=es-419
https://developers.google.com/youtube/v3/docs?hl=es-419

**AWS**
- Crear dos buckets, uno de entrada y uno de salida
- En el bucket de entrada, cargar este archivo: https://github.com/Vialesoft/Vialesoft_Devlab/blob/main/Cursos/Portafolio_DataEngineer/Unidades/3-Youtube/Documentos/channels_to_analize.csv
- Crear la función lambda con el código en https://github.com/Vialesoft/Vialesoft_Devlab/blob/main/Cursos/Portafolio_DataEngineer/Unidades/3-Youtube/Documentos/lambda_demo.py
- Configurar los permisos de los buckets para poder acceder desde la función lambda a los buckets
- Generar una función de test de la función
