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


# Refer to https://www.cs.cmu.edu/~pattis/15-1XX/common/handouts/ascii.html
# for ASCII character code mappings
def is_symbol(ch):
    return not (is_lower_case(ch) or is_upper_case(ch) or is_number(ch))


def is_lower_case(ch):
    return 97 <= ord(ch) <= 122


def is_upper_case(ch):
    return 65 <= ord(ch) <= 90


def is_number(ch):
    return 48 <= ord(ch) <= 57


def is_compliant_to_password_policy(password):
    """ Returns true if password is:
        at least 6 characters in long, contains one lower and upper case character, one symbol and number"""
    if len(password) < 6:
        return False

    else:
        is_sym = False
        is_lower = False
        is_upper = False
        is_num = False

        for ch in password:
            if is_sym and is_lower and is_upper and is_num: #early break if all 4 conditions are met
                return True

            if is_symbol(ch):
                is_sym = True
                continue

            if is_lower_case(ch):
                is_lower = True
                continue

            if is_upper_case(ch):
                is_upper = True
                continue

            if is_number(ch):
                is_num = True
                continue

        return False