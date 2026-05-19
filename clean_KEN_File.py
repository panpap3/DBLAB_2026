import csv
import os

output_rows = []
ken_id = 1

with open('code/ORIGINAL_FILES/ΚΩΔΙΚΟΙ_ΚΕΝ.csv', 'r', encoding='utf-8-sig') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        
        parts = line.split(';')
        if len(parts) != 4:
            continue
        
        kod = parts[0].strip()
        perigrafi = parts[1].strip()
        kostos = parts[2].strip()
        mdn = parts[3].strip()
        
        
        if not kostos:
            continue
            
        
        kostos = kostos.replace(' ', '')
        mdn = mdn.replace(' ', '')
        
        
        try:
            float(kostos)
            int(mdn)
        except:
            continue
            
        output_rows.append(f"{ken_id};{kod};{perigrafi};{kostos};{mdn}")
        ken_id +=1


with open('code/STATIC_DATA/KOSTOLOGISI.csv', 'w', encoding='utf-8') as f:
    for row in output_rows:
        f.write(row + '\n')

print(f"Done! {len(output_rows)} rows")