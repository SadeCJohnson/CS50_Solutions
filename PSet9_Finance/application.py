import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    return apology("TODO")


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    return apology("TODO")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    return apology("TODO")


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    return apology("TODO")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    return apology("TODO")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    return apology("TODO")


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)

# HOW TO POTENTIALLY BYPASS 'ADD TO CART' DISABLEMENT
# (1)recognized post request when adding to cart: https://studenthighstreet.com/cart/add?id=c637d81e-9ec1-452e-85ad-5d6f59ebf175
# (2) searched for ID parameter in network tab upon looking at 'fleece-embroidered-joggers' route and uncovered fabebook tracing request which has id embedded in [content_id]
# https://www.facebook.com/tr/?id=180595369100633&ev=ViewContent&dl=https%3A%2F%2Fstudenthighstreet.com%2Flisting%2Fchildsdraw%2Ffleece-embroidered-joggers&rl=https%3A%2F%2Fstudenthighstreet.com%2Fcategory%2Fmen%2Fclothing%2Ftrousers-shorts&if=false&ts=1641804386131&cd[currency]=GBP&cd[content_name]=Fleece%20Embroidered%20Joggers&cd[content_category]=Trousers&cd[content_ids]=%5B%22c637d81e-9ec1-452e-85ad-5d6f59ebf175%22%5D&cd[content_type]=product_group&cd[value]=70&sw=1280&sh=720&v=2.9.48&r=stable&ec=1&o=30&fbp=fb.1.1641603310746.1059201454&it=1641804385932&coo=false&exp=p1&rqm=GET
# (3) searched [content_id] string for given item and found facebook tracing request
#https://www.facebook.com/tr/?id=180595369100633&ev=ViewContent&dl=https://studenthighstreet.com/listing/arcminute/arcminute-puffer-jacket&rl=&if=false&ts=1641804681937&cd[currency]=GBP&cd[content_name]=Arcminute Puffer Jacket&cd[content_category]=Jackets&cd[content_ids]=["9e2ee909-c3f9-4563-bc3e-11389abf6805"]&cd[content_type]=product_group&cd[value]=110&sw=1280&sh=720&v=2.9.48&r=stable&ec=1&o=30&fbp=fb.1.1641603310746.1059201454&it=1641804680677&coo=false&exp=p1&rqm=GET
# (4) formulated new post request: https://studenthighstreet.com/cart/add?id=9e2ee909-c3f9-4563-bc3e-11389abf6805
# (5) edited other tab with post request exposed to include new id and resend
# (6) done with failed attempt!