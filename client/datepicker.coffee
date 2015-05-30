Router.route "datepicker"

MINUTE =
  name: "Minutes"
  size: 1000 * 60
  maxBlocks: 15

HOUR =
  name: "Hours"
  size: 60 * MINUTE.size
  maxBlocks: 24

DAY =
  name: "Days"
  size: HOUR.size * 24
  maxBlocks: 13

WEEK =
  name: "Weeks"
  size: DAY.size * 7
  maxBlocks: 9

MONTH =
  name: "Months"
  size: DAY.size * 30
  maxBlocks: 23

YEAR =
  name: "Years"
  size: DAY.size * 364
  maxBlocks: Number.MAX_VALUE

blockUnits = [MINUTE, HOUR, DAY, WEEK, MONTH, YEAR]

# A profile that will be used to filter blocks
# Depending on the current block unit, blocks that do not fit the profile will not be offered for selection
# For example, if days is set to [0..4] then weekend days will not be offered
class DatePickerProfile
  constructor: (@name) ->
    @hours = [0..23]
    @days = [0..6]
    @months = [0..11]

  isBlockValid: (block, blockUnit) ->
    if blockUnit is HOUR
      block.startTime.getHours() in hours
    else if blockUnit is DAY
      block.startTime.getDay() in days
    else if blockUnit is MONTH
      block.startTime.getMonth() in months
    else
      true

# A class that will iteratively pick a date
class DatePicker
  constructor: (@startDate, @endDate, @numBlocks, @blockUnit, @datePickerProfile) ->
    block =
      startTime: startDate.getTime()
      endTime: endDate.getTime()
    #@pickBlock(block)

# Get the blocks to choose from.
  getBlocks: ->
    if curBlockUnit is blockUnit
      curNumBlocks = numBlocks
    else
      curNumBlocks = 1
    blocks = []
    curTime = curStartDate.getTime()
    while curTime < curEndDate.getTime()
      block =
        startTime: curTime
        endTime: getEndTime(curTime, curNumBlocks)
      blocks.push(block) if @datePickerProfile.isBlockValid(block, curBlockUnit)
      curTime = getEndTime(curTime, 1)
    blocks

# Based on the current block unit, get the end time for a block which is blockLength units long
  getEndTime: (time, blockLength) ->
    if blockUnits.indexOf(curBlockUnit) < blockUnits.indexOf(MONTH)
      time + blockLength * curBlockUnit.size
    else
      date = new Date(time)
      if curBlockUnit is MONTH
        date.addMonths(blockLength)
      else if curBlockUnit is YEAR
        date.setYear(date.getYear() + blockLength)
      date.getTime()

  pickBlock: (block) ->
    timeBetween = block.endTime - block.startTime
    @curBlockUnit = blockUnit
    @curStartDate = new Date(block.startTime)
    @curEndDate = new Date(block.endTime)
    while timeBetween / curBlockUnit.size > curBlockUnit.maxBlocks
      curBlockUnit = blockUnits[blockUnits.indexOf(curBlockUnit) + 1]
    cleanDate(curStartDate)
    cleanDate(curEndDate)

  isFinished: ->
    startDate.getTime() + numBlocks * blockUnit.size >= endDate.getTime()

  cleanDate: (date) ->
    date.setSeconds(0)
    if blockUnits.indexOf(curBlockUnit) > blockUnits.indexOf(MINUTE)
      date.setMinutes(0)
    if blockUnits.indexOf(curBlockUnit) > blockUnits.indexOf(HOUR)
      date.setHours(0)
    if blockUnits.indexOf(curBlockUnit) > blockUnits.indexOf(DAY)
      date.setDate(1)
    if blockUnits.indexOf(curBlockUnit) > blockUnits.indexOf(MONTH)
      date.setMonth(1)
