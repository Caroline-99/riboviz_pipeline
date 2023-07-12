import pandas as pd

# Load the dataset
df = pd.read_csv('/Users/carolineeastwood/Desktop/Diss_project/riboviz_pipeline/assets/samplesheet.csv')

# Check if there are any empty headers
empty_headers = df.columns[(df.columns == "") | (df.columns.str.isspace())]

if len(empty_headers) > 0:
    print(f"Empty header columns found: {empty_headers}")
else:
    print("No empty header columns found.")

