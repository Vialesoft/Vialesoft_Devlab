import pandas as pd
from auxiliar.helpers import Helpers
from sqlalchemy import create_engine

helpers = Helpers('../config/config.ini')

conn, engine = helpers.connectToDB()

# Extraer Titanic
df = pd.read_sql_query("select * from angelmamberto15_coderhouse.titanic", con=conn)

print(df)