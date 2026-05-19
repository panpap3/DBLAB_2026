# DBLAB-2026
# General Hospital — Database System

**Databases Semester Project 2025-2026**  
School of Electrical and Computer Engineering, NTUA

## Overview
Design and implementation of a storage and management system for a General Hospital. The database manages staff, patients, admissions, shifts, medications, medical procedures, and evaluations.

## Directory Structure
```text
├── README.md
├── diagrams/
│   ├── er.pdf
│   └── relational.pdf
├── sql/
│   ├── install.sql
│   ├── load.sql
│   ├── Q01.sql / Q01_out.txt
│   ├── ...
│   └── Q15.sql / Q15_out.txt
├── docs/
│   └── report.pdf
└── code/
    └── MOCK_DATA/
    └── ORIGINAL_FILES/
    └── STATIC_DATA/   z
    └── databases.py
    └── clean_KEN_File.py
    └── drastiki_ousia.py
    └── iatrikes_prajeis.py
    └── farmako_arthro_57.py
```

 ## Directory Features

- **Database Management:** Utilizes MariaDB for robust and scalable data storage of hospital operations including staff, patients, admissions, and medical procedures.
- **Data Generation:** Includes a Python script (`databases.py`) to generate realistic synthetic data for all entities, respecting all business constraints and referential integrity.
- **Triggers & Constraints:** Implements MariaDB triggers to automatically enforce business rules such as shift limits, allergy checks, supervision hierarchy, and concurrent procedure conflicts.
- **Original Files:** Integrates real-world reference datasets including ICD-10 diagnosis codes, EMA Article 57 approved medications, KEN (DRG) billing codes, and official Greek medical procedure classifications.

This project is ideal for hospital administrators, medical informaticians, and anyone interested in managing large-scale healthcare facility data.

## Database Features

- **Staff Management:** Store detailed information about doctors, nurses, and administrative staff, including specialties, ranks, supervision hierarchy, and shift assignments.
- **Patient Management:** Handle patient records including personal data, insurance information, emergency contacts, allergies, and complete admission history.
- **Admission & Billing:** Manage hospital admissions with diagnosis (ICD-10), bed assignment, KEN-based billing, and extra charges for extended stays.
- **Shift Scheduling:** Organize daily on-call groups across all departments and shifts, enforcing monthly limits, rest periods, and supervision rules automatically.
- **Medical Procedures & Examinations:** Track surgical and diagnostic procedures, operating room scheduling, and laboratory examination results.
- **Pharmacy & Prescriptions:** Manage drug prescriptions with allergy safety checks against the EMA Article 57 database, preventing dangerous drug interactions.
- **Emergency Triage:** Record and prioritize emergency department cases by urgency level (1-5) following FIFO logic within each priority level.
- **Patient Reviews:** Allow patients with completed admissions to rate their nursing care experience and individual doctors who treated them.


## Installation

1. **Clone the repository:**
git clone <repository_url>
cd DBLAB-2026

2. **Create and activate virtual environment:**

- Windows (PowerShell):
```text
python -m venv .venv
..venv\Scripts\Activate.ps1
```
- Windows (CMD):
```text
python -m venv .venv
.venv\Scripts\activate
```
- Linux/Mac:
```text
python -m venv .venv
source .venv/bin/activate
```
3. **Install the required Python libraries:**
```text
pip install -r requirements.txt
```
4. **Generate synthetic data:**
```text
python code/databases.py
```
5. **Set up the MariaDB database (via XAMPP Shell):**
```text
mysql -u root 
source /file location/install.sql
source /file location/load.sql
```
6. **Run a query directly (via XAMPP Shell):**
```text
source /file loaction/sql/Q01.sql
```
7. **(Optional) If you want to see how the other .py files work that clean the data run:**
```text
python code/databases.py
python code/drastiki_ousia.py
python code/clean_KEN_File.py
python code/iatrikes_prajeis.py
python code/farmako_arthro_57.py
```