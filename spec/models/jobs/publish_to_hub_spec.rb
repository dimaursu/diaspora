#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Jobs::PublishToHub do
  describe '.perform' do
    it 'calls pubsubhubbub' do
      url = "http://publiczone.com/"
      m = mock()

      m.should_receive(:publish).with(url)
      PubSubHubbub.should_receive(:new).with(AppConfig[:pubsub_server]).and_return(m)
      Jobs::PublishToHub.perform(url)
    end
  end
end
