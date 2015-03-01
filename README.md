# hubot-rain-alert

Alert a specific set of channels immediately whenever it starts and stops raining at your office location.

Uses the Wunderground API.

## Config

| Variable | Description |
| -------- | ----------- |
| `HUBOT_RAIN_ANNOUNCE_ROOMS` | (Required) Which rooms to announce to, comma separated. On Slack, you'd use something like `general,weather` to announce in #general and #weather. |
| `HUBOT_RAIN_STATION` | (Required) What to query Wunderground for. Can be a zipcode, GPS coordinates, PWS, etc. [See the Wunderground docs](http://www.wunderground.com/weather/api/d/docs?d=data/index) under `query` |
| `HUBOT_RAIN_WUNDERGROUND_TOKEN` | (Required) Token for this Wunderground API client. Sign up for one [here](http://www.wunderground.com/weather/api/). Free for 500 calls a day, paid plans available for more. |
| `HUBOT_RAIN_ANNOUNCE_ROOMS` | (Required) Which rooms to announce to, comma separated. On Slack, you'd use something like `general,weather` to announce in #general and #weather. |
| `HUBOT_RAIN_FREQUENCY | (Optional, default 2) How frequently to check for updates, in minutes. |
| `HUBOT_RAIN_STARTHOUR | (Optional, default 0) The beginning hour of when rain checks will be made, useful for limiting calls to between work hours and maximizing API calls per day. |
| `HUBOT_RAIN_STARTEND | (Optional, default 24) The end hour of when rain checks will be made, useful for limiting calls to between work hours and maximizing API calls per day. |

## Commands

None yet.

## Author

[jaxbot](https://github.com/jaxbot)

