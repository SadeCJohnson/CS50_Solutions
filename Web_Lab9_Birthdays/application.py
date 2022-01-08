import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")

@app.route("/", methods=["GET", "POST"])
def index():

    if request.method == "POST":
        name = request.form.get('name')
        month = request.form.get('month')
        day = request.form.get('day')
        if (name is not None) and (month is not None) and (day is not None): # in case user changes name of html input tag which would render those get() assumptions above to be null!
            if day != '' and month != '': # in case user submits empty strings for numerical types which will result in some type error
                if (int(day) in range(1, 32)) and int(month) in range(1, 13): # in case user alters min/ max range on client side
                    db.execute("INSERT INTO birthdays (name, month, day) VALUES(?, ?, ?)", name, month, day)
        return redirect("/")

    else:
        birthday_rows = db.execute("SELECT * FROM birthdays")
        return render_template("select.html", birthdays=birthday_rows)

if __name__ == '__main__':
    app.run(debug=True)