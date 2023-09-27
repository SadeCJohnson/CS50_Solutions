## :computer::school_satchel:CS50x:school_satchel::computer:
pset solutions for [2021 Harvard CS50x](https://cs50.harvard.edu/x/2021/)


## Launching the Application 🖥️ 🖱️


- **Without New Relic:**
  1. Clone the Techie_Finance repository: https://github.com/SadeCJohnson/Techie_Finance.git .
  2. Navigate to the `/Techie_Finance/Trading-Platform` directory on your machine. This is where you’ll find all of the necessary files.
  3. Launch the app by running the `flask --app app run` command in your Terminal Window.
  4. Paste the `http://127.0.0.1:5000` host into the browser of choice to start interacting with the Platform.

- **With New Relic:**
  1. Clone the Techie_Finance repository: https://github.com/SadeCJohnson/Techie_Finance.git .
  2. Navigate to the `*Techie_Finance/Trading-Platform` directory on your machine. This is where you’ll find all of the necessary files.
  3. Follow the guided installation steps found in the New Relic's Python quickstart: https://newrelic.com/instant-observability/python.
  4. Ensure the configurations have been set up in your `newrelic.ini` file.
  5. Launch the app by running the ` NEW_RELIC_CONFIG_FILE=newrelic.ini newrelic-admin run-program flask  --app app run` command in your Terminal Window. This will allow all activity to be captured in the New Relic platform.
  6. Paste the `http://127.0.0.1:5000` host into the browser of choice to start interacting with the Platform.
