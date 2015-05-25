Router.route "groups",
   subscriptions: -> [
      Meteor.subscribe "groups"
   ,
      Meteor.subscribe "userData"
   ]
   data: ->
      groups: Groups.find {}

Template.groups.events
   'click #createGroup': (e,t)->
      group =
         name: $('#name').val()
      Meteor.call 'createGroup', group, (error)->
         if error
            alert EJSON.stringify error
         else
            $('#name').val ''
   'click .joinGroup': (e,t)->
      Meteor.call 'joinGroup', this._id, (error)->
         if error
            alert EJSON.stringify error
