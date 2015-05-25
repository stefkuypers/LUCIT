Meteor.publish "groups", (q={})-> Groups.find q

Meteor.methods
   joinGroup: (groupId)->
      unless this.userId
         throw new Meteor.Error "unauthorized", "You need to be logged in"
      check groupId, String
      user = Meteor.users.findOne this.userId
      groups = user.groups or []
      unless _.contains groups, groupId
         groups.push groupId
         Meteor.users.update this.userId,
            $set:
               groups: groups
      else
         throw new Meteor.Error "already-member", "You are already a member of this group"
   createGroup: (group)->
      unless this.userId
         throw new Meteor.Error "unauthorized", "You need to be logged in"
      check group,
         name: String
      Groups.insert group

