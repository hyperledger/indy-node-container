Indy Docker Container WG
=========================

2020-03-16 Kick Off Meeting
===========================


Vorstellungsrunde
------------------
- Wer will/kann was, welche Container setups laufen aktuell, kurzer Erfahrungsaustausch
Bereits bei drei Teilnehmern Indy Node in Container (GS1, DB, Spherity)



Teilnehmer
-----------

- Sebastian (EECC->GS1): Container
  - https://github.com/Echsecutor/docker-indy-node 

- Robin (DB): Container auf open shift

- Niclas (Spherity): Container abgeleitet von Sovrin / IfIS
  - https://github.com/spherity/sovrin-container/tree/ssi4de
  - von  https://github.com/internet-sicherheit/sovrin-container

- Martin

- Frank (Bosch): VM

- Marquart (Siemens): VM



Ziele der AG
-------------

- Python slim container
- Möglichst wenig dependencies
- Contribution -> Hyperledger
  - Upstream First
  - Keine ID Union Speziallösung

- GitHub Actions, die das Docker Image baut und pusht (CI/CD)
- Ein all-in-one Image vs. Mehrere Images entsprechend der Dependencies?
- Long term ggf: Indy Node Service (systemd) -> Anpassung am Source Code
- Gemeinsames Image, welches alle Konsortialpartner nutzen können
- Nur Open-Source Dependencies
- Evaluierung verschiedener Base Images
  - Ubuntu16.04, Ubuntu20.04, python:3.8-slim-buster, Reg Hat Universal Base Image (UBI), Debian 10 (“Buster”)


Arbeitsweise
------------
- Zuerst IDunion GitHub, später ggF Umzug zu Hyperledger Indy GitHub?
- Vertretung in Indy Contributors Calls?
- Doku nah am Code in Markdown, English, Github
- Alles außer Meeting Minutes in englisch dokumentieren
- Meeting Notes in Meeting Sprache 
  - Deutsch (bis auf weiteres) 
  - Diskussion: in Nextcloud?
  - BEVORZUGT: Alle an einer Stelle -> https://github.com/IDunion/docker-container-wg

- **Start des APs ab Mitte April**
- Nächster Termin in größerer Runde mit Fokus auf Fachlichkeit
- Turnus wird dann definiert (Alle 2 Wochen / Alle 4 Wochen / Fokussierte Sprints VS ?)


Next Steps
----------
- Docker Project in IDunion anlegen ✔️
- Minutes dort speichern ✔️
- **Nächstes Treffen 16. April 11:15 – 12:15 Uhr**
- Slack Channel über GitHub Projekt und Notes informieren

