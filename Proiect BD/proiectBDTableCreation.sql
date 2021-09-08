CREATE TABLE student_bce (
  stud_id NUMBER(6,0),
  nume VARCHAR(20),
  prenume VARCHAR(20),
  data_nasterii DATE,
  grupa_id NUMBER(3,0),
  PRIMARY KEY (stud_id)
);

ALTER TABLE student_bce
MODIFY nume NOT NULL;

ALTER TABLE student_bce
MODIFY prenume NOT NULL;

ALTER TABLE student_bce
MODIFY grupa_id NOT NULL;


ALTER TABLE student_bce
MODIFY stud_id>100000;

CREATE TABLE grupa_bce (
  grupa_id NUMBER(3,0),
  specializare VARCHAR(20),
  PRIMARY KEY (grupa_id)
);

ALTER TABLE grupa_bce
ADD CHECK grupa_id>100;

ALTER TABLE student_bce
ADD FOREIGN KEY(grupa_id) REFERENCES grupa_bce(grupa_id)

CREATE TABLE curs_bce (
  curs_id NUMBER(3,0),
  nume VARCHAR(40),
  PRIMARY KEY (curs_id)
);

ALTER TABLE curs_bce
MODIFY nume NOT NULL;

CREATE TABLE examinare_bce (
  ex_id NUMBER(4,0),
  curs_id NUMBER(3,0),
  data_ex DATE,
  PRIMARY KEY (ex_id)
);

ALTER TABLE examinare_bce
MODIFY curs_id NOT NULL;

ALTER TABLE examinare_bce
ADD FOREIGN KEY(curs_id) REFERENCES curs_bce(curs_id)

CREATE TABLE sustine_bce (
  grupa_id NUMBER(3,0),
  ex_id NUMBER(4,0)
  PRIMARY KEY (grupa_id,ex_id)
);

ALTER TABLE sustine_bce
ADD FOREIGN KEY(ex_id) REFERENCES examinare_bce(ex_id)

ALTER TABLE sustine_bce
ADD FOREIGN KEY(grupa_id) REFERENCES grupa_bce(grupa_id)

CREATE TABLE profesor_bce (
  prof_id VARCHAR(20),
  nume VARCHAR(20),
  prenume VARCHAR(20),
  titlu_univ VARCHAR(20),
  PRIMARY KEY (prof_id)
);

ALTER TABLE profesor_bce
MODIFY nume NOT NULL;

ALTER TABLE profesor_bce
MODIFY prenume NOT NULL;

ALTER TABLE profesor_bce
MODIFY titlu_univ NOT NULL;

CREATE TABLE preda_bce (
  prof_id NUMBER(6,0),
  curs_id NUMBER(3,0)
  PRIMARY KEY (prof_id,curs_id)
);

ALTER TABLE preda_bce
ADD FOREIGN KEY(prof_id) REFERENCES profesor_bce(prof_id)

ALTER TABLE preda_bce
ADD FOREIGN KEY(curs_id) REFERENCES curs_bce(curs_id)

CREATE TABLE supravegheaza_bce (
  prof_id NUMBER(6,0),
  ex_id NUMBER(4,0)
  PRIMARY KEY (prof_id,ex_id)
);

ALTER TABLE supravegheaza_bce
ADD FOREIGN KEY(prof_id) REFERENCES profesor_bce(prof_id)

ALTER TABLE supravegheaza_bce
ADD FOREIGN KEY(ex_id) REFERENCES examinare_bce(ex_id)

CREATE TABLE sala_bce (
  sala_id NUMBER(3,0),
  nume VARCHAR(20),
  capacitate NUMBER(4,0),
  PRIMARY KEY (sala_id)
);

ALTER TABLE sala_bce
MODIFY capacitate NOT NULL;

CREATE TABLE se_tine_in_bce(
  ex_id NUMBER(4,0),
  sala_id NUMBER(3,0)
  PRIMARY KEY (ex_id,sala_id)
);

ALTER TABLE se_tine_in_bce
ADD FOREIGN KEY(ex_id) REFERENCES examinare_bce(ex_id)

ALTER TABLE se_tine_in_bce
ADD FOREIGN KEY(sala_id) REFERENCES sala_bce(sala_id)

CREATE TABLE bursa_bce(
bursa_id NUMBER(1,0),
tip VARCHAR(20),
suma NUMBER(4,0),
PRIMARY KEY(bursa_id)
);

ALTER TABLE student_bce
ADD bursa_id NUMBER(1,0);

ALTER TABLE student_bce
ADD FOREIGN KEY(bursa_id) REFERENCES bursa_bce(bursa_id);


