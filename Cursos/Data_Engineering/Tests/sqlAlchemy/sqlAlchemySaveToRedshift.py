import pandas as pd
from auxiliar.helpers import Helpers
from sqlalchemy import create_engine

df = pd.read_csv("../files/train.csv")
helpers = Helpers('../config/config.ini')

conn, engine = helpers.connectToDB()

# Grabar Titanic
df.to_sql(
    name = 'titanic',
    con = conn,
    schema = "angelmamberto15_coderhouse",
    if_exists = 'replace',
    method = 'multi',
    chunksize = 1000,
    index = False
)

