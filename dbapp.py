import sqlite3

DB = None
CONN = None

def connect_to_db():
    global DB, CONN
    CONN = sqlite3.connect("cursive.db")
    DB = CONN.cursor()

def disconnect_db():
    CONN.close()

def get_user(username, password):
    query = """SELECT * FROM users WHERE username=? AND password=?"""
    DB.execute(query, (username, password))
    rows = DB.fetchall()
    return rows

def create_user(username, password):
    query = """INSERT into users (username, password) VALUES (?, ?)"""
    DB.execute(query, (username, password))
    CONN.commit()

def add_score(username, password, letter, score):
    query = """SELECT rowid FROM users WHERE username=? AND password=?"""
    DB.execute(query, (username, password))
    row = DB.fetchone()
    userId = row[0]
    print ("adding score %s (%s) to user %s"%(letter, score, userId))
    query = """INSERT INTO scores (userId, letter, grade) VALUES (?, ?, ?)"""
    DB.execute(query, (userId, letter, float(score)))
    CONN.commit()

def get_scores(username, password):
    query = """SELECT rowid FROM users WHERE username=? AND password=?"""
    DB.execute(query, (username,password))
    row = DB.fetchone()
    userId = row[0]
    print ("getting scores for user %s"%userId)
    query = """SELECT * FROM scores WHERE userId=?"""
    DB.execute(query, (userId,))
    rows = DB.fetchall()
    return rows