import time
import sqlite3
import bcrypt
from flask import *
from functools import wraps

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
	return bcrypt.checkpw(pwd.encode('utf-8'), hash_.encode('utf-8'))

def make_error(status_code, message):
    response = jsonify({
        'status': status_code,
        'error': message,
    })
    response.status_code = status_code
    return response

def authorize(f):
    @wraps(f)
    def decorated_function(*args, **kws):
    	if 'uid' in session and session['uid'] != None:
    		return f(*args, **kws)
    	else:
    		return make_error(401, "Need to be loggedin")
    return decorated_function


#############################################################################
#############################################################################


@app.route('/userinfo')
def userinfo():
	time.sleep(1)
	if 'uid' in session and session['uid'] != None:
		udata = dict(query_db("SELECT uid, email, balance FROM users WHERE uid = ?",
						 [session['uid']], one=True))
		return jsonify({"loggedin": True, "uid": session['uid'], "user_data":udata})
	else:
		return jsonify({"loggedin": False, "uid": None})

# TODO: /register route too

@app.route('/login', methods=["POST"])
def login():
	data = request.get_json()
	email = data["email"]
	passw = data["password"]
	uid, hash_ = query_db("SELECT uid, passwordhash FROM users WHERE email = ?", [email], one=True)
	if check_pwd(passw, hash_):
		session['uid'] = uid
		return jsonify({"success": True})
	else:
		return make_error(400, "Username and password do not match")

@app.route('/logout', methods=["GET", "POST"])
def logout():
	session['uid'] = None
	return jsonify({"success": True})

@app.route('/vendors')
def vendors():
	vds = dict()
	for row in query_db("SELECT contact_no,name,open,photoURL,vid FROM vendors"):
		vds[row['vid']] = dict(row)
	return jsonify(vds)

@app.route('/products/<int:vid>')
def products(vid):
	pds = dict()
	for row in query_db("SELECT * FROM products WHERE vid=?", [vid]):
		pds[row['pid']] = dict(row)
	return jsonify(pds)

@app.route('/placeOrder', methods=["POST"])
@authorize
def placeOrder():
	data = request.get_json()
	# TODO LATER: should use transactions here
	try:

		total_price = 0
		for pid in data['order']:
			qty = data['order'][pid]
			qtyleft, price1 = query_db("SELECT qty_left, price FROM products WHERE pid=?", pid, one=True)
			if qty < 0:
				abort(400)
			if qtyleft < qty:
				return make_error(400, "Product is unavailable!")
			total_price += qty * price1

		# TODO: SOME MORE TESTING, qty > 0 etc
		acc_balance = query_db("SELECT balance FROM users WHERE uid=?", [session['uid']], one=True)[0]
		if acc_balance < total_price:
			return make_error(400, "Insufficient account balance")
		
		m_oid = query_db("SELECT MAX(oid) FROM orders", one=True)[0]
		oid = m_oid + 1 if m_oid is not None else 1
		vid = data['vid']

		conn = get_db()
		c = conn.cursor()
		for pid in data['order']:
			qty = data['order'][pid]
			o_data = [oid, session['uid'], vid, pid, qty, int(time.time()), 0, total_price] # 0 = status
			c.execute("INSERT INTO orders VALUES (?,?,?,?,?,?,?,?)", o_data)
			c.execute("UPDATE products SET qty_left = qty_left-? WHERE pid=?", [qty, pid])
		c.execute("UPDATE users SET balance=?", [acc_balance - total_price])
		conn.commit()
		conn.close()

		return jsonify({"success": True, "oid": oid})
	
	except KeyError:
		abort(400)

@app.route('/orders/<int:uid>')
@authorize
def orders(uid):
	if uid != session['uid']:
		abort(401)
	orders = query_db("SELECT oid, timestamp, totalprice, SUM(status)/count(status) \
						as status FROM orders WHERE uid=? GROUP BY oid", [uid])
	ods = dict()
	for row in orders:
		ods[row['oid']] = dict(row)
	return jsonify(ods)

@app.route('/status/<int:oid>')
@authorize
def status(oid):
	data = query_db("SELECT * FROM orders WHERE oid=?", [oid])
	order_status = dict()
	order_status['items'] = list()
	for row in data:
		order_status['timestamp'] = row['timestamp']
		pname = query_db("SELECT name FROM products where pid=?", [row["pid"]], one=True)[0]
		est_time = query_db("SELECT est_time FROM products where pid=?", [row["pid"]], one=True)[0]
		order_status['items'].append({"name": pname, "qty": row["qty"],
									  "est_time": est_time, "status": row["status"]})
	return jsonify(order_status)

app.run(host="0.0.0.0",debug=True)