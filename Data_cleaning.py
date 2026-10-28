import pandas as pd

# 1. Load the dataset
file_path = "C:/Users/bhava/OneDrive/Desktop/Production_output/Production_output_downtime.xlsx"

# Read the specific sheet containing the data
df = pd.read_excel(file_path, sheet_name="smart_manufacturing_dataset")

print(f"Original dataset shape: {df.shape}")

# 2. Check for missing values
print("\n--- Missing Values Before Cleaning ---")
print(df.isnull().sum())

# Handling missing 'Fault_Type': 
# Missing fault types usually indicate normal operation. Fill NaN with 'Normal'.
df["fault_Type"] = df["fault_Type"].fillna("Normal")

# 3. Drop duplicate rows if any exist
initial_rows = len(df)
df = df.drop_duplicates()
print(f"\nRemoved {initial_rows - len(df)} duplicate rows.")

# 4. Standardize text/categorical columns
categorical_cols = ["machine_id", "operation_mode", "fault_type", "target_class"]
for col in categorical_cols:
    if col in df.columns:
        df[col] = df[col].astype(str).str.strip()



# 6. Verify missing values after cleaning
print("\n--- Missing Values After Cleaning ---")
print(df.isnull().sum())

# 7. Save the cleaned dataset to a new Excel or CSV file
output_path = "cleaned_production_data.xlsx"
df.to_excel(output_path, index=False)
print(f"\nCleaned dataset successfully saved to {output_path}")