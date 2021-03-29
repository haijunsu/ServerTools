/**
 * Usage: mongo --eval 'var mydb="<dbname>"; var secret="${PASS_FILE}"' getUsers.js
 *
 */
load(secret);
db = db.getSiblingDB(mydb);
var users = db.getUsers()
print("Total users: " + users.length);
users.forEach(function(user) {
  //print(JSON.stringify(user));
  printjson(user);
});

