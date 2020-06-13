--PROJEKCJIE:
--Wybór wszystkich numerów  paszportów osób przylatujacych na lotnisko
SELECT nrPaszportu FROM Przybysz;
--Wybór wszystkich modeli samolotów przylatujacych i odlatujacych z lotniska
SELECT DISTINCT Producent, Modelm FROM Samoloty ORDER BY Producent DESC;
--Wybór wszystkich dat i godzin przylotów
SELECT dataPrzylotu FROM Przyloty;
--Znalezienie wszystkich terminali
SELECT DISTINCT Terminal FROM Bramki;
--Linie lotnicze operujace na lotnisku
SELECT nazwaLini FROM LinieLotnicze;
--Piloci przylatujacy/odlatujacy 
SELECT Imie, Nazwisko FROM Piloci;
--Imiona i nazwika podró¿ujacych
SELECT Imie, Nazwisko FROM Podró¿nik;
--Producenci samolotów które operuja na lotnisku
SELECT DISTINCT Producent FROM Samoloty;
--Jakie bramki sa na lotnisku
SELECT idBramki FROM Bramki;
--Kontrolerzy biletow
SELECT Imie, Nazwisko FROM Kontroler;

--SELEKCJE:
--Podró¿nik starszy ni¿ 60 lat
SELECT IMIE, Nazwisko, Wiek, nrPaszportu FROM Podró¿nik WHERE Wiek >=60;
--Brami znajdujace sie na terminalu 2
SELECT idBramki FROM Bramki WHERE Terminal = 2;
--Piloci przylatujacy/odlatujacy bêdacy kobietami
SELECT Imie, Nazwisko FROM Piloci WHERE Pleæ = 'K';
--Kontrolerzy pracujacy przy bramkach A
SELECT Imie, Nazwisko FROM Kontroler WHERE Bramka LIKE 'A%';
--Samoloty cargo operujace na lotnisku
SELECT Producent, Modelm FROM Samoloty WHERE Typ = 'cargo';
--Piloci starsi ni¿ 45 lat
SELECT Imie, Nazwisko, Wiek FROM Piloci WHERE Wiek >=45;
--Samoloty przewo¿ace wiêcej ni¿ 400 osob
SELECT Producent, Modelm, standliczbamiejsc FROM Samoloty WHERE standliczbamiejsc >=400;
--Piloci ze sta¿em wiêkszym ni¿ 15 lat
SELECT Imie, Nazwisko, Sta¿ FROM Piloci WHERE Sta¿ >= 15;
--Porty lotnicze znajdujace sie w Polsce
SELECT NazwaMiasta FROM PortyLotnicze WHERE Pañstwo = 'Polska';
--Podró¿ni nieposiadajacy baga¿u rejestrowanego
SELECT Imie, Nazwisko, nrPaszportu FROM Podró¿nik WHERE baga¿Rejestowany = 'NIE';

--JOINY 2 TABLICE
--Osoby pracyjacy na terminalu 2
SELECT Kontroler.Imie, Kontroler.Nazwisko FROM Bramki INNER JOIN Kontroler ON Bramki.idBramki=Kontroler.Bramka WHERE Terminal = '2';
--Linie Lotnicze przylatujace na lotnisko boeingami
SELECT Przyloty.LiniaLotnicza FROM Samoloty INNER JOIN Przyloty ON Samoloty.idSamolotu=przyloty.idsamolotu WHERE Producent = 'Boeing';
--idLotow przylatujace na Terminal 1
SELECT Przyloty.idLotu FROM Bramki INNER JOIN Przyloty ON Przyloty.idBramki=Bramki.idBramki WHERE Terminal='1';
--Piloci latajacy z lotniska liniami LOT Polish Airlanes
SELECT Piloci.Imie, Piloci.Nazwisko FROM Odloty INNER JOIN Piloci ON Piloci.idPilota=Odloty.idKapitana WHERE LiniaLotnicza = 'LOT Polish Airlanes';
--Przybysze bez baga¿u przylatujacy po godzine 12
SELECT Przybysz.Imie, Przybysz.Nazwisko, Przybysz.nrPaszportu FROM Przyloty INNER JOIN Przybysz ON Przybysz.idLotu=Przyloty.idLotu WHERE (przybysz.baga¿rejestowany = 'NIE' AND przyloty.dataprzylotu >= TO_DATE('01/01/2021 16:00' , 'dd/mm/yyyy hh24-mi'));
--Osoby podró¿ujace Lufthansa
SELECT Podró¿nik.Imie, Podró¿nik.Nazwisko, Podró¿nik.nrPaszportu FROM Odloty INNER JOIN Podró¿nik ON Podró¿nik.idOdLotu=Odloty.idLotu WHERE LiniaLotnicza = 'Lufthansa';
--Przewidywana liczba osob przybylych
SELECT SUM(Samoloty.standliczbamiejsc) FROM Przyloty INNER JOIN Samoloty ON Przyloty.idSamolotu=Samoloty.idSamolotu;
--Samoloty przylatujace na lotnisko
SELECT UNIQUE Samoloty.Producent, Samoloty.Modelm FROM Przyloty INNER JOIN Samoloty ON Samoloty.idSamolotu=Przyloty.idSamolotu;
--Samoloty cargo, które przyleciay po 12
SELECT UNIQUE Samoloty.Producent, Samoloty.Modelm FROM Przyloty INNER JOIN Samoloty ON Samoloty.idSamolotu=Przyloty.idSamolotu WHERE( przyloty.dataprzylotu >= TO_DATE('01/01/2021 16:00' , 'dd/mm/yyyy hh24-mi') AND Samoloty.typ = 'cargo');
--Osoby majace 70 i wiecej lat przylatujace na lotnisko
SELECT Przybysz.Imie, Przybysz.Nazwisko, Przybysz.nrPaszportu FROM Przyloty INNER JOIN Przybysz ON Przyloty.idLotu=Przybysz.idLotu WHERE wiek>=70;

--3 Joiny
--Piloci odlatujacy Boeingami
SELECT Piloci.Imie, Piloci.Nazwisko FROM Odloty INNER JOIN Piloci ON Odloty.idKapitana=Piloci.idPilota INNER JOIN Samoloty ON Odloty.idSamolotu=Samoloty.idSamolotu WHERE Producent='Boeing';
--Osoby podró¿ujace z terminala 3
SELECT Podró¿nik.Imie, Podró¿nik.Nazwisko, Podró¿nik.nrPaszportu FROM Odloty INNER JOIN Podró¿nik ON Podró¿nik.idOdLotu=Odloty.idLotu INNER JOIN Bramki ON Odloty.idBramki=Bramki.idBramki WHERE Terminal = '2';
--Przyloty z Polski na terminal 1
SELECT Przyloty.idLotu FROM PortyLotnicze INNER JOIN Przyloty ON Przyloty.lotnisko=Portylotnicze.kodIATA INNER JOIN Bramki ON Przyloty.idbramki=bramki.idbramki WHERE (Terminal = '1' AND Pañstwo='Polska');
--Piloci przylatujacy z USA
SELECT Piloci.Imie, Piloci.Nazwisko FROM Przyloty INNER JOIN Piloci ON Przyloty.idKapitana=Piloci.idPilota INNER JOIN PortyLotnicze ON Przyloty.lotnisko=PortyLotnicze.kodIATA WHERE(Pañstwo = 'Stany Zjednoczone');
--Linie lotnicze odlatujace Airbusami A380
SELECT LinieLotnicze.nazwalini, LinieLotnicze.KodLini FROM Odloty INNER JOIN LinieLotnicze ON Odloty.LiniaLotnicza=LinieLotnicze.nazwalini INNER JOIN Samoloty ON Odloty.idSamolotu=Samoloty.idSamolotu WHERE modelm='A380';
--Osoby wylatujace do USA
SELECT Podró¿nik.Imie, Podró¿nik.Nazwisko, Podró¿nik.nrPaszportu FROM Odloty INNER JOIN Podró¿nik ON Odloty.idLotu=Podró¿nik.idOdlotu INNER JOIN PortyLotnicze ON Odloty.lotnisko=PortyLotnicze.kodIATA WHERE pañstwo = 'Stany Zjednoczone';
--Osoby przylatujace Airbusami
SELECT Przybysz.Imie, Przybysz.Nazwisko, Przybysz.nrPaszportu FROM Przyloty INNER JOIN Przybysz ON Przyloty.idLotu=Przybysz.idLotu INNER JOIN Samoloty ON Przyloty.idSamolotu=Samoloty.idSamolotu WHERE Producent='Airbus';
--Piloci latajacy samolotami cargo
SELECT Piloci.Imie, Piloci.Nazwisko FROM Odloty INNER JOIN Piloci ON Odloty.idKapitana=Piloci.idPilota INNER JOIN Samoloty ON Odloty.idSamolotu=Samoloty.idSamolotu WHERE Typ='cargo';
--Linie lotnicze operujace na trasie  USA-Radom
SELECT UNIQUE LinieLotnicze.nazwaLini, LinieLotnicze.Kraj FROM Przyloty INNER JOIN LinieLotnicze ON Przyloty.linialotnicza=Linielotnicze.nazwaLini INNER JOIN PortyLotnicze ON Przyloty.lotnisko=PortyLotnicze.kodIATA WHERE Pañstwo='Stany Zjednoczone'; 
--Potencialna liczba ludzi przybylych na terminal 1 przed godzina 15
SELECT SUM(Samoloty.standliczbamiejsc) FROM Przyloty INNER JOIN Samoloty ON Przyloty.idSamolotu=Samoloty.idSamolotu INNER JOIN Bramki ON Przyloty.idBramki=Bramki.idBramki WHERE (Terminal='1' AND przyloty.dataprzylotu <= TO_DATE('01/01/2021 15:00' , 'dd/mm/yyyy hh24-mi'));


