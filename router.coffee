Router.configure
	notFoundTemplate : 'notFound'

# if Meteor.isClient
# 	IronRouterProgress.configure
# 		spinner : true


Router.route '/', ->
	@render 'home'

Router.route '/login', ->
	@render 'login'

