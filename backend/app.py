import sqlite3
import bcrypt
from flask import *

app = Flask(__name__)

app.secret_key = "secret!"

DATABASE = "app.db"

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    db.row_factory = sqlite3.Row
    return db

def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def hash_pwd(pwd):
	return bcrypt.hashpw(pwd.encode('utf-8'), gensalt())

def check_pwd(pwd, hash_):
	return bcrypt.checkpw(pwd.encode('utf-8'), hash_)

@app.route('/userinfo')
def userinfo():
	return jsonify({"loggedin": True, "uid": 1})

@app.route('/login')
def login():
	return jsonify({"success": True})

@app.route('/logout')
def logout():
	return jsonify({"success": True})

@app.route('/vendors')
def vendors():
	vds = dict()
	for row in query_db("SELECT * FROM vendors;"):
		vds[row['vid']] = [dict(row)]
	return jsonify(vds)

@app.route('/products/<int:vid>')
def products(vid):
	pds = dict()
	for row in query_db("SELECT * FROM products WHERE vid=?", [vid]):
		pds[row['pid']] = [dict(row)]
	return jsonify(pds)

@app.route('/placeOrder', methods=["POST"])
def placeOrder():
	return jsonify({"success": True})

@app.route('/orders/<int:uid>')
def orders(uid):
	return jsonify({"success": True})

@app.route('/status/<int:oid>')
def status(oid):
	return jsonify({"success": True})

app.run(host="0.0.0.0",debug=True)