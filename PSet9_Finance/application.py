import os
from datetime import datetime

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd, validate_form_inputs

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
    """
    CREATE TABLE IF NOT EXISTS transactions
  (
     user_id          INTEGER NOT NULL,
     ownership_status BIT NOT NULL, -- 1 if bought, 0 if sold
     ticker_symbol    TEXT NOT NULL,
     amount           INTEGER NOT NULL,
     purchase_price   DECIMAL(9,2) NOT NULL,
     transaction_time DATETIME NOT NULL,
     FOREIGN KEY(user_id) REFERENCES users (id)
  );
    """
    if request.method == 'POST':
        try:
            amt_of_shares = int(request.form.get("amount"))

        except ValueError:
            return apology("'" + request.form.get("amount") + "' is not a valid integer")

        # Ensure shares > 0
        if amt_of_shares <= 0:
            return apology("Cannot make a purchase with share amount = " + str(amt_of_shares))

        stock_symbol = request.form.get("symbol")

        form_input = validate_form_inputs(amt_of_shares=amt_of_shares, stock_symbol=stock_symbol)

        # Ensure username and passwords are not None
        if form_input:
            return apology(form_input[0] + " = '" + str(form_input[1]) + "' is invalid!")

        # Ensure stock symbol is valid
        quote = lookup(stock_symbol)
        if not quote:
            return apology(stock_symbol + " is not a valid stock symbol!")

        # Ensure user has enough cash to make purchase
        rows = db.execute("SELECT cash FROM users WHERE id = ?", session.get("user_id"))
        user_balance = rows[0]["cash"]
        purchase_price = round(quote["price"] * amt_of_shares, 2)
        if user_balance < purchase_price:
            return apology("Insufficient funds!\nYou require $" + str(purchase_price - user_balance) + " to complete purchase.")

        else:
            db.execute("UPDATE users SET cash = " + str(round(user_balance - purchase_price, 2)) + " WHERE id = ?", session.get("user_id"))
            db.execute("INSERT INTO transactions VALUES('" + str(session.get("user_id")) + "', '"
                                                           + str(1) + "', '"
                                                           + stock_symbol + "', '"
                                                           + str(amt_of_shares) + "', '"
                                                           + str(quote["price"]) + "', '"
                                                           + datetime.now().strftime("%Y-%m-%d, %H:%M:%S") + "')")

            # Transactions are not supported here since SQLite doesn't support multiple statements at once
            # https://docs.python.org/3/library/sqlite3.html#sqlite3.Cursor.execute
            # db.execute("BEGIN TRANSACTION;\n" +
            #            "UPDATE users SET cash = " + str(round(user_balance - purchase_price, 2)) + " WHERE id = " + str(session.get("user_id")) + ";\n" +
            #            "INSERT INTO transactions VALUES('" + str(session.get("user_id")) + "', '"
            #                                                + str(1) + "', '"
            #                                                + stock_symbol + "', '"
            #                                                + str(amt_of_shares) + "', '"
            #                                                + str(quote["price"]) + "', '"
            #                                                + datetime.now().strftime("%Y-%m-%d, %H:%M:%S") + "');\n" +
            #            "COMMIT TRANSACTION;")
            flash("Bought!")
            return redirect("/")

    else:
        return render_template("buy.html")


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
        username = request.form.get("username")
        password = request.form.get("password")

        form_input = validate_form_inputs(username=username, password=password)

        # Ensure username and passwords are not None
        if form_input:
            return apology(form_input[0] + " = '" + str(form_input[1]) + "' is invalid!")

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
    if request.method == "POST":
        symbol = request.form.get("symbol")
        form_input = validate_form_inputs(symbol=symbol)
        if form_input:
            return apology(form_input[0] + " = '" + str(form_input[1]) + "' is invalid!")
        if not lookup(symbol):
            return apology(symbol + " is not a valid stock symbol!")
        return render_template("quoted.html", quote=lookup(symbol))

    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")

        form_input = validate_form_inputs(username=username, password=password, confirmation=confirmation)
        if form_input:
            return apology(form_input[0] + " = '" + str(form_input[1]) + "' is invalid!")

        rows = db.execute("SELECT * FROM users WHERE username is ?", username) #always return a singleton due to unique contraint
        if len(rows) != 0 and rows[0]["username"] == username:
            return apology("Username '" + rows[0]["username"] + "' is already taken!")

        elif password != confirmation:
            return apology("Passwords are NOT the same!")

        #TODO: implement stricter password policy:
        # (i.e. 6 characters long, at least one lower and upper, with at least one number and symbol)
        # could write a helper function using regex or write a naive one in which each requirement is intially false
        # then as you iterate through the list of character checking if any of the above requirements is met ... if so change flag to true and continue
        # then finally, and all the flags and return true or false

        else:
            db.execute("INSERT INTO users (username, hash) VALUES(?, ?)", username, generate_password_hash(password))
            #sets session id to newly inserted row in order to login user
            rows = db.execute("SELECT * FROM users WHERE username is ?", username)
            session["user_id"] = rows[0]["id"]
            return redirect("/")

    else:
        return render_template("register.html")


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

if __name__ == '__main__':
    app.run(debug=True)