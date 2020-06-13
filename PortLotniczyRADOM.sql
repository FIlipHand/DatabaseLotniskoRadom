--USUWANIE STARYCH TABEL
DROP TABLE Kontroler CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Podró¿nik CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Odloty CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Przybysz CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Przyloty CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Bramki CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE LinieLotnicze CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Piloci CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE PortyLotnicze CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci
DROP TABLE Samoloty CASCADE CONSTRAINTS; --Usuniêcie tabeli razem ze wszystkimi wiêzami integralnoœci

--TWORZENIE NOWYCH TABEL
CREATE TABLE Bramki(
    idBramki VARCHAR(3) CONSTRAINT id_bramki_nn NOT NULL, --id bramki nie mo¿e byæ puste 
    Terminal VARCHAR(1),      
    CONSTRAINT idBramki_pk PRIMARY KEY(idBramki), -- klucz glówny
    CONSTRAINT terminal_chcek CHECK(Terminal IN ('1', '2', '3', '4')) --terminal mo¿e byæ tylko równy 1, 2, 3, 4 
);

CREATE TABLE PortyLotnicze (
    NazwaMiasta VARCHAR(30) CONSTRAINT nazwa_miasta_nn NOT NULL, --nazwa miasta nie mo¿e byæ pusta
    kodIATA VARCHAR(3), --3-literowy kod lotniska 
    Pañstwo VARCHAR(40) CONSTRAINT panstwao_nn NOT NULL, --pañstwo w jakim znajduje siê lotnisko
    CONSTRAINT kodIATA_pk PRIMARY KEY (kodIATA) -- kluccz glówny 
);

CREATE TABLE Samoloty (
    idSamolotu INT  NOT NULL, -- numer pszypisany do samolotu; nie mo¿e byæ puste
    Producent VARCHAR(30) CONSTRAINT producent_nn NOT NULL, -- Producent samolotu; nie mo¿e byæ puste
    Modelm VARCHAR(10) CONSTRAINT modelm NOT NULL , --model samolotu; nie mo¿e byæ puste
    Typ VARCHAR(12), 
    StandLiczbaMiejsc INT, --przewidywana liczba miejsc w samolocie
    CONSTRAINT id_pk PRIMARY KEY(idSamolotu), -- klucz glówny 
    CONSTRAINT samolot_typ CHECK(Typ IN ('pasa¿erski', 'cargo')) --samolot mo¿e byæ albo pasa¿erski albo cargo
);

CREATE TABLE LinieLotnicze (
    nazwaLini VARCHAR(30), --nazwa lini lotniczych 
    kodLini VARCHAR(2) CONSTRAINT kod_lini_u UNIQUE, --kod lini muszacy byæ unikalny
    kraj VARCHAR(30), --kraj do którego nale¿a linie; mo¿e byæ pusty (np. prywatne linie cargo)
    CONSTRAINT nazwa_pk PRIMARY KEY(nazwaLini) --klucz glówny
);
CREATE TABLE Piloci(
    idPilota INT, --numer pilota
    Imie VARCHAR(30) CONSTRAINT imie_nn NOT NULL, --Imie pilota; nie mo¿e byæ puste
    Nazwisko VARCHAR(40) CONSTRAINT nazwisko_nn NOT NULL, --Nazwisko pilota; nie mo¿e byæ puste
    Wiek INT CONSTRAINT wiek_nn NOT NULL,--Wiek pilota; nie mo¿e byæ puste
    Pleæ VARCHAR(1) CONSTRAINT plec_check CHECK(Pleæ IN ('K', 'M')),--Pleæ pilota; kobieta (k) albo mê¿czyzna (m)
    Sta¿ int CONSTRAINT staz_nn NOT NULL, -- sta¿ pilota; nie mo¿e byæ puste
    CONSTRAINT idPilota_pk PRIMARY KEY(idPilota)--klucz glówny
);

CREATE TABLE Przyloty (
    idLotu INT CONSTRAINT id_przylotu_nn NOT NULL, --id lotu; nie mo¿e byæ puste
    lotnisko VARCHAR(3), -- kod lotniska z którego samolot przylecial
    idKapitana INT, -- id pilota bêdacego kapitanem
    idBramki VARCHAR(3), --bramka do ktorej samolot dokuje
    idSamolotu INT, --id samolotu obslugujacego lot
    liniaLotnicza VARCHAR(25), --linia lotnicza obslugujaca lot
    dataPrzylotu TIMESTAMP CONSTRAINT data_przy_nn NOT NULL, -- data przylotu samolotu na lotnisko
    CONSTRAINT idPrzylotu_pk PRIMARY KEY(idLotu),--klucz glówny
    CONSTRAINT prz_lotnisko_fk FOREIGN KEY (lotnisko) REFERENCES PortyLotnicze(kodIATA),  --klucz obcy laczacy z tabela PortyLotnicze
    CONSTRAINT prz_idKapitana_fk FOREIGN KEY (idKapitana) REFERENCES Piloci(idPilota), --klucz obcy laczacy z tabela Piloci
    CONSTRAINT prz_bramka_fk FOREIGN KEY (idBramki) REFERENCES Bramki(idBramki), --klucz obcy laczacy z tabela Bramki
    CONSTRAINT prz_idSamolotu_fk FOREIGN KEY (idSamolotu) REFERENCES Samoloty(idSamolotu), --klucz obcy laczacy z tablica Samoloty
    CONSTRAINT prz_linia_fk FOREIGN KEY (liniaLotnicza) REFERENCES LinieLotnicze(nazwaLini) --klucz obcy laczacy z tablica LinieLotnicze
);

CREATE TABLE Odloty (
    idLotu INT CONSTRAINT id_odlotu_nn NOT NULL,
    lotnisko VARCHAR(3),-- kod lotniska do ktorego samolot leci
    idKapitana INT, -- id pilota bêdacego kapitanem
    idBramki VARCHAR(3), --bramka z ktorej samolot odlatuje
    idSamolotu INT,--id samolotu obslugujacego lot
    liniaLotnicza VARCHAR(25), --linia lotnicza obslugujaca lot
    dataOdlotu TIMESTAMP CONSTRAINT data_odlotu_nn NOT NULL, -- data odlotu samolotu na lotnisko
    CONSTRAINT idOdlotu_pk PRIMARY KEY(idLotu),--klucz glówny
    CONSTRAINT od_lotnisko_fk FOREIGN KEY (lotnisko) REFERENCES PortyLotnicze(kodIATA),  --klucz obcy laczacy z tabela PortyLotnicze
    CONSTRAINT od_idKapitana_fk FOREIGN KEY (idKapitana) REFERENCES Piloci(idPilota), --klucz obcy laczacy z tabela Piloci
    CONSTRAINT od_bramka_fk FOREIGN KEY (idBramki) REFERENCES Bramki(idBramki), --klucz obcy laczacy z tabela Bramki
    CONSTRAINT od_idSamolotu_fk FOREIGN KEY (idSamolotu) REFERENCES Samoloty(idSamolotu), --klucz obcy laczacy z tablica Samoloty
    CONSTRAINT od_linia_fk FOREIGN KEY (liniaLotnicza) REFERENCES LinieLotnicze(nazwaLini) --klucz obcy laczacy z tablica LinieLotnicze
);

CREATE TABLE Podró¿nik(
    idOdlotu INT, --id lotu podró¿nika
    nrPaszportu VARCHAR(9), --numer paszportu podró¿nika
    Imie VARCHAR(20) CONSTRAINT pod_imie_nn NOT NULL, --Imie podró¿nika niebêdace puste
    Nazwisko VARCHAR(30) CONSTRAINT pod_nazwisko_nn NOT NULL, --Nazwisko Podró¿nika niebêdace puste
    Wiek INT CONSTRAINT pod_wiek_nn NOT NULL, --wiek podró¿nika niebêdace puste
    baga¿Rejestowany VARCHAR(3) CONSTRAINT pod_bg_rej_ck CHECK(baga¿Rejestowany IN ('TAK', 'NIE')), --czy podró¿nika ma ze soba baga¿ rejestrowany (TAK/NIE)?
    CONSTRAINT nrPodr_pk PRIMARY KEY(nrPaszportu), -- klucz glówny
    CONSTRAINT idOdlotu_fk FOREIGN KEY (idOdlotu) REFERENCES Odloty(idLotu) -- klucz obcy laczacy z tabela Odloty
    
);

CREATE TABLE Przybysz(
    idLotu INT, --id lotu przybysza
    nrPaszportu VARCHAR(9), --nr paszportu przybysza niebêdace puste
    Imie VARCHAR(20) CONSTRAINT prz_imie_nn NOT NULL, --imie przybysz niebêdace puste
    Nazwisko VARCHAR(30) CONSTRAINT prz_nazwisko_nn NOT NULL, --nazwisko przybysza niebêdace puste
    Wiek INT CONSTRAINT prz_wiek_nn NOT NULL, --wiek przybysza niebedacy pusty
    baga¿Rejestowany VARCHAR(3) CONSTRAINT prz_bg_rej_ck CHECK(baga¿Rejestowany IN ('TAK', 'NIE')), --czy przybysz ma ze soba baga¿ rejestrowany (TAK/NIE)?
    CONSTRAINT nrPrzy_pk PRIMARY KEY(nrPaszportu),--klucz glówny
    CONSTRAINT idPrzylotu_fk FOREIGN KEY (idLotu) REFERENCES Przyloty(idLotu)--klucz obcy laczacy z tabela Przyloty
);

CREATE TABLE Kontroler(
    Imie VARCHAR(30) CONSTRAINT kon_imie_nn NOT NULL, --imie kontrolera bêdace niepuste
    Nazwisko VARCHAR(30) CONSTRAINT kon_nazwisko_nn NOT NULL, --nazwisko kontrolera bedace niepuste
    Bramka VARCHAR(3) NOT NULL, --bramka przy ktorej pracuje kontroler; niepuste
    CONSTRAINT kon_bramka_fk FOREIGN KEY (Bramka) REFERENCES Bramki (idBramki) --klucz obcy laczacy z tabela bramki
);




--WSTAWIANIE DANYCH

--Samoloty
INSERT INTO Samoloty VALUES(1, 'Boeing', '737', 'pasa¿erski',150);
INSERT INTO Samoloty VALUES(2, 'Boeing', '747', 'pasa¿erski',420);
INSERT INTO Samoloty VALUES(3, 'Boeing', '747', 'cargo', NULL);
INSERT INTO Samoloty VALUES(4, 'Boeing', '757', 'cargo', NULL);
INSERT INTO Samoloty VALUES(5, 'Boeing', '777', 'pasa¿erski',400);
INSERT INTO Samoloty VALUES(6, 'Boeing', '787', 'pasa¿erski',300);
INSERT INTO Samoloty VALUES(7, 'Airbus', 'A320', 'pasa¿erski', 150);
INSERT INTO Samoloty VALUES(8, 'Airbus', 'A330', 'pasa¿erski', 270);
INSERT INTO Samoloty VALUES(9, 'Airbus', 'A340', 'pasa¿erski', 350);
INSERT INTO Samoloty VALUES(10, 'Airbus', 'A350', 'pasa¿erski', 330);
INSERT INTO Samoloty VALUES(11, 'Airbus', 'A380', 'pasa¿erski', 555);
INSERT INTO Samoloty VALUES(12, 'Bombardier', 'CRJ-800', 'pasa¿erski', 70);
INSERT INTO Samoloty VALUES(13, 'Bombardier', 'CRJ-900', 'pasa¿erski', 90);

--LinieLotnicze

INSERT INTO LinieLotnicze VALUES('Lufthansa', 'LH', 'Niemcy');
INSERT INTO LinieLotnicze VALUES('LOT Polish Airlanes', 'LO', 'Polska');
INSERT INTO LinieLotnicze VALUES('British Airways', 'BA', 'Wielka Brytania');
INSERT INTO LinieLotnicze VALUES('Emirates', 'EK', 'Dubai');
INSERT INTO LinieLotnicze VALUES('Etihad Airways', 'EY', 'Zjednoczone Emitary Arabskie');
INSERT INTO LinieLotnicze VALUES('Air France', 'AF', 'Francja');
INSERT INTO LinieLotnicze VALUES('Scandinavian Airlanes', 'SK', NULL);
INSERT INTO LinieLotnicze VALUES('FedEx Express', 'FX', NULL);
INSERT INTO LinieLotnicze VALUES('Cargolux', 'CV', NULL);
INSERT INTO LinieLotnicze VALUES('KLM', 'KL', 'Holandia');
INSERT INTO LinieLotnicze VALUES('Air China', 'CA', 'Chiny');
INSERT INTO LinieLotnicze VALUES('United Airlanes', 'UA', 'Stany Zjednoczone');
INSERT INTO LinieLotnicze VALUES('Singapore Airlines', 'SQ', 'Singapur');
INSERT INTO LinieLotnicze VALUES('Korean Air', 'KE', 'Korea Poludniowa');
INSERT INTO LinieLotnicze VALUES('Air Canada', 'AC', 'Kanada');


--Lotniska

INSERT INTO PortyLotnicze VALUES('Wroclaw', 'WRO', 'Polska');
INSERT INTO PortyLotnicze VALUES('Katowice', 'KTW', 'Polska');
INSERT INTO PortyLotnicze VALUES('Kraków', 'KRK', 'Polska');
INSERT INTO PortyLotnicze VALUES('Monachium', 'MUC', 'Niemcy');
INSERT INTO PortyLotnicze VALUES('Frankfurt', 'FRA', 'Niemcy');
INSERT INTO PortyLotnicze VALUES('Pary¿', 'CDG', 'Francja');
INSERT INTO PortyLotnicze VALUES('Amsterdam', 'AMS', 'Holandia');
INSERT INTO PortyLotnicze VALUES('Londyn', 'LHR', 'Wielka Brytania');
INSERT INTO PortyLotnicze VALUES('Los Angeles', 'LAX', 'Stany Zjednoczone');
INSERT INTO PortyLotnicze VALUES('Toronto', 'YYZ', 'Kanada');
INSERT INTO PortyLotnicze VALUES('Waszyngton', 'IAD', 'Stany Zjednoczone');
INSERT INTO PortyLotnicze VALUES('Oslo', 'OSL', 'Norwegia');
INSERT INTO PortyLotnicze VALUES('Sztokholm', 'ARN', 'Szwecja');
INSERT INTO PortyLotnicze VALUES('Abu Zabi', 'AUH', 'Zjednoczone Emiraty Arabskie');
INSERT INTO PortyLotnicze VALUES('Pekin', 'PEK', 'Chiny');
INSERT INTO PortyLotnicze VALUES('Singapur', 'SIN', 'Singapur');
INSERT INTO PortyLotnicze VALUES('Seul', 'ICN', 'Kore Poludniowa');
INSERT INTO PortyLotnicze VALUES('Wilno', 'VNO', 'Litwa');
INSERT INTO PortyLotnicze VALUES('Nowy Jork', 'JFK', 'Stany Zjednoczone');
INSERT INTO PortyLotnicze VALUES('Moskwa', 'DME', 'Rosja');
INSERT INTO PortyLotnicze VALUES('Lublin', 'LUZ', 'Polska');
INSERT INTO PortyLotnicze VALUES('Chicago', 'ORD', 'Stany Zjednoczone');
INSERT INTO PortyLotnicze VALUES('Rzym', 'FCO', 'Wochy');
INSERT INTO PortyLotnicze VALUES('Praga', 'PRG', 'Czechy');
INSERT INTO PortyLotnicze VALUES('Nowe Deli', 'DEL', 'Indie');
INSERT INTO PortyLotnicze VALUES('Wiedeñ', 'VIE', 'Austria');
INSERT INTO PortyLotnicze VALUES('Gdañsk', 'GDN', 'Polska');

--Piloci
INSERT INTO Piloci VALUES('1','Mason','Campbell','36','M', 10);
INSERT INTO Piloci VALUES('2','Jay','Rose','40','M', 14);
INSERT INTO Piloci VALUES('3','Jake','Morgan','49','M', 19);
INSERT INTO Piloci VALUES('4','Kayden','Davidson','46','M', 12);
INSERT INTO Piloci VALUES('5','Reuben','Gordon','37','M', 10);
INSERT INTO Piloci VALUES('6','Frederick','George','40','M', 11);
INSERT INTO Piloci VALUES('7','Emanuel','Adams','43','M', 11);
INSERT INTO Piloci VALUES('8','Kash','Dalton','33','M', 5);
INSERT INTO Piloci VALUES('9','Randy','Watson','43','M', 15);
INSERT INTO Piloci VALUES('10','Caiden','Frost','35','M', 5);
INSERT INTO Piloci VALUES('11','Rodney','Norman','35','M', 7);
INSERT INTO Piloci VALUES('12','Erik','Simmons','33','M', 4);
INSERT INTO Piloci VALUES('13','Trevon','Diaz','32','M', 6);
INSERT INTO Piloci VALUES('14','Raylan','Talley','32','M', 5);
INSERT INTO Piloci VALUES('15','Lionel','Heath','49','M', 19);
INSERT INTO Piloci VALUES('16','Landyn','Aguilar','32','M', 3);
INSERT INTO Piloci VALUES('17','Jayden','Austin','42','M', 13);
INSERT INTO Piloci VALUES('18','Emily','Knight','42','K', 15);
INSERT INTO Piloci VALUES('19','Sophie','Baker','35','K', 6);
INSERT INTO Piloci VALUES('20','Summer','Stone','32','K', 5);
INSERT INTO Piloci VALUES('21','Celia','Greer','30','K', 3);
INSERT INTO Piloci VALUES('22','Edward','Baranowski','35','M', 8);
INSERT INTO Piloci VALUES('23','Joachim','B¹k','38','M', 12);
INSERT INTO Piloci VALUES('24','Gustaw','Michalak','42','M', 15);
INSERT INTO Piloci VALUES('25','Kordian','Ko³odziej','37','M', 8);
INSERT INTO Piloci VALUES('26','Beata','Mazurek','33','K', 4);
INSERT INTO Piloci VALUES('27','Józefa','Szymañska','46','K', 18);
INSERT INTO Piloci VALUES('28','Patrycja','Niedziela','32','K', 5);
INSERT INTO Piloci VALUES('29','Kamil','Œlimak','49','M', 20);
INSERT INTO Piloci VALUES('30','Andrew','Young','42','M', 11);

--Bramki
INSERT INTO Bramki VALUES('A01', '1');
INSERT INTO Bramki VALUES('A02', '1');
INSERT INTO Bramki VALUES('A03', '1');
INSERT INTO Bramki VALUES('B01', '1');
INSERT INTO Bramki VALUES('B02', '1');
INSERT INTO Bramki VALUES('B03', '1');
INSERT INTO Bramki VALUES('C01', '2');
INSERT INTO Bramki VALUES('C02', '2');
INSERT INTO Bramki VALUES('C03', '2');
INSERT INTO Bramki VALUES('D01', '2');
INSERT INTO Bramki VALUES('D02', '2');
INSERT INTO Bramki VALUES('D03', '2');
INSERT INTO Bramki VALUES('E01', '3');
INSERT INTO Bramki VALUES('E02', '3');
INSERT INTO Bramki VALUES('E03', '3');
INSERT INTO Bramki VALUES('S01', '4');
INSERT INTO Bramki VALUES('S02', '4');
INSERT INTO Bramki VALUES('S03', '4');

--Kontroler
INSERT INTO Kontroler VALUES('Eliza','Jasiñska', 'A01');
INSERT INTO Kontroler VALUES('Marlena','Kowalczyk', 'A02');
INSERT INTO Kontroler VALUES('Lidia','WoŸniak', 'A03');
INSERT INTO Kontroler VALUES('Wanda','Sobczak', 'B01');
INSERT INTO Kontroler VALUES('Marlena','Baranowska', 'B02');
INSERT INTO Kontroler VALUES('Marta','Gajewska', 'B03');
INSERT INTO Kontroler VALUES('Elwira','Wojciechowska', 'C01');
INSERT INTO Kontroler VALUES('Aneta','Baran', 'C02');
INSERT INTO Kontroler VALUES('Juliusz','G³owacka', 'C03');
INSERT INTO Kontroler VALUES('Jan','Piotrowski', 'D01');
INSERT INTO Kontroler VALUES('Kordian','Ostrowski', 'D02');
INSERT INTO Kontroler VALUES('Olaf','Pietrzak', 'D03');
INSERT INTO Kontroler VALUES('Cecylia','Krawczyk', 'E01');
INSERT INTO Kontroler VALUES('Zofia','Malinowska', 'E02');
INSERT INTO Kontroler VALUES('£ucja','Zalewska', 'E03');

--Przyloty 
INSERT INTO Przyloty VALUES(1,'WRO', 25, 'A01', 12, 'LOT Polish Airlanes', TO_DATE('01/01/2021 12:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(2,'VIE', 29, 'B01', 1, 'LOT Polish Airlanes', TO_DATE('01/01/2021 12:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(3,'FRA', 5, 'B02', 2, 'Lufthansa', TO_DATE('01/01/2021 12:45' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(4,'ORD', 7, 'C01', 5, 'United Airlanes', TO_DATE('01/01/2021 13:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(5,'KRK', 9, 'A02', 12, 'LOT Polish Airlanes', TO_DATE('01/01/2021 13:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(6,'AUH', 11, 'D01', 11, 'Etihad Airways', TO_DATE('01/01/2021 13:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(7,'PEK', 13, 'E01', 2, 'Air China', TO_DATE('01/01/2021 13:45' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(8,'ICN', 15, 'E02', 2, 'Korean Air', TO_DATE('01/01/2021 14:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(9,'LAX', 17, 'C02', 13, 'LOT Polish Airlanes', TO_DATE('01/01/2021 14:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(10,'MUC', 19, 'B01', 3, 'Lufthansa', TO_DATE('01/01/2021 16:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(11,'LUZ', 27, 'B02', 13, 'LOT Polish Airlanes', TO_DATE('01/01/2021 16:45' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(12,'OSL', 23, 'C01', 5, 'United Airlanes', TO_DATE('01/01/2021 17:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(13,'KTW', 1, 'S01', 3, 'Cargolux', TO_DATE('01/01/2021 17:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(14,'DME', 21, 'S03', 3, 'Cargolux', TO_DATE('01/01/2021 17:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Przyloty VALUES(15,'ARN', 3, 'S03', 4, 'FedEx Express', TO_DATE('01/01/2021 17:45' , 'dd/mm/yyyy hh24-mi'));

--Odloty
INSERT INTO Odloty VALUES(16,'CDG', 2, 'A03', 10, 'Air France', TO_DATE('01/01/2021 7:10' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(17,'AMS', 4, 'B03', 6, 'KLM', TO_DATE('01/01/2021 7:20' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(18,'LHR', 6, 'B01', 8, 'British Airways', TO_DATE('01/01/2021 7:40', 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(19,'FCO', 26, 'A02', 12, 'LOT Polish Airlanes', TO_DATE('01/01/2021 8:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(20,'JFK', 10, 'C02', 5, 'United Airlanes', TO_DATE('01/01/2021 8:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(21,'SIN', 12, 'D01', 11, 'Singapore Airlines', TO_DATE('01/01/2021 8:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(22,'YYZ', 14, 'C01', 9, 'Air Canada', TO_DATE('01/01/2021 10:45' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(23,'ARN', 16, 'E02', 7, 'Scandinavian Airlanes', TO_DATE('01/01/2021 11:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(24,'AUH', 18, 'C02', 11, 'Emirates', TO_DATE('01/01/2021 11:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(25,'VNO', 20, 'B01', 3, 'Cargolux', TO_DATE('01/01/2021 13:31' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(26,'FCO', 22, 'B02', 1, 'LOT Polish Airlanes', TO_DATE('01/01/2021 16:45' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(27,'DEL', 24, 'E01', 5, 'LOT Polish Airlanes', TO_DATE('01/01/2021 17:00' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(28,'GDN', 8, 'S01', 4, 'FedEx Express', TO_DATE('01/01/2021 17:15' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(29,'PRG', 28, 'A03', 8, 'LOT Polish Airlanes', TO_DATE('01/01/2021 17:30' , 'dd/mm/yyyy hh24-mi'));
INSERT INTO Odloty VALUES(30,'FRA', 30, 'B03', 2, 'Lufthansa', TO_DATE('01/01/2021 17:45' , 'dd/mm/yyyy hh24-mi'));

--Podró¿nik
INSERT INTO Podró¿nik VALUES(19,'2625100','Heronim','Górski','46', 'TAK');
INSERT INTO Podró¿nik VALUES(18,'5008309','Andrzej','Mazurek','43', 'TAK');
INSERT INTO Podró¿nik VALUES(27,'5216701','Juliusz','Sadowska','48', 'TAK');
INSERT INTO Podró¿nik VALUES(22,'5891156','Jerzy','Makowski','39', 'TAK');
INSERT INTO Podró¿nik VALUES(19,'3335228','Alek','Szewczyk','62', 'TAK');
INSERT INTO Podró¿nik VALUES(20,'7034387','Karol','Borkowski','35', 'NIE');
INSERT INTO Podró¿nik VALUES(19,'1047345','Karol','Krupa','27', 'NIE');
INSERT INTO Podró¿nik VALUES(26,'3541955','Leszek','Lis','40', 'TAK');
INSERT INTO Podró¿nik VALUES(27,'9076243','Franciszek','Szczepañski','27', 'NIE');
INSERT INTO Podró¿nik VALUES(20,'9951255','Aureliusz','D¹browski','46', 'TAK');
INSERT INTO Podró¿nik VALUES(19,'8369750','Otylia','WoŸniak','28', 'TAK');
INSERT INTO Podró¿nik VALUES(20,'4043774','Berenika','Brzeziñska','74', 'TAK');
INSERT INTO Podró¿nik VALUES(17,'2235537','Alice','Zawadzka','22', 'TAK');
INSERT INTO Podró¿nik VALUES(27,'3425196','Oliwia','Sikora','37', 'TAK');
INSERT INTO Podró¿nik VALUES(20,'9404693','Konstancja','Ostrowska','26', 'NIE');
INSERT INTO Podró¿nik VALUES(30,'7923139','Aniela','Wojciechowska','28', 'TAK');
INSERT INTO Podró¿nik VALUES(16,'4068766','Amelia','Zió³kowska','38', 'TAK');
INSERT INTO Podró¿nik VALUES(21,'1971925','¯aneta','Kucharska','21', 'TAK');
INSERT INTO Podró¿nik VALUES(16,'1558698','Ró¿a','Mazurek','42', 'NIE');
INSERT INTO Podró¿nik VALUES(21,'4003325','Katarzyna','Czarnecka','34', 'TAK');
INSERT INTO Podró¿nik VALUES(27,'6698360','Ada','B¹k','27', 'TAK');
INSERT INTO Podró¿nik VALUES(18,'5761590','Roksana','Górska','29', 'TAK');
INSERT INTO Podró¿nik VALUES(17,'8498678','Czes³awa','D¹browska','29', 'TAK');
INSERT INTO Podró¿nik VALUES(30,'5321535','John','Davis','48', 'TAK');
INSERT INTO Podró¿nik VALUES(18,'3525123','Jenson','Fletcher','46', 'TAK');
INSERT INTO Podró¿nik VALUES(22,'1844737','Hayden','Gardner','39', 'TAK');
INSERT INTO Podró¿nik VALUES(27,'8437967','Adam','Turner','37', 'TAK');
INSERT INTO Podró¿nik VALUES(23,'9911478','Dominic','Young','36', 'TAK');
INSERT INTO Podró¿nik VALUES(30,'9697535','Deacon','Ayers','29', 'TAK');
INSERT INTO Podró¿nik VALUES(17,'5257574','Rohan','Rich','48', 'TAK');
INSERT INTO Podró¿nik VALUES(18,'5384364','Christopher','Freeman','22', 'TAK');
INSERT INTO Podró¿nik VALUES(23,'1412513','Wilson','Chase','49', 'TAK');
INSERT INTO Podró¿nik VALUES(29,'3826635','Sterling','Harvey','27', 'NIE');
INSERT INTO Podró¿nik VALUES(24,'4601174','Victoria','Collins','21', 'TAK');
INSERT INTO Podró¿nik VALUES(24,'8782464','Millie','Harper','42', 'TAK');
INSERT INTO Podró¿nik VALUES(29,'3422402','Matilda','Atkinson','47', 'TAK');
INSERT INTO Podró¿nik VALUES(16,'3777716','Lexi','Phillips','47', 'TAK');
INSERT INTO Podró¿nik VALUES(30,'1112103','Poppy','Hayes','34', 'TAK');
INSERT INTO Podró¿nik VALUES(30,'8008893','Willa','Cooke','31', 'TAK');
INSERT INTO Podró¿nik VALUES(16,'7724529','Gisselle','Howard','40', 'TAK');
INSERT INTO Podró¿nik VALUES(17,'7814552','Serenity','Patrick','42', 'TAK');
INSERT INTO Podró¿nik VALUES(17,'5715936','Coraline','Tran','29', 'TAK');
INSERT INTO Podró¿nik VALUES(26,'9644721','Zaria','Merritt','23', 'NIE');

--Przybysz
INSERT INTO Przybysz VALUES(3,'7397699','Jan','Borkowski',36, 'TAK');
INSERT INTO Przybysz VALUES(12,'8229064','Rados³aw','Szczepañski',28, 'TAK');
INSERT INTO Przybysz VALUES(10,'9097218','Maciej','Kubiak',33, 'NIE');
INSERT INTO Przybysz VALUES(4,'1797767','Oskar','Piotrowski',42, 'TAK');
INSERT INTO Przybysz VALUES(11,'9323819','Jacek','Jankowski',75, 'TAK');
INSERT INTO Przybysz VALUES(3,'4062384','Kacper','Kowalczyk',21, 'TAK');
INSERT INTO Przybysz VALUES(6,'4451967','Ksawery','Pietrzak',48, 'TAK');
INSERT INTO Przybysz VALUES(1,'5156654','Bartosz','Szymañski',42, 'NIE');
INSERT INTO Przybysz VALUES(9,'2050667','Mieszko','W³odarczyk',78, 'TAK');
INSERT INTO Przybysz VALUES(4,'2034732','Janusz','Koz³owski',49, 'TAK');
INSERT INTO Przybysz VALUES(8,'4421399','Urszula','Witkowska',22, 'TAK');
INSERT INTO Przybysz VALUES(2,'8880678','Czes³awa','WoŸniak',35, 'NIE');
INSERT INTO Przybysz VALUES(9,'3004633','Lidia','Michalak',41, 'TAK');
INSERT INTO Przybysz VALUES(12,'7675166','Lidia','Szczepañska',40, 'TAK');
INSERT INTO Przybysz VALUES(11,'2638696','Luiza','Mazur',43, 'TAK');
INSERT INTO Przybysz VALUES(5,'5040340','Oktawia','Koz³owska',44, 'TAK');
INSERT INTO Przybysz VALUES(6,'7522263','Kamila','Walczak',47, 'NIE');
INSERT INTO Przybysz VALUES(5,'9414357','Alice','Wróblewska',34, 'TAK');
INSERT INTO Przybysz VALUES(2,'3919484','Ma³gorzata','G³owacka',44, 'TAK');
INSERT INTO Przybysz VALUES(11,'8816153','Agata','Borkowska',27, 'TAK');
INSERT INTO Przybysz VALUES(10,'2440595','Jordan','Lawson',32, 'NIE');
INSERT INTO Przybysz VALUES(4,'6681518','Joe','Shaw',29, 'TAK');
INSERT INTO Przybysz VALUES(9,'3543334','Caleb','Bell',34, 'TAK');
INSERT INTO Przybysz VALUES(8,'4360375','Frankie','Edwards',44, 'TAK');
INSERT INTO Przybysz VALUES(1,'8688321','Zak','Ryan',43, 'TAK');
INSERT INTO Przybysz VALUES(4,'8869999','Samuel','Goff',41, 'TAK');
INSERT INTO Przybysz VALUES(6,'8011413','Victor','Walton',31, 'TAK');
INSERT INTO Przybysz VALUES(1,'8019886','Kingston','Erickson',70, 'TAK');
INSERT INTO Przybysz VALUES(9,'1167973','Bruno','Bullock',37, 'TAK');
INSERT INTO Przybysz VALUES(1,'5331906','Maximus','Vaughan',27, 'TAK');
INSERT INTO Przybysz VALUES(10,'7778825','Amelia','Clark',30, 'TAK');
INSERT INTO Przybysz VALUES(3,'8957201','Georgina','Read',25, 'TAK');
INSERT INTO Przybysz VALUES(6,'8358141','Amy','Chapman',38, 'TAK');
INSERT INTO Przybysz VALUES(3,'7689753','Keira','Wood',30, 'TAK');
INSERT INTO Przybysz VALUES(12,'2829679','Daisy','Smith',31, 'TAK');
INSERT INTO Przybysz VALUES(2,'1604767','Sierra','Raymond',74, 'TAK');
INSERT INTO Przybysz VALUES(5,'8781976','Zoe','Horton',44, 'TAK');
INSERT INTO Przybysz VALUES(3,'6778499','Erika','Wynn',43, 'TAK');
INSERT INTO Przybysz VALUES(2,'2224568','Laylah','Hunt',42, 'TAK');
INSERT INTO Przybysz VALUES(8,'3067835','Demi','Mcgowan',28, 'TAK');

