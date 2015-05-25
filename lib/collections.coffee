@Group = (doc)-> _.extend this, doc
_.extend Group.prototype,
   isMember: (user=Meteor.user())->
      check user, Object
      _.contains user.groups, this._id

@Groups = new Mongo.Collection "groups",
   transform: (doc)-> new Group doc
