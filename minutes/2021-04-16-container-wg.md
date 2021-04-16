Indy Docker Container WG
=========================

2020-04-16 2. Meeting
===========================


Teilnehmer
-----------

- Sebastian (EECC)

- Marquart (Siemens)

- Dhia (ING)

- Bernhardt (Bosch)


Vorstellungsrunde / Kennenlernen
-----------------

- Ziele der Partner und Ziele der WG


Ressourcen
----------

- ID Union Einschwingphase
- Noch kein Bescheid
- Geringe Dringlichkeit

Diesen Monat plant nur Sebastian sich konkret mit dem Container Build zu befassen.


Next Steps
---------------

Exploration:

- Sebastian guckt sich einen indy container build basierend auf `python:3.8-slim-buster` an  
  - Ziel: Was sind die Probleme?
  - Working Image bis zum nächsten call unwahrscheinlich
  - Wird auf https://github.com/IDunion/docker-container-wg geteilt


Nächster Termin
----------------

[2021-04-30 9:30 bis 10:00](https://nextcloud.idunion.org/apps/calendar/dayGridMonth/now/edit/popover/L3JlbW90ZS5waHAvZGF2L2NhbGVuZGFycy9zZWJhc3RpYW4vaWQtdW5pb24vNUZDQzNEQzYtRDlDOC00Qjg4LUE4NzYtRUI5NjQzODhBRDA0Lmljcw==/1619767800)


Sonstiges
------------

- Wir wollen CI im github soweit aufbauen, dass build des containers und ggf start (a la docker-compose up) getestet wird. Tests der Funktionalität des Indy Nodes laufen im indy node repository. Wenn möglich soll unser Container dort hin zurück gespielt und im Rahmen der Tests dort mit auf funktionalität des nodes getestet werden.

- Kommunikationskanal ist primär [unser Slack Kanal](https://idunionworkspace.slack.com/archives/C01NPP5C25U)

- Termine halten wir im NextCloud Kalender aktuell ([Kalender Infos](https://docs.nextcloud.com/server/21/user_manual/en/pim/calendar.html))
