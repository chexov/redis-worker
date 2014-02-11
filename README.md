redis-worker
============

This is a repo with small scripts which helps me to glue redis queues and
shellscripts together.
It is good for running workres on your CPU farm and stuff...

The goal is ability to easily migrate from already running single script in
your production environment.

 - `worker.sh` receives some "taskId" from the redis based queue and knows what
   to do and where to look for the data.

