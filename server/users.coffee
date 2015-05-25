Meteor.publish "userData", ->
   if this.userId
      return Meteor.users.find this.userId,
         fields:
            groups: 1,
   else
      this.ready()
