# Description:
#   Announces when it is raining (useful when you work in the basement)
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_RAIN_ANNOUNCE_ROOMS (Required) Which rooms to announce to, comma separated. On Slack, you'd use something like `general,weather` to announce in #general and #weather.
#   HUBOT_RAIN_STATION (Required) What to query Wunderground for. Can be a zipcode, GPS coordinates, PWS, etc. [See the Wunderground docs](http://www.wunderground.com/weather/api/d/docs?d=data/index) under `query`
#   HUBOT_RAIN_WUNDERGROUND_TOKEN (Required) Token for this Wunderground API client. Sign up for one [here](http://www.wunderground.com/weather/api/). Free for 500 calls a day, paid plans available for more.
#   HUBOT_RAIN_ANNOUNCE_ROOMS (Required) Which rooms to announce to, comma separated. On Slack, you'd use something like `general,weather` to announce in #general and #weather.
#   HUBOT_RAIN_FREQUENCY (Optional, default 2) How frequently to check for updates, in minutes.
#   HUBOT_RAIN_STARTHOUR (Optional, default 0) The beginning hour of when rain checks will be made, useful for limiting calls to between work hours and maximizing API calls per day.
#   HUBOT_RAIN_STARTEND (Optional, default 24) The end hour of when rain checks will be made, useful for limiting calls to between work hours and maximizing API calls per day.
#
# Commands:
#   None
#
# Author:
#   jaxbot

module.exports = (robot) ->
  http = require 'http'

  roomsToAnnounceIn = process.env.HUBOT_RAIN_ANNOUNCE_ROOMS.split(',')
  rainCheckFrequency = process.env.HUBOT_RAIN_FREQUENCY or 2
  startHour = process.env.HUBOT_RAIN_STARTHOUR or 0
  endHour = process.env.HUBOT_RAIN_ENDHOUR or 24
  station = process.env.HUBOT_RAIN_STATION
  token = process.env.HUBOT_RAIN_WUNDERGROUND_TOKEN

  lastPrecip = -1
  currentlyRaining = false

  sendAnnouncement = (message) ->
    for room in roomsToAnnounceIn
      robot.messageRoom room, message

  checkForRain = ->
    http.get "http://api.wunderground.com/api/" + token + "/features/conditions/q/" + station + ".json", (res) ->
      dataString = ""
      res.on 'data', (data) ->
        dataString += data.toString()
      res.on 'end', ->
        weatherData = JSON.parse dataString
        condition = weatherData.current_observation.weather
        precip = parseFloat(weatherData.current_observation.precip_1hr_in)

        rain = false
        if condition.toLowerCase().indexOf("rain") != -1
          rain = true
        else if lastPrecip != -1 and precip > lastPrecip
          rain = true
        if rain and not currentlyRaining
          sendAnnouncement "Announcement: It's raining! (Condition: " + condition + ", Precip this hour: " + precip + ", last: " + lastPrecip + ")"
        if not rain and currentlyRaining
          sendAnnouncement "Announcement: It has stopped raining."
        currentlyRaining = rain
        lastPrecip = precip

  setInterval ->
    hour = (new Date).getHours()
    if hour >= startHour and hour <= endHour
      checkForRain()
  , rainCheckFrequency * 60 * 1000
