import openpyxl

wb = openpyxl.load_workbook('code/ORIGINAL_FILES/article-57-product-data_en.xlsx', read_only=True)
ws = wb.active

# Συλλογή όλων των ζευγών (φάρμακο, συνταγή)
drug_keys = []  # λίστα (drug_name, formula_num) με τη σειρά εμφάνισης
drug_keys_set = set()
drug_substances = []  # λίστα (drug_name, formula_num, substance)

for i, row in enumerate(ws.iter_rows(values_only=True)):
    if i < 20:
        continue

    drug_name = str(row[0]).strip() if row[0] else None
    substances_raw = str(row[1]).strip() if row[1] else None

    if not drug_name or not substances_raw or substances_raw == 'None':
        continue

    drug_name_clean = drug_name.replace('"', '""').strip()

    formulas = substances_raw.split('|')
    for formula_num, formula in enumerate(formulas, start=1):
        substances = formula.split(',')
        for substance in substances:
            substance = substance.strip()
            if substance and substance[0].isalpha():
                key = (drug_name_clean, formula_num)
                if key not in drug_keys_set:
                    drug_keys_set.add(key)
                    drug_keys.append(key)
                drug_substances.append((key, substance.replace('"', '""')))

# (drug_name, formula_num) -> ΦΑΡΜΑΚΟ_ID
drug_id_map = {key: idx + 1 for idx, key in enumerate(drug_keys)}

# Αποθήκευση ΦΑΡΜΑΚΑ
with open('code/STATIC_DATA/DRUGS.csv', 'w', encoding='utf-8') as f:
    for name, formula_num in drug_keys:
        f.write(f'"{name}";{formula_num}\n')

# Αποθήκευση ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57
seen_pairs = set()
with open('code/STATIC_DATA/DRUG_SUBSTANCES.csv', 'w', encoding='utf-8') as f:
    for key, substance in drug_substances:
        fid = drug_id_map[key]
        pair = (fid, substance)
        if pair not in seen_pairs:
            seen_pairs.add(pair)
            f.write(f'{fid};"{substance}"\n')

print(f"Done! {len(drug_keys)} φάρμακα, {len(seen_pairs)} ζεύγη")