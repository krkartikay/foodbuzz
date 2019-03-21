import time
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
	if 'uid' in session:
		return jsonify({"loggedin": True, "uid": session['uid']})
	else:
		return jsonify({"loggedin": False, "uid": None})

@app.route('/login')
def login():
	session['uid'] = 1
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
	data = request.get_json()
	# TODO LATER: should use transactions here
	try:

		if data['uid'] != session['uid']:
			abort(401)

		total_price = 0
		for pid in data['order']:
			qty = data['order'][pid]
			price1 = query_db("SELECT price FROM products WHERE pid=?;", pid, one=True)[0]
			total_price += qty * price1

		acc_balance = query_db("SELECT balance FROM users WHERE uid=?;", [session['uid']], one=True)[0]
		if acc_balance < total_price:
			abort(400, "Insufficient account balance")
		
		m_oid = query_db("SELECT MAX(oid) FROM orders;", one=True)[0]
		oid = m_oid + 1 if m_oid is not None else 1
		vid = data['vid']

		conn = get_db()
		c = conn.cursor()
		for pid in data['order']:
			qty = data['order'][pid]
			o_data = [oid, session['uid'], vid, pid, qty, int(time.time()), 0]
			c.execute("INSERT INTO orders VALUES (?,?,?,?,?,?,?);", o_data)
			c.execute("UPDATE products SET qty_left = qty_left-?;", [qty])
		c.execute("UPDATE users SET balance=?", [acc_balance - total_price])
		conn.commit()
		conn.close()

		return jsonify({"success": True, "oid": oid})
	except KeyError:
		abort(400)

@app.route('/orders/<int:uid>')
def orders(uid):
	return jsonify({"success": True})

@app.route('/status/<int:oid>')
def status(oid):
	return jsonify({"success": True})

app.run(host="0.0.0.0",debug=True)