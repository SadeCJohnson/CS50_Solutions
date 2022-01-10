
from cs50 import SQL
from flask import Flask, redirect, render_template, request

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")


def validate_form(day: str, month: str, name: str) -> bool:
    if (name is not None) and (month is not None) and (day is not None): # in case user changes name of html input tag which would render those get() assumptions above to be null!
        if day != '' and month != '': # in case user submits empty strings for numerical types which will result in some type error
            if (int(day) in range(1, 32)) and int(month) in range(1, 13): # in case user alters min/ max range on client side
                return True
    return False

@app.route("/", methods=["GET", "POST"])
def index():

    if request.method == "POST":
        name = request.form.get('name')
        month = request.form.get('month')
        day = request.form.get('day')
        if validate_form(day=day, month=month, name=name):
            db.execute("INSERT INTO birthdays (name, month, day) VALUES(?, ?, ?)", name, month, day)
        return redirect("/")

    else:
        #TODO: cache results into browser storage and have update_entry() 'GET' method retrieve from cache to reduce redundant call on db
        birthday_rows = db.execute("SELECT * FROM birthdays")
        return render_template("block_definitions.html", birthdays=birthday_rows)


@app.route("/update_entry", methods=["GET", "POST"])
def update_entry():
    if request.method == "POST":
        name = request.form.get('names')
        month = request.form.get('month')
        day = request.form.get('day')
        if validate_form(day=day, month=month, name=name):
            db.execute("UPDATE birthdays SET month = ?, day = ? where name = ?", month, day, name)
        return redirect("/")
    else:
        rows = db.execute("SELECT name FROM birthdays")
        return render_template("update_entry.html", rows=rows)


@app.route("/delete_entry", methods=["GET", "POST"])
def delete_entry():
    pass


if __name__ == '__main__':
    app.run(debug=True)