load(secret);
db = db.getSiblingDB(mydb);
db.createUser (
  { 
    "user": username,
    "pwd": pwd,
    "roles": [
      {
        "role": rolename,
        "db": mydb
      }
    ]
  }
)

