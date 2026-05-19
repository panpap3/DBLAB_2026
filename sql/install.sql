DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE ΠΡΟΣΩΠΙΚΟ (
    ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ VARCHAR(11) NOT NULL,
    ΟΝΟΜΑ VARCHAR(50) NOT NULL,
    ΕΠΩΝΥΜΟ VARCHAR(50) NOT NULL,
    ΗΛΙΚΙΑ INT NOT NULL CHECK (ΗΛΙΚΙΑ >= 18),
    EMAIL VARCHAR(100) NOT NULL UNIQUE,
    ΤΗΛΕΦΩΝΟ VARCHAR(30) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΠΡΟΣΛΗΨΗΣ DATE NOT NULL,
    ΤΥΠΟΣ_ΠΡΟΣΩΠΙΚΟΥ VARCHAR(20) NOT NULL CHECK (ΤΥΠΟΣ_ΠΡΟΣΩΠΙΚΟΥ IN ('Ιατρός', 'Νοσηλευτής', 'Διοικητικός')),
    PRIMARY KEY (ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
);

CREATE TABLE ΙΑΤΡΟΙ (
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΑΡΙΘΜΟΣ_ΑΔΕΙΑΣ_ΙΣ VARCHAR(20) NOT NULL UNIQUE,
    ΕΙΔΙΚΟΤΗΤΑ VARCHAR(50) NOT NULL,
    ΒΑΘΜΙΔΑ VARCHAR(20) NOT NULL CHECK (ΒΑΘΜΙΔΑ IN ('Ειδικευόμενος', 'Επιμελητής Β΄', 'Επιμελητής Α΄', 'Διευθυντής')),
    ΑΜΚΑ_ΕΠΟΠΤΗ VARCHAR(11) NULL,
    PRIMARY KEY (ΑΜΚΑ_ΙΑΤΡΟΥ),
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΠΡΟΣΩΠΙΚΟ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΕΠΟΠΤΗ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE ΤΜΗΜΑ (
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    ΠΕΡΙΓΡΑΦΗ TEXT,
    ΑΡΙΘΜΟΣ_ΚΛΙΝΩΝ INT NOT NULL CHECK (ΑΡΙΘΜΟΣ_ΚΛΙΝΩΝ > 0),
    ΟΡΟΦΟΣ_ΚΤΙΡΙΟ VARCHAR(50) NOT NULL,
    ΑΜΚΑ_ΔΙΕΥΘΥΝΤΗ_ΤΜΗΜΑΤΟΣ VARCHAR(11) NULL,
    PRIMARY KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
);

CREATE TABLE ΝΟΣΗΛΕΥΤΕΣ (
    ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ VARCHAR(11) NOT NULL,
    ΒΑΘΜΙΔΑ VARCHAR(20) NOT NULL CHECK (ΒΑΘΜΙΔΑ IN ('Βοηθός Νοσηλευτή', 'Νοσηλευτής', 'Προϊστάμενος')),
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ),
    FOREIGN KEY (ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ) REFERENCES ΠΡΟΣΩΠΙΚΟ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΔΙΟΙΚΗΤΙΚΟ_ΠΡΟΣΩΠΙΚΟ (
    ΑΜΚΑ_ΔΙΟΙΚΗΤΙΚΟΥ VARCHAR(11) NOT NULL,
    ΡΟΛΟΣ VARCHAR(50) NOT NULL,
    ΓΡΑΦΕΙΟ_ΕΡΓΑΣΙΑΣ VARCHAR(50) NOT NULL,
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΔΙΟΙΚΗΤΙΚΟΥ),
    FOREIGN KEY (ΑΜΚΑ_ΔΙΟΙΚΗΤΙΚΟΥ) REFERENCES ΠΡΟΣΩΠΙΚΟ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE ΤΜΗΜΑ
ADD FOREIGN KEY (ΑΜΚΑ_ΔΙΕΥΘΥΝΤΗ_ΤΜΗΜΑΤΟΣ) 
REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE ΙΑΤΡΟΙ_ΤΜΗΜΑΤΑ (
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΙΑΤΡΟΥ, ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ),
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ΚΛΙΝΕΣ (
    ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ VARCHAR(20) NOT NULL,
    ΤΥΠΟΣ VARCHAR(20) NOT NULL CHECK (ΤΥΠΟΣ IN ('ΜΕΘ', 'Μονόκλινο', 'Πολύκλινο','Δίκλινο')),
    ΚΑΤΑΣΤΑΣΗ VARCHAR(20) NOT NULL CHECK (ΚΑΤΑΣΤΑΣΗ IN ('Διαθέσιμη', 'Κατειλημμένη', 'Υπό Συντήρηση')),
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ),
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE ΑΣΘΕΝΕΙΣ (
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΟΝΟΜΑ VARCHAR(50) NOT NULL,
    ΕΠΩΝΥΜΟ VARCHAR(50) NOT NULL,
    ΠΑΤΡΩΝΥΜΟ VARCHAR(50) NOT NULL,
    ΗΛΙΚΙΑ INT NOT NULL CHECK (ΗΛΙΚΙΑ >= 0),
    ΦΥΛΟ VARCHAR(10) NOT NULL CHECK (ΦΥΛΟ IN ('Άνδρας', 'Γυναίκα')),
    ΒΑΡΟΣ DECIMAL(5,2) NOT NULL CHECK (ΒΑΡΟΣ > 0),
    ΥΨΟΣ DECIMAL(5,2) NOT NULL CHECK (ΥΨΟΣ > 0),
    ΔΙΕΥΘΥΝΣΗ VARCHAR(100) NOT NULL,
    ΤΗΛΕΦΩΝΟ VARCHAR(30) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    ΕΠΑΓΓΕΛΜΑ VARCHAR(100),
    ΥΠΗΚΟΟΤΗΤΑ VARCHAR(50) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΑΣΘΕΝΗ)
);

CREATE TABLE ΑΣΦΑΛΙΣΤΙΚΟΣ_ΦΟΡΕΑΣ (
    ΑΡΙΘΜΟΣ_ΣΥΜΒΟΛΑΙΟΥ VARCHAR(20) NOT NULL,
    ΟΝΟΜΑ_ΦΟΡΕΑ VARCHAR(100) NOT NULL,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    PRIMARY KEY (ΑΡΙΘΜΟΣ_ΣΥΜΒΟΛΑΙΟΥ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ΣΤΟΙΧΕΙΑ_ΟΙΚΕΙΩΝ_ΑΤΟΜΩΝ (
    ΑΜΚΑ_ΑΤΟΜΟΥ VARCHAR(11) NOT NULL,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΟΝΟΜΑ VARCHAR(50) NOT NULL,
    ΕΠΩΝΥΜΟ VARCHAR(50) NOT NULL,
    ΔΙΕΥΘΥΝΣΗ VARCHAR(100) NOT NULL,
    ΤΗΛΕΦΩΝΟ VARCHAR(30) NOT NULL,
    ΒΑΘΜΟΣ_ΣΥΓΓΕΝΕΙΑΣ VARCHAR(50) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΑΤΟΜΟΥ, ΑΜΚΑ_ΑΣΘΕΝΗ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ΚΟΣΤΟΛΟΓΗΣΗ (
    ΚΕΝ_ID INT NOT NULL,
    ΚΩΔΙΚΟΣ_ΚΕΝ VARCHAR(20) NOT NULL,
    ΠΕΡΙΓΡΑΦΗ TEXT NOT NULL,
    ΚΟΣΤΟΣ_ΑΝΑ_ΚΕΝ DECIMAL(10,2) NOT NULL CHECK (ΚΟΣΤΟΣ_ΑΝΑ_ΚΕΝ > 0),
    ΜΔΝ INT NOT NULL CHECK (ΜΔΝ > 0),
    PRIMARY KEY (ΚΕΝ_ID)
);

CREATE TABLE ΤΜΗΜΑ_ΕΠΕΙΓΟΝΤΩΝ_ΠΕΡΙΣΤΑΤΙΚΩΝ (
    ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ INT NOT NULL AUTO_INCREMENT,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ VARCHAR(11) NOT NULL,
    ΣΥΜΠΤΩΜΑΤΑ TEXT NOT NULL,
    ΕΠΙΠΕΔΟ_ΕΠΕΙΓΟΝΤΟΣ INT NOT NULL CHECK (ΕΠΙΠΕΔΟ_ΕΠΕΙΓΟΝΤΟΣ BETWEEN 1 AND 5),
    ΗΜΕΡΟΜΗΝΙΑ_ΑΦΙΞΗΣ DATETIME NOT NULL,
    ΠΟΡΙΣΜΑ TINYINT(1) NOT NULL CHECK (ΠΟΡΙΣΜΑ IN (0,1)),
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ) REFERENCES ΝΟΣΗΛΕΥΤΕΣ(ΑΜΚΑ_ΝΟΣΗΛΕΥΤΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΝΟΣΗΛΕΙΑ (
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL AUTO_INCREMENT ,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ DATE NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ DATE NULL,
    ΚΟΣΤΟΣ_ΝΟΣΗΛΕΙΑΣ DECIMAL(10,2) NULL CHECK (ΚΟΣΤΟΣ_ΝΟΣΗΛΕΙΑΣ >= 0),
    ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ VARCHAR(20) NOT NULL,
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    ΚΕΝ_ID INT NOT NULL,
    ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ INT ,
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ) REFERENCES ΚΛΙΝΕΣ(ΜΟΝΑΔΙΚΟΣ_ΑΡΙΘΜΟΣ_ΚΛΙΝΗΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΕΝ_ID) REFERENCES ΚΟΣΤΟΛΟΓΗΣΗ(ΚΕΝ_ID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ) REFERENCES ΤΜΗΜΑ_ΕΠΕΙΓΟΝΤΩΝ_ΠΕΡΙΣΤΑΤΙΚΩΝ(ΚΩΔΙΚΟΣ_ΠΕΡΙΣΤΑΤΙΚΟΥ)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ IS NULL OR ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ >= ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ)
);

CREATE TABLE ΚΩΔΙΚΟΙ_ICD10 (
    ΚΩΔΙΚΟΣ_ICD10 VARCHAR(10) NOT NULL,
    ΠΕΡΙΓΡΑΦΗ TEXT NOT NULL,
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ICD10)
);

CREATE TABLE ΔΙΑΓΝΩΣΕΙΣ_ΝΟΣΗΛΕΙΑΣ (
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    ΚΩΔΙΚΟΣ_ICD10 VARCHAR(10) NOT NULL,
    ΤΥΠΟΣ VARCHAR(20) NOT NULL CHECK (ΤΥΠΟΣ IN ('Εισόδου','Εξόδου')),
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ, ΚΩΔΙΚΟΣ_ICD10, ΤΥΠΟΣ),
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ICD10) REFERENCES ΚΩΔΙΚΟΙ_ICD10(ΚΩΔΙΚΟΣ_ICD10)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE ΕΞΕΤΑΣΕΙΣ (
    ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ VARCHAR(20) NOT NULL,
    ΤΥΠΟΣ VARCHAR(50) NOT NULL,
    ΚΟΣΤΟΣ DECIMAL(10,2) NOT NULL CHECK (ΚΟΣΤΟΣ >= 0),
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ)
);

CREATE TABLE ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ (
    ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ VARCHAR(20) NOT NULL,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ DATETIME NOT NULL,
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΑΠΟΤΕΛΕΣΜΑ_ΠΕΡΙΓΡΑΦΗ TEXT,
    ΑΠΟΤΕΛΕΣΜΑ_ΤΙΜΗ DECIMAL(10,2),
    ΑΠΟΤΕΛΕΣΜΑ_ΜΟΝΑΔΑ_ΜΕΤΡΗΣΗΣ VARCHAR(20),
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ, ΑΜΚΑ_ΑΣΘΕΝΗ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ),
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ) REFERENCES ΕΞΕΤΑΣΕΙΣ(ΚΩΔΙΚΟΣ_ΕΞΕΤΑΣΗΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ (
    ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ VARCHAR(200) NOT NULL,
    ΟΝΟΜΑ TEXT NOT NULL,
    ΚΑΤΗΓΟΡΙΑ VARCHAR(100) NOT NULL CHECK (ΚΑΤΗΓΟΡΙΑ IN (
    'ΠΡΑΞΕΙΣ ΑΝΑΙΣΘΗΣΙΑΣ',
    'ΠΡΑΞΕΙΣ ΧΕΙΡΟΥΡΓΙΚΕΣ – ΕΠΕΜΒΑΤΙΚΕΣ – ΕΝΔΟΣΚΟΠΙΚΕΣ',
    'ΑΠΕΙΚΟΝΙΣΗ – ΕΠΕΜΒΑΤΙΚΕΣ ΚΑΙ ΘΕΡΑΠΕΥΤΙΚΕΣ ΑΚΤΙΝΙΚΕΣ ΠΡΑΞΕΙΣ',
    'ΠΡΑΞΕΙΣ ΒΙΟΠΑΘΟΛΟΓΙΑΣ',
    'ΠΡΑΞΕΙΣ ΙΑΤΡΟΔΙΚΑΣΤΙΚΗΣ – ΠΑΘΟΛΟΓΙΚΗΣ ΑΝΑΤΟΜΙΚΗΣ – ΚΥΤΤΑΡΟΛΟΓΙΑΣ')),
    ΔΙΑΡΚΕΙΑ INT NOT NULL CHECK (ΔΙΑΡΚΕΙΑ > 0),
    ΚΟΣΤΟΣ DECIMAL(10,2) NOT NULL CHECK (ΚΟΣΤΟΣ >= 0),
    ΧΩΡΟΣ VARCHAR(50) NOT NULL,
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ)
);

CREATE TABLE ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ (
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ VARCHAR(200) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ DATETIME NOT NULL,
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΑΙΘΟΥΣΑ VARCHAR(50) NOT NULL,
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ) REFERENCES ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ(ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΒΟΗΘΟΙ (
    ΑΜΚΑ_ΒΟΗΘΟΥ VARCHAR(11) NOT NULL,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ VARCHAR(200) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ DATETIME NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΒΟΗΘΟΥ, ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ),
    FOREIGN KEY (ΑΜΚΑ_ΒΟΗΘΟΥ) REFERENCES ΠΡΟΣΩΠΙΚΟ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ) 
        REFERENCES ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ(ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ΔΡΑΣΤΙΚΕΣ_ΟΥΣΙΕΣ (
    ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ VARCHAR(500) NOT NULL,
    PRIMARY KEY (ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ)
);

CREATE TABLE ΦΑΡΜΑΚΑ (
    ΦΑΡΜΑΚΟ_ID INT NOT NULL AUTO_INCREMENT,
    ΟΝΟΜΑ_ΦΑΡΜΑΚΟΥ VARCHAR(300) NOT NULL,
    ΣΥΝΤΑΓΗ INT NOT NULL DEFAULT 1,
    PRIMARY KEY (ΦΑΡΜΑΚΟ_ID)
);

CREATE TABLE ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57 (
    ΦΑΡΜΑΚΟ_ID INT NOT NULL,
    ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ VARCHAR(500) NOT NULL,
    PRIMARY KEY (ΦΑΡΜΑΚΟ_ID, ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ),
    FOREIGN KEY (ΦΑΡΜΑΚΟ_ID) REFERENCES ΦΑΡΜΑΚΑ(ΦΑΡΜΑΚΟ_ID),
    FOREIGN KEY (ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ) REFERENCES ΔΡΑΣΤΙΚΕΣ_ΟΥΣΙΕΣ(ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ)
);

CREATE TABLE ΑΛΛΕΡΓΙΕΣ (
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ VARCHAR(500) NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΑΣΘΕΝΗ, ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ) REFERENCES ΔΡΑΣΤΙΚΕΣ_ΟΥΣΙΕΣ(ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ (
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΦΑΡΜΑΚΟ_ID INT NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΕΝΑΡΞΗΣ DATE NOT NULL,
    ΔΟΣΟΛΟΓΙΑ VARCHAR(100) NOT NULL,
    ΣΥΧΝΟΤΗΤΑ VARCHAR(100) NOT NULL,
    ΗΜΕΡΟΜΗΝΙΑ_ΛΗΞΗΣ DATE NULL,
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    PRIMARY KEY (ΑΜΚΑ_ΙΑΤΡΟΥ, ΑΜΚΑ_ΑΣΘΕΝΗ, ΦΑΡΜΑΚΟ_ID, ΗΜΕΡΟΜΗΝΙΑ_ΕΝΑΡΞΗΣ),
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΦΑΡΜΑΚΟ_ID) REFERENCES ΦΑΡΜΑΚΑ(ΦΑΡΜΑΚΟ_ID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (ΗΜΕΡΟΜΗΝΙΑ_ΛΗΞΗΣ IS NULL OR ΗΜΕΡΟΜΗΝΙΑ_ΛΗΞΗΣ >= ΗΜΕΡΟΜΗΝΙΑ_ΕΝΑΡΞΗΣ)
);

CREATE TABLE ΒΑΡΔΙΕΣ (
    ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ VARCHAR(30) NOT NULL ,
    ΤΥΠΟΣ VARCHAR(20) NOT NULL CHECK (ΤΥΠΟΣ IN ('Πρωινή', 'Απογευματινή', 'Νυχτερινή')),
    ΗΜΕΡΟΜΗΝΙΑ DATE NOT NULL,
    ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ),
    FOREIGN KEY (ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ) REFERENCES ΤΜΗΜΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ (
    ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ VARCHAR(30) NOT NULL,
    ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ VARCHAR(11) NOT NULL,
    PRIMARY KEY (ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ, ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ),
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ) REFERENCES ΒΑΡΔΙΕΣ(ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ) REFERENCES ΠΡΟΣΩΠΙΚΟ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΑΞΙΟΛΟΓΗΣΗ_ΝΟΣΗΛΕΙΑΣ (
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    ΠΟΙΟΤΗΤΑ_ΝΟΣΗΛΕΥΤΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ INT NOT NULL CHECK (ΠΟΙΟΤΗΤΑ_ΝΟΣΗΛΕΥΤΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ BETWEEN 1 AND 5),
    ΚΑΘΑΡΙΟΤΗΤΑ INT NOT NULL CHECK (ΚΑΘΑΡΙΟΤΗΤΑ BETWEEN 1 AND 5),
    ΦΑΓΗΤΟ INT NOT NULL CHECK (ΦΑΓΗΤΟ BETWEEN 1 AND 5),
    ΣΥΝΟΛΙΚΗ_ΕΜΠΕΙΡΙΑ INT NOT NULL CHECK (ΣΥΝΟΛΙΚΗ_ΕΜΠΕΙΡΙΑ BETWEEN 1 AND 5),
    PRIMARY KEY (ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΑΞΙΟΛΟΓΗΣΗ_ΙΑΤΡΟΥ (
    ΑΜΚΑ_ΑΣΘΕΝΗ VARCHAR(11) NOT NULL,
    ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ INT NOT NULL,
    ΑΜΚΑ_ΙΑΤΡΟΥ VARCHAR(11) NOT NULL,
    ΠΟΙΟΤΗΤΑ_ΙΑΤΡΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ INT NOT NULL CHECK (ΠΟΙΟΤΗΤΑ_ΙΑΤΡΙΚΗΣ_ΦΡΟΝΤΙΔΑΣ BETWEEN 1 AND 5),
    PRIMARY KEY (ΑΜΚΑ_ΑΣΘΕΝΗ, ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ, ΑΜΚΑ_ΙΑΤΡΟΥ),
    FOREIGN KEY (ΑΜΚΑ_ΑΣΘΕΝΗ) REFERENCES ΑΣΘΕΝΕΙΣ(ΑΜΚΑ_ΑΣΘΕΝΗ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ) REFERENCES ΝΟΣΗΛΕΙΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ΑΜΚΑ_ΙΑΤΡΟΥ) REFERENCES ΙΑΤΡΟΙ(ΑΜΚΑ_ΙΑΤΡΟΥ)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ΦΩΤΟΓΡΑΦΙΕΣ (
    ID_ΦΩΤΟΓΡΑΦΙΑΣ INT NOT NULL AUTO_INCREMENT,
    IMAGE_URL VARCHAR(500) NOT NULL,
    ΠΕΡΙΓΡΑΦΗ TEXT,
    ΤΥΠΟΣ_ΟΝΤΟΤΗΤΑΣ VARCHAR(50) NOT NULL,
    ID_ΟΝΤΟΤΗΤΑΣ VARCHAR(100) NOT NULL,
    PRIMARY KEY (ID_ΦΩΤΟΓΡΑΦΙΑΣ)
);
-- TRIGGERS
DELIMITER $$


-- ΕΠΟΠΤΕΙΑ ΙΑΤΡΩΝ

-- Ειδικευόμενος υποχρεωτικά έχει επόπτη, Διευθυντής δεν έχει
CREATE TRIGGER trg_iatros_epopteia_insert
BEFORE INSERT ON ΙΑΤΡΟΙ
FOR EACH ROW
BEGIN
    IF NEW.ΒΑΘΜΙΔΑ = 'Ειδικευόμενος' AND NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ειδικευόμενος υποχρεωτικά έχει επόπτη.';
    END IF;
    IF NEW.ΒΑΘΜΙΔΑ = 'Διευθυντής' AND NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Διευθυντής δεν μπορεί να έχει επόπτη.';
    END IF;
END$$

CREATE TRIGGER trg_iatros_epopteia_update
BEFORE UPDATE ON ΙΑΤΡΟΙ
FOR EACH ROW
BEGIN
    IF NEW.ΒΑΘΜΙΔΑ = 'Ειδικευόμενος' AND NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ειδικευόμενος υποχρεωτικά έχει επόπτη.';
    END IF;
    IF NEW.ΒΑΘΜΙΔΑ = 'Διευθυντής' AND NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Διευθυντής δεν μπορεί να έχει επόπτη.';
    END IF;
END$$

-- Απαγόρευση κυκλικής αλυσίδας εποπτείας
CREATE TRIGGER trg_iatros_no_cycle_insert
BEFORE INSERT ON ΙΑΤΡΟΙ
FOR EACH ROW
BEGIN
    DECLARE v_current VARCHAR(11);
    DECLARE v_steps   INT DEFAULT 0;
    IF NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NOT NULL THEN
        SET v_current = NEW.ΑΜΚΑ_ΕΠΟΠΤΗ;
        WHILE v_current IS NOT NULL AND v_steps < 200 DO
            IF v_current = NEW.ΑΜΚΑ_ΙΑΤΡΟΥ THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Κυκλική αλυσίδα εποπτείας απαγορεύεται.';
            END IF;
            SELECT ΑΜΚΑ_ΕΠΟΠΤΗ INTO v_current FROM ΙΑΤΡΟΙ WHERE ΑΜΚΑ_ΙΑΤΡΟΥ = v_current;
            SET v_steps = v_steps + 1;
        END WHILE;
    END IF;
END$$

CREATE TRIGGER trg_iatros_no_cycle_update
BEFORE UPDATE ON ΙΑΤΡΟΙ
FOR EACH ROW
BEGIN
    DECLARE v_current VARCHAR(11);
    DECLARE v_steps   INT DEFAULT 0;
    IF NEW.ΑΜΚΑ_ΕΠΟΠΤΗ IS NOT NULL THEN
        SET v_current = NEW.ΑΜΚΑ_ΕΠΟΠΤΗ;
        WHILE v_current IS NOT NULL AND v_steps < 200 DO
            IF v_current = NEW.ΑΜΚΑ_ΙΑΤΡΟΥ THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Κυκλική αλυσίδα εποπτείας απαγορεύεται.';
            END IF;
            SELECT ΑΜΚΑ_ΕΠΟΠΤΗ INTO v_current FROM ΙΑΤΡΟΙ WHERE ΑΜΚΑ_ΙΑΤΡΟΥ = v_current;
            SET v_steps = v_steps + 1;
        END WHILE;
    END IF;
END$$

--ΒΑΡΔΙΕΣ

-- Μέγιστος αριθμός βαρδιών ανά μήνα (Ιατροί=15, Νοσηλευτές=20, Διοικητικοί=25)
CREATE TRIGGER trg_omada_monthly_limit
BEFORE INSERT ON ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ
FOR EACH ROW
trig: BEGIN

    DECLARE v_shift_date   DATE;
    DECLARE v_person_type  VARCHAR(20);
    DECLARE v_max_shifts   INT;
    DECLARE v_current_count INT;

    IF @DISABLE_TRIGGERS = 1 THEN LEAVE trig; END IF;

    SELECT ΗΜΕΡΟΜΗΝΙΑ INTO v_shift_date
    FROM ΒΑΡΔΙΕΣ WHERE ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ;

    SELECT ΤΥΠΟΣ_ΠΡΟΣΩΠΙΚΟΥ INTO v_person_type
    FROM ΠΡΟΣΩΠΙΚΟ WHERE ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ = NEW.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ;

    SET v_max_shifts = CASE v_person_type
        WHEN 'Ιατρός'     THEN 15
        WHEN 'Νοσηλευτής' THEN 20
        ELSE                   25
    END;

    SELECT COUNT(*) INTO v_current_count
    FROM ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ oe
    JOIN ΒΑΡΔΙΕΣ β ON oe.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = β.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ
    WHERE oe.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ  = NEW.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ
      AND YEAR(β.ΗΜΕΡΟΜΗΝΙΑ)  = YEAR(v_shift_date)
      AND MONTH(β.ΗΜΕΡΟΜΗΝΙΑ) = MONTH(v_shift_date);

    IF v_current_count >= v_max_shifts THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Υπέρβαση μέγιστου αριθμού βαρδιών μήνα.';
    END IF;
END$$

-- Ελάχιστο 8ωρο ανάπαυσης μεταξύ διαδοχικών βαρδιών
CREATE TRIGGER trg_omada_8hour_rest
BEFORE INSERT ON ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ
FOR EACH ROW
trig: BEGIN

    DECLARE v_shift_date DATE;
    DECLARE v_shift_type VARCHAR(20);
    DECLARE v_new_start  DATETIME;
    DECLARE v_last_end   DATETIME;

    IF @DISABLE_TRIGGERS = 1 THEN LEAVE trig; END IF;

    SELECT ΗΜΕΡΟΜΗΝΙΑ, ΤΥΠΟΣ INTO v_shift_date, v_shift_type
    FROM ΒΑΡΔΙΕΣ WHERE ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ;

    SET v_new_start = CASE v_shift_type
        WHEN 'Πρωινή'       THEN TIMESTAMP(v_shift_date, '07:00:00')
        WHEN 'Απογευματινή' THEN TIMESTAMP(v_shift_date, '15:00:00')
        WHEN 'Νυχτερινή'    THEN TIMESTAMP(v_shift_date, '23:00:00')
    END;

    SELECT MAX(CASE β.ΤΥΠΟΣ
        WHEN 'Πρωινή'       THEN TIMESTAMP(β.ΗΜΕΡΟΜΗΝΙΑ, '15:00:00')
        WHEN 'Απογευματινή' THEN TIMESTAMP(β.ΗΜΕΡΟΜΗΝΙΑ, '23:00:00')
        WHEN 'Νυχτερινή'    THEN TIMESTAMP(DATE_ADD(β.ΗΜΕΡΟΜΗΝΙΑ, INTERVAL 1 DAY), '07:00:00')
    END) INTO v_last_end
    FROM ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ oe
    JOIN ΒΑΡΔΙΕΣ β ON oe.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = β.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ
    WHERE oe.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ = NEW.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ;

    IF v_last_end IS NOT NULL AND TIMESTAMPDIFF(HOUR, v_last_end, v_new_start) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Δεν τηρείται ελάχιστο διάστημα ανάπαυσης 8 ωρών μεταξύ βαρδιών.';
    END IF;
END$$

-- Μέγιστο 3 συνεχόμενες νυχτερινές βάρδιες
CREATE TRIGGER trg_omada_consecutive_nights
BEFORE INSERT ON ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ
FOR EACH ROW
trig: BEGIN

    DECLARE v_shift_date  DATE;
    DECLARE v_shift_type  VARCHAR(20);
    DECLARE v_consecutive INT;

    IF @DISABLE_TRIGGERS = 1 THEN LEAVE trig; END IF;

    SELECT ΗΜΕΡΟΜΗΝΙΑ, ΤΥΠΟΣ INTO v_shift_date, v_shift_type
    FROM ΒΑΡΔΙΕΣ WHERE ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ;

    IF v_shift_type = 'Νυχτερινή' THEN
        SELECT COUNT(*) INTO v_consecutive
        FROM ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ oe
        JOIN ΒΑΡΔΙΕΣ β ON oe.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = β.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ
        WHERE oe.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ = NEW.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ
          AND β.ΤΥΠΟΣ = 'Νυχτερινή'
          AND β.ΗΜΕΡΟΜΗΝΙΑ IN (
              DATE_SUB(v_shift_date, INTERVAL 1 DAY),
              DATE_SUB(v_shift_date, INTERVAL 2 DAY),
              DATE_SUB(v_shift_date, INTERVAL 3 DAY)
          );

        IF v_consecutive >= 3 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Υπέρβαση 3 συνεχόμενων νυχτερινών βαρδιών.';
        END IF;
    END IF;
END$$

-- Βάρδια με Ειδικευόμενο απαιτεί παρουσία Επιμελητή Α΄ ή Διευθυντή
-- (ο senior πρέπει να εισαχθεί πριν τον Ειδικευόμενο)
CREATE TRIGGER trg_omada_intern_supervision
AFTER INSERT ON ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ
FOR EACH ROW
trig: BEGIN

    DECLARE v_rank VARCHAR(20);
    DECLARE v_has_senior INT;

    IF @DISABLE_TRIGGERS = 1 THEN LEAVE trig; END IF;

    -- Βγες αμέσως αν δεν είναι ιατρός
    SELECT ΒΑΘΜΙΔΑ INTO v_rank
    FROM ΙΑΤΡΟΙ 
    WHERE ΑΜΚΑ_ΙΑΤΡΟΥ = NEW.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ;

    -- Αν δεν είναι ιατρός ή δεν είναι ειδικευόμενος → βγες
    IF v_rank IS NULL OR v_rank != 'Ειδικευόμενος' THEN
        LEAVE trig;
    END IF;

    SELECT COUNT(*) INTO v_has_senior
    FROM ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ oe
    JOIN ΙΑΤΡΟΙ ι ON oe.ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ = ι.ΑΜΚΑ_ΙΑΤΡΟΥ
    WHERE oe.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΒΑΡΔΙΑΣ
      AND ι.ΒΑΘΜΙΔΑ IN ('Επιμελητής Α΄', 'Διευθυντής');

    IF v_has_senior = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Βάρδια με Ειδικευόμενο απαιτεί παρουσία Επιμελητή Α΄ ή Διευθυντή.';
    END IF;
END trig$$

-- ΕΠΕΜΒΑΣΕΙΣ


-- Δεν επιτρέπονται δύο ταυτόχρονες επεμβάσεις στον ίδιο χώρο ή από τον ίδιο ιατρό
CREATE TRIGGER trg_no_concurrent_operation
BEFORE INSERT ON ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ
FOR EACH ROW
BEGIN
    DECLARE v_duration INT;
    DECLARE v_conflict INT;

    SELECT ΔΙΑΡΚΕΙΑ INTO v_duration
    FROM ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ WHERE ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ = NEW.ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ;

    -- Έλεγχος διαθεσιμότητας χώρου
    SELECT COUNT(*) INTO v_conflict
    FROM ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ ιπα
    JOIN ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ ιπ ON ιπα.ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ = ιπ.ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ
    WHERE ιπα.ΑΙΘΟΥΣΑ = NEW.ΑΙΘΟΥΣΑ
      AND ιπα.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ < DATE_ADD(NEW.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ, INTERVAL v_duration MINUTE)
      AND DATE_ADD(ιπα.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ, INTERVAL ιπ.ΔΙΑΡΚΕΙΑ MINUTE) > NEW.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ;

    IF v_conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ο χώρος επέμβασης είναι ήδη κατειλημμένος την ίδια ώρα.';
    END IF;

    -- Έλεγχος διαθεσιμότητας ιατρού
    SELECT COUNT(*) INTO v_conflict
    FROM ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ ιπα
    JOIN ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ ιπ ON ιπα.ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ = ιπ.ΚΩΔΙΚΟΣ_ΠΡΑΞΗΣ
    WHERE ιπα.ΑΜΚΑ_ΙΑΤΡΟΥ = NEW.ΑΜΚΑ_ΙΑΤΡΟΥ
      AND ιπα.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ < DATE_ADD(NEW.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ, INTERVAL v_duration MINUTE)
      AND DATE_ADD(ιπα.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ, INTERVAL ιπ.ΔΙΑΡΚΕΙΑ MINUTE) > NEW.ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ;

    IF v_conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ο ιατρός συμμετέχει ήδη σε άλλη επέμβαση την ίδια ώρα.';
    END IF;
END$$

-- ΑΞΙΟΛΟΓΗΣΕΙΣ

-- Αξιολόγηση νοσηλείας μόνο για ολοκληρωμένη νοσηλεία
CREATE TRIGGER trg_eval_admission_complete
BEFORE INSERT ON ΑΞΙΟΛΟΓΗΣΗ_ΝΟΣΗΛΕΙΑΣ
FOR EACH ROW
BEGIN
    DECLARE v_exit_date DATE;

    SELECT ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ INTO v_exit_date
    FROM ΝΟΣΗΛΕΙΑ WHERE ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ;

    IF v_exit_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Αξιολόγηση επιτρέπεται μόνο για ολοκληρωμένη νοσηλεία.';
    END IF;
END$$

-- Αξιολόγηση ιατρού: ολοκληρωμένη νοσηλεία + ο ιατρός έχει συνταγογραφήσει κατά τη νοσηλεία
CREATE TRIGGER trg_eval_doctor_prescribed
BEFORE INSERT ON ΑΞΙΟΛΟΓΗΣΗ_ΙΑΤΡΟΥ
FOR EACH ROW
BEGIN
    DECLARE v_exit_date  DATE;
    DECLARE v_prescribed INT;

    SELECT ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ INTO v_exit_date
    FROM ΝΟΣΗΛΕΙΑ WHERE ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ;

    IF v_exit_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Αξιολόγηση επιτρέπεται μόνο για ολοκληρωμένη νοσηλεία.';
    END IF;

    SELECT COUNT(*) INTO v_prescribed
    FROM ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ
    WHERE ΑΜΚΑ_ΙΑΤΡΟΥ        = NEW.ΑΜΚΑ_ΙΑΤΡΟΥ
      AND ΑΜΚΑ_ΑΣΘΕΝΗ        = NEW.ΑΜΚΑ_ΑΣΘΕΝΗ
      AND ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ = NEW.ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ;

    IF v_prescribed = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ο ασθενής μπορεί να αξιολογήσει μόνο ιατρό που τον συνταγογράφησε κατά τη νοσηλεία.';
    END IF;
END$$


--  ΦΑΡΜΑΚΑ


-- Απαγόρευση συνταγογράφησης αν ο ασθενής έχει αλλεργία σε δραστική ουσία του φαρμάκου
CREATE TRIGGER trg_no_allergy_prescription
BEFORE INSERT ON ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM ΑΛΛΕΡΓΙΕΣ α
    JOIN ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57 φ ON α.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ = φ.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ
    WHERE α.ΑΜΚΑ_ΑΣΘΕΝΗ = NEW.ΑΜΚΑ_ΑΣΘΕΝΗ
      AND φ.ΦΑΡΜΑΚΟ_ID  = NEW.ΦΑΡΜΑΚΟ_ID;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Απαγορεύεται η συνταγογράφηση: αλλεργία σε δραστική ουσία του φαρμάκου.';
    END IF;
END$$

DELIMITER ;

-- INDEXES (2.2)

-- ΝΟΣΗΛΕΙΑ: συχνές αναζητήσεις ανά ασθενή, τμήμα, ημερομηνίες
CREATE INDEX idx_nosilia_asthenis   ON ΝΟΣΗΛΕΙΑ(ΑΜΚΑ_ΑΣΘΕΝΗ);
CREATE INDEX idx_nosilia_tmima      ON ΝΟΣΗΛΕΙΑ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ);
CREATE INDEX idx_nosilia_eisagogi   ON ΝΟΣΗΛΕΙΑ(ΗΜΕΡΟΜΗΝΙΑ_ΕΙΣΑΓΩΓΗΣ);
CREATE INDEX idx_nosilia_exodos     ON ΝΟΣΗΛΕΙΑ(ΗΜΕΡΟΜΗΝΙΑ_ΕΞΟΔΟΥ);

-- ΔΙΑΓΝΩΣΕΙΣ_ΝΟΣΗΛΕΙΑΣ: αναζήτηση ανά κωδικό ICD-10
CREATE INDEX idx_diag_icd10         ON ΔΙΑΓΝΩΣΕΙΣ_ΝΟΣΗΛΕΙΑΣ(ΚΩΔΙΚΟΣ_ICD10);

-- ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ: ανά ιατρό, φάρμακο, νοσηλεία
CREATE INDEX idx_syntago_iatros     ON ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ(ΑΜΚΑ_ΙΑΤΡΟΥ);
CREATE INDEX idx_syntago_farmako    ON ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ(ΦΑΡΜΑΚΟ_ID);
CREATE INDEX idx_syntago_nosilia    ON ΣΥΝΤΑΓΟΓΡΑΦΗΣΗ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ);

-- ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ: ανά ασθενή, ιατρό, νοσηλεία
CREATE INDEX idx_exam_asthenis      ON ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ(ΑΜΚΑ_ΑΣΘΕΝΗ);
CREATE INDEX idx_exam_iatros        ON ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ(ΑΜΚΑ_ΙΑΤΡΟΥ);
CREATE INDEX idx_exam_nosilia       ON ΕΞΕΤΑΣΕΙΣ_ΑΠΟΤΕΛΕΣΜΑΤΑ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ);

-- ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ: ανά ιατρό, αίθουσα+ώρα (trigger αλληλεπικάλυψης), νοσηλεία
CREATE INDEX idx_praxis_iatros      ON ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ(ΑΜΚΑ_ΙΑΤΡΟΥ);
CREATE INDEX idx_praxis_aithousa    ON ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ(ΑΙΘΟΥΣΑ, ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ);
CREATE INDEX idx_praxis_nosilia     ON ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ(ΚΩΔΙΚΟΣ_ΝΟΣΗΛΕΙΑΣ);

-- ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ: ανά μέλος προσωπικού (trigger μηνιαίου ορίου & 8ωρου)
CREATE INDEX idx_omada_amka         ON ΟΜΑΔΑ_ΕΦΗΜΕΡΙΑΣ(ΑΜΚΑ_ΠΡΟΣΩΠΙΚΟΥ);

-- ΒΑΡΔΙΕΣ: ανά τμήμα + ημερομηνία
CREATE INDEX idx_vardies_tmima_date ON ΒΑΡΔΙΕΣ(ΟΝΟΜΑ_ΤΜΗΜΑΤΟΣ, ΗΜΕΡΟΜΗΝΙΑ);

-- ΑΞΙΟΛΟΓΗΣΗ_ΙΑΤΡΟΥ: ανά ιατρό (μέση βαθμολογία)
CREATE INDEX idx_axiol_iatros       ON ΑΞΙΟΛΟΓΗΣΗ_ΙΑΤΡΟΥ(ΑΜΚΑ_ΙΑΤΡΟΥ);

-- ΑΛΛΕΡΓΙΕΣ: ανά δραστική ουσία (trigger αλλεργίας)
CREATE INDEX idx_allerg_ousia       ON ΑΛΛΕΡΓΙΕΣ(ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ);

-- ΤΜΗΜΑ_ΕΠΕΙΓΟΝΤΩΝ_ΠΕΡΙΣΤΑΤΙΚΩΝ: ανά ασθενή
CREATE INDEX idx_tep_asthenis       ON ΤΜΗΜΑ_ΕΠΕΙΓΟΝΤΩΝ_ΠΕΡΙΣΤΑΤΙΚΩΝ(ΑΜΚΑ_ΑΣΘΕΝΗ);

-- ΙΑΤΡΟΙ: ανά επόπτη (αλυσίδα εποπτείας) και βαθμίδα
CREATE INDEX idx_iatros_epoptis     ON ΙΑΤΡΟΙ(ΑΜΚΑ_ΕΠΟΠΤΗ);
CREATE INDEX idx_iatros_vathmida    ON ΙΑΤΡΟΙ(ΒΑΘΜΙΔΑ);

-- ΠΡΟΣΩΠΙΚΟ: ανά τύπο (trigger βαρδιών)
CREATE INDEX idx_prosop_typos       ON ΠΡΟΣΩΠΙΚΟ(ΤΥΠΟΣ_ΠΡΟΣΩΠΙΚΟΥ);

-- ΑΣΦΑΛΙΣΤΙΚΟΣ_ΦΟΡΕΑΣ: ανά ασθενή
CREATE INDEX idx_asfal_asthenis     ON ΑΣΦΑΛΙΣΤΙΚΟΣ_ΦΟΡΕΑΣ(ΑΜΚΑ_ΑΣΘΕΝΗ);

-- ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57: ανά δραστική ουσία (trigger αλλεργίας)
CREATE INDEX idx_fa57_ousia         ON ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57(ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ);

-- Για Q02, Q05 (αναζήτηση ανά ειδικότητα)
CREATE INDEX idx_iatros_eidikotita ON ΙΑΤΡΟΙ(ΕΙΔΙΚΟΤΗΤΑ);

-- Για Q05 (νέοι ιατροί ηλικία < 35)
CREATE INDEX idx_prosop_ilikia ON ΠΡΟΣΩΠΙΚΟ(ΗΛΙΚΙΑ);

-- Για Q11 (επεμβάσεις τρέχοντος έτους)
CREATE INDEX idx_praxis_date ON ΙΑΤΡΙΚΕΣ_ΠΡΑΞΕΙΣ_ΑΣΘΕΝΗ(ΗΜΕΡΟΜΗΝΙΑ_ΩΡΑ);

SET FOREIGN_KEY_CHECKS = 1;