# import.sh
#!/bin/bash
mongod --fork --logpath /var/log/mongod.log
mongorestore /dump