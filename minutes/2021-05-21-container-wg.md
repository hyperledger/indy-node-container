Indy Docker Container WG
=========================

2020-05-14 4. Meeting
===========================


Attendance
-----------

- Sebastian (EECC)
- Niclas (Spherity)
- Marquart (Siemens)
- Guido (Mgm)

State of the Art
-----

Our repo: https://github.com/IDunion/indy-node-container

- Contribution from Guido: test setup to run a local network of 4 nodes
  - Could be integrated into our CI -> we should check with the indy_node CI team
  - VON-network container missing.
    - Apparently they do not push it into any registry
    - We could fork + add build action -> Contribute upstream

- Contribution Robin: Vulnerability scan
  - Nicklas: Integrate vulnerability scan into CI Pipeline

- Init script still not working
  - should be easy to fix (dl + move to appropriate bin folder in container or use .deb instead of pypi package for indy node)

- node controller still missing
  - restart functionality should be easy to port to a container setting
  - upgrade not so trivial. Various options have been discussed. Tagging our Containers with the indy node version would be a first step towards automated container upgrades

Next Steps
---------------

- Issues are being tracked/assigned at https://github.com/IDunion/indy-node-container/issues
  - free to take.
  - If an issue already has an assignee, please slack the respective person about the status to avoid doing the same work twice


Next Meeting
----------------

- Weekly Fri 9:00-10:00 for the next few weeks
