import openpyxl
import random

wb = openpyxl.load_workbook('code/ORIGINAL_FILES/ΕΛΛΗΝΙΚΗ ΟΝΟΜΑΤΟΛΟΓΙΑ ΚΑΙ ΚΩΔΙΚΟΠΟΙΗΣΗ ΤΩΝ ΙΑΤΡΙΚΩΝ ΠΡΑΞΕΩΝ.xlsx', read_only=True)
ws = wb['ΤΕΛΙΚΟ']

category_map = {
    'Α': 'ΠΡΑΞΕΙΣ ΑΝΑΙΣΘΗΣΙΑΣ',
    'Β': 'ΠΡΑΞΕΙΣ ΧΕΙΡΟΥΡΓΙΚΕΣ – ΕΠΕΜΒΑΤΙΚΕΣ – ΕΝΔΟΣΚΟΠΙΚΕΣ',
    'Γ': 'ΑΠΕΙΚΟΝΙΣΗ – ΕΠΕΜΒΑΤΙΚΕΣ ΚΑΙ ΘΕΡΑΠΕΥΤΙΚΕΣ ΑΚΤΙΝΙΚΕΣ ΠΡΑΞΕΙΣ',
    'Δ': 'ΠΡΑΞΕΙΣ ΒΙΟΠΑΘΟΛΟΓΙΑΣ',
    'Ε': 'ΠΡΑΞΕΙΣ ΙΑΤΡΟΔΙΚΑΣΤΙΚΗΣ – ΠΑΘΟΛΟΓΙΚΗΣ ΑΝΑΤΟΜΙΚΗΣ – ΚΥΤΤΑΡΟΛΟΓΙΑΣ'
}

αιθουσες = [
    'Χειρουργείο 1', 'Χειρουργείο 2', 'Χειρουργείο 3',
    'Χειρουργείο 4', 'Χειρουργείο 5', 'Αίθουσα Επέμβασης 1',
    'Αίθουσα Επέμβασης 2', 'Αίθουσα Επέμβασης 3',
    'Αίθουσα Επέμβασης 4', 'Αίθουσα Επέμβασης 5'
]

current_category = None
output_rows = []
seen_codes = set()

for i, row in enumerate(ws.iter_rows(values_only=True)):
    if not any(v for v in row):
        continue

    col0 = str(row[0]).strip() if row[0] else None
    col1 = str(row[1]).strip() if row[1] else None
    col2 = str(row[2]).strip() if row[2] else None

    if i < 2:
        continue

    
    if col0 and (not col1 or col1 == 'None'):
        letter = col0.split('.')[0].strip()
        current_category = category_map.get(letter)
        continue

    
    if col1 and col1 != 'None' and current_category:
        kod = col1.strip().replace('"', '').replace("'", '')
        name = col2.strip() if col2 and col2 != 'None' else ''

        if kod in seen_codes:
            continue
        seen_codes.add(kod)

        διαρκεια = random.randint(15, 300)
        κοστος = round(random.uniform(50, 5000), 2)
        χωρος = random.choice(αιθουσες)

        
        name_clean = name.replace('|', ' ').replace('"', "'").replace('῾', "'").replace('῟', "'")
        χωρος_clean = χωρος.replace('|', ' ')

        output_rows.append(
            f'"{kod}"|"{name_clean}"|"{current_category}"|{διαρκεια}|{κοστος}|"{χωρος_clean}"'
        )

with open('code/STATIC_DATA/PRACTICES_FINAL.csv', 'w', encoding='utf-8') as f:
    for row in output_rows:
        f.write(row + '\n')

print(f"Done! {len(output_rows)} rows")