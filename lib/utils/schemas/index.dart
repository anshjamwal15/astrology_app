const String userTable = '''
  CREATE TABLE user(
    id TEXT PRIMARY KEY,
    email TEXT,
    name TEXT,
    photo TEXT,
    mobile TEXT,
    creation_date INTEGER 
  )
''';