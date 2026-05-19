import pandas as pd
import random
import re 
import csv
from faker import Faker
from datetime import date, timedelta, datetime

# Αρχικοποίηση Faker
fake = Faker('el_GR')

# Σταθερές ελάχιστων απαιτήσεων
NUM_DEPARTMENTS = 15
NUM_DOCTORS = 300
NUM_NURSES = 250
NUM_ADMINS = 100
NUM_PATIENTS = 20000
NUM_ADMISSIONS = 30000
NUM_PRESCRIPTIONS = 3000
NUM_MEDICAL_ACTS = 8000 
NUM_EMERGENCIES = 5000 
NUM_EXAMS = 15000 

# Όρια Ημερομηνιών
start_date = date(2024, 1, 1)
end_date = date(2026, 12, 31)

# Λίστες για να αποθηκεύουμε τα δεδομένα πριν γίνουν DataFrames
personnel_data = [] 
doctors_data = []
nurses_data = []
admins_data = []
departments_data = []
doctors_departments_data = []
beds_data = []
patients_data = []
relatives_data = []
admissions_data = []
prescriptions_data = []
patient_acts_data = []
insurance_data = []
er_data = []
clinical_exams_data = []
exam_results_data = []
doctor_eval_data = []
admission_eval_data = []
assistants_data = []
shifts_data = []
on_call_group_data = []



# Λεξικό μετατροπής Ελληνικών χαρακτήρων σε Λατινικούς
greek_to_latin = {
    'α': 'a', 'ά': 'a', 'β': 'v', 'γ': 'g', 'δ': 'd', 'ε': 'e', 'έ': 'e',
    'ζ': 'z', 'η': 'i', 'ή': 'i', 'θ': 'th', 'ι': 'i', 'ί': 'i', 'ϊ': 'i', 'ΐ': 'i',
    'κ': 'k', 'λ': 'l', 'μ': 'm', 'ν': 'n', 'ξ': 'x', 'ο': 'o', 'ό': 'o',
    'π': 'p', 'ρ': 'r', 'σ': 's', 'ς': 's', 'τ': 't', 'υ': 'y', 'ύ': 'y', 'ϋ': 'y', 'ΰ': 'y',
    'φ': 'f', 'χ': 'ch', 'ψ': 'ps', 'ω': 'o', 'ώ': 'o'
}

# Ένα σύνολο  για να θυμάται το πρόγραμμα ποια emails έχει ήδη δώσει
generated_emails = set()
email_domains = ['gmail.com', 'yahoo.gr', 'hotmail.com', 'outlook.com', 'icloud.com']

def generate_unique_email(first_name, last_name,domain=None):
    # Μετατροπή σε πεζά
    f_lower = first_name.lower()
    l_lower = last_name.lower()
    
    # Μετατροπή σε Greeklish
    f_lat = ''.join(greek_to_latin.get(char, char) for char in f_lower)
    l_lat = ''.join(greek_to_latin.get(char, char) for char in l_lower)
    
    # Καθαρισμός από τυχόν κενά ή ειδικούς χαρακτήρες
    f_lat = re.sub(r'[^a-z]', '', f_lat)
    l_lat = re.sub(r'[^a-z]', '', l_lat)
    
    # Διαλέγουμε μια τυχαία, ρεαλιστική μορφή email
    format_choice = random.choice([
        f"{f_lat}.{l_lat}",    # giorgos.papadopoulos
        f"{f_lat[0]}{l_lat}",  # gpapadopoulos
        f"{f_lat}_{l_lat}"     # giorgos_papadopoulos
    ])
    
   # ΕΛΕΓΧΟΣ DOMAIN: Αν δεν του δώσουμε συγκεκριμένο, διαλέγει τυχαίο
    if domain is None:
        target_domain = random.choice(email_domains)
    else:
        target_domain = domain

    email = f"{format_choice}@{target_domain}"

    # ΕΞΑΣΦΑΛΙΣΗ ΜΟΝΑΔΙΚΟΤΗΤΑΣ
    original_prefix = format_choice
    counter = 1
    while email in generated_emails:
        # Αν υπάρχει ήδη, του βάζουμε ένα νούμερο, π.χ. g.papadopoulos2@hospital.gr
        email = f"{original_prefix}{counter}@{target_domain}"
        counter += 1
    # Αποθηκεύουμε το email στη λίστα για να μην το ξαναδώσουμε
    generated_emails.add(email)
    
    return email

# ΤΜΗΜΑΤΑ (χωρίς τον διευθυντή)
dept_names = ['Καρδιολογία', 'Χειρουργική', 'ΜΕΘ', 'Επείγοντα', 'Ορθοπεδική', 
              'Παιδιατρική', 'Γυναικολογία', 'Νευρολογία', 'Ογκολογία', 'Πνευμονολογία',
              'Ουρολογία', 'Οφθαλμολογία', 'ΩΡΛ', 'Γαστρεντερολογία', 'Ενδοκρινολογία']
dept_descriptions = {
    'Καρδιολογία': 'Διάγνωση και συντηρητική θεραπεία παθήσεων του καρδιαγγειακού συστήματος.',
    'Χειρουργική': 'Αντιμετώπιση περιστατικών που απαιτούν επεμβατική θεραπεία.',
    'ΜΕΘ': 'Εντατική παρακολούθηση και υποστήριξη ζωτικών λειτουργιών βαρέως πασχόντων.',
    'Επείγοντα': 'Άμεση αντιμετώπιση και διαλογή (Triage) οξέων ιατρικών περιστατικών.',
    'Ορθοπεδική': 'Θεραπεία παθήσεων και τραυματισμών του μυοσκελετικού συστήματος.',
    'Παιδιατρική': 'Πρωτοβάθμια και δευτεροβάθμια ιατρική φροντίδα βρεφών, παιδιών και εφήβων.',
    'Γυναικολογία': 'Παρακολούθηση κύησης και παθήσεων γυναικείου αναπαραγωγικού συστήματος.',
    'Νευρολογία': 'Διάγνωση και θεραπεία διαταραχών του νευρικού συστήματος.',
    'Ογκολογία': 'Ολοκληρωμένη φροντίδα και χημειοθεραπεία ασθενών με νεοπλασίες.',
    'Πνευμονολογία': 'Διάγνωση και αντιμετώπιση παθήσεων του αναπνευστικού συστήματος.',
    'Ουρολογία': 'Αντιμετώπιση παθήσεων ουροποιητικού και ανδρικού αναπαραγωγικού συστήματος.',
    'Οφθαλμολογία': 'Κλινική εξέταση και μικροχειρουργική θεραπεία παθήσεων των οφθαλμών.',
    'ΩΡΛ': 'Διάγνωση και θεραπεία παθήσεων αυτιού, μύτης και λάρυγγα.',
    'Γαστρεντερολογία': 'Ενδοσκοπικός έλεγχος και αντιμετώπιση παθήσεων πεπτικού συστήματος.',
    'Ενδοκρινολογία': 'Θεραπεία ορμονικών διαταραχών, σακχαρώδους διαβήτη και θυρεοειδούς.'
}

for name in dept_names:
    desc = dept_descriptions.get(name,'Γενική ιατρική και νοσηλευτική φροντίδα.')
    departments_data.append({
        'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': name,
        'ΠΕΡΙΓΡΑΦΗ': desc,
        'ΑΡΙΘΜΟΣ_ΚΛΙΝΩΝ': random.randint(15, 50),
        'ΟΡΟΦΟΣ_ΚΤΙΡΙΟ': f"Όροφος {random.randint(1, 5)}",
        'ΑΜΚΑ_ΔΙΕΥΘΥΝΤΗ_ΤΜΗΜΑΤΟΣ': None  # Θα το γεμίσουμε μόλις φτιάξουμε ιατρούς
    })


# ΙΑΤΡΟΙ, ΝΟΣΗΛΕΥΤΕΣ, ΔΙΟΙΚΗΤΙΚΟ ΠΡΟΣΩΠΙΚΟ 
generated_amkas = set()
def create_personnel(role_type):
    # Καθορισμός ηλικιακών ορίων βάσει του ρόλου
    min_age = 28 if role_type == 'Ιατρός' else 25
    max_age = 65
    
    #  Παραγωγή ρεαλιστικής Ημερομηνίας Γέννησης
    dob = fake.date_of_birth(minimum_age=min_age, maximum_age=max_age)
    
    # Υπολογισμός της ακριβούς ηλικίας (Τρέχουσα χρονιά - Χρονιά Γέννησης)
    today = datetime.now().date()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    
    # Δημιουργία Ρεαλιστικού και Μοναδικού ΑΜΚΑ (DDMMYY + 5 τυχαία ψηφία)
    dob_string = dob.strftime('%d%m%y') 
    
    while True:
        random_digits = fake.bothify(text='#####') 
        amka = dob_string + random_digits
        if amka not in generated_amkas: # Ελέγχουμε αν έχει ξαναβγεί
            generated_amkas.add(amka)
            break
            
    
    gender = random.choice(['Άνδρας', 'Γυναίκα'])
    
    if gender == 'Άνδρας':
        f_name = fake.first_name_male()
        l_name = fake.last_name_male()
    else:
        f_name = fake.first_name_female()
        l_name = fake.last_name_female()

    
    staff_email = generate_unique_email(f_name, l_name,domain="hospital.gr")
    

    # Αποθήκευση στη λίστα
    personnel_data.append({
        'ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ': amka,
      'ΟΝΟΜΑ': f_name,
        'ΕΠΩΝΥΜΟ': l_name,
        'ΗΛΙΚΙΑ': age,                    
         'EMAIL': staff_email, 
        'ΤΗΛΕΦΩΝΟ': fake.phone_number(),
        'ΗΜΕΡΟΜΗΝΙΑ_ΠΡΟΣΛΗΨΗΣ': fake.date_between(start_date=start_date, end_date=end_date),
        'ΤΥΠΟΣ_ΠΡΟΣΩΠΙΚΟΥ': role_type
    })
    
    return amka

generated_amkas = set()

def generate_realistic_amka_and_age(min_age, max_age):
    
    dob = fake.date_of_birth(minimum_age=min_age, maximum_age=max_age)
    
    
    today = datetime.now().date()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    
    
    dob_string = dob.strftime('%d%m%y')
    
    while True:
        random_digits = fake.bothify(text='#####') 
        amka = dob_string + random_digits
        if amka not in generated_amkas:
            generated_amkas.add(amka)
            break
    dob_relative = fake.date_of_birth(minimum_age=20, maximum_age=80)
    dob_relative_string = dob_relative.strftime('%d%m%y')
    while True:
        random_digits = fake.bothify(text='#####')
        amka_relative = dob_relative_string + random_digits
        if amka_relative not in generated_amkas:
            generated_amkas.add(amka_relative)
            break
            
    return amka, age , amka_relative

# ΙΑΤΡΟΙ 
ranks = ['Ειδικευόμενος', 'Επιμελητής Β΄', 'Επιμελητής Α΄', 'Διευθυντής']
specialties = [
    'Καρδιολόγος',
    'Χειρουργός',
    'Εντατικολόγος',
    'Ορθοπεδικός',
    'Παιδίατρος',
    'Γυναικολόγος',
    'Νευρολόγος',
    'Ογκολόγος',
    'Πνευμονολόγος',
    'Ουρολόγος',
    'Οφθαλμίατρος',
    'Ωτορινολαρυγγολόγος',
    'Γαστρεντερολόγος',
    'Ενδοκρινολόγος',
    'Επειγοντολόγος'
]

for _ in range(NUM_DOCTORS):
    amka = create_personnel('Ιατρός')
    rank = random.choices(ranks, weights=[30, 25, 15, 10], k=1)[0]
    dept = random.choice(dept_names)
    
    doctors_data.append({
        'ΑΜΚΑ_ΙΑΤΡΟΥ': amka,
        'ΑΡΙΘΜΟΣ_ΑΔΕΙΑΣ_ΙΣ': fake.unique.bothify(text='MED-######'),
        'ΕΙΔΙΚΟΤΗΤΑ': random.choice(specialties),
        'ΒΑΘΜΙΔΑ': rank,
        'ΑΜΚΑ_ΕΠΟΠΤΗ': None 
    })
    # Συνδέουμε τον ιατρό με ένα τμήμα (Πίνακας ΙΑΤΡΟΙ_ΤΜΗΜΑΤΑ)
    doctors_departments_data.append({'ΑΜΚΑ_ΙΑΤΡΟΥ': amka, 'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': dept})

# Διαχείριση Εποπτείας Ιατρών
directors = [d for d in doctors_data if d['ΒΑΘΜΙΔΑ'] == 'Διευθυντής']
epimelites_A = [d for d in doctors_data if d['ΒΑΘΜΙΔΑ'] == 'Επιμελητής Α΄']
epimelites_B = [d for d in doctors_data if d['ΒΑΘΜΙΔΑ'] == 'Επιμελητής Β΄']

for doctor in doctors_data:
    if doctor['ΒΑΘΜΙΔΑ'] == 'Ειδικευόμενος' and (epimelites_A or epimelites_B or directors):
        doctor['ΑΜΚΑ_ΕΠΟΠΤΗ'] = random.choice(epimelites_A + epimelites_B + directors)['ΑΜΚΑ_ΙΑΤΡΟΥ']
    elif doctor['ΒΑΘΜΙΔΑ'] == 'Επιμελητής Β΄' and (epimelites_A or directors) and random.random() > 0.3:
        doctor['ΑΜΚΑ_ΕΠΟΠΤΗ'] = random.choice(epimelites_A + directors)['ΑΜΚΑ_ΙΑΤΡΟΥ']

# Ανάθεση Διευθυντών στα Τμήματα
for dept in departments_data:
    if directors:
        dept['ΑΜΚΑ_ΔΙΕΥΘΥΝΤΗ_ΤΜΗΜΑΤΟΣ'] = random.choice(directors)['ΑΜΚΑ_ΙΑΤΡΟΥ']

# ΝΟΣΗΛΕΥΤΕΣ
nurse_ranks = ['Βοηθός Νοσηλευτή', 'Νοσηλευτής', 'Προϊστάμενος']
for _ in range(NUM_NURSES):
    amka = create_personnel('Νοσηλευτής')
    nurses_data.append({
        'ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ': amka,
        'ΒΑΘΜΙΔΑ': random.choices(nurse_ranks, weights=[40, 50, 10], k=1)[0],
        'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': random.choice(dept_names)
    })

# ΔΙΟΙΚΗΤΙΚΟ ΠΡΟΣΩΠΙΚΟ 
admin_roles = ['Γραμματέας', 'Λογιστής', 'Υπάλληλος Υποδοχής']
for _ in range(NUM_ADMINS):
    amka = create_personnel('Διοικητικός')
    admins_data.append({
        'ΑΜΚΑ_ΔΙΟΙΚΗΤΙΚΟΥ': amka,
        'ΡΟΛΟΣ': random.choice(admin_roles),
        'ΓΡΑΦΕΙΟ_ΕΡΓΑΣΙΑΣ': f"Γραφείο {random.randint(100, 500)}",
        'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': random.choice(dept_names)
    })


# ΚΛΙΝΕΣ
bed_types = ['ΜΕΘ', 'Μονόκλινο', 'Δίκλινο', 'Πολύκλινο']
bed_id = 1
for dept in dept_names:
    for _ in range(20):
        beds_data.append({
            'ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ': bed_id,
            'ΤΥΠΟΣ': random.choice(bed_types),
            'ΚΑΤΑΣΤΑΣΗ': random.choice(['Διαθέσιμη', 'Κατειλημμένη', 'Υπό Συντήρηση']),
            'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': dept
        })
        bed_id += 1

# ΑΣΘΕΝΕΙΣ & ΟΙΚΕΙΑ ΠΡΟΣΩΠΑ
for _ in range(NUM_PATIENTS):
    amka_patient, age , amka_relative  = generate_realistic_amka_and_age(min_age=1, max_age=95)
    # Επιλέγουμε ΠΡΩΤΑ το φύλο
    gender = random.choice(['Άνδρας', 'Γυναίκα'])

    # Φτιάχνουμε το όνομα και το επώνυμο βάσει του φύλου
    if gender == 'Άνδρας':
        first_name = fake.first_name_male()
        last_name = fake.last_name_male()
    else:
        first_name = fake.first_name_female()
        last_name = fake.last_name_female()

    patient_email = generate_unique_email(first_name, last_name)
    
    patients_data.append({
        'ΑΜΚΑ_ΑΣΘΕΝΗ': amka_patient,
        'ΟΝΟΜΑ': first_name,
        'ΕΠΩΝΥΜΟ': last_name,
        'ΠΑΤΡΩΝΥΜΟ': fake.first_name_male(),
        'ΗΛΙΚΙΑ': age,
        'ΦΥΛΟ': gender,
        'ΒΑΡΟΣ': round(random.uniform(40.0, 120.0), 1),
        'ΥΨΟΣ': random.randint(140, 195),
        'ΔΙΕΥΘΥΝΣΗ': fake.address().replace('\n', ', '),
        'ΤΗΛΕΦΩΝΟ': fake.phone_number(),
        'EMAIL': patient_email,
        'ΕΠΑΓΓΕΛΜΑ': fake.job(),
        'ΥΠΗΚΟΟΤΗΤΑ': 'Ελληνική'
    })
    
    relatives_data.append({
        'ΑΜΚΑ_ΑΤΟΜΟΥ': amka_relative,
        'ΑΜΚΑ_ΑΣΘΕΝΗ': amka_patient,
        'ΟΝΟΜΑ': fake.first_name(),
        'ΕΠΩΝΥΜΟ': fake.last_name(),
        'ΔΙΕΥΘΥΝΣΗ': fake.address().replace('\n', ', '),
        'ΤΗΛΕΦΩΝΟ': fake.phone_number(),
        'ΒΑΘΜΟΣ_ΣΥΓΓΕΝΕΙΑΣ': random.choice(['Σύζυγος', 'Γονέας', 'Αδελφός/ή', 'Τέκνο'])
    })

# ΤΜΗΜΑ ΕΠΕΙΓΟΝΤΩΝ ΠΕΡΙΣΤΑΤΙΚΩΝ


end_date_er = datetime.now()
start_date_er = end_date_er - timedelta(days=2*365)

symptoms_list = ['Οξύς πόνος στο στήθος', 'Δύσπνοια', 'Υψηλός πυρετός', 'Οξύ κοιλιακό άλγος', 'Τραυματισμός κεφαλής']
er_outcomes = ['Εξιτήριο', 'Εισαγωγή', 'Διακομιδή', 'Θάνατος', 'Αποχώρηση']

for i in range(NUM_EMERGENCIES):
    er_data.append({
        'ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ': i + 1,
        'ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ': random.choice(nurses_data)['ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ'],
        'ΣΥΜΠΤΩΜΑΤΑ': random.choice(symptoms_list),
        'ΕΠΙΠΕΔΟ_ΕΠΕΙΓΟΝΤΟΣ': random.randint(1, 5),
        'ΑΜΚΑ_ΑΣΘΕΝΗ': random.choice(patients_data)['ΑΜΚΑ_ΑΣΘΕΝΗ'],
        'ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ_ΑΦΙΞΗΣ': fake.date_time_between(start_date=start_date_er, end_date=end_date_er),
        'ΠΟΡΙΣΜΑ': random.choice([0,1]) # Εδώ αποφασίζεται αν θα γίνει νοσηλεία
    })

# ΝΟΣΗΛΕΙΕΣ

# Φόρτωση ΚΕΝ
ken_df = pd.read_csv('C:/Users/panos/DBLAB_2026/code/STATIC_DATA/KOSTOLOGISI.csv',
                     sep=';',
                     header=None,
                     names=['ΚΩΔΙΚΟΣ_ΚΕΝ', 'ΠΕΡΙΓΡΑΦΗ', 'ΚΟΣΤΟΣ', 'ΗΜΕΡΕΣ'],
                     encoding='utf-8')

ken_df['KEN_ID'] = range(1, len(ken_df) + 1)
ken_id_list = ken_df['KEN_ID'].tolist()

# Καθαρισμός δεδομένων
ken_df['ΚΟΣΤΟΣ'] = pd.to_numeric(ken_df['ΚΟΣΤΟΣ'].astype(str).str.replace(',', '.'), errors='coerce').fillna(0)
ken_df['ΗΜΕΡΕΣ'] = pd.to_numeric(ken_df['ΗΜΕΡΕΣ'], errors='coerce').fillna(1)

# Λεξικό KEN_ID → {ΚΟΣΤΟΣ, ΗΜΕΡΕΣ}
ken_dict = ken_df.set_index('KEN_ID')[['ΚΟΣΤΟΣ', 'ΗΜΕΡΕΣ']].to_dict('index')

# Mapping βασισμένο στις επίσημες 25 κατηγορίες ΤΚΑ (Τομέας Κατηγορίας Ασθένειας)
_ken_prefix_depts = {
    'Ν': ['Νευρολογία'],                                  
    'Ο': ['Οφθαλμολογία'],                               
    'Ω': ['ΩΡΛ'],                                        
    'Α': ['Πνευμονολογία', 'ΜΕΘ'],                    
    'Κ': ['Καρδιολογία', 'ΜΕΘ'],                        
    'Π': ['Γαστρεντερολογία', 'Χειρουργική'],          
    'Η': ['Γαστρεντερολογία', 'Χειρουργική'],          
    'Μ': ['Ορθοπεδική', 'Χειρουργική'],               
    'Δ': ['Χειρουργική'],                               
    'Θ': ['Ενδοκρινολογία'],                             
    'Υ': ['Ουρολογία'],                                  
    'Β': ['Ουρολογία'],                                   
    'Γ': ['Γυναικολογία'],                              
    'Λ': ['Γυναικολογία'],                               
    'Τ': ['Παιδιατρική'],                               
    'Ξ': ['Ογκολογία'],                                   
    'Σ': ['Ογκολογία'],                                   
    'Ρ': ['ΜΕΘ', 'Επείγοντα'],                         
    'Χ': ['Νευρολογία'],                              
    'Ι': ['Γαστρεντερολογία', 'Επείγοντα'],             
    'Φ': ['Χειρουργική', 'Επείγοντα', 'ΜΕΘ'],          
    'Ζ': ['ΜΕΘ', 'Χειρουργική'],                        
    'S': ['Χειρουργική', 'ΜΕΘ'],                      
    'G': ['Χειρουργική'],                                 
    'W': dept_names,                                      
    'Ε': ['Χειρουργική', 'ΜΕΘ'],                       
}

# KEN_ID → prefix (πρώτο γράμμα κωδικού ΚΕΝ) για επιλογή τμήματος
ken_id_to_prefix = {
    row['KEN_ID']: str(row['ΚΩΔΙΚΟΣ_ΚΕΝ'])[0]
    for _, row in ken_df.iterrows()
}

# Index: τμήμα → κλίνες
beds_by_dept = {}
for b in beds_data:
    beds_by_dept.setdefault(b['ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ'], []).append(b)

def _pick_bed_for_ken(selected_ken_id):
    """Επιστρέφει (τμήμα, κλίνη) συμβατά με το ΤΚΑ του επιλεγμένου ΚΕΝ."""
    prefix    = ken_id_to_prefix.get(selected_ken_id, 'W')
    depts     = _ken_prefix_depts.get(prefix, dept_names)
    valid     = [d for d in depts if beds_by_dept.get(d)]
    if not valid:
        valid = list(beds_by_dept.keys())
    dept = random.choice(valid)
    return dept, random.choice(beds_by_dept[dept])

admissions_data = []

# Νοσηλείες από ΤΕΠ

MAX_ER_ADMISSIONS = int(NUM_ADMISSIONS * 0.20)
er_admissions = [er for er in er_data if er['ΠΟΡΙΣΜΑ'] == 1][:MAX_ER_ADMISSIONS]

for er_case in er_admissions:
    arrival_dt = er_case['ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ_ΑΦΙΞΗΣ']
    
    wait_hours = random.randint(0, 6)
    adm_datetime = arrival_dt + timedelta(hours=wait_hours)
    adm_date = adm_datetime.date()

    selected_ken_id = random.choice(ken_id_list)
    ken_cost = ken_dict[selected_ken_id]['ΚΟΣΤΟΣ']
    ken_days = int(max(1, ken_dict[selected_ken_id]['ΗΜΕΡΕΣ']))
    dept_name, bed = _pick_bed_for_ken(selected_ken_id)

    extra_days = random.randint(0, 5)
    actual_days = ken_days + extra_days
    dis_date = adm_date + timedelta(days=actual_days)

    if extra_days > 0:
        daily_cost = ken_cost / ken_days
        final_cost = ken_cost + (extra_days * daily_cost)
    else:
        final_cost = ken_cost

    admissions_data.append({
        'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': len(admissions_data) + 1,
        'ΑΜΚΑ_ΑΣΘΕΝΗ': er_case['ΑΜΚΑ_ΑΣΘΕΝΗ'],
        'ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ': adm_date,
        'ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ': dis_date,
        'ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ': bed['ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ'],
        'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': dept_name,
        'ΚΟΣΤΟΣ_ΝΟΣΗΛΕΙΑΣ': round(final_cost, 2),
        'ΚΕΝ_ID': selected_ken_id,
        'ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ': er_case['ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ']
    })

# Προγραμματισμένες νοσηλείες χωρίς ΤΕΠ
remaining_admissions = NUM_ADMISSIONS - len(admissions_data)

for _ in range(remaining_admissions):
    adm_date = fake.date_between(start_date=start_date, end_date=end_date)

    selected_ken_id     = random.choice(ken_id_list)
    ken_cost            = ken_dict[selected_ken_id]['ΚΟΣΤΟΣ']
    ken_days            = int(max(1, ken_dict[selected_ken_id]['ΗΜΕΡΕΣ']))
    dept_name, bed      = _pick_bed_for_ken(selected_ken_id)

    extra_days  = random.randint(0, 8)
    actual_days = ken_days + extra_days
    dis_date    = adm_date + timedelta(days=actual_days)

    if extra_days > 0:
        daily_cost = ken_cost / ken_days
        final_cost = ken_cost + (extra_days * daily_cost)
    else:
        final_cost = ken_cost

    admissions_data.append({
        'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ':         len(admissions_data) + 1,
        'ΑΜΚΑ_ΑΣΘΕΝΗ':               random.choice(patients_data)['ΑΜΚΑ_ΑΣΘΕΝΗ'],
        'ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ':      adm_date,
        'ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ':         dis_date,
        'ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ': bed['ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ'],
        'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ':            dept_name,
        'ΚΟΣΤΟΣ_ΝΟΣΗΛΕΙΑΣ': round(final_cost, 2),
        'ΚΕΝ_ID': selected_ken_id,
        'ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ': None
    })

# ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ
for _ in range(NUM_PRESCRIPTIONS):
    adm_idx = random.randrange(len(admissions_data))
    adm = admissions_data[adm_idx]
    start_d = fake.date_between(start_date=adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ'], end_date=adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ'])
    
    prescriptions_data.append({
        'ΑΜΚΑ_ΙΑΤΡΟΥ': random.choice(doctors_data)['ΑΜΚΑ_ΙΑΤΡΟΥ'],
        'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': adm_idx + 1,
        'ΑΜΚΑ_ΑΣΘΕΝΗ': adm['ΑΜΚΑ_ΑΣΘΕΝΗ'],
        'ΦΑΡΜΑΚΟ_ID': random.randint(1, 151019),
        'ΔΟΣΟΛΟΓΙΑ': f"{random.randint(1,3)} mg",
        'ΣΥΧΝΟΤΗΤΑ': random.choice(['1x', '2x', '3x']),
        'ΗΜΕΡΟΜΗΝΙΑ_ΕΝΑΡΞΗΣ': start_d,
        'ΗΜΕΡΟΜΗΝΙΑ_ΛΗΞΗΣ': start_d + timedelta(days=random.randint(3, 10))
    })

# ΙΑΤΡΙΚΕΣ ΠΡΑΞΕΙΣ ΑΣΘΕΝΗ
practices_df = pd.read_csv('C:/Users/panos/DBLAB_2026/code/STATIC_DATA/PRACTICES_FINAL.csv', 
                           sep='|', 
                           header=None,
                           names=['ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ', 'ΟΝΟΜΑ', 'ΚΑΤΗΓΟΡΙΑ', 'ΔΙΑΡΚΕΙΑ', 'ΚΟΣΤΟΣ', 'ΧΩΡΟΣ'],
                           encoding='utf-8-sig')

# ΔΙΑΡΚΕΙΑ (χρειάζεται για τον υπολογισμό αλληλεπικαλύψεων)
practices_list = practices_df[['ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ', 'ΧΩΡΟΣ', 'ΔΙΑΡΚΕΙΑ']].to_dict('records')

# Ενεργές κρατήσεις
room_bookings   = {}  
doctor_bookings = {}  

def _has_overlap(bookings, key, start, end):
    for s, e in bookings.get(key, []):
        if start < e and s < end:
            return True
    return False


for _ in range(NUM_MEDICAL_ACTS):
    placed = False
    for _attempt in range(30):
        adm_idx  = random.randrange(len(admissions_data))
        adm      = admissions_data[adm_idx]
        practice = random.choice(practices_list)
        doctor   = random.choice(doctors_data)

        act_start = fake.date_time_between_dates(
            datetime_start=datetime.combine(adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ'], datetime.min.time()),
            datetime_end=datetime.combine(adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ'],     datetime.min.time())
        )
        act_end  = act_start + timedelta(minutes=int(practice['ΔΙΑΡΚΕΙΑ']))
        room     = practice['ΧΩΡΟΣ']
        amka_dr  = doctor['ΑΜΚΑ_ΙΑΤΡΟΥ']

        if _has_overlap(room_bookings, room, act_start, act_end):
            continue
        if _has_overlap(doctor_bookings, amka_dr, act_start, act_end):
            continue

        room_bookings.setdefault(room, []).append((act_start, act_end))
        doctor_bookings.setdefault(amka_dr, []).append((act_start, act_end))

        patient_acts_data.append({
            'ΑΜΚΑ_ΑΣΘΕΝΗ':      adm['ΑΜΚΑ_ΑΣΘΕΝΗ'],
            'ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ':   practice['ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ'],
            'ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ':   act_start,
            'ΑΙΘΟΥΣΑ':          room,
            'ΑΜΚΑ_ΙΑΤΡΟΥ':      amka_dr,
            'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': adm_idx + 1
        })
        placed = True
        break
    
# ΑΣΦΑΛΙΣΤΙΚΟΣ ΦΟΡΕΑΣ
insurance_providers = ['ΕΟΠΥΥ', 'ΕΘΝΙΚΗ ΑΣΦΑΛΙΣΤΙΚΗ', 'INTERAMERICAN', 'ΕΥΡΩΠΑΪΚΗ ΠΙΣΤΗ', 'GENERALI', 'NN HELLAS', 'EUROLIFE FFH']

for patient in patients_data:
    if random.random() < 0.75:  # 75% πιθανότητα να είναι ασφαλισμένος
        insurance_data.append({
            'ΑΡΙΘΜΟΣ_ΣΥΜΒΟΛΑΙΟΥ': fake.unique.bothify(text='INS-#########'),
            'ΟΝΟΜΑ_ΦΟΡΕΑ': random.choice(insurance_providers),
            'ΑΜΚΑ_ΑΣΘΕΝΗ': patient['ΑΜΚΑ_ΑΣΘΕΝΗ']
        })

# ΚΛΙΝΙΚΕΣ ΕΞΕΤΑΣΕΙΣ & ΕΞΕΤΑΣΕΙΣ ΑΠΟΤΕΛΕΣΜΑΤΑ
# Ένα λεξικό με τους πιθανούς τύπους εξετάσεων και το αν έχουν αριθμητικό αποτέλεσμα
exam_catalog = [
    {'ΤΥΠΟΣ': 'Γενική Αίματος', 'ΜΟΝΑΔΑ': 'K/μL', 'IS_NUMERIC': True},
    {'ΤΥΠΟΣ': 'Ακτινογραφία Θώρακος', 'ΜΟΝΑΔΑ': None, 'IS_NUMERIC': False},
    {'ΤΥΠΟΣ': 'Μαγνητική Τομογραφία (MRI)', 'ΜΟΝΑΔΑ': None, 'IS_NUMERIC': False},
    {'ΤΥΠΟΣ': 'Σάκχαρο Αίματος', 'ΜΟΝΑΔΑ': 'mg/dL', 'IS_NUMERIC': True},
    {'ΤΥΠΟΣ': 'Χοληστερίνη', 'ΜΟΝΑΔΑ': 'mg/dL', 'IS_NUMERIC': True},
    {'ΤΥΠΟΣ': 'Υπέρηχος Κοιλίας', 'ΜΟΝΑΔΑ': None, 'IS_NUMERIC': False},
    {'ΤΥΠΟΣ': 'Ηλεκτροκαρδιογράφημα (ΗΚΓ)', 'ΜΟΝΑΔΑ': None, 'IS_NUMERIC': False},
    {'ΤΥΠΟΣ': 'PCR COVID-19', 'ΜΟΝΑΔΑ': None, 'IS_NUMERIC': False},
    {'ΤΥΠΟΣ': 'Ουρία', 'ΜΟΝΑΔΑ': 'mg/dL', 'IS_NUMERIC': True},
    {'ΤΥΠΟΣ': 'Κρεατινίνη', 'ΜΟΝΑΔΑ': 'mg/dL', 'IS_NUMERIC': True}
]

for i in range(NUM_EXAMS):
    # Παίρνουμε μια τυχαία νοσηλεία για να συνδέσουμε Ασθενή και Νοσηλεία σωστά
    adm_idx = random.randrange(len(admissions_data))
    adm = admissions_data[adm_idx]
    exam_def = random.choice(exam_catalog)
    
    # Φτιάχνουμε τον Μοναδικό Κωδικό της Εξέτασης
    exam_code = f"EXM_{i+1:05d}"
    
    # Προσθήκη στον πίνακα ΕΞΕΤΑΣΕΙΣ
    clinical_exams_data.append({
        'ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ': exam_code,
        'ΤΥΠΟΣ': exam_def['ΤΥΠΟΣ'],
        'ΚΟΣΤΟΣ': round(random.uniform(15.0, 250.0), 2)
    })
    
    # Παραγωγή δεδομένων για το Αποτέλεσμα
    if exam_def['IS_NUMERIC']:
        value = str(round(random.uniform(10.0, 200.0), 2))
        description = "Εντός φυσιολογικών ορίων" if random.random() > 0.2 else "Εκτός φυσιολογικών ορίων - Χρήζει προσοχής"
        unit = exam_def['ΜΟΝΑΔΑ']
    else:
        value = None
        description = random.choice([
            "Φυσιολογικά ευρήματα.", 
            "Απαιτείται περαιτέρω κλινική διερεύνηση.", 
            "Παθολογικά ευρήματα (βλ. αναλυτική γνωμάτευση).", 
            "Αρνητικό.", 
            "Θετικό."
        ])
        unit = None

    # Ημερομηνία εξέτασης (ανάμεσα στην εισαγωγή και έξοδο του ασθενούς)
    exam_date = fake.date_time_between_dates(
        datetime_start=datetime.combine(adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ'], datetime.min.time()),
        datetime_end=datetime.combine(adm['ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ'], datetime.min.time())
    )

    # Προσθήκη στον πίνακα ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ
    exam_results_data.append({
        'ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ': exam_code,  # Ίδιος κωδικός (Σχέση 1:1)
        'ΑΠΟΤΕΛΕΣΜΑ_ΠΕΡΙΓΡΑΦΗ': description,
        'ΑΠΟΤΕΛΕΣΜΑ_ΤΙΜΗ': value,
        'ΑΠΟΤΕΛΕΣΜΑ_ΜΟΝΑΔΑ_ΜΕΤΡΗΣΗΣ': unit,
        'ΑΜΚΑ_ΙΑΤΡΟΥ': random.choice(doctors_data)['ΑΜΚΑ_ΙΑΤΡΟΥ'],
        'ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ': exam_date,
        'ΑΜΚΑ_ΑΣΘΕΝΗ': adm['ΑΜΚΑ_ΑΣΘΕΝΗ'],
        'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': adm_idx + 1
    })

 # ΔΙΑΓΝΩΣΕΙΣ ΝΟΣΗΛΕΙΑΣ
adm_diagnoses_data = []

icd10_df = pd.read_csv('C:/Users/panos/DBLAB_2026/code/STATIC_DATA/ICD_10_FINAL.csv', 
                       sep=';',
                       header=None,
                       names=['ΚΩΔΙΚΟΣ_ICD_10', 'ΠΕΡΙΓΡΑΦΗ'],
                       encoding='utf-8')

icd10_list = icd10_df['ΚΩΔΙΚΟΣ_ICD_10'].tolist()

for i, adm in enumerate(admissions_data):
    num_diagnoses = random.choices([1, 2], weights=[70, 30], k=1)[0]
    
    icd_eisodou = random.choice(icd10_list)
    adm_diagnoses_data.append({
        'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': i+1,
        'ΚΩΔΙΚΟΣ_ICD_10': icd_eisodou,
        'ΤΥΠΟΣ': 'Εισόδου'
    })

    if num_diagnoses > 1:
        icd_exodou = random.choice(icd10_list)
        while icd_exodou == icd_eisodou:
            icd_exodou = random.choice(icd10_list)
        adm_diagnoses_data.append({
            'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': i+1,
            'ΚΩΔΙΚΟΣ_ICD_10': icd_exodou,
            'ΤΥΠΟΣ': 'Εξόδου'
        })

# 12. ΑΞΙΟΛΟΓΗΣΗ ΙΑΤΡΟΥ
# Το trigger απαιτεί η αξιολόγηση να αντιστοιχεί σε συνταγογράφηση ίδιου ιατρού + ίδιας νοσηλείας.
dr_patient_adm_triples = set()
for pres in prescriptions_data:
    dr_patient_adm_triples.add((pres['ΑΜΚΑ_ΑΣΘΕΝΗ'], pres['ΑΜΚΑ_ΙΑΤΡΟΥ'], pres['ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ']))
patient_admissions_index = {}
# Περίπου το 80% των αξιολογήσιμων συνδυασμών δίνουν αξιολόγηση
for amka_patient, amka_doctor, kod_nosileias in list(dr_patient_adm_triples):
    if random.random() < 0.80:
        doctor_eval_data.append({
            'ΑΜΚΑ_ΑΣΘΕΝΗ': amka_patient,
            'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': kod_nosileias,
            'ΑΜΚΑ_ΙΑΤΡΟΥ': amka_doctor,
            'ΠΟΙΟΤΗΤΑ_ΙΑΤΡΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ': random.randint(1, 5) 
        })

# ΑΞΙΟΛΟΓΗΣΗ ΝΟΣΗΛΕΙΑΣ
# Περίπου το 80% των νοσηλειών αξιολογούνται
seen_evals = set()
for i, adm in enumerate(admissions_data):
    if random.random() < 0.80:
        key=(adm['ΑΜΚΑ_ΑΣΘΕΝΗ'],i+1)
        if key not in seen_evals:
            seen_evals.add(key)
            ποιοτητα = random.randint(1, 5)
            καθαριοτητα = random.randint(1, 5)
            φαγητο = random.randint(1, 5)
            συνολικη = round(ποιοτητα * 0.50 + καθαριοτητα * 0.30 + φαγητο * 0.20)
            admission_eval_data.append({
                'ΑΜΚΑ_ΑΣΘΕΝΗ': adm['ΑΜΚΑ_ΑΣΘΕΝΗ'],
                'ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ': i+1,
                'ΠΟΙΟΤΗΤΑ_ΝΟΣΗΛΕΥΤΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ': ποιοτητα,
                'ΚΑΘΑΡΙΟΤΗΤΑ': καθαριοτητα,
                'ΦΑΓΗΤΟ': φαγητο,
                'ΣΥΝΟΛΙΚΗ_ΕΜΠΕΙΡΙΑ': random.randint(1, 5) 
        })
# ΒΟΗΘΟΙ 
assistants_data = []
for act in patient_acts_data:
    if random.random() < 0.30:  # 30% των πράξεων έχουν βοηθό
        assistants_data.append({
            'ΑΜΚΑ_ΒΟΗΘΟΥ': random.choice(personnel_data)['ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ'],
            'ΑΜΚΑ_ΑΣΘΕΝΗ': act['ΑΜΚΑ_ΑΣΘΕΝΗ'],
            'ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ': act['ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ'],
            'ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ': act['ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ']
        })

# ΒΑΡΔΙΕΣ ΚΑΙ ΟΜΑΔΑ ΕΦΗΜΕΡΙΑΣ
shifts_data = []
on_call_group_data = []

NUM_DAYS_SHIFTS = 730
shift_types = [
    ('Πρωινή', 7, 15), 
    ('Απογευματινή', 15, 23), 
    ('Νυχτερινή', 23, 7)
]
shift_id = 1

# Λεξικά παρακολούθησης των περιορισμών 
from collections import defaultdict

shifts_per_month = defaultdict(lambda: defaultdict(int))
last_shift_end = {p['ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ']: datetime.min for p in personnel_data}
consecutive_nights = {p['ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ']: 0 for p in personnel_data}

start_shifts = date(2025, 1, 1)
shift_dates = [start_shifts + timedelta(days = i) for i in range(NUM_DAYS_SHIFTS)]

# Ομαδοποίηση προσωπικού για γρήγορη αναζήτηση
docs_by_dept = {dept: [] for dept in dept_names}
for dd in doctors_departments_data:
    # Βρίσκουμε τον ιατρό για να ξέρουμε τη βαθμίδα του
    doc_info = next(d for d in doctors_data if d['ΑΜΚΑ_ΙΑΤΡΟΥ'] == dd['ΑΜΚΑ_ΙΑΤΡΟΥ'])
    docs_by_dept[dd['ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ']].append(doc_info)

nurses_by_dept = {dept: [] for dept in dept_names}
for n in nurses_data:
    nurses_by_dept[n['ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ']].append(n['ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ'])

admins_by_dept = {dept: [] for dept in dept_names}
for a in admins_data:
    admins_by_dept[a['ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ']].append(a['ΑΜΚΑ_ΔΙΟΙΚΗΤΙΚΟΥ'])
            # --- ΒΟΗΘΗΤΙΚΗ ΣΥΝΑΡΤΗΣΗ ΕΛΕΓΧΟΥ ΠΕΡΙΟΡΙΣΜΩΝ ---
def is_eligible(amka, max_monthly, is_night):
        year_month = (d_date.year, d_date.month)
        if shifts_per_month[amka][year_month] >= max_monthly: return False
        if (start_dt - last_shift_end[amka]).total_seconds() < 8 * 3600: return False
        if is_night and consecutive_nights[amka] >= 3: return False
        return True

for d_date in shift_dates:
    for dept in dept_names:
        for s_name, start_h, end_h in shift_types:
            # Υπολογισμός ακριβούς ώρας έναρξης και λήξης βάρδιας (για τον έλεγχο του 8ώρου)
            start_dt = datetime.combine(d_date, datetime.min.time().replace(hour=start_h))
            end_dt = datetime.combine(d_date, datetime.min.time().replace(hour=end_h))
            if s_name == 'Νυχτερινή':
                end_dt += timedelta(days=1) # Η νυχτερινή τελειώνει την επόμενη μέρα
                
            s_code = f"SHF_{shift_id:05d}"
            shifts_data.append({
                'ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ': s_code,
                'ΤΥΠΟΣ': s_name,
                'ΗΜΕΡΟΜΗΝΙΑ': d_date,
                'ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ': dept
            })
            shift_id += 1

        

            # ΕΠΙΛΟΓΗ ΙΑΤΡΩΝ (Απαιτούνται 3. Κανόνας: Ειδικευόμενος -> Παρουσία Επιμελητή Α/Διευθυντή)
            available_docs = docs_by_dept[dept]
            eligible_docs = [doc for doc in available_docs if is_eligible(doc['ΑΜΚΑ_ΙΑΤΡΟΥ'], 15, s_name == 'Νυχτερινή')]
            
            seniors = [doc['ΑΜΚΑ_ΙΑΤΡΟΥ'] for doc in eligible_docs if doc['ΒΑΘΜΙΔΑ'] in ['Επιμελητής Α΄', 'Διευθυντής']]
            others = [doc['ΑΜΚΑ_ΙΑΤΡΟΥ'] for doc in eligible_docs if doc['ΒΑΘΜΙΔΑ'] not in ['Επιμελητής Α΄', 'Διευθυντής']]
            
            chosen_docs = []
            # Βάζουμε πάντα 1 senior πρώτα ώστε το trigger AFTER INSERT να τον βρίσκει ήδη
            if seniors:
                chosen_docs.append(seniors.pop(0))
                pool = seniors + others  # υπόλοιποι — μπορεί να περιλαμβάνουν Ειδικευόμενο
            else:
                # Χωρίς senior, αποκλείουμε Ειδικευόμενους για να μην πυροδοτηθεί το trigger
                pool = [doc['ΑΜΚΑ_ΙΑΤΡΟΥ'] for doc in eligible_docs if doc['ΒΑΘΜΙΔΑ'] == 'Επιμελητής Β΄']
            # Συμπληρώνουμε μέχρι 3
            random.shuffle(pool)
            while len(chosen_docs) < 3 and pool:
                chosen_docs.append(pool.pop(0))
                
            for amka in chosen_docs:
                on_call_group_data.append({'ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ': s_code, 'ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ': amka})
                shifts_per_month[amka][(d_date.year, d_date.month)] += 1
                last_shift_end[amka] = end_dt
                if s_name == 'Νυχτερινή': consecutive_nights[amka] += 1
                else: consecutive_nights[amka] = 0 # Reset αν κάνει πρωί/απόγευμα
                
            #  ΕΠΙΛΟΓΗ ΝΟΣΗΛΕΥΤΩΝ (Απαιτούνται 6) ---
            eligible_nurses = [amka for amka in nurses_by_dept[dept] if is_eligible(amka, 20, s_name == 'Νυχτερινή')]
            chosen_nurses = random.sample(eligible_nurses, k=min(6, len(eligible_nurses)))
            
            for amka in chosen_nurses:
                on_call_group_data.append({'ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ': s_code, 'ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ': amka})
                shifts_per_month[amka][(d_date.year, d_date.month)] += 1
                last_shift_end[amka] = end_dt
                if s_name == 'Νυχτερινή': consecutive_nights[amka] += 1
                else: consecutive_nights[amka] = 0
                
            # ΕΠΙΛΟΓΗ ΔΙΟΙΚΗΤΙΚΟΥ ΠΡΟΣΩΠΙΚΟΥ (Απαιτούνται 2) ---
            eligible_admins = [amka for amka in admins_by_dept[dept] if is_eligible(amka, 25, s_name == 'Νυχτερινή')]
            chosen_admins = random.sample(eligible_admins, k=min(2, len(eligible_admins)))
            
            for amka in chosen_admins:
                on_call_group_data.append({'ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ': s_code, 'ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ': amka})
                shifts_per_month[amka][(d_date.year, d_date.month)] += 1
                last_shift_end[amka] = end_dt
                if s_name == 'Νυχτερινή': consecutive_nights[amka] += 1
                else: consecutive_nights[amka] = 0

# ΑΛΛΕΡΓΙΕΣ
allergies_data = []

substances_df = pd.read_csv('C:/Users/panos/DBLAB_2026/code/STATIC_DATA/DRUG_SUBSTANCES.csv', 
                            sep=';',
                            header=None,
                            names=['ID_ΟΥΣΙΑΣ', 'ΟΝΟΜΑ_ΟΥΣΙΑΣ'], 
                            encoding='utf-8')

# Παίρνουμε τη λίστα με τα ΟΝΟΜΑΤΑ και όχι τα IDs
substances_names_list = substances_df['ΟΝΟΜΑ_ΟΥΣΙΑΣ'].tolist()

for patient in patients_data:
    # 20% πιθανότητα ένας ασθενής να έχει αλλεργία
    if random.random() < 0.20:
        # Μπορεί να έχει από 1 έως 3 αλλεργίες
        num_allergies = random.choices([1, 2, 3], weights=[75, 20, 5], k=1)[0]

# Επιλέγουμε τυχαία ΟΝΟΜΑΤΑ ουσιών χωρίς να διπλοτυπώνονται για τον ίδιο ασθενή
        patient_allergens = random.sample(substances_names_list, k=num_allergies)

        for allergen_name in patient_allergens:
            allergies_data.append({
                'ΑΜΚΑ_ΑΣΘΕΝΗ': patient['ΑΜΚΑ_ΑΣΘΕΝΗ'],
                'ΑΛΛΕΡΓΙΑ_ΣΕ_ΟΥΣΙΑ': allergen_name
            })

# ΦΩΤΟΓΡΑΦΙΕΣ 
photos_data = []

# Φωτογραφίες για Ιατρούς 
for doc in doctors_data:
    amka = doc['ΑΜΚΑ_ΙΑΤΡΟΥ']  
    photos_data.append({
        'IMAGE_URL': f"https://www.hospital.gr/assets/images/doctors/doc{amka}.jpg",
        'ΠΕΡΙΓΡΑΦΗ': f"Επίσημη φωτογραφία προφίλ του ιατρού με ΑΜΚΑ {amka}",
        'ΤΥΠΟΣ_ΟΝΤΟΤΗΤΑΣ': "Ιατρός",
        'ID_ΟΝΤΟΤΗΤΑΣ': amka
    })

# Φωτογραφίες για Τμήματα 
for dep in departments_data:
    onoma = dep['ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ']
    safename = onoma.replace(' ', '').lower()
    photos_data.append({
        'IMAGE_URL': f"https://www.hospital.gr/assets/images/departments/%7Bsafe_name%7D.jpg",
        'ΠΕΡΙΓΡΑΦΗ': f"Άποψη των εγκαταστάσεων του τμήματος: {onoma}",
        'ΤΥΠΟΣ_ΟΝΤΟΤΗΤΑΣ': "Τμήμα",
        'ID_ΟΝΤΟΤΗΤΑΣ': onoma
    })

# Φωτογραφίες για Εξοπλισμό 
equipments = [
    ('Μαγνητικός Τομογράφος', 'MRI_01'),
    ('Αξονικός Τομογράφος', 'CT_02'),
    ('Μηχάνημα Υπερήχων', 'US_03')
]
for eq_name, eq_id in equipments:
    photos_data.append({
        'IMAGE_URL': f"https://www.hospital.gr/assets/images/equipment/%7Beq_id%7D.jpg",
        'ΠΕΡΙΓΡΑΦΗ': f"Ιατρικός εξοπλισμός: {eq_name}",
        'ΤΥΠΟΣ_ΟΝΤΟΤΗΤΑΣ': "Εξοπλισμός",
        'ID_ΟΝΤΟΤΗΤΑΣ': eq_id
    })

# ΕΞΑΓΩΓΗ ΣΕ CSV

path = "C:/Users/panos/DBLAB_2026/code/MOCK_DATA/"

# Μετατροπή σε DataFrames
dfs = {
    'PERSONNEL': pd.DataFrame(personnel_data),
    'DOCTORS': pd.DataFrame(doctors_data),
    'NURSES': pd.DataFrame(nurses_data),
    'ADMINS': pd.DataFrame(admins_data),
    'DEPARTMENTS': pd.DataFrame(departments_data),
    'DOCTORS_DEPARTMENTS': pd.DataFrame(doctors_departments_data),
    'BEDS': pd.DataFrame(beds_data),
    'PATIENTS': pd.DataFrame(patients_data),
    'RELATIVES': pd.DataFrame(relatives_data),
    'ADMISSIONS': pd.DataFrame(admissions_data),
    'PRESCRIPTIONS': pd.DataFrame(prescriptions_data),
    'PATIENT_ACTS': pd.DataFrame(patient_acts_data),
    'INSURANCE': pd.DataFrame(insurance_data),         
    'EMERGENCY_ROOM': pd.DataFrame(er_data),
    'CLINICAL_EXAMS': pd.DataFrame(clinical_exams_data),
    'EXAM_RESULTS': pd.DataFrame(exam_results_data),
    'DOCTOR_EVAL': pd.DataFrame(doctor_eval_data),
    'ADMISSION_EVAL': pd.DataFrame(admission_eval_data),
    'ASSISTANTS': pd.DataFrame(assistants_data),
    'SHIFTS': pd.DataFrame(shifts_data),
    'ON_CALL_GROUP': pd.DataFrame(on_call_group_data),
    'ADMISSION_DIAGNOSES':pd.DataFrame(adm_diagnoses_data),
    'ALLERGIES': pd.DataFrame(allergies_data),
    'PHOTOS':pd.DataFrame(photos_data)
}

# Εξαγωγή του κάθε DataFrame σε αρχείο csv 
for table_name, df in dfs.items():
    df.to_csv(f"{path}{table_name}.csv", index=False, encoding='utf-8')

print("Όλα τα CSV αρχεία  δημιουργήθηκαν επιτυχώς!")