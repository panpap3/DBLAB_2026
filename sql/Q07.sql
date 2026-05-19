SELECT 
    Α.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ,
    COUNT(DISTINCT Α.ΑΜΚΑ_ΑΣΘΕΝΗ) AS ΑΡΙΘΜΟΣ_ΑΛΛΕΡΓΙΚΩΝ_ΑΣΘΕΝΩΝ,
    COUNT(DISTINCT Φ.ΦΑΡΜΑΚΟ_ID) AS ΑΡΙΘΜΟΣ_ΦΑΡΜΑΚΩΝ
FROM ΑΛΛΕΡΓΙΕΣ Α                                  -- idx_allerg_ousia
LEFT JOIN ΦΑΡΜΑΚΑ_ΑΡΘΡΟ_57 Φ ON Α.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ = Φ.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ  -- idx_fa57_ousia
GROUP BY Α.ΔΡΑΣΤΙΚΗ_ΟΥΣΙΑ
ORDER BY ΑΡΙΘΜΟΣ_ΑΛΛΕΡΓΙΚΩΝ_ΑΣΘΕΝΩΝ DESC
LIMIT 50;