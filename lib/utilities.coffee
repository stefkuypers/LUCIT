Date.isLeapYear: (year) ->
  (((year % 4 is 0) && (year % 100 is not 0)) || (year % 400 is 0))

Date.getDaysInMonth: (year, month) ->
  [31, (Date.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]

Date.prototype.isLeapYear: ->
  Date.isLeapYear(this.getFullYear())

Date.prototype.getDaysInMonth: ->
  Date.getDaysInMonth(this.getFullYear(), this.getMonth())

Date.prototype.addMonths: (value) ->
  n = this.getDate()
  this.setDate(1)
  this.setMonth(this.getMonth() + value)
  this.setDate(Math.min(n, this.getDaysInMonth()))
  this