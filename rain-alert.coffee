# Description:
#   Announces when it is raining (useful when you work in the basement)
#
# Dependencies:
#   None
#
# Configuration:
#   None
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
