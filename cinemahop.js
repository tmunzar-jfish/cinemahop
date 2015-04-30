if (Meteor.isClient) {
  Meteor.subscribe("movies");
  Meteor.subscribe("movie_timings");
  Meteor.subscribe("cinemas");
  Meteor.subscribe("cities");


  Template.header.events({
    'click .by-movie': function() {
      console.log("You clicked .by-movie element");
      Meteor.logout();
    }
  });

  Template.home.helpers({
    movies: function () {
      return Movies.find({});
    }
  });

}

if (Meteor.isServer) {

  Meteor.startup(function () {
   
  });

  Meteor.publish("movies", function () {
    return Movies.find();
  });
  Meteor.publish("cities", function () {
    return Cities.find();
  });
  Meteor.publish("movie_timings", function () {
    return MovieTimings.find();
  });
  Meteor.publish("cinemas", function () {
    return Cinemas.find();
  });
}


Cinemas.helpers({
    titleWithCity: function() {
      if(this.city_id) {
        return this.title + ' - ' + this.cityTitle();
      }
    },
    cityTitle: function() {
      if(this.city_id) {
        return Cities.findOne(this.city_id).title;
      }
    }
});

MovieTimings.helpers({
  movieTitle: function() {
    if(this.movie_id){
      return Movies.findOne(this.movie_id).title;
    }
  },
  movieColumn: function(){
    if(this.movie_id){
      return Movies.findOne(this.movie_id).title;
    }
  },
  theMovie: function() {
    if(this.movie_id){
      return Movies.findOne(this.movie_id);
    }
  }
});
