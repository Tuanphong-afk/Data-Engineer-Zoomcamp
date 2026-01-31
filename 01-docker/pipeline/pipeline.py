import sys 

print("argument", sys.argv)

month = int(sys.argv[1])

import pandas as pd

df = pd.DataFrame({"day": [1, 2], "num_passengers":[3, 4]})
df['Month'] = month
print(df.head())

df.to_parquet(f"output_{month}.parquet")

print(f'Hello pipeline, month = {month}')