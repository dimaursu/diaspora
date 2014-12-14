app.views.Location = Backbone.View.extend({

  el: "#location",

  initialize: function(){
    this.render();
    this.getLocation();
  },

  render: function(){
    $(this.el).append('<i title="delete location" class="fa fa-times"></i>');
  },

  getLocation: function(e){
    element = this.el;

    locator = new OSM.Locator();
    locator.getAddress(function(address, latlng){
      $(element).html('<input id="location_address" type="text" class="input-block-level" value="' + address + '"/>');
      $('#location_coords').val(latlng.latitude + "," + latlng.longitude);
      $(element).append('<a id="hide_location"><i title="delete location" class="fa fa-times"></i></a>');
    });
  },
});

