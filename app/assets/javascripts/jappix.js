$(document).ready(function() {
  var JappixConfig = {
    api_path: 'api/v1/tokens',

    bosh_path: function() {
      var port = $('script#jappix').data('boshport');
      var bind = $('script#jappix').data('boshbind');
      var url = location.protocol + '//' + location.hostname
      if (port != "443" && port != "80") {
        return (url + ":" + port + bind)
      } else {
        return (url + bind)
      }
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
