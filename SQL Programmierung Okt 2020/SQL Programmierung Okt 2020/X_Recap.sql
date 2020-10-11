/*


TAB deny

Besitzverkettung
dbo.Sicht --> dbo.Sicht--> dbo.Sicht--> dbo.Tab

Schneller: Seiten reduzieren

Seite: hat max 700 Slots, 8192 bytes Volumen, 8060 Nutzlast, i.dR. muss ein DS in die Seite passen 
Seiten 1.1 in RAM

Seiten reduzieren --> RAM weniger -->weniger CPU Last



DB Design: Normalisierung führt zu vielen JOINs.. im Regelfall NF 3
		   --besser wird es durch zB: evtl Redundanz einführen (RngSumme)
											--Pflege der Rendundanz:
												x Trigger unabhängig von Software
												x F() hat keine Daten..leider nicht, muss persistent sein
												x BI Logik (Prozedur ändert ord Details errechnet aber auch RngSumme)
												 --was aber wenn man dann SSMS verwendet
												 --kann per Rechte gesteuert
									Datentypen
									Tabellen evtl splitten, damit die Seiten besser gefüllt werden 
									--Kunden und Kundensonstiges  (Spalten in andere tabellen)

									--part Sicht (DS in andere Tabellen)
										Umsatz2020 , Umsatz2019--> Sicht Check 
										extrem unflexibel
										aber auch statische Systeme Jan, Feb, Mrz
										--> Spoint: part00, part01, ...part31


									--physikalische Part:
											Dgruppen + partScheme + part F()
											Seit SQL 2016 SP1 auch in Express
											kombinierbar mit vielen anderern Mechanismen zb Kompression
											flexibel änderbar (mit einem einzeiler)
											--Messen, dass Part was brachte: TABLE SCAN (Heap) :Seek


												
								
												

									
										




*/