$(document).ready(function() {
  var JappixConfig = {
    api_path: 'api/v1/tokens',

    bosh_path: function() {
      var query = $('script#jappix').data('bosh') || ':5280/http-bind'
      return (location.protocol + '//' + location.hostname + query)
    },

    jid: app.currentUser.get('diaspora_id'),

    user: function() {
      return this.jid.replace(/@.*?$/g, '')
    },

    domain: function() {
      return this.jid.replace(/^.*?@/g, '')
    }
  };

  // set global bosh variable for jappix
  HOST_BOSH = JappixConfig.bosh_path();
  if (app.currentUser.authenticated()) {
    $.post(JappixConfig.api_path, null, function(data) {
      if (data['token']) {
        JappixMini.launch({
          connection: {
            user: JappixConfig.user(),
            password: data['token'],
            domain: JappixConfig.domain()
          },
          application: {
            network: { autoconnect: false },
            interface: {
              showpane: true,
              animate: true
            }
          }
        });
      } else {
        console.error('No token found! Authenticated!?');
      }
    }, 'json');
  }
});
