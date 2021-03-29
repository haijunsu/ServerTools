Authentication using ~/.mongorc.js
Make sure the permission is 0600 of ~/.mongorc to protect your admin credentials
Add the auth method:

// connect to db
db = connect("localhost:27017/project_db");
// authentication
db.getSiblingDB("project_db").auth("project_admin", "pass");


For db admin user only
db.getSiblingDB("admin").auth("db_admin", "pass");

