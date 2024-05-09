import pandas as pd
from auxiliar.helpers import Helpers
import psycopg2

conn = psycopg2.connect(
    dbname = "data-engineer-database",
    user = "angelmamberto15_coderhouse",
    password = "9J8GfW05q0",
    host = "data-engineer-cluster.cyhh5bfevlmn.us-east-1.redshift.amazonaws.com",
    port = '5439'
)

cur = conn.cursor()
cur.execute("select * from angelmamberto15_coderhouse.titanic")

# Show the first one
# Este método retorna una fila y se mueve a la siguiente
print(cur.fetchone())
print(cur.fetchmany(3))

conn.commit()
conn.close()