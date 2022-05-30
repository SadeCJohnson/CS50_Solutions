import os
import requests
import urllib.parse

from flask import redirect, render_template, request, session
from functools import wraps


def apology(message, code=400):
    """Render message as an apology to user."""
    def escape(s):
        """
        Escape special characters.

        https://github.com/jacebrowning/memegen#special-characters
        """
        for old, new in [("-", "--"), (" ", "-"), ("_", "__"), ("?", "~q"),
                         ("%", "~p"), ("#", "~h"), ("/", "~s"), ("\"", "''")]:
            s = s.replace(old, new)
        return s
    return render_template("apology.html", top=code, bottom=escape(message)), code


def login_required(f):
    """
    Decorate routes to require login.

    https://flask.palletsprojects.com/en/1.1.x/patterns/viewdecorators/
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)
    return decorated_function


def lookup(symbol):
    """Look up quote for symbol."""

    # Contact API
    try:
        api_key = os.environ.get("API_KEY")
        url = f"https://cloud.iexapis.com/stable/stock/{urllib.parse.quote_plus(symbol)}/quote?token={api_key}"
        response = requests.get(url)
        response.raise_for_status()
    except requests.RequestException:
        return None

    # Parse response
    try:
        quote = response.json()
        return {
            "name": quote["companyName"],
            "price": float(quote["latestPrice"]),
            "symbol": quote["symbol"]
        }
    except (KeyError, TypeError, ValueError):
        return None


def usd(value):
    """Format value as USD."""
    return f"${value:,.2f}"


def validate_form_inputs(**kwargs):
    """Returns param key:val pair to show to apology if form is invalid"""
    for key, val in kwargs.items():
        if val == '':
            return key, val
        elif val is None:
            return key, None
    return None


def is_symbol(ch):
    pass


def is_lower_case(ch):
    pass


def is_upper_case(ch):
    pass


def is_number(ch):
    pass


def is_compliant_to_password_policy(password):
    """ Returns true if password is:
        at least 6 characters in long, contains one lower and upper case character, one symbol and number"""
    if len(password) < 6:
        return False

    else:
        is_symbol = False
        is_lower_case = False
        is_upper_case = False
        is_number = False

        for ch in password:
            if is_symbol(ch):
                is_symbol = True
                continue

            if is_lower_case(ch):
                is_lower_case = True
                continue

            if is_upper_case(ch):
                is_upper_case = True
                continue

            if is_number(ch):
                is_number = True
                continue

            if is_symbol and is_lower_case and is_upper_case and is_number: #early break if all 4 conditions are met
                return True