[![Code Climate](https://codeclimate.com/github/raphweiner/elefeely-twilio-interface.png)](https://codeclimate.com/github/raphweiner/elefeely-twilio-interface)

### Elefeely Twilio Interface

This app is responsible for interfacing between Twilio and the [primary Elefeely app](https://github.com/raphweiner/elefeely-api). It runs a cron job that retrieves a list of verified numbers from the primary API and kicks off background task to send SMS via the Twilio gem.  It also handles the parsing the responses from users that come in as callbacks from Twilio (this can either be a phone number verification, new feeling, or unsubscription.  The [Elefeey gem](https://github.com/raphweiner/elefeely) is used within this app to sign and send requests to the primary Elefeely app.

##### Other project repos

The [primary Elefeely app](https://github.com/raphweiner/elefeely-api), the [Elefeely UI](https://github.com/raphweiner/elefeely-ui) backbone.js app that acts as the project front-end, and the [Elefeey gem](https://github.com/raphweiner/elefeely) that is used to sign and make requests to the primary Elefeely app from the Elefeely Twilio Interface app.
