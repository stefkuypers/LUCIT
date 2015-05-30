Date.isLeapYear = (year) ->
  year % 4 == 0 and year % 100 != 0 or year % 400 == 0

Date.getDaysInMonth = (year, month) ->
  [
    31
    if Date.isLeapYear(year) then 29 else 28
    31
    30
    31
    30
    31
    31
    30
    31
    30
    31
  ][month]

Date::isLeapYear = ->
  Date.isLeapYear @getFullYear()

Date::getDaysInMonth = ->
  Date.getDaysInMonth @getFullYear(), @getMonth()

Date::addMonths = (value) ->
  n = @getDate()
  @setDate 1
  @setMonth @getMonth() + value
  @setDate Math.min(n, @getDaysInMonth())
  this