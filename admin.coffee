@AdminConfig =
	name: 'CinemaHop'
	collections:
		Movies:
			icon: 'film'
		MovieTimings:
			icon: 'clock-o'
			tableColumns: [
					{ label:'Movie', name:'movieTitle()' }
					{ label:'Showtime', name:'show_time' }
			]
			children: [
        find: (movieTimingDoc)->
          if SimpleSchema.RegEx.Id.test movieTimingDoc.movie_id
              Movies.find movieTimingDoc.movie_id
          else @ready()
      ]
		Cities:
			icon: 'building-o'
			tableColumns: [
					{label: 'Name', name: 'title'}
			]
		Cinemas:
			icon: 'video-camera'
			tableColumns: [
					{label: 'Name', name: 'title'}
					{label: 'City', name: 'cityTitle()'}
	    ]
	autoForm: 
		omitFields: ['createdAt', 'updatedAt']

@Schemas = {}


@Cities = new Mongo.Collection('cities');
Schemas.City = new SimpleSchema
	title:
		type: String
		label: "Name"
		max: 60
	code:
		type: String
		label: "Letter Code"
		max: 20
	latitude:
		type: Number
		decimal: true
	longitude:
		type: Number
		decimal: true
Cities.attachSchema(Schemas.City);


@Cinemas = new Mongo.Collection('cinemas');
Schemas.Cinemas = new SimpleSchema
	title:
		type: String
		label: "Name"
		max: 60
	city_id:
		type: String
		label: "City"
		autoform:
			options: ->
				_.map Cities.find({}).fetch(), (city)->
					label: city.title
					value: city._id
Cinemas.attachSchema(Schemas.Cinemas);

@Movies = new Mongo.Collection('movies');
Schemas.Movie = new SimpleSchema
	title:
		type: String
		label: "Title"
		max: 200
	imdb_id:
		type: String
		label: "IMDB id"
		max: 60
	poster:
    type: String
    autoform:
        afFieldInput:
            type: 'fileUpload'
            collection: 'Posters'
    label: 'Choose file' # optional
	createdAt: 
    type: Date
    autoValue: ->
      	if this.isInsert
        		return new Date()
Movies.attachSchema(Schemas.Movie);


@Posters = new FS.Collection("posters",
  stores: [new FS.Store.GridFS("posters", {})]
)
Posters.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true


@MovieTimings = new Mongo.Collection('movie_timings');
Schemas.MovieTiming = new SimpleSchema
	movie_id:
		type: String
		label: 'Movie'
		autoform:
			options: ->
					_.map Movies.find({}).fetch(), (movie)->
							label: movie.title
							value: movie._id
	show_time:
		type: Date
		autoform:
			afFieldInput:
					type: "datetime-local"
	adult:
		type: Boolean
		label: "Adults Only?"
	three_d:
		type: Boolean
		label: "3D?"
	cinema_id:
		type: String
		label: 'Cinema'
		autoform:
			options: ->
					_.map Cinemas.find({}).fetch(), (cinema)->
							label: cinema.titleWithCity()
							value: cinema._id

MovieTimings.attachSchema(Schemas.MovieTiming);
