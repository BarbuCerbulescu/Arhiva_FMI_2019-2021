SELECT grupa_id "Grupa",COUNT(e.ex_id) "Nr. examene"
FROM examinare_bce e  JOIN sustine_bce s
ON s.ex_id=e.ex_id
AND data_ex - TO_DATE(CONCAT('01-JUN-',TO_CHAR(SYSDATE,'YYYY'))) <14 AND
data_ex - TO_DATE(CONCAT('01-JUN-',TO_CHAR(SYSDATE,'YYYY'))) >=0
--alegem doar ex. cu data curprinsa intre 1 si 14 Iunie
--verificare este facuta odata cu join-ul si nu in WHERE
--deorece vrem ca in tabelul final sa avem toate grupele
--chiar daca nu au examen in aceasta perioada
RIGHT JOIN grupa_bce
USING(grupa_id)
GROUP BY grupa_id
ORDER BY grupa_id;


SELECT DISTINCT s.nume,prenume,c.nume
FROM student_bce s LEFT JOIN sustine_bce
USING(grupa_id)
JOIN examinare_bce
USING(ex_id)
JOIN curs_bce c
USING(curs_id)
WHERE s.nume LIKE 'Ionescu';

SELECT sala_id,CASE
	       WHEN sala_id IN (SELECT sala_id
				FROM se_tine_in_bce JOIN examinare_bce
				USING(ex_id)
				WHERE TO_CHAR(data_ex,'DD-MON') LIKE '09-JUN')THEN 'Da'
	       ELSE 'Nu'
	       END AS raspuns
FROM sala_bce;


SELECT ex_id,nume
FROM examinare_bce JOIN curs_bce
USING(curs_id)
START WITH TO_CHAR(data_ex,'DD-MON') LIKE '15-JUN'
CONNECT BY PRIOR data_ex=data_ex-1;




SELECT e.ex_id,nume
FROM examinare_bce e JOIN curs_bce
USING(curs_id)
JOIN se_tine_in_bce s
ON e.ex_id=s.ex_id
JOIN sustine_bce g
ON e.ex_id=g.ex_id
WHERE (SELECT SUM(nr) AS nrStudenti
        FROM(SELECT grupa_id AS gr,COUNT(*) AS nr
            FROM student_bce
            GROUP BY grupa_id)
            WHERE gr=g.grupa_id) > (SELECT SUM(capacitate) AS capacitateTotala
                                    FROM sala_bce JOIN se_tine_in_bce
                                    USING(sala_id)
                                    WHERE ex_id=e.ex_id);




SELECT ex_id,nume,data_ex
FROM examinare_bce e JOIN curs_bce
USING(curs_id)
WHERE (SELECT COUNT(sala_id)
        FROM se_tine_in_bce JOIN examinare_bce
        USING(ex_id)
        WHERE ex_id=e.ex_id)>(SELECT COUNT(prof_id)
                             FROM supravegheaza_bce JOIN examinare_bce ex
                             USING(ex_id)
                             JOIN preda_bce p
                             USING(prof_id)
                             WHERE ex_id=e.ex_id AND ex.curs_id=p.curs_id);



WITH date_ordonate AS(SELECT data_ex
FROM examinare_bce
ORDER BY data_ex)
--vom folosi tabelul de date ordonate calendaristic
--pentru a afla diferenta maxim dintre doua date alaturate
--in tabel,aceasta reprezentand perioada maxima 
--in care nu are loc nicio examinare
SELECT MAX(dif) "Nr maxim zile fara examinari"
FROM(SELECT d1.data_ex -d2.data_ex AS dif
     FROM (SELECT ROWNUM AS r1,data_ex 
           FROM date_ordonate) d1 CROSS JOIN (SELECT ROWNUM AS r2,data_ex 
                                              FROM date_ordonate) d2
     WHERE r1=r2+1);

SELECT prof_id,nume,prenume,COUNT(curs_id) "Nr. cursuri predate la 211"
FROM (SELECT DISTINCT prof_id,nume,prenume,curs_id 
      FROM profesor_bce JOIN preda_bce
      USING(prof_id)
      JOIN examinare_bce
      USING(curs_id)
      JOIN sustine_bce
      USING(ex_id)
      WHERE grupa_id=211)
GROUP BY prof_id,nume,prenume;

--se simuleaza operatorul DIVISION
SELECT prof_id,nume,prenume
FROM profesor_bce
WHERE prof_id IN(SELECT DISTINCT prof_id
                FROM profesor_bce
                MINUS
                SELECT prof_id FROM
                ( SELECT prof_id, grupa_id
                FROM (SELECT prof_id FROM profesor_bce),
                (SELECT grupa_id FROM grupa_bce ) 
                MINUS
                SELECT prof_id, grupa_id 
                FROM profesor_bce JOIN preda_bce
                USING(prof_id)
                JOIN examinare_bce
                USING(curs_id)
                JOIN sustine_bce
                USING(ex_id)
		)
);

SELECT grupa_id "Grupa",COUNT(stud_id) "Nr. studenti"
FROM grupa_bce LEFT JOIN student_bce
USING(grupa_id)
GROUP BY grupa_id
HAVING COUNT(stud_id)<(SELECT capacitate/2
                FROM sala_bce
                WHERE sala_id=10);

SELECT stud_id,nume,prenume
FROM student_bce s
WHERE NOT EXISTS(SELECT *
                FROM sustine_bce JOIN examinare_bce
                USING(ex_id)
                JOIN curs_bce
                USING(curs_id)
                WHERE LOWER(TRIM(nume)) LIKE 'programare orientata pe obiecte' AND grupa_id=s.grupa_id);


SELECT stud_id,nume,prenume
FROM student_bce
WHERE grupa_id IN(SELECT grupa_id
                  FROM sustine_bce
                  WHERE ex_id IN(SELECT ex_id
                                FROM sustine_bce
                                WHERE grupa_id>=100 AND grupa_id<200));


SELECT NVL(TO_CHAR(grupa_id),' ') "Grupa",NVL(nume,' ') "Curs",MAX(data_ex) "Data ultimului examen"
FROM grupa_bce LEFT JOIN sustine_bce
USING(grupa_id)
JOIN examinare_bce
USING(ex_id)
JOIN curs_bce
USING(curs_id)
GROUP BY CUBE(grupa_id,nume)
ORDER BY grupa_id,nume;


SELECT stud_id,nume,prenume
FROM student_bce
WHERE LOWER(TRIM(prenume)) LIKE '%gheorghe%'
UNION
SELECT stud_id,nume,prenume
FROM student_bce 
WHERE MOD(TO_NUMBER(TO_CHAR(data_nasterii,'YYYY')),5)=0;


SELECT stud_id,nume,prenume,NVL(suma,0)+(SELECT MAX(grupa_id) FROM grupa_bce) "Suma obtinuta"
FROM student_bce LEFT JOIN bursa_bce
USING(bursa_id);
