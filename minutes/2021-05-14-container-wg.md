Indy Docker Container WG
=========================

2020-05-14 4. Meeting
===========================


Attendance
-----------

- Sebastian (EECC)
- Levin (EECC)
- Niclas (Spherity)


State of the Art
-----

Our repo: https://github.com/IDunion/indy-node-container

- Sebastian is still the only contributor. Are there issues using github for our WG?
- Github repo structure cleaned up into run/buil/minutes + minimal READMEs + ghcr builds
- Niclas offered to improve the build actions, which would be great since we are currently using an outdated docker build and push action

- Sebastian: On Docker experiments
  - Buster and Ubtuntu18 based containers build sucessfully. GS1 is running the buster container currently in the test network
  - Vulnerability Scan of the buster container by [Robin has provided a vulnerability](clair-report-indy-node-slim-buster.json) with 1 "critical" and 7 "high" severity issues that should be investigated.

- At [the last indy contributors call](https://wiki.hyperledger.org/display/indy/2021-05-11+Indy+Contributors+Call), Sebastian has shared that we are working on the images and got some very positive feedback
  - Contribution of the images to [indy-node](https://github.com/hyperledger/indy-node) via a PR would be very welcome
  - Helpful hints:
    - Old PR for supervisor'ed containers: https://github.com/hyperledger/indy-node/pull/588/files
    - Sebastian got IBM's Sovrin Steward Dockerfile via Rocket Chat (Based on Ubuntu16 + supervisor)

- Niclas quickly checked the node_control_tool
  - Pool Restart is "off ledger" -> node-gossip? Or some direct TCP communication between the node_control_tools? A quick look at the code seems to indicate the latter.
  - Interesting hard-coded port: https://github.com/hyperledger/indy-node/blob/master/indy_node/utils/node_control_tool.py#L86
  - It might be a good idea to write a wrapper/seperate "controller tool" (script) for containerized nodes


- General state of indy node with regard to a production ID Union Network:
  - Upstream/OSS development is apparently lacking resources to keep up with the maintenance
  - AP6 might have to plan for investing some developer resources into indy_node itself in order to
    - Get the currently urgend maintenance done
    - Cleanup technical dept to reduce future maintenance cost/effort


Next Steps
---------------

- Open ToDos (see github issues):
 - High Level Overview over the goals and state of the art of the WG in README in github
 - Niclas to improve github actions
 - Check Robin's vulnerability scan

- Check/Contact Bcgov:
  - https://github.com/bcgov/aries-cloudagent-container
  - Contact / know how exchange between ID Union and BC Gov could be quite beneficial!


Next Meeting
----------------

- Weekly Fri 9:00-10:00 for the next few weeks
