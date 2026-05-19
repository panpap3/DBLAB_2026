import openpyxl
import os

os.makedirs('STATIC_DATA', exist_ok=True)

wb = openpyxl.load_workbook('code/ORIGINAL_FILES/article-57-product-data_en.xlsx', read_only=True)
ws = wb.active

unique_substances = set()

for i, row in enumerate(ws.iter_rows(values_only=True)):
    if i < 20:
        continue

    substances_raw = str(row[1]).strip() if row[1] else None

    if not substances_raw or substances_raw == 'None':
        continue

    formulas = substances_raw.split('|')
    for formula in formulas:
        substances = formula.split(',')
        for substance in substances:
            substance = substance.strip()
            if substance and substance[0].isalpha():
                unique_substances.add(substance)

# UTF-8 χωρίς BOM
with open('code/STATIC_DATA/SUBSTANCES_FINAL.csv', 'w', encoding='utf-8') as f:
    for substance in sorted(unique_substances):
        substance_clean = substance.replace('"', '""')
        f.write(f'"{substance_clean}"\n')

print(f"Done! {len(unique_substances)} δραστικές ουσίες")